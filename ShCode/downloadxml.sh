# kranke - Jan 2025
# Script to download maxi xml data

# Input begins
ROOTDIR='/home/kranke/Documents/ResearchProjects/Maxithlon'
LEAGUEID=1
# Input ends

# Define files
DATADIR="${ROOTDIR}/Data"
USER=$(head -n 1 "${DATADIR}/PSW/maxi.psw")
SECCODE=$(tail -n +2 "${DATADIR}/PSW/maxi.psw" | head -n 1)
COOKIEFILE="${DATADIR}/PSW/maxicookies.txt"
LFILE="${DATADIR}/LEAGUE/league_${LEAGUEID}.xml"

# Remove cookie file if it's older than 30 minutes
if [ $(find ${COOKIEFILE} -type f -mmin +45 2>/dev/null) ]; then
    rm ${COOKIEFILE}
fi

# If cookie file does not exist, log in
if [ ! -e ${COOKIEFILE} ]; then
  wget --save-cookies=${COOKIEFILE} --keep-session-cookies -O loginfile.txt "https://www.maxithlon.com/maxi-xml/login.php?user=${USER}&scode=${SECCODE}"
  rm loginfile.txt
fi

# Download league data
wget --load-cookies=${COOKIEFILE} -O ${LFILE} "https://www.maxithlon.com/maxi-xml/league.php?leagueid=${LEAGUEID}"

# Loop over all teamid and download team info and athletes
for teamid in `xmlstarlet sel -t -m "//standing/team" -v "@id" -n ${LFILE}`; do
  wget --load-cookies=${COOKIEFILE} -O "${DATADIR}/ATHLETES/athletes_team_${teamid}.xml" "https://www.maxithlon.com/maxi-xml/athletes.php?teamid=${teamid}"
  wget --load-cookies=${COOKIEFILE} -O "${DATADIR}/TEAM/teaminfo_${teamid}.xml"          "https://www.maxithlon.com/maxi-xml/team.php?teamid=${teamid}"
done

