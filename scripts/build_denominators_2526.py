#!/usr/bin/env python3
"""Build 2025-26 school TK/K and allocated grade proxies from CDE TSVs (not observed ADA)."""
import argparse, csv, hashlib, json
from collections import defaultdict
from pathlib import Path

YEAR = "2025-26"
DAYS = 180
FIELDS = ("school_year cds_code county_code district_code school_code county_name district_name school_name "
"charter_census grade_band tk_census_enrollment k_census_enrollment grade1_census_enrollment "
"grade2_census_enrollment grade3_census_enrollment tk_k_census_enrollment "
"tk_k_eligible_cumulative_enrollment tk_k_total_absence_days grade1_3_total_absence_days "
"instructional_days_assumed estimated_tk_k_ada estimated_tk_k_attended_days "
"estimated_tk_k_cumulative_ada estimated_tk_ada_allocated estimated_k_ada_allocated "
"estimated_grade1_ada_allocated absence_tkk_match absence_grade1_3_match "
"flag_suppressed_tkk flag_suppressed_grade1_3 flag_zero_tkk_absences flag_negative_ada "
"flag_missing_tkk_estimate estimator_status").split()

def number(value):
    if value is None or str(value).strip() in ("", "*", "NA"):
        return None
    return float(str(value).replace(",", ""))

def code(row, county, district, school):
    values = [row[county], row[district], row[school]]
    for value, width in zip(values, (2, 5, 7)):
        if not value.isdigit() or len(value) > width:
            raise ValueError("Invalid CDS component: " + str(values))
    return "".join(value.zfill(width) for value, width in zip(values, (2, 5, 7)))

def load_tab(path, grouping, category, year_column, cds_columns, selected):
    found = {}
    with open(path, encoding="latin-1", newline="") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            if row[grouping] != "S" or row[category] not in selected:
                continue
            if row[year_column] != YEAR:
                raise ValueError("Unexpected school year: " + str(path))
            key = (code(row, *cds_columns), row[category])
            if key in found:
                raise ValueError("Duplicate school CDS/category " + str(key))
            found[key] = row
    if not found:
        raise ValueError("No expected school-level rows: " + str(path))
    return found

def allocate(enrollment, group_enrollment, group_absence, days=DAYS):
    if any(v is None for v in (enrollment, group_enrollment, group_absence)) or group_enrollment <= 0:
        return None
    return enrollment - group_absence * enrollment / group_enrollment / days

def estimate_one(enrollment, tkk, gr13, days=DAYS):
    tk, k, g1, g2, g3 = (number(enrollment[key]) for key in
                          ("GR_TK", "GR_KN", "GR_01", "GR_02", "GR_03"))
    combined = tk + k if tk is not None and k is not None else None
    absence = number(tkk["Total Days Absent"]) if tkk else None
    cumulative = number(tkk["Eligible Cumulative Enrollment"]) if tkk else None
    absence13 = number(gr13["Total Days Absent"]) if gr13 else None
    gsum = g1 + g2 + g3 if all(x is not None for x in (g1, g2, g3)) else None
    p1 = combined - absence / days if combined is not None and absence is not None else None
    p2 = cumulative - absence / days if cumulative is not None and absence is not None else None
    cds = code(enrollment, "CountyCode", "DistrictCode", "SchoolCode")
    return dict(
      school_year=YEAR, cds_code=cds, county_code=cds[:2], district_code=cds[2:7],
      school_code=cds[7:], county_name=enrollment["CountyName"],
      district_name=enrollment["DistrictName"], school_name=enrollment["SchoolName"],
      charter_census=enrollment["Charter"], grade_band="TK_K_COMBINED",
      tk_census_enrollment=tk, k_census_enrollment=k, grade1_census_enrollment=g1,
      grade2_census_enrollment=g2, grade3_census_enrollment=g3,
      tk_k_census_enrollment=combined, tk_k_eligible_cumulative_enrollment=cumulative,
      tk_k_total_absence_days=absence, grade1_3_total_absence_days=absence13,
      instructional_days_assumed=days, estimated_tk_k_ada=p1,
      estimated_tk_k_attended_days=p1 * days if p1 is not None else None,
      estimated_tk_k_cumulative_ada=p2,
      estimated_tk_ada_allocated=allocate(tk, combined, absence, days),
      estimated_k_ada_allocated=allocate(k, combined, absence, days),
      estimated_grade1_ada_allocated=allocate(g1, gsum, absence13, days),
      absence_tkk_match="yes" if tkk else "no",
      absence_grade1_3_match="yes" if gr13 else "no",
      flag_suppressed_tkk="yes" if tkk and "*" in (tkk["Total Days Absent"], tkk["Eligible Cumulative Enrollment"]) else "no",
      flag_suppressed_grade1_3="yes" if gr13 and "*" in (gr13["Total Days Absent"], gr13["Eligible Cumulative Enrollment"]) else "no",
      flag_zero_tkk_absences="yes" if absence == 0 else "no",
      flag_negative_ada="yes" if p1 is not None and p1 < 0 else "no",
      flag_missing_tkk_estimate="yes" if p1 is None else "no",
      estimator_status="computed_combined_proxy" if p1 is not None else "missing_or_suppressed"
    )

def write_csv(path, rows, fields):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows)

def fingerprint(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(2**20), b""):
            h.update(chunk)
    return h.hexdigest()

def build(enrollment_path, absence_path, output_dir, districts=None):
    e = load_tab(enrollment_path, "AggregateLevel", "ReportingCategory", "AcademicYear",
        ("CountyCode", "DistrictCode", "SchoolCode"), {"TA"})
    a = load_tab(absence_path, "Aggregate Level", "Reporting Category", "Academic Year",
        ("County Code", "District Code", "School Code"), {"GRTKKN", "GR13"})
    by_district = defaultdict(list)
    for (cds, _), enrollment in e.items():
        if districts and enrollment["DistrictName"] not in districts:
            continue
        tk, k = number(enrollment["GR_TK"]), number(enrollment["GR_KN"])
        if tk is None or k is None or tk + k <= 0:
            continue
        by_district[(cds[:2],cds[2:7])].append(
            estimate_one(enrollment, a.get((cds, "GRTKKN")), a.get((cds, "GR13"))))
    all_rows, quality = [], []
    for (county_code, district_code), rows in sorted(by_district.items()):
        rows.sort(key=lambda r: r["cds_code"])
        all_rows.extend(rows)
        prefix = county_code + "_" + district_code
        district = rows[0]["district_name"]
        write_csv(output_dir / ("district_" + prefix + "_school_proxies_2025_26.csv"), rows, FIELDS)
        complete = [r for r in rows if r["estimated_tk_k_ada"] is not None]
        quality.append(dict(district=district, district_cds=prefix.replace("_", ""),
          tkk_census_schools=len(rows), tkk_estimates_available=len(complete),
          missing_tkk_estimates=len(rows)-len(complete),
          total_census_tkk=sum(r["tk_k_census_enrollment"] for r in rows),
          sum_estimated_tkk_ada_complete_cases=sum(r["estimated_tk_k_ada"] for r in complete),
          negative_tkk_proxies=sum(r["flag_negative_ada"]=="yes" for r in rows),
          zero_absence_schools=sum(r["flag_zero_tkk_absences"]=="yes" for r in rows)))
    write_csv(output_dir / "school_denominator_proxies_2025_26.csv", all_rows, FIELDS)
    write_csv(output_dir / "district_quality_summary_2025_26.csv", quality,
      list(quality[0]) if quality else ["district", "district_cds"])
    output_dir.mkdir(parents=True, exist_ok=True)
    manifest = dict(school_year=YEAR, assumed_instructional_days=DAYS,
      enrollment_path=str(enrollment_path), enrollment_sha256=fingerprint(enrollment_path),
      absence_path=str(absence_path), absence_sha256=fingerprint(absence_path),
      method="Census TK+K minus GRTKKN absence days/180; grade-specific sensitivity allocates group absence days by Census shares",
      notes="Proxies, not observed ADA. TK/K and GR13 absence bands are combined. No meal numerators.")
    (output_dir / "source_manifest.json").write_text(json.dumps(manifest, indent=2)+"\n", encoding="utf-8")
    return quality

if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("enrollment", type=Path)
    p.add_argument("absence", type=Path)
    p.add_argument("output_dir", type=Path)
    p.add_argument("--district", action="append", help="Exact CDE district name")
    a = p.parse_args()
    print(json.dumps(build(a.enrollment, a.absence, a.output_dir, a.district), indent=2))
