connectDB <- function(){
  DBlocal <- dbConnect(RPostgres::Postgres(),
                       dbname = 'covid', 
                       host = 'localhost',
                       port = 5432, 
                       user = 'postgres',
                       password = '008800')
  return(DBlocal)
}

function(input, output, session){
  # Tab COVID-19 by Date --------------------------------------
  output$out01_table <- renderDataTable({
    in01_date <- toString(input$in01_date)
    q1 <- sprintf("SELECT a.continent as Continent  
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
                  WHERE b.date = '%s'
                  GROUP BY Country, Continent", in01_date)
    #q2 <- sprintf("SELECT d.day_name FROM day d
    #            JOIN time t on t.day_of_week = d.day_id WHERE t.date = '%s'", 
    #              in01_date)
    DB <- connectDB()
    out01_table <- dbGetQuery(DB, q1)
    day <- toString(dbGetQuery(DB, q2)[1,1])
    dbDisconnect(DB)
    if (nrow(out01_table) == 0){
      data.frame(message = "Hanya data dari 1 Januari 2020 hingga 30 Juni 2020 yang tersedia.")
    } else {
      out01_table
    }
  })
  
  # Tab COVID-19 by Country --------------------------------------
  output$out02_table <- renderDataTable({
    in02_country <- input$in02_country
    q2 <- sprintf("SELECT b.date as Date
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
              WHERE a.country_name = '%s'
              GROUP BY Date", in02_country)
    DB <- connectDB()
    out02_table <- dbGetQuery(DB, q2)
    dbDisconnect(DB)
    out02_table
  })
  
  # Tab COVID-19 by Date & Country --------------------------------------
  output$out03_table <- renderDataTable({
    in03_date <- toString(input$in03_date)
    in03_country <- input$in03_country
    q3 <- sprintf("SELECT SUM(b.cases) as Covid_Case
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
                  WHERE b.date = '%s'
                  AND a.country_name = '%s'", in03_date, in03_country)
    DB <- connectDB()
    out03_table <- dbGetQuery(DB, q3)
    dbDisconnect(DB)
    if (nrow(out03_table) == 0){
      df <- data.frame(message = "Hanya data dari 1 Januari 2020 hingga 30 Juni 2020 yang tersedia.")
      df
    } else {
      out03_table
    }
  })
  
  # Tab COVID-19 by Mitigation --------------------------------------
  table1 <- reactive({
    in04_year <- toString(input$in04_year)
    q4a <- sprintf("SELECT d.convert_name as Country
                          , AVG(a.value) as Health_Index
                          -- , b.measure_value as Countermeasures_Mitigation
                    FROM country_health_index a
                    JOIN measurement b on b.country_id=a.country_id
                    JOIN time c ON c.time_id=a.time_id 
                    JOIN country d ON d.country_id=a.country_id
                    WHERE c.year = '%s'
                    GROUP BY Country
                    ORDER BY Health_Index DESC
                    LIMIT 10", in04_year)
    DB <- connectDB()
    out04_table1 <- dbGetQuery(DB, q4a)
    dbDisconnect(DB)
    out04_table1
  })
  
  table2 <- reactive({
    in04_year <- toString(input$in04_year)
    q4b <- sprintf("SELECT d.convert_name as Country
                          , AVG(a.value) as Health_Index
                          -- , b.measure_value as Countermeasures_Mitigation
                    FROM country_health_index a
                    JOIN measurement b on b.country_id=a.country_id
                    JOIN time c ON c.time_id=a.time_id 
                    JOIN country d ON d.country_id=a.country_id
                    WHERE c.year = '%s'
                    GROUP BY Country
                    ORDER BY Health_Index ASC
                    LIMIT 10", in04_year)
    DB <- connectDB()
    out04_table2 <- dbGetQuery(DB, q4b)
    dbDisconnect(DB)
    out04_table2
  })
  
  output$out04_table1 <- renderDataTable({
    table1()
  })
  
  output$out04_table2 <- renderDataTable({
    table2()
  })
  
  output$out04_ui <- renderUI({
    selectInput(
      inputId = "in04_country",
      label = "Pilih Negara",
      choices = c(table1()$country, table2()$country)
    )
  })
  
  output$out04_table3 <- renderDataTable({
    in04_year <- input$in04_year
    in04_country <- input[['in04_country']]
    q4c <- sprintf("SELECT b.measure_value as Countermeasures_Mitigation
                    FROM country_health_index a
                    JOIN measurement b on b.country_id=a.country_id
                    JOIN time c ON c.time_id=a.time_id 
                    JOIN country d ON d.country_id=a.country_id
                    WHERE c.year = '%s' AND d.convert_name = '%s'", in04_year, in04_country)
    DB <- connectDB()
    out04_table3 <- dbGetQuery(DB, q4c)
    dbDisconnect(DB)
    out04_table3
  })
}