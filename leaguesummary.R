# kranke - Jan 2025
# Script to compute summary for athletes.php xml file

require( xml2 )

# Input begins
leagueid   <- 7
datadir    <- '/home/kranke/Documents/ResearchProjects/Maxithlon/Data'
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

# Initialize leaguedf
leaguedf             <- data.frame( matrix( ncol = length( colsummary ) + 4, nrow = length( teamids ) ) )
colnames( leaguedf ) <- c( 'teamId', 'teamName', 'owner', 'regionId', colsummary )
leaguedf$teamId      <- teamids

# Loop over each team
for ( teamid in teamids ) {
  
  # Team file
  idxdf    <- which( leaguedf$teamId == teamid )
  teamfile <- paste( datadir, '/TEAM/teaminfo_', teamid, '.xml', sep = '' )
  teamdoc  <- read_xml( teamfile )

  # Assign the team info
  leaguedf$teamName[ idxdf ] <- xml_text( xml_find_first( teamdoc, 'teamName' ) ) 
  leaguedf$owner[ idxdf ]    <- xml_text( xml_find_first( teamdoc, 'owner' ) ) 
  leaguedf$regionId[ idxdf ] <- xml_text( xml_find_first( teamdoc, 'regionId' ) ) 
 
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
  athldf[, colsummary ]         <- lapply( athldf[, colsummary ], as.numeric )
  leaguedf[ idxdf, colsummary ] <- apply( athldf[ athldf$youth == 0, colsummary ], 2, mean  )
}

print( leaguedf )
