from pathlib import Path
from html import escape
import csv
B=Path(__file__).resolve().parents[1]
with (B/'outputs/lodi_31_school_k_meal_attendance_review.csv').open(newline='') as f:
    rows=list(csv.DictReader(f))
rows.sort(key=lambda r:float(r['lunch_per_100_attended_days']),reverse=True)
W,H=1150,1240
xl,xr=342,1090
ytop,dy=180,30
max_x=105
x=lambda v: xl+(float(v)/max_x)*(xr-xl)
parts=[f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" role="img" aria-labelledby="title desc">',
'<title id="title">Kindergarten meals relative to modeled kindergarten attendance in Lodi Unified, 2025-26</title>',
'<desc id="desc">31 school-level breakfast and lunch ratios. Each denominator is modeled kindergarten attended student-days, not children enrolled or observed kindergarten attendance.</desc>',
'<rect width="1150" height="1240" fill="white"/>',
'<style>text{font-family:Arial,Helvetica,sans-serif;fill:#26343e} .minor{font-size:14px;fill:#576774} .name{font-size:15px} .small{font-size:13px;fill:#546571}</style>',
'<text x="342" y="42" style="font-size:24px;font-weight:bold">Kindergarten meals relative to modeled attendance</text>',
'<text x="342" y="68" class="minor">Lodi Unified | 31 matched schools | 2025-26</text>',
'<rect x="890" y="88" width="12" height="12" transform="rotate(45 896 94)" fill="#2B6F9D"/><text x="910" y="99" class="minor">Breakfast</text>',
'<circle cx="1017" cy="94" r="6" fill="#C97442"/><text x="1031" y="99" class="minor">Lunch</text>']
for tick in range(0,101,20):
  px=x(tick)
  parts.append(f'<line x1="{px:.1f}" x2="{px:.1f}" y1="145" y2="1118" stroke="#E9EDF0" stroke-width="1"/>')
  parts.append(f'<text x="{px:.1f}" y="1145" text-anchor="middle" class="minor">{tick}</text>')
parts.append(f'<line x1="{x(100):.1f}" x2="{x(100):.1f}" y1="145" y2="1118" stroke="#89939C" stroke-width="1.2" stroke-dasharray="4 4"/>')
for n,r in enumerate(rows):
  y=ytop+n*30
  label=r['cde_school'].removesuffix(' Elementary School').removesuffix(' Elementary')
  a=x(r['breakfast_per_100_attended_days']);z=x(r['lunch_per_100_attended_days'])
  parts.append(f'<text x="330" y="{y+5}" text-anchor="end" class="name">{escape(label)}</text>')
  parts.append(f'<line x1="{a:.2f}" y1="{y}" x2="{z:.2f}" y2="{y}" stroke="#CBD3D9" stroke-width="1.2"/>')
  # four-sided diamond icon for breakfast
  parts.append(f'<polygon points="{a:.2f},{y-6} {a+6:.2f},{y} {a:.2f},{y+6} {a-6:.2f},{y}" fill="#2B6F9D"/>')
  parts.append(f'<circle cx="{z:.2f}" cy="{y}" r="5.5" fill="#C97442"/>')
parts.extend([
'<text x="714" y="1177" text-anchor="middle" style="font-size:17px">Recorded K meals per 100 modeled K attendance days</text>',
'<text x="342" y="1205" class="small">DENOMINATOR: modeled kindergarten student-days, not enrollment or observed K attendance.</text>',
'<text x="342" y="1224" class="small">These descriptive ratios are not verified percentages of students receiving meals.</text>',
'</svg>'])
(B/'outputs/lodi_k_meals_per_100_estimated_attendance_days.svg').write_text('\n'.join(parts)+'\n')
print('wrote compact SVG', (B/'outputs/lodi_k_meals_per_100_estimated_attendance_days.svg').stat().st_size)