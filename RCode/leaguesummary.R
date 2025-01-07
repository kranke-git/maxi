# kranke - Jan 2025
# Script to compute summary for athletes.php xml file

require( xml2 )
require( xtable )
source( '/home/kranke/Documents/ResearchProjects/Maxithlon/CODE/RCode/staticdata.R' )
source( '/home/kranke/Documents/ResearchProjects/Maxithlon/CODE/RCode/utils.R' )

# Input begins
leagueid   <- 7 
datadir    <- '/home/kranke/Documents/ResearchProjects/Maxithlon/Data'
docsdir    <- '/home/kranke/Documents/ResearchProjects/Maxithlon/CODE/docs'
colsummary <- c( 'age', 'wage', 'height', 'weight', 'fans', 'maxid', 'form', 'care', 'experience', 'mood' )
# Input ends

# Get the teamids and info from the league
leaguefile <- paste( datadir, '/LEAGUE/league_', leagueid, '.xml', sep = '' )
leaguedoc  <- read_xml( leaguefile )
season     <- as.numeric( xml_text( xml_find_first( leaguedoc, 'season' ) ) )
nationId   <- as.numeric( xml_text( xml_find_first( leaguedoc, 'nationId' ) ) )
level      <- as.numeric( xml_text( xml_find_first( leaguedoc, 'level' ) ) )
number     <- as.numeric( xml_text( xml_find_first( leaguedoc, 'number' ) ) )
teamids    <- xml_attr( xml_find_all( leaguedoc, "//team" ), 'id' )

# Initialize leaguedf and other data frames
leaguedf             <- data.frame( matrix( ncol = length( colsummary ) + 7, nrow = length( teamids ) ) )
colnames( leaguedf ) <- c( 'teamId', 'teamName', 'owner', 'regionId', 'athletesCount', 'weeklyWage', 'percentItalian', colsummary )
leaguedf$teamId      <- teamids
seniordf             <- leaguedf
speclst              <- list()
specids              <- c( 1, 2, 3, 4, 5, 6, 7 )
for ( s in specids ) {
  speclst[[ s ]] <- leaguedf
}

# Loop over each team
for ( teamid in teamids ) {
 
  # Team file
  idxdf    <- which( leaguedf$teamId == teamid )
  teamfile <- paste( datadir, '/TEAM/teaminfo_', teamid, '.xml', sep = '' )
  teamdoc  <- read_xml( teamfile )
 
  # Athletes file
  athfile  <- paste( datadir, '/ATHLETES/athletes_team_', teamid, '.xml', sep = '' )
  athdoc   <- read_xml( athfile )
  athletes <- xml_find_all( athdoc, "//athlete" )
  tagnames <- xml_name( xml_children( athletes[ 1 ] )  )
  athldf   <- data.frame( idx=1:length( athletes ) )
  for ( tag in tagnames ) {
    athldf[[ tag ]] <- xml_text( xml_find_first( athletes, tag ) )
  }

  # Summarize athletes file and fill league dataframe
  leaguedf <- summarize_athletes( leaguedf, idxdf, athldf, athldf$youth == 0, colsummary, teamdoc, nationId )
  seniordf <- summarize_athletes( seniordf, idxdf, athldf, athldf$youth == 0 & as.numeric( athldf$age >= 18 ), colsummary, teamdoc, nationId )
  for ( s in specids ) {
    speclst[[ s ]] <- summarize_athletes( speclst[[ s ]], idxdf, athldf, athldf$youth == 0 & as.numeric( athldf$specialtyId ) == s, colsummary, teamdoc, nationId )
  }
}

# Write routines
digits          <- c( 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 1, 2, 0, 2, 2, 2, 2 )
sortedRegions   <- regionNames[ order( regionIds ) ]
writeLeagueTable( leaguedf, 'mainteam', digits, paste( docsdir, '/ROUT', sep = ''), season, level, number, nationNames[ nationId ], sortedRegions ) 
writeLeagueTable( seniordf, 'mainteam_noyouth', digits, paste( docsdir, '/ROUT', sep = ''), season, level, number, nationNames[ nationId ], sortedRegions ) 
for ( s in specids ) {
  writeLeagueTable( speclst[[ s ]], paste( 'mainteam_', specialtyNames[ s ], sep = '' ), digits, paste( docsdir, '/ROUT', sep = ''), season, level, number, nationNames[ nationId ], sortedRegions )  
}
