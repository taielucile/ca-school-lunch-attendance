#!/usr/bin/env python3
"""Reproduce 17-school 2025–26 Ventura TK/K proxy comparison.

Input is the *archived, independently verified* team benchmark CSV, not the
original observed ADA workbook. The source must contain obs_ada, census, cum,
and abs_days rows by CDS, group TK+K. This tests archived-reference agreement.
"""
import argparse
import csv
from collections import Counter, defaultdict
from pathlib import Path

FIELDNAMES = [
    "school_year", "cds_code", "school_name", "observed_tkk_ada",
    "census_tkk_enrollment", "cumulative_eligible_tkk_enrollment",
    "absence_days_tkk", "assumed_student_days", "p0_census",
    "p1_census_minus_absences", "p2_cumulative_minus_absences",
    "p1_signed_error", "p2_signed_error", "p1_absolute_error",
    "p2_absolute_error", "closer_proxy", "source"
]
SOURCE = (
    "whippedfruit/Feed-California-Kinders "
    "analysis/2026-10-25/tables/independent_benchmark_checks.csv"
)

def evaluate(rows):
    by_cds = defaultdict(dict)
    for r in rows:
        if r["group"] != "TK+K" or not r["cds"].startswith("5672652"):
            continue
        d = by_cds[r["cds"]]
        if r["field"] in d:
            raise ValueError("Duplicate reference field for CDS " + r["cds"])
        d[r["field"]] = float(r["reconstructed"])
        d["school"] = r["school"]
    output = []
    for cds, r in sorted(by_cds.items()):
        if not all(k in r for k in ("obs_ada", "census", "cum", "abs_days")):
            raise ValueError("Incomplete Ventura reference for CDS " + cds)
        obs, p0 = r["obs_ada"], r["census"]
        p1, p2 = p0-r["abs_days"]/180, r["cum"]-r["abs_days"]/180
        err1, err2 = abs(p1-obs), abs(p2-obs)
        closer = "tie" if abs(err1-err2)<1e-8 else (
            "census" if err1 < err2 else "cumulative"
        )
        output.append(dict(
            school_year="2025-26", cds_code=cds, school_name=r["school"],
            observed_tkk_ada=obs, census_tkk_enrollment=p0,
            cumulative_eligible_tkk_enrollment=r["cum"],
            absence_days_tkk=r["abs_days"], assumed_student_days=180,
            p0_census=p0, p1_census_minus_absences=p1,
            p2_cumulative_minus_absences=p2, p1_signed_error=p1-obs,
            p2_signed_error=p2-obs, p1_absolute_error=err1,
            p2_absolute_error=err2, closer_proxy=closer, source=SOURCE
        ))
    if len(output)!=17:
        raise ValueError("Expected 17 Ventura TK/K reference rows, got "+str(len(output)))
    counts = Counter(r["closer_proxy"] for r in output)
    if counts != {"census":13,"cumulative":2,"tie":2}:
        raise AssertionError("Archived Ventura winner counts changed: "+str(counts))
    expected = dict(observed_tkk_ada=1179.14,
                    p0_census=1263.0,
                    p1_census_minus_absences=1186.0555555555557,
                    p2_cumulative_minus_absences=1236.0555555555557)
    for key, val in expected.items():
        observed = sum(r[key] for r in output)
        if abs(observed-val)>1e-6:
            raise AssertionError(f"Ventura {key}: {observed} differs from {val}")
    return output

def main(source, output):
    with source.open(encoding="utf-8-sig",newline="") as f:
        res = evaluate(csv.DictReader(f))
    output.parent.mkdir(parents=True,exist_ok=True)
    with output.open("w", encoding="utf-8",newline="") as f:
        w=csv.DictWriter(f,fieldnames=FIELDNAMES)
        w.writeheader(); w.writerows(res)
    print("Validated", len(res), "Ventura schools:",
          dict(Counter(r["closer_proxy"] for r in res)))

if __name__=="__main__":
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("archived_verified_benchmark_csv",type=Path)
    p.add_argument("output_csv",type=Path)
    a=p.parse_args()
    main(a.archived_verified_benchmark_csv,a.output_csv)
