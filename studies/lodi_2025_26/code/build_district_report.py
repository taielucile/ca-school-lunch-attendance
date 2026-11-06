from pathlib import Path
import csv
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_CELL_VERTICAL_ALIGNMENT
from docx.enum.section import WD_SECTION_START

BASE = Path(__file__).resolve().parents[1]
OUT = BASE/'outputs'
DOC = BASE/'district_review'
with (OUT/'lodi_31_school_k_meal_attendance_review.csv').open(newline='') as f:
    rows = list(csv.DictReader(f))
rows.sort(key=lambda x: float(x['lunch_per_100_attended_days']), reverse=False)
# This is a presentation chart from the already R-verified school table, not new analysis.
fig, ax = plt.subplots(figsize=(11.8, 12.7), dpi=175)
fig.patch.set_facecolor('white')
labels = [x['cde_school'].removesuffix(' Elementary School').removesuffix(' Elementary') for x in rows]
y = list(range(len(rows)))
b = [float(x['breakfast_per_100_attended_days']) for x in rows]
l = [float(x['lunch_per_100_attended_days']) for x in rows]
for yy, bb, ll in zip(y, b, l):
    ax.plot([bb,ll],[yy,yy],linewidth=.85,color='#CAD1D8',zorder=1)
ax.scatter(b,y,s=38,marker='D',c='#2B6F9D',label='Breakfast',zorder=3)
ax.scatter(l,y,s=45,marker='o',c='#C97442',label='Lunch',zorder=3)
ax.set_yticks(y,labels,fontsize=8.7)
ax.set_xlim(0,105)
ax.set_xticks(range(0,101,20))
ax.set_ylim(-.8,len(rows)-.3)
ax.set_axisbelow(True)
ax.grid(axis='x',color='#EAEDF0',linewidth=.85)
ax.axvline(100,color='#929BA2',linestyle='--',linewidth=.9)
ax.tick_params(axis='y',length=0,pad=7)
for s in ['top','left','right']: ax.spines[s].set_visible(False)
ax.spines['bottom'].set_color('#ADB5BC')
ax.set_xlabel('Recorded K meals per 100 modeled K attendance days',fontsize=11.1,labelpad=14)
ax.legend(loc='lower right',bbox_to_anchor=(1,.995),ncol=2,frameon=False,fontsize=9.7)
fig.text(.35,.967,'Kindergarten meals relative to modeled attendance',fontsize=15.5,fontweight='bold')
fig.text(.35,.943,'Lodi Unified | 31 matched schools | 2025–26',fontsize=10.3,color='#53616C')
fig.text(.35,.033,'DENOMINATOR: estimated kindergarten student-days attended, not pupils or observed K attendance.',fontsize=8.6,color='#344D5B')
fig.text(.35,.014,'Descriptive meal-to-day ratios, not verified percentages of students receiving meals.',fontsize=8.6,color='#53616C')
fig.subplots_adjust(left=.35,right=.976,top=.907,bottom=.102)
fig.savefig(OUT/'lodi_k_meals_per_100_estimated_attendance_days_final.png',dpi=175,facecolor='white')
plt.close(fig)

D = Document()
s = D.sections[0]
s.page_width=Inches(8.5);s.page_height=Inches(11)
s.top_margin=Inches(.74);s.bottom_margin=Inches(.66)
s.left_margin=Inches(.78);s.right_margin=Inches(.78)
normal = D.styles['Normal'];normal.font.name='Aptos';normal.font.size=Pt(10.2);normal.font.color.rgb=RGBColor(42,53,60)
normal.paragraph_format.space_after=Pt(8)
for st,size in [('Title',19.6),('Heading 1',12.4)]:
    style=D.styles[st];style.font.name='Aptos Display' if st=='Title' else 'Aptos';style.font.size=Pt(size);style.font.bold=True
    style.font.color.rgb=RGBColor(29,64,84)
    style.paragraph_format.space_before=Pt(9);style.paragraph_format.space_after=Pt(4)

p=D.add_paragraph('FEED CALIFORNIA KINDERS  /  DRAFT FOR RESEARCH-TEAM REVIEW');p.runs[0].bold=True;p.runs[0].font.size=Pt(8.2);p.runs[0].font.color.rgb=RGBColor(90,108,118)
D.add_paragraph('Kindergarten meals and estimated attendance in Lodi Unified',style='Title')
p=D.add_paragraph('2025–26 school year   |   31 matched schools   |   November 6, 2026');p.runs[0].italic=True
D.add_paragraph('Lodi Unified’s meal workbook records 70,667 kindergarten breakfasts and 203,639 kindergarten lunches at the 31 schools in this comparison. We compare these counts with an estimate of how many days kindergarten students attended school. The meal counts come from the district; the kindergarten attendance days are modeled from state data, not directly observed K attendance.')
D.add_paragraph('What the records show',style='Heading 1')
t=D.add_table(rows=2, cols=3);t.alignment=WD_TABLE_ALIGNMENT.CENTER;t.style='Light Shading Accent 1'
headers=['K breakfasts recorded','K lunches recorded','Modeled K attended student-days']
vals=['70,667 meals','203,639 meals','287,174 days']
for i in range(3):
    t.cell(0,i).text=headers[i]
    t.cell(1,i).text=vals[i]
    t.cell(0,i).vertical_alignment=WD_CELL_VERTICAL_ALIGNMENT.CENTER
    for r in t.cell(1,i).paragraphs[0].runs:r.bold=True;r.font.size=Pt(12);r.font.color.rgb=RGBColor(27,73,98)
D.add_paragraph('Across these schools, there were 24.6 recorded kindergarten breakfasts and 70.9 lunches per 100 modeled kindergarten attendance days. These are meal-to-day ratios, not percentages of students. For example, 70.9 lunches per 100 modeled attendance days does not establish that 70.9% of children received school lunch. The district values use total meals divided by total modeled days, not an average of school ratios.')
D.add_paragraph('What the denominator means',style='Heading 1')
D.add_paragraph('We used Census Day kindergarten enrollment and public absence totals for transitional kindergarten and kindergarten combined (TK/K). Because the absence file does not report kindergarten absences separately, the model assigns them according to kindergarten’s share of TK/K Census enrollment in each school. It assumes 180 school days. This produces modeled kindergarten student-days attended, not kindergarten enrollment, observed attendance, or a verified count of student-days.')
D.add_paragraph('How to read the figure',style='Heading 1')
D.add_paragraph('The figure shows breakfast and lunch separately for all 31 schools. A marker farther right means more recorded meals relative to modeled kindergarten attendance days. The values range from 4.1 to 68.8 for breakfast and 35.9 to 97.1 for lunch per 100 modeled days. These differences describe the data; the available files do not establish why schools differ.')
D.add_paragraph('Scope and remaining checks',style='Heading 1')
D.add_paragraph('The 31 school names matched across the meal workbook, kindergarten eligibility list and state attendance file. Four additional state-file schools with no corresponding meal record were excluded from both sides of this comparison. The workbook’s “Preschool” category was kept separate; it is not assumed to mean TK. Reporting dates, grade labels and actual kindergarten attended days still need district confirmation before interpreting the results as student meal participation.')
sec2=D.add_section(WD_SECTION_START.NEW_PAGE)
sec2.top_margin=Inches(.47);sec2.bottom_margin=Inches(.45);sec2.left_margin=Inches(.52);sec2.right_margin=Inches(.52)
p=D.add_paragraph('Figure 1. Recorded kindergarten meals per 100 modeled K attendance days',style='Heading 1');p.paragraph_format.space_before=Pt(0)
D.add_picture(str(OUT/'lodi_k_meals_per_100_estimated_attendance_days_final.png'),width=Inches(7.35))
p=D.add_paragraph('Sources: Lodi Unified 2025–26 meal workbook; CDE 2025–26 Census enrollment and TK/K absenteeism records. Denominator assumes 180 days and allocates combined TK/K absences by Census enrollment shares. The ratios are not observed K attendance or verified student participation. For research-team review; not approved by Lodi Unified.')
p.runs[0].font.size=Pt(8.0);p.runs[0].font.color.rgb=RGBColor(85,99,109)
D.save(DOC/'Lodi_Kindergarten_Meals_Report_2025_26_FOR_REVIEW.docx')
print('Wrote report and final figure')