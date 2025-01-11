#!/bin/bash
# kranke - January 2025
# Script to create html file from html tables created in R

# Input begins
ROOTDIR="/home/kranke/Documents/ResearchProjects/Maxithlon"
LEAGUEIDS=( 1 2 3 4 5 6 7 )
SPECIALTIES=( 'Sprinters' 'MiddleDistance' 'LongDistance' 'RaceWalk' 'Jumpers' 'Throwers' 'CombinedAthletes')
TSTAMP='20250111_172940UTC'
# Input ends

# Initialize directories/files
ROUTDIR="${ROOTDIR}/Output/LeagueTables"
DOCSDIR="${ROOTDIR}/CODE/docs"
HEADERFILE="${DOCSDIR}/league_header.html"

for LEAGUEID in "${LEAGUEIDS[@]}"; do

  echo "+++ Processing League ${LEAGUEID}"

  # Initialize league-specific files
  TBLFILE="${ROUTDIR}/${TSTAMP}/table_league${LEAGUEID}_mainteam.html"
  TBLFILE_NY="${ROUTDIR}/${TSTAMP}/table_league${LEAGUEID}_mainteam_noyouth.html"
  OUTFILE="${DOCSDIR}/league${LEAGUEID}.html"
  STRFILE="${ROUTDIR}/${TSTAMP}/title_league${LEAGUEID}.html"
  TITLESTRING=`cat ${STRFILE}`
  
  # Create the html file
  cat ${HEADERFILE}                               >  ${OUTFILE}
  echo "<h1>${TITLESTRING}</h1>"                  >> ${OUTFILE}
  echo "<h2> Main Team Stats</h2>"                >> ${OUTFILE}
  cat ${TBLFILE}                                  >> ${OUTFILE}
  echo "<h2> Main Team without junior Stats</h2>" >> ${OUTFILE}
  cat ${TBLFILE_NY}                               >> ${OUTFILE}
  for SPECIALTY in "${SPECIALTIES[@]}"; do
    TBLFILE_SPC="${ROUTDIR}/${TSTAMP}/table_league${LEAGUEID}_mainteam_${SPECIALTY}.html"
    echo "<h2> Main Team Stats: ${SPECIALTY}</h2>" >> ${OUTFILE}
    cat ${TBLFILE_SPC}                             >> ${OUTFILE}
  done
  echo "</body>"                                    >> ${OUTFILE}
  echo "</html>"                                    >> ${OUTFILE}
  sed -i "s/LeagueInfoModifyHere/${TITLESTRING}/g"     ${OUTFILE}

done
