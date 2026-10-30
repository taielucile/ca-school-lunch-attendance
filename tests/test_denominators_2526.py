"""Synthetic regression tests for the 2025–26 denominator and link-audit scripts."""
import csv, sys, tempfile, unittest
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from build_denominators_2526 import estimate_one, allocate, build
from audit_fns10_links import audit, district_key, school_key

class DenominatorTest(unittest.TestCase):
    def setUp(self):
        self.e = dict(CountyCode="56",DistrictCode="72652",SchoolCode="6056030",
            CountyName="Ventura",DistrictName="Ventura Unified",SchoolName="Demo",
            Charter="N",GR_TK="20",GR_KN="40",GR_01="50",GR_02="40",GR_03="60")
    def test_arithmetic_and_cds(self):
        r = estimate_one(self.e, dict(**{"Total Days Absent":"900","Eligible Cumulative Enrollment":"65"}),
            dict(**{"Total Days Absent":"1200","Eligible Cumulative Enrollment":"180"}))
        self.assertEqual(r["cds_code"], "56726526056030")
        self.assertAlmostEqual(r["estimated_tk_k_ada"],55)
        self.assertAlmostEqual(r["estimated_tk_k_cumulative_ada"],60)
        self.assertAlmostEqual(r["estimated_k_ada_allocated"],40-900*40/60/180)
        self.assertAlmostEqual(r["estimated_grade1_ada_allocated"],50-1200*50/150/180)
        self.assertAlmostEqual(r["estimated_k_ada_allocated"]+r["estimated_tk_ada_allocated"],55)
    def test_suppression(self):
        r=estimate_one(self.e,{"Total Days Absent":"*","Eligible Cumulative Enrollment":"*"},None)
        self.assertIsNone(r["estimated_tk_k_ada"])
        self.assertEqual(r["flag_suppressed_tkk"],"yes")
    def test_zero_allocation(self):
        self.assertIsNone(allocate(0,0,0))
    def test_end_to_end_small_fixture(self):
        with tempfile.TemporaryDirectory() as td:
            td=Path(td); e=td/"e.tsv"; a=td/"a.tsv"; out=td/"out"
            efields=["AcademicYear","AggregateLevel","ReportingCategory","CountyCode","DistrictCode",
                "SchoolCode","CountyName","DistrictName","SchoolName","Charter","GR_TK","GR_KN","GR_01","GR_02","GR_03"]
            with e.open("w",newline="") as f:
                w=csv.DictWriter(f,fieldnames=efields,delimiter="\t")
                w.writeheader();w.writerow({"AcademicYear":"2025-26","AggregateLevel":"S","ReportingCategory":"TA",**self.e})
            afields=["Academic Year","Aggregate Level","Reporting Category","County Code","District Code",
                "School Code","Total Days Absent","Eligible Cumulative Enrollment"]
            with a.open("w",newline="") as f:
                w=csv.DictWriter(f,fieldnames=afields,delimiter="\t");w.writeheader()
                for cat,days in [("GRTKKN","900"),("GR13","1200")]:
                    w.writerow({"Academic Year":"2025-26","Aggregate Level":"S",
                    "Reporting Category":cat,"County Code":"56","District Code":"72652",
                    "School Code":"6056030","Total Days Absent":days,"Eligible Cumulative Enrollment":"65"})
            q=build(e,a,out)
            self.assertEqual(q[0]["tkk_estimates_available"],1)
            self.assertTrue((out/"source_manifest.json").exists())
            self.assertTrue((out/"school_denominator_proxies_2025_26.csv").exists())

class RecordLinkageTest(unittest.TestCase):
    def test_normalize(self):
        self.assertEqual(district_key("Lodi USD"),district_key("Lodi Unified School District"))
        self.assertEqual(school_key("E.P. Foster Elementary School"),school_key("E P Foster Elementary"))
    def test_district_block(self):
        schools=[dict(district_name="Lodi Unified",school_name="Washington Elementary",cds_code="111"),
                 dict(district_name="Ventura Unified",school_name="Washington Elementary",cds_code="222"),
                 dict(district_name="Lodi Unified",school_name="George Washington Elementary",cds_code="333")]
        r=list(audit([dict(sponsor_name="Lodi Unified School District",site_name="Washington Elementary")],schools))[0]
        self.assertEqual((r["status"],r["candidate_cds"]),("exact_normalized_candidate","111"))
        s=list(audit([dict(sponsor_name="Lodi Unified",site_name="George Washngton Elementary")],schools))[0]
        self.assertEqual((s["status"],s["candidate_cds"]),("fuzzy_review_only","333"))


class LongFormatTest(unittest.TestCase):
    def test_allocation_and_missingness(self):
        from reshape_district_denominators_2526 import long_rows
        wide = dict(school_year="2025-26",cds_code="56726526056030",county_code="56",
          district_code="72652",district_name="Ventura Unified",school_name="Demo",
          charter_census="N",tk_census_enrollment="20",k_census_enrollment="40",
          grade1_census_enrollment="50",tk_k_total_absence_days="900",
          grade1_3_total_absence_days="",instructional_days_assumed="180",
          estimated_tk_ada_allocated="18.333333",estimated_k_ada_allocated="36.666667",
          estimated_grade1_ada_allocated="")
        r = long_rows([wide])
        self.assertEqual([x["grade"] for x in r], ["TK","K","01"])
        self.assertEqual([x["status"] for x in r],
                         ["model_allocated_proxy","model_allocated_proxy","missing_or_suppressed"])
        self.assertEqual(r[2]["estimated_ada"], "")
        self.assertAlmostEqual(float(r[0]["estimated_attended_student_days"]),3300,places=3)

if __name__=="__main__":
    unittest.main()
