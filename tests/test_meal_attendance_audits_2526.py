import csv
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import audit_irvine_meal_reports as irvine
import reproduce_ventura_2526 as ventura


class IrvineAuditTest(unittest.TestCase):
    def test_missing_report_rows_stay_visible_in_sensitivity(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "attendance.csv"
            with path.open("w", newline="") as file:
                writer = csv.writer(file)
                writer.writerow(["school", "grade", *[f"attendance_11_{day:02}" for day in irvine.DAYS]])
                writer.writerow(["Example School", "K", 10, 10, 10, 10, 10])
            with patch.object(irvine, "read_meal_report",
                              side_effect=lambda _, day: {("Example School", "K", day, "Lunch"): 4}
                              | ({("Example School", "K", day, "Breakfast"): 5} if day == 3 else {})):
                breakfast = next(row for row in irvine.audit(path.parent, path)
                                 if (row["grade"], row["session"]) == ("K", "Breakfast"))
        self.assertEqual(breakfast["missing_rows"], 4)
        self.assertEqual(breakfast["quantity_per_100_days_if_omissions_zero"], 10)
        self.assertEqual(breakfast["quantity_per_100_days_on_reported_rows"], 50)

    def test_parser_reconciles_all_grades_and_preserves_target_rows(self):
        report = ("Solis Park K‐8 School  Lunch  Kindergarten  Lunch Meal  4  11/3/2025\n"
                  "Other School  Lunch  6th  Lunch Meal ‐ $3.75  1  11/3/2025\n5\n")
        with patch.object(subprocess, "run", return_value=subprocess.CompletedProcess([], 0, report)):
            self.assertEqual(irvine.read_meal_report(Path("fixture.pdf"), 3),
                             {("Solis Park K - 8", "K", 3, "Lunch"): 4})
        with patch.object(subprocess, "run", return_value=subprocess.CompletedProcess([], 0, report[:-2] + "6\n")):
            with self.assertRaisesRegex(ValueError, "total does not reconcile"):
                irvine.read_meal_report(Path("fixture.pdf"), 3)


class VenturaAuditTest(unittest.TestCase):
    def test_incomplete_benchmark_fails(self):
        rows = [{"group": "TK+K", "cds": "56726520000001", "field": "obs_ada",
                 "reconstructed": "9", "school": "Example School"}]
        with self.assertRaisesRegex(ValueError, "Incomplete Ventura reference"):
            ventura.evaluate(rows)
