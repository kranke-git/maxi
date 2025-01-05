# kranke - January 2025
# Utilities for all R scripts

###########################################################################################################
summarize_athletes <- function( leaguedf, idxdf, athldf, idxfilter, colsummary, teamdoc ) {
  # Summarize athletes file and fill league dataframe
  leaguedf$athletesCount[ idxdf ] = sum( idxfilter )
  athldf[, colsummary ]           = lapply( athldf[, colsummary ], as.numeric )
  leaguedf[ idxdf, colsummary ]   = apply( athldf[ idxfilter, colsummary ], 2, mean  )
  leaguedf$wage[ idxdf ]          = leaguedf$wage[ idxdf ] * leaguedf$athletesCount[ idxdf ]
  leaguedf$weeklyWage[ idxdf ]    = paste( round( leaguedf$wage[ idxdf ]/1e3 ), 'k', sep = '' )
  leaguedf$teamName[ idxdf ]      = xml_text( xml_find_first( teamdoc, 'teamName' ) )
  leaguedf$owner[ idxdf ]         = xml_text( xml_find_first( teamdoc, 'owner' ) )
  leaguedf$regionId[ idxdf ]      = xml_text( xml_find_first( teamdoc, 'regionId' ) )
  return( leaguedf )
}
###########################################################################################################


###########################################################################################################
writeLeagueTable <- function( dfwrite, outlabel, digits, outdir, season, level, number, nationName ) {
  # Write out the league table in html format
  dfwrite        = dfwrite[ order( -dfwrite$wage ), ]
  dfwrite$wage   = NULL
  outfile        = paste( outdir, '/table_league', leagueid, '_', outlabel, '.html', sep = '' )
  outfile_str    = paste( outdir, '/title_league', leagueid, '.html', sep = '' )
  writeLines( print( xtable( dfwrite, digits = digits ), type="html", html.table.attributes="", include.rownames = FALSE  ), outfile )
  cat( paste( "Season ", season, "; ", nationName, " League ", level, ".", number, sep = ''), file = outfile_str  )
}
###########################################################################################################
