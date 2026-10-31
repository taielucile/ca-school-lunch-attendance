"""Static regression checks for the verified Oct 2026 source-audit metadata.

These check candidate ledger integrity but CANNOT validate names against a district
site-ID crosswalk or prove that meal grades align with attendance exposure.
"""
import csv
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DIR = ROOT / "results" / "2025_26"

def read_csv(name):
    with (DIR / name).open(newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream))

class NewWorkbookAuditTest(unittest.TestCase):
    def test_elk_grove_cds_review(self):
        rows = read_csv("elk_grove_unified_source_cds_candidates_review_only.csv")
        self.assertEqual(len(rows),43)
        self.assertEqual(sum(r["match_status"]=="unique_normalized_name_candidate" for r in rows),40)
        self.assertEqual(sum(r["match_status"]=="name_variant_requires_confirmation" for r in rows),3)
        self.assertEqual({r["source_school_name"] for r in rows if r["match_status"]=="name_variant_requires_confirmation"},
                         {"Charles Mack Elementary","James McKee Elementary","Maeola Beitzel Elementary"})
        self.assertEqual(len({r["candidate_cds_code"] for r in rows}),43)
        self._check_common(rows,"3467314")

    def test_ontario_cds_review(self):
        rows = read_csv("ontario_montclair_source_cds_candidates_review_only.csv")
        self.assertEqual(len(rows),26)
        self.assertEqual(sum(r["match_status"]=="unique_normalized_name_candidate" for r in rows),24)
        self.assertEqual(sum(r["match_status"]=="name_variant_requires_confirmation" for r in rows),2)
        self.assertEqual({r["source_school_name"] for r in rows if r["match_status"]=="name_variant_requires_confirmation"},
                         {"Euclid Elementary","Haynes Elementary"})
        self.assertEqual(len({r["candidate_cds_code"] for r in rows}),26)
        self._check_common(rows,"3667819")

    def _check_common(self,rows,prefix):
        for r in rows:
            self.assertEqual(len(r["candidate_cds_code"]),14)
            self.assertTrue(r["candidate_cds_code"].isdigit())
            self.assertTrue(r["candidate_cds_code"].startswith(prefix))
            self.assertEqual(r["adjudication_status"],"UNREVIEWED")
            self.assertNotIn("accepted",r["match_status"].lower())
            self.assertTrue(r["eligibility_note"])
        name=next(iter(rows))["district_name"]
        matched_cde = read_csv(
            "elk_grove_unified_school_denominator_proxies.csv" if prefix=="3467314"
            else "ontario_montclair_school_denominator_proxies.csv")
        official = {r["cds_code"]:r["school_name"] for r in matched_cde}
        for r in rows:
            self.assertEqual(official[r["candidate_cds_code"]],r["candidate_cde_school_name"])

    def test_audit_manifest(self):
        x=json.loads((DIR/"elk_ontario_uploaded_workbook_source_audit_2026_10_31.json").read_text())
        self.assertEqual(len(x["inputs"]),2)
        for source in x["inputs"]:
            self.assertEqual(len(source["sha256"]),64)
        self.assertEqual(x["elk_grove"]["detailed_school_grade_rows"],442)
        self.assertEqual(x["elk_grove"]["source_printed_total_breakfast"],711424)
        self.assertEqual(x["elk_grove"]["source_printed_total_lunch"],2429657)
        self.assertEqual(x["elk_grove"]["grade_code19_school_rows"],43)
        self.assertEqual(x["ontario_montclair"]["named_school_blocks"],32)
        self.assertEqual(x["ontario_montclair"]["elementary_K_TK_school_blocks"],26)
        self.assertEqual(x["ontario_montclair"]["elementary_K_TK_school_blocks"],26)
        self.assertEqual(x["ontario_montclair"]["month_and_grand_total_checks"],1056)
        self.assertEqual(x["ontario_montclair"]["school_month_ADA_differences_across_meal_columns"],17)
        self.assertFalse(x["participation_rate_ready"])

if __name__ == "__main__":
    unittest.main()
