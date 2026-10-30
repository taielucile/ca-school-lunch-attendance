#!/usr/bin/env python3
"""Rebuild 2024–25 FNS10-to-CBEDS site audit from original published source files.

No fuzzy name link is automatically accepted. Preserve full breakfast/lunch
claim counts; never treat schoolwide FNS10 claims as kindergarten meals.
"""
import argparse,csv,json,re,unicodedata
from collections import Counter,defaultdict
from difflib import SequenceMatcher
from pathlib import Path
from openpyxl import load_workbook

def norm(s):
    s=unicodedata.normalize("NFKD",str(s or "")).encode("ascii","ignore").decode().lower()
    return " ".join(re.sub(r"[^a-z0-9]+"," ",s).split())

def district(s):
    return " ".join(re.sub(
        r"\b(unified school district|school district|unified|union elementary school district|union school district|elementary school district|unified district|usd)\b",
        " ",norm(s)).split())

def read_cde(path):
    catalog={}
    with open(path,encoding="utf-8-sig",newline="") as f:
        for r in csv.DictReader(f,delimiter="\t"):
            if r["Level"]!="S":continue
            cds=r["Cdscode"].zfill(14)
            if len(cds)!=14 or not cds.isdigit() or r["Year"]!="2425":
                raise ValueError("Bad CBEDS identity or year")
            identity=(r["DistrictName"],r["SchoolName"],r["CountyName"])
            if cds in catalog and catalog[cds]!=identity:
                raise ValueError("Conflicting identity "+cds)
            catalog[cds]=identity
    return catalog

def read_claims(path):
    pairs=defaultdict(lambda:dict(breakfast_meals=0,lunch_meals=0,originals=set()))
    counts=Counter();totals=Counter();types=Counter();raw=set()
    w=load_workbook(path,read_only=True,data_only=True)
    cols=("ProgramGroupYear","ProgramCode","FnsReportDate","ClaimDate","SponsorName","SiteName","MealTypeCode","MlsServedTotal")
    for meal,sheet in [("Breakfast","Breakfast SY24-25"),("Lunch","Lunch SY24-25")]:
        ws=w[sheet]
        if tuple(next(ws.iter_rows(min_row=8,max_row=8,values_only=True))[:8])!=cols:
            raise ValueError("Changed FNS10 workbook columns")
        for row in ws.iter_rows(min_row=9,values_only=True):
            if not row[4]:continue
            year,program,_,_,sponsor,site,meal_code,n=row[:8]
            if str(year)!="2025" or str(program)!="NSLP" or not site or not isinstance(n,(int,float)) or n<0:
                raise ValueError("Unexpected FNS10 claim")
            sponsor,site=str(sponsor).strip(),str(site).strip()
            p=pairs[(district(sponsor),norm(site))]
            p["originals"].add((sponsor,site))
            p[meal.lower()+"_meals"]+=int(n)
            raw.add((sponsor,site));counts[meal]+=1;totals[meal]+=int(n);types[str(meal_code)]+=int(n)
    assert counts=={"Breakfast":108259,"Lunch":108666},counts
    assert totals=={"Breakfast":327641211,"Lunch":557472855},totals
    return pairs,counts,totals,types,len(raw)

def similarity(a,b):
    x,y=set(a.split()),set(b.split())
    tok=2*len(x&y)/(len(x)+len(y)) if x and y else 0
    return round(.6*SequenceMatcher(None,a,b).ratio()+.4*tok,6)

def save(path,rows,fields):
    path.parent.mkdir(parents=True,exist_ok=True)
    with open(path,"w",newline="",encoding="utf-8") as f:
        w=csv.DictWriter(f,fieldnames=fields,extrasaction="ignore")
        w.writeheader();w.writerows(rows)

def run(book,cbeds,out):
    catalog=read_cde(cbeds)
    pairs,counts,totals,types,raw_count=read_claims(book)
    by_exact=defaultdict(list);by_dist=defaultdict(list);by_school=defaultdict(list)
    school_rows=[]
    for cds,(dn,sn,cn) in sorted(catalog.items()):
        r=dict(cds_code=cds,district_name=dn,school_name=sn,county_name=cn,
               district_key=district(dn),school_key=norm(sn))
        school_rows.append(r);by_exact[(r["district_key"],r["school_key"])].append(r)
        by_dist[r["district_key"]].append(r);by_school[r["school_key"]].append(r)
    ambiguous=[dict(district_key=k[0],school_key=k[1],n=len(v),
                candidate_cdss=";".join(r["cds_code"] for r in v),
                candidate_names=";".join(r["school_name"] for r in v))
               for k,v in by_exact.items() if len(v)>1]
    audit=[]
    for (dk,sk),p in sorted(pairs.items()):
        exact=by_exact.get((dk,sk),[])
        opts=by_dist.get(dk,[])
        ranked=sorted(((similarity(sk,r["school_key"]),r) for r in opts),
                      key=lambda t:(-t[0],t[1]["cds_code"]))[:2] if not exact else []
        if len(exact)==1:
            candidate=exact[0];status="unique_exact_district_site_name";score=1.0;runner=""
        elif len(exact)>1:
            candidate=exact[0];status="ambiguous_exact";score=1.0;runner=1.0
        elif ranked:
            score,candidate=ranked[0];status="unmatched_fuzzy_review_only"
            runner=ranked[1][0] if len(ranked)>1 else ""
        else:
            candidate=None;status="unmatched_no_district_block";score="";runner=""
        global_schools=by_school[sk]
        fallback=global_schools[0] if len(global_schools)==1 else None
        if status=="unmatched_no_district_block" and fallback:
            tier="global_unique_school_name_review"
        elif status=="unmatched_fuzzy_review_only" and score>=.9 and (score-float(runner or 0))>=.04:
            tier="within_district_high_similarity_review"
        elif status=="unmatched_fuzzy_review_only":
            tier="within_district_ambiguous_fuzzy_review"
        elif status=="unique_exact_district_site_name":
            tier="exact_unique_candidate"
        else:
            tier="no_reliable_unique_candidate"
        if tier=="global_unique_school_name_review":
            candidate=fallback
        audit.append(dict(
            sponsor_key=dk,site_key=sk,original_sponsor_sites=" | ".join(
                a+" :: "+b for a,b in sorted(p["originals"])),
            source_name_variants=len(p["originals"]),status=status,review_tier=tier,
            candidate_cds=candidate["cds_code"] if candidate else "",
            candidate_district=candidate["district_name"] if candidate else "",
            candidate_school=candidate["school_name"] if candidate else "",
            top_similarity=score,next_similarity=runner,
            same_district_cde_schools=len(opts),same_school_name_statewide=len(global_schools),
            breakfast_meals=p["breakfast_meals"],lunch_meals=p["lunch_meals"],
            review_decision="UNREVIEWED" if tier!="exact_unique_candidate" else "UNIQUE_EXACT_NAME_CANDIDATE",
            note="No fuzzy match accepted; exact names still require official identity confirmation"))
    fields=list(audit[0]);unmatched=[r for r in audit if r["status"]!="unique_exact_district_site_name"]
    unmatched.sort(key=lambda r:(-r["lunch_meals"],r["sponsor_key"],r["site_key"]))
    save(out/"fns10_all_site_link_candidates_2024_25.csv",audit,fields)
    save(out/"fns10_unmatched_priority_250.csv",unmatched[:250],fields)
    save(out/"cbeds_ambiguous_keys.csv",ambiguous,
         ["district_key","school_key","n","candidate_cdss","candidate_names"])
    save(out/"cbeds_school_catalog.csv",school_rows,list(school_rows[0]))
    matched=[r for r in audit if r["status"]=="unique_exact_district_site_name"]
    summary=dict(year="2024-25",claim_rows=dict(counts),meals_served=dict(totals),
       meal_type_code_totals=dict(types),raw_trimmed_site_pairs=raw_count,
       normalized_site_pairs=len(pairs),unique_cbeds_schools=len(catalog),
       exact_unique_candidate_pairs=len(matched),
       exact_unique_candidate_distinct_cds=len({r["candidate_cds"] for r in matched}),
       exact_unique_lunch_meals=sum(r["lunch_meals"] for r in matched),
       exact_unique_breakfast_meals=sum(r["breakfast_meals"] for r in matched),
       status_counts=dict(Counter(r["status"] for r in audit)),
       unmatched_review_tiers=dict(Counter(r["review_tier"] for r in unmatched)),
       ambiguous_cbeds_key_count=len(ambiguous),
       caveat="This conservative normalization differs from the previous 9,988 / 6,515 matching method. No name match is an authoritative site-to-CDS crosswalk.")
    out.mkdir(parents=True,exist_ok=True)
    (out/"fns10_audit_summary.json").write_text(json.dumps(summary,indent=2)+"\n",encoding="utf-8")
    print(json.dumps(summary,indent=2))
    return summary

if __name__=="__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("workbook",type=Path)
    parser.add_argument("cbeds",type=Path)
    parser.add_argument("out",type=Path)
    a=parser.parse_args();run(a.workbook,a.cbeds,a.out)
