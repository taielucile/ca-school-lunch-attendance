#!/usr/bin/env python3
"""Produce FNS10 sponsor/site-to-CDS review candidates; do not auto-accept fuzzy matches."""
import argparse, csv, math, re, unicodedata
from collections import Counter, defaultdict
from difflib import SequenceMatcher
from pathlib import Path

def norm(text):
    s = unicodedata.normalize("NFKD", str(text or ""))
    s = "".join(c for c in s if not unicodedata.combining(c)).lower()
    return " ".join(re.sub(r"[^a-z0-9]+", " ", s).split())

def district_key(s):
    return " ".join(re.sub(r"\b(unified school district|union elementary school district|elementary school district|school district|unified district|unified|usd)\b", " ", norm(s)).split())

def school_key(s):
    return " ".join(re.sub(r"\b(elementary school|high school|middle school)\b",
        lambda m: m.group().split()[0], norm(s)).split())

def cosine(a, b):
    aa, bb = Counter(a.split()), Counter(b.split())
    denom = math.sqrt(sum(v*v for v in aa.values()) * sum(v*v for v in bb.values()))
    return sum(v*bb[k] for k,v in aa.items())/denom if denom else 0

def similarity(a, b):
    return (cosine(a,b)+SequenceMatcher(None,a,b).ratio())/2

def audit(meals, schools):
    blocks = defaultdict(list)
    for c in schools:
        blocks[district_key(c["district_name"])].append(c)
    for m in meals:
        district = district_key(m["sponsor_name"])
        school = school_key(m["site_name"])
        options = blocks.get(district, [])
        ranked = sorted(((similarity(school, school_key(c["school_name"])),c) for c in options),
            key=lambda x:(-x[0],x[1]["cds_code"]))
        exact = [c for _,c in ranked if school_key(c["school_name"])==school]
        if len(exact)==1:
            candidate, status, score = exact[0], "exact_normalized_candidate", 1.0
        elif len(exact)>1:
            candidate, status, score = exact[0], "ambiguous_exact", 1.0
        elif ranked:
            score,candidate=ranked[0]; status="fuzzy_review_only"
        else:
            candidate,status,score=None,"no_district_block",0
        yield dict(sponsor_name=m["sponsor_name"],site_name=m["site_name"],
            sponsor_key=district,site_key=school,status=status,
            candidate_cds=candidate["cds_code"] if candidate else "",
            candidate_district=candidate["district_name"] if candidate else "",
            candidate_school=candidate["school_name"] if candidate else "",
            top_score=round(score,5),
            second_score=round(ranked[1][0],5) if len(ranked)>1 else "",
            candidate_count_in_district=len(options),
            note="Candidate only; inspect ambiguous names, district structure, charters and school renames.")

def load(path, cols):
    with open(path,newline="",encoding="utf-8-sig") as f:
        r=csv.DictReader(f)
        missing=set(cols)-set(r.fieldnames or [])
        if missing:raise ValueError("Missing fields: "+str(sorted(missing)))
        return list(r)

if __name__=="__main__":
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("fns10_pairs_csv",type=Path,help="Columns: sponsor_name,site_name")
    p.add_argument("cde_school_catalog_csv",type=Path,help="Columns: district_name,school_name,cds_code")
    p.add_argument("output_csv",type=Path)
    a=p.parse_args()
    results=list(audit(load(a.fns10_pairs_csv,("sponsor_name","site_name")),
                       load(a.cde_school_catalog_csv,("district_name","school_name","cds_code"))))
    a.output_csv.parent.mkdir(parents=True,exist_ok=True)
    with open(a.output_csv,"w",newline="",encoding="utf-8") as f:
        fields=list(results[0]) if results else ("status","candidate_cds")
        w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(results)
    print(dict(Counter(x["status"] for x in results)))
