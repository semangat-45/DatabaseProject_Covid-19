source("conf.R")

DB <- DBserver
function(input, output, session){
  # Tab COVID-19 by Date --------------------------------------
  output$out01_table <- renderDataTable({
    in01_date <- toString(input$in01_date)
    q1 <- sprintf("SELECT b.date as Date
                        , a.continent as Continent  
                        , a.convert_name as Country
                        , SUM(b.cases) as Covid_Case
                        , SUM(b.deaths) as Cases_of_Covid_Death
                        , SUM(b.recovered) as Covid_Recovery_Cases
                        --, c.source_name as Source
                  FROM country a
                  JOIN (SELECT ad.time_id
                  	    , it.date
                  	    , ad.country_id
                  	    , ad.cases
                  	    , ad.deaths
                  	    , ad.recovered
                  	    --, ad.source_id
                        FROM data ad
                        JOIN time it ON it.time_id=ad.time_id
                        GROUP BY ad.time_id
                        		, it.date
                  		, ad.country_id
                  		, ad.cases
                  	 	, ad.deaths
                  	 	, ad.recovered
                  		, ad.source_id
                  	 ) b ON b.country_id = a.country_id
                  WHERE Date = '%s'
                  GROUP BY Date, Country, Continent", in01_date)
    q2 <- sprintf("SELECT d.day_name FROM day d
                JOIN time t on t.day_of_week = d.day_id WHERE t.date = '%s'", 
                  in01_date)
    DBserver <- DB
    out01_table <- dbGetQuery(DBserver, q1)
    day <- toString(dbGetQuery(DBserver, q2)[1,1])
    dbDisconnect(DBserver)
    if (nrow(out01_table) == 0){
      data.frame(message = "Hanya data dari 1 Januari 2020 hingga 30 Juni 2020 yang tersedia.")
    } else {
      out01_table
    }
  })
  
  # Tab COVID-19 by Country --------------------------------------
  output$out02_table <- renderDataTable({
    
  })
  
  
  # Tab COVID-19 by Date & Country --------------------------------------
}