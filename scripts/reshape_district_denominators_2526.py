#!/usr/bin/env python3
"""Reshape school-level CDE 2025–26 proxies to long grade rows.

Never call these measured grade-specific ADA: the GRTKKN and GR13 absence-day
bands were allocated by Census grade shares. Existing files remain unchanged.
"""
import argparse
import csv
from pathlib import Path

COLS = [
    "school_year", "cds_code", "county_code", "district_code",
    "district_name", "school_name", "grade", "census_enrollment",
    "absence_group", "source_grade_band_absence_days",
    "instructional_days_assumed", "estimated_ada",
    "estimated_attended_student_days", "proxy_method", "status",
    "charter_census", "notes"
]
GRADES = [
    ("TK", "tk_census_enrollment", "estimated_tk_ada_allocated", "GRTKKN", "tk_k_total_absence_days"),
    ("K", "k_census_enrollment", "estimated_k_ada_allocated", "GRTKKN", "tk_k_total_absence_days"),
    ("01", "grade1_census_enrollment", "estimated_grade1_ada_allocated", "GR13", "grade1_3_total_absence_days"),
]

def long_rows(schools):
    result = []
    for w in schools:
        for grade, enrol_col, estimate_col, band, absence_col in GRADES:
            e = w[enrol_col]
            if not e or float(e) <= 0:
                continue
            proxy = w[estimate_col]
            days = int(w["instructional_days_assumed"])
            result.append({
                "school_year": w["school_year"],
                "cds_code": w["cds_code"],
                "county_code": w["county_code"],
                "district_code": w["district_code"],
                "district_name": w["district_name"],
                "school_name": w["school_name"],
                "grade": grade,
                "census_enrollment": e,
                "absence_group": band,
                "source_grade_band_absence_days": w[absence_col],
                "instructional_days_assumed": str(days),
                "estimated_ada": proxy,
                "estimated_attended_student_days": (
                    f"{float(proxy)*days:.6f}" if proxy else ""
                ),
                "proxy_method": "census_share_allocated_absences",
                "status": "model_allocated_proxy" if proxy else "missing_or_suppressed",
                "charter_census": w["charter_census"],
                "notes": (
                    "NOT observed grade-specific ADA: group absences allocated "
                    "proportional to Census enrollment"
                ),
            })
    return result

def reshape(input_csv, output_csv):
    with input_csv.open("r", encoding="utf-8-sig", newline="") as f:
        rows = list(csv.DictReader(f))
    required = {v for values in GRADES for v in values[1:3]} | {
        "school_year", "cds_code", "county_code", "district_code",
        "district_name", "school_name", "instructional_days_assumed",
        "charter_census", "tk_k_total_absence_days", "grade1_3_total_absence_days"
    }
    if not rows:
        raise ValueError("Empty wide source: " + str(input_csv))
    missing = required - set(rows[0])
    if missing:
        raise ValueError("Wide source missing columns: " + repr(sorted(missing)))
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    result = long_rows(rows)
    with output_csv.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=COLS)
        writer.writeheader()
        writer.writerows(result)
    return len(result)

if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("input_csv", type=Path, help="Wide CDE school proxy CSV")
    p.add_argument("output_csv", type=Path, help="Long grade TK, K, 01 proxy CSV")
    args = p.parse_args()
    print("Wrote", reshape(args.input_csv, args.output_csv), "grade-sensitivity rows")
