# kranke - Jan 2025
# Script to download maxi xml data

# Input begins
ROOTDIR='/home/kranke/Documents/ResearchProjects/Maxithlon'
#LEAGUEIDS=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 )
LEAGUEIDS=( 1 )
SPECTIME='20250111_172940UTC'
# Input ends

# Define files
DATADIR="${ROOTDIR}/Data"
USER=$(head -n 1 "${DATADIR}/PSW/maxi.psw")
SECCODE=$(tail -n +2 "${DATADIR}/PSW/maxi.psw" | head -n 1)
COOKIEFILE="${DATADIR}/PSW/maxicookies.txt"

# If spectime is not empty, set CTIMe to that; otherwise set to current time
if [[ -n "$SPECTIME" ]]; then
  CTIME=${SPECTIME}
else
  CTIME=$(date -u +"%Y%m%d_%H%M%SUTC")
fi

# Remove cookie file if it's older than 30 minutes
if [ $(find ${COOKIEFILE} -type f -mmin +45 2>/dev/null) ]; then
    rm ${COOKIEFILE}
fi

# If cookie file does not exist, log in
if [ ! -e ${COOKIEFILE} ]; then
  wget --save-cookies=${COOKIEFILE} --keep-session-cookies -O loginfile.txt "https://www.maxithlon.com/maxi-xml/login.php?user=${USER}&scode=${SECCODE}"
  rm loginfile.txt
fi

# Create time directories
mkdir -p "${DATADIR}/LEAGUE/${CTIME}"
mkdir -p "${DATADIR}/ATHLETES/${CTIME}"
mkdir -p "${DATADIR}/TEAM/${CTIME}"

# Download league data
for LEAGUEID in "${LEAGUEIDS[@]}"; do
  
  LFILE="${DATADIR}/LEAGUE/${CTIME}/league_${LEAGUEID}.xml"
  wget --load-cookies=${COOKIEFILE} -O ${LFILE} "https://www.maxithlon.com/maxi-xml/league.php?leagueid=${LEAGUEID}"

  # Loop over all teamid and download team info and athletes
  for teamid in `xmlstarlet sel -t -m "//standing/team" -v "@id" -n ${LFILE}`; do
    wget --load-cookies=${COOKIEFILE} -O "${DATADIR}/ATHLETES/${CTIME}/athletes_team_${teamid}.xml" "https://www.maxithlon.com/maxi-xml/athletes.php?teamid=${teamid}"
    wget --load-cookies=${COOKIEFILE} -O "${DATADIR}/TEAM/${CTIME}/teaminfo_${teamid}.xml"          "https://www.maxithlon.com/maxi-xml/team.php?teamid=${teamid}"
  done
done
