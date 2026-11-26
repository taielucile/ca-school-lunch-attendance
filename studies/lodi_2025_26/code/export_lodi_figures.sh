#!/usr/bin/env bash
set -euo pipefail

study_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
output_dir=${1:-lodi_r_rendered_figures}

Rscript "$study_dir/code/render_lodi_figures.R" \
  "$study_dir/outputs/lodi_31_school_grade_meal_census_for_R.csv" \
  "$study_dir/outputs/lodi_31_school_absence_group_inputs_2025_26.csv" \
  "$output_dir"

for name in 01_Lodi_Breakfast 02_Lodi_Lunch 03_Lodi_Combined_Meals; do
  prefix="$output_dir/$name"
  gs -q -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dEmbedAllFonts=true -dSubsetFonts=true \
    -sOutputFile="$prefix.embedded.pdf" -c '<</NeverEmbed []>> setdistillerparams' -f "$prefix.pdf"
  mv "$prefix.embedded.pdf" "$prefix.pdf"
  pdftoppm -r 100 -png -singlefile "$prefix.pdf" "$prefix"
done
