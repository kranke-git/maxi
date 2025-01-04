#!/bin/bash

DOCSDIR="/home/kranke/Documents/ResearchProjects/Maxithlon/CODE/docs"

# Input HTML file with header and footer
INPUT_HTML="${DOCSDIR}/input.html"

# File containing the new table
NEW_TABLE_HTML="${DOCSDIR}/table.html"

# Output HTML file
OUTPUT_HTML="${DOCSDIR}/output.html"

# Extract parts of the HTML
HEADER=$(sed -n '/<!-- START LEAGUE TABLE -->/q;p' "$INPUT_HTML")
FOOTER=$(sed -n '1,/<!-- END LEAGUE TABLE -->/d;p' "$INPUT_HTML")

# Combine header, new table, and footer into the output file
{
  echo "$HEADER"
  echo "<!-- START LEAGUE TABLE -->"
  cat "$NEW_TABLE_HTML"
  echo "<!-- END LEAGUE TABLE -->"
  echo "$FOOTER"
} > "$OUTPUT_HTML"
