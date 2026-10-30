#!/usr/bin/env python3
"""Extract and check source-backed 2025–26 school denominators for meal-source districts.

The repository's meal files are not proof of grade coverage, period compatibility,
or suitability for a school-level participation estimate.
"""
import csv
import sys
from pathlib import Path
from reshape_district_denominators_2526 import reshape

# These districts have identifiable 2025–26 district meal-source files in the
# shared team repo but were absent from the six-district denominator handoff.
DISTRICTS = {
    "Chino Valley Unified": ("3667678", "chino_valley_unified"),
    "Davis Joint Unified": ("5772678", "davis_joint_unified"),
    "Oak Park Unified": ("5673874", "oak_park_unified"),
}

def main(source: Path, output: Path):
    with source.open(newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        fields = reader.fieldnames
        assert fields and "cds_code" in fields and "district_name" in fields
        selected = {cds: [] for cds, _ in DISTRICTS.values()}
        for row in reader:
            for name, (district_cds, _) in DISTRICTS.items():
                if row["cds_code"][:7] == district_cds:
                    if row["district_name"] != name:
                        raise ValueError(f"District identity disagreement: {row['cds_code']}")
                    selected[district_cds].append(row)
    output.mkdir(parents=True, exist_ok=True)
    summary = []
    for name, (cds, slug) in DISTRICTS.items():
        rows = sorted(selected[cds], key=lambda r: r["cds_code"])
        if not rows:
            raise ValueError(f"No Census school records for {name} / {cds}")
        if len({r["cds_code"] for r in rows}) != len(rows):
            raise ValueError(f"Duplicate school identifier in {name}")
        wide = output / (slug + "_school_denominator_proxies.csv")
        long = output / (slug + "_school_grade_proxies.csv")
        with wide.open("w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fields)
            writer.writeheader()
            writer.writerows(rows)
        grade_rows = reshape(wide, long)
        usable = sum(bool(r["estimated_tk_k_ada"]) for r in rows)
        summary.append(dict(
            district=name, district_cds=cds, school_rows=len(rows),
            tk_k_proxies_calculable=usable,
            tk_k_proxies_missing=len(rows)-usable,
            school_grade_sensitivity_rows=grade_rows,
            tk_k_census_enrollment=sum(float(r["tk_k_census_enrollment"]) for r in rows),
            estimated_tk_k_ada_complete_cases=sum(
                float(r["estimated_tk_k_ada"]) for r in rows if r["estimated_tk_k_ada"]
            ),
        ))
    with (output/"additional_meal_district_quality_summary.csv").open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(summary[0]))
        w.writeheader()
        w.writerows(summary)
    for row in summary:
        print(row)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("usage: python scripts/extract_additional_meal_districts_2526.py STATEWIDE.csv OUTPUT_DIR")
    main(Path(sys.argv[1]), Path(sys.argv[2]))
