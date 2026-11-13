#!/usr/bin/env python3
"""Audit Irvine's five November 2025 meal reports against daily K/PK attendance."""

import argparse
import csv
import re
import subprocess
from collections import defaultdict
from pathlib import Path


DAYS = range(3, 8)
GRADES = {"Kindergarten": "K", "PK": "PK_TK"}
SESSIONS = ("Breakfast", "Lunch")
SITE_NAMES = {
    "Beacon Park School": "Beacon Park K-8",
    "Cadence Park School": "Cadence Park K - 8",
    "Solis Park K-8 School": "Solis Park K - 8",
    "Vista Verde School": "Vista Verde K-8",
}
VIRTUAL_SITE = "IUSD Virtual Academy Elementary"
ROW = re.compile(
    r"(.+?)\s{2,}(Breakfast|Lunch)\s{2,}(\S+)\s{2,}"
    r"(Breakfast|Lunch) Meal(.*?)(?=\s{2,})\s{2,}([\d,]+)\s{2,}(\d+/\d+/\d+)"
)


def read_meal_report(path, day):
    report = subprocess.run(
        ["pdftotext", "-layout", str(path), "-"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    meals = {}
    quantities = []
    printed_totals = []
    for line in report.splitlines():
        line = line.strip()
        if not line or line.startswith("Serving Building"):
            continue
        if re.fullmatch(r"[\d,]+", line):
            printed_totals.append(int(line.replace(",", "")))
            continue
        match = ROW.fullmatch(line)
        if not match:
            raise ValueError(f"{path.name}: unexpected report line {line!r}")
        site, session, grade, item_session, item_suffix, quantity, date = match.groups()
        if date != f"11/{day}/2025" or item_session != session:
            raise ValueError(f"{path.name}: inconsistent date or meal session")
        quantity = int(quantity.replace(",", ""))
        quantities.append(quantity)
        if grade in GRADES:
            if item_suffix:
                raise ValueError(f"{path.name}: unexpected K/PK meal item: {line!r}")
            key = SITE_NAMES.get(site.replace("‐", "-"), site), GRADES[grade], day, session
            if key in meals:
                raise ValueError(f"Duplicate meal-report row: {key}")
            meals[key] = quantity
    if printed_totals != [sum(quantities)]:
        raise ValueError(f"{path.name}: report total does not reconcile")
    print(f"{path.name}: {len(quantities)} item rows, total {printed_totals[0]:,}")
    return meals


def audit(report_directory, attendance_path):
    meals = {}
    for day in DAYS:
        meals.update(read_meal_report(report_directory / f"Meals Served 2025.11.{day:02}.pdf", day))
    attendance = {}
    with attendance_path.open(encoding="utf-8-sig", newline="") as file:
        for row in csv.DictReader(file):
            site, grade = row["school"], row["grade"]
            if grade not in GRADES.values():
                raise ValueError(f"Unexpected attendance grade: {grade}")
            if site == VIRTUAL_SITE:
                continue
            for day in DAYS:
                key = site, grade, day
                if key in attendance:
                    raise ValueError(f"Duplicate attendance row: {key}")
                attendance[key] = int(row[f"attendance_11_{day:02}"])
    unmatched = {key[:3] for key in meals} - attendance.keys()
    if unmatched:
        raise ValueError(f"Meal rows without matched attendance: {sorted(unmatched)}")

    totals = defaultdict(lambda: dict(quantity=0, all_days=0, reported_days=0, missing_rows=0))
    for key, attended_days in attendance.items():
        for session in SESSIONS:
            quantity = meals.get((*key, session))
            for grade in (key[1], "Combined"):
                summary = totals[grade, session]
                summary["all_days"] += attended_days
                if quantity is None:
                    summary["missing_rows"] += 1
                else:
                    summary["quantity"] += quantity
                    summary["reported_days"] += attended_days
    for (grade, session), summary in sorted(totals.items()):
        quantity = summary["quantity"]
        yield dict(
            grade=grade,
            session=session,
            **summary,
            quantity_per_100_days_if_omissions_zero=(100 * quantity / summary["all_days"]
                                                       if summary["all_days"] else None),
            quantity_per_100_days_on_reported_rows=(100 * quantity / summary["reported_days"]
                                                   if summary["reported_days"] else None),
        )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("report_directory", type=Path)
    parser.add_argument("attendance_csv", type=Path)
    parser.add_argument("output_csv", type=Path)
    args = parser.parse_args()
    rows = list(audit(args.report_directory, args.attendance_csv))
    args.output_csv.parent.mkdir(parents=True, exist_ok=True)
    with args.output_csv.open("w", encoding="utf-8", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    main()
