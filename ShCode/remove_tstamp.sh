# kranke - January 2025
# Script to remove timestamp directories

# Input begins
TSTAMP='20250111_174528UTC'
ROOTDIR='/home/kranke/Documents/ResearchProjects/Maxithlon'
# Input ends

DATADIR="${ROOTDIR}/Data"
OUTDIR="${ROOTDIR}/Output"

echo "Removing ${DATADIR}/LEAGUE/${TSTAMP}"
echo "Removing ${DATADIR}/TEAMS/${TSTAMP}"
echo "Removing ${DATADIR}/ATHLETES/${TSTAMP}"
rm -rI "${DATADIR}/LEAGUE/${TSTAMP}"
rm -rI "${DATADIR}/TEAMS/${TSTAMP}"
rm -rI "${DATADIR}/ATHLETES/${TSTAMP}"
