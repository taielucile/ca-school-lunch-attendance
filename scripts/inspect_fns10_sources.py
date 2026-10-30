#!/usr/bin/env python3
"""Read-only workbook/CBEDS schema inspection for source-aware FNS10 parsing."""
import json,sys
from pathlib import Path
from openpyxl import load_workbook
xlsx,cbeds,out=(Path(x) for x in sys.argv[1:4]);out.parent.mkdir(parents=True,exist_ok=True)
wb=load_workbook(xlsx,read_only=True,data_only=True)
summary={"sheets":[],"cbeds":{}}
for ws in wb.worksheets:
    sample=[]
    for row in ws.iter_rows(min_row=1,max_row=6,values_only=True):
        sample.append([str(c)[:110] if c is not None else "" for c in row[:18]])
    summary["sheets"].append({"title":ws.title,"rows":ws.max_row,"cols":ws.max_column,"sample":sample})
with cbeds.open(encoding="utf-8-sig",newline="") as f:
    first=[next(f) for _ in range(5)]
summary["cbeds"]={"sample":[s[:600] for s in first]}
out.write_text(json.dumps(summary,indent=2),encoding="utf-8")
print(json.dumps(summary,indent=2)[:18000])