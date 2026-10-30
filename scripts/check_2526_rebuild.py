#!/usr/bin/env python3
"""Compare clean full-data rebuild to committed district extracts by CDS."""
import csv,math,sys
from pathlib import Path
root=Path(sys.argv[1]);built=Path(sys.argv[2])
expected={"Lodi Unified":"lodi_unified","Ventura Unified":"ventura_unified",
"Irvine Unified":"irvine_unified","Elk Grove Unified":"elk_grove_unified",
"Ontario-Montclair":"ontario_montclair","Ojai Unified":"ojai_unified"}
problems=[]
for name,short in expected.items():
    committed=root/"results"/"2025_26"/(short+"_school_denominator_proxies.csv")
    with committed.open(newline="") as f:baseline={r["cds_code"]:r for r in csv.DictReader(f)}
    sample=next(iter(baseline.values()))
    fn=built/("district_"+sample["county_code"]+"_"+sample["district_code"]+"_school_proxies_2025_26.csv")
    with fn.open(newline="") as f:actual={r["cds_code"]:r for r in csv.DictReader(f)}
    if baseline.keys()!=actual.keys():
        problems.append(f"{name}: CDS keys differ {len(baseline)} vs {len(actual)}");continue
    for cds,old in baseline.items():
        for col in ["tk_k_census_enrollment","tk_k_total_absence_days","estimated_tk_k_ada",
                    "estimated_tk_ada_allocated","estimated_k_ada_allocated",
                    "estimated_grade1_ada_allocated"]:
            a=actual[cds][col].strip();b=old[col].strip()
            if a and b:
                if not math.isclose(float(a),float(b),rel_tol=0,abs_tol=1e-5):
                    problems.append(f"{name}:{cds}:{col} {a} != {b}")
            elif a!=b:problems.append(f"{name}:{cds}:{col} missingness mismatch")
    print(f"{name}: {len(baseline)} CDS keys; compared models and source counts")
if problems:
    print("\n".join(problems[:35]))
    raise SystemExit(f"{len(problems)} reconciliation problems")
print("All six district wide extracts reconcile to full official source rebuild.")