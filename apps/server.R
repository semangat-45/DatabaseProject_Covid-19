function(input, output, session){
  # Tab COVID-19 by Date --------------------------------------
  tab1 <- reactive({
    in01_date <- toString(input$in01_date)
    q1 <- sprintf("SELECT a.continent as Continent  
                        , a.convert_name as Country
                        , a.country_code as Code
                        , SUM(b.cases) as Covid_Case
                        , SUM(b.deaths) as Cases_of_Covid_Death
                        , SUM(b.recovered) as Covid_Recovery_Cases
                        , SUM(b.cumulate_cases) as Cumulative_Cases
                        , SUM(b.cumulate_deaths) as Cumulative_Deaths
                        , SUM(b.cumulate_recovered) as Cumulative_Recovered
                        --, c.source_name as Source
                  FROM country a
                  JOIN (SELECT ad.time_id
                  	    , it.date
                  	    , ad.country_id
                  	    , ad.cases
                  	    , ad.deaths
                  	    , ad.recovered
                  	    , ad.cumulate_cases
                  	    , ad.cumulate_deaths
                  	    , ad.cumulate_recovered
                  	    --, ad.source_id
                        FROM data ad
                        JOIN time it ON it.time_id=ad.time_id
                        GROUP BY ad.time_id
                        		, it.date
                        		, ad.country_id
                        		, ad.cases
                        	 	, ad.deaths
                        	 	, ad.recovered
                        	 	, ad.cumulate_cases
                        	 	, ad.cumulate_deaths
                        	 	, ad.cumulate_recovered
                        		, ad.source_id
                  	 ) b ON b.country_id = a.country_id
                  WHERE b.date = '%s'
                  GROUP BY Country, Continent, Code", in01_date)
    DB <- connectDB()
    out01_table <- dbGetQuery(DB, q1)
    dbDisconnect(DB)
    out01_table
  })
  
  output$out01_table <- renderDataTable({
    if (nrow(tab1()) == 0){
      data.frame(message = "Hanya data dari 1 Januari 2020 hingga 30 Juni 2020 yang tersedia.")
    } else {
      tab1()
    }
  })
  
  output$out01_plot1 <- renderPlot({
    world <- TMWorldBorders
    world <- merge(world, tab1(), by.x = "ISO3", by.y="code")
    spplot(world,"covid_case", main="COVID-19 Case", na.rm = T)
  })
  
  output$out01_plot2 <- renderPlot({
    world <- TMWorldBorders
    world <- merge(world, tab1(), by.x = "ISO3", by.y="code")
    spplot(world,"cumulative_cases", main="COVID-19 Cumulative Case", na.rm = T)
  })
  
  # Tab COVID-19 by Country --------------------------------------
  tab2 <- reactive({
    in02_country <- input$in02_country
    q2 <- sprintf("SELECT b.date as Date
                    , SUM(b.cases) as Covid_Case
                    , SUM(b.deaths) as Cases_of_Covid_Death
                    , SUM(b.recovered) as Covid_Recovery_Cases
                    , SUM(b.cumulate_cases) as Cumulative_Cases
                    , SUM(b.cumulate_deaths) as Cumulative_Deaths
                    , SUM(b.cumulate_recovered) as Cumulative_Recovered
                    --, c.source_name as Source
              FROM country a
              JOIN (SELECT ad.time_id
              	    , it.date
              	    , ad.country_id
              	    , ad.cases
              	    , ad.deaths
              	    , ad.recovered
              	    , ad.cumulate_cases
              	    , ad.cumulate_deaths
              	    , ad.cumulate_recovered
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
                  	    , ad.cumulate_cases
                  	    , ad.cumulate_deaths
                  	    , ad.cumulate_recovered
              	 ) b ON b.country_id = a.country_id
              WHERE a.country_name = '%s'
              GROUP BY Date", in02_country)
    DB <- connectDB()
    out02_table <- dbGetQuery(DB, q2)
    dbDisconnect(DB)
    out02_table
  })
  
  output$out02_table <- renderDataTable({
    tab2()
  })
  
  output$out02_plot1 <- renderPlotly({
    fig2a <- plot_ly(tab2(), x = ~date, y = ~covid_case, name = 'New Cases', type = 'scatter', mode = 'lines') 
    fig2a <- fig2a %>% add_trace(y = ~cases_of_covid_death, name = 'New Death', type = 'scatter', mode = 'lines') 
    fig2a <- fig2a %>% add_trace(y = ~covid_recovery_cases, name = 'New Recovery', type = 'scatter', mode = 'lines') 
    fig2a
  })
  
  output$out02_plot2 <- renderPlotly({
    fig2b <- plot_ly(tab2(), x = ~date, y = ~cumulative_cases, name = 'Cumulative Cases', type = 'scatter', mode = 'lines') 
    fig2b <- fig2b %>% add_trace(y = ~cumulative_deaths, name = 'Cumulative Death', type = 'scatter', mode = 'lines') 
    fig2b <- fig2b %>% add_trace(y = ~cumulative_recovered, name = 'Cumulative Recovery', type = 'scatter', mode = 'lines') 
    fig2b
  })
  
  # Tab COVID-19 by Date & Country --------------------------------------
  tab3 <- reactive({
    in03_date <- toString(input$in03_date)
    in03_country <- input$in03_country
    q3 <- sprintf("SELECT a.country_code as Code
                        , a.convert_name as Country
                        , SUM(b.cases) as Covid_Case
                        , SUM(b.deaths) as Cases_of_Covid_Death
                        , SUM(b.recovered) as Covid_Recovery_Cases
                        , SUM(b.cumulate_cases) as Cumulative_Cases
                        , SUM(b.cumulate_deaths) as Cumulative_Deaths
                        , SUM(b.cumulate_recovered) as Cumulative_Recovered
                        --, c.source_name as Source
                  FROM country a
                  JOIN (SELECT ad.time_id
                  	    , it.date
                  	    , ad.country_id
                  	    , ad.cases
                  	    , ad.deaths
                  	    , ad.recovered
                  	    , ad.cumulate_cases
                  	    , ad.cumulate_deaths
                  	    , ad.cumulate_recovered
                  	    --, ad.source_id
                        FROM data ad
                        JOIN time it ON it.time_id=ad.time_id
                        GROUP BY ad.time_id
                        		, it.date
                  		, ad.country_id
                  		, ad.cases
                  	 	, ad.deaths
                  	 	, ad.recovered
                  	 	, ad.cumulate_cases
                  	  , ad.cumulate_deaths
                  	  , ad.cumulate_recovered
                  		, ad.source_id
                  	 ) b ON b.country_id = a.country_id
                  WHERE b.date = '%s'
                  AND a.country_name = '%s'
                  GROUP BY Country, Code", in03_date, in03_country)
    DB <- connectDB()
    out03_table <- dbGetQuery(DB, q3)
    dbDisconnect(DB)
    out03_table
  })
  
  output$out03_table <- renderDataTable({
    if (nrow(tab3()) == 0){
      data.frame(message = "Hanya data dari 1 Januari 2020 hingga 30 Juni 2020 yang tersedia.")
    } else {
      tab3()
    }
  })
  
  output$out03_plot1 <- renderPlot({
    world <- TMWorldBorders
    world <- merge(world, tab1(), by.x = "ISO3", by.y="code")
    sub <- world[world$ISO3 == tab3()$code,]
    plot(sub, col=world$ISO3); text(sub, tab3()$country, cex=1)
  })

  # Tab COVID-19 Health Index and Mitigation --------------------------------------
  tab4a <- reactive({
    in04_year <- toString(input$in04_year)
    q4a <- sprintf("SELECT d.convert_name as Country
                          , ROUND(AVG(CAST(a.value AS numeric)), 4) as Health_Index
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
  
  tab4b <- reactive({
    in04_year <- toString(input$in04_year)
    q4b <- sprintf("SELECT d.convert_name as Country
                          ,  ROUND(AVG(CAST(a.value AS numeric)), 4) as Health_Index
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
    tab4a()
  })
  
  output$out04_table2 <- renderDataTable({
    tab4b()
  })
  
  ui04 <- reactive({
    selectInput(
      inputId = "in04_country",
      label = "Pilih Negara",
      choices = c(tab4a()$country, tab4b()$country)
    )
  })
  
  output$out04_ui <- renderUI({
    ui04()
  })
  
  output$out04_table3 <- renderDataTable({
    in04_year <- input$in04_year
    in04_country <- req(input$in04_country)
    q4c <- sprintf("SELECT b.measure_value as Countermeasures_Mitigation 
                   FROM country_health_index a JOIN measurement b on b.country_id=a.country_id 
                   JOIN time c ON c.time_id=a.time_id 
                   JOIN country d ON d.country_id=a.country_id
                   WHERE c.year = %s AND d.convert_name = '%s'", 
                   in04_year, in04_country)
    DB <- connectDB()
    out04_table3 <- dbGetQuery(DB, q4c)
    dbDisconnect(DB)
    out04_table3
  })
  
  output$out04_plot1 <- renderPlotly({
    fig4a <- plot_ly(tab4a(), x = ~country, y = ~health_index, type = 'bar', textposition = 'auto',
                     marker = list(color = 'rgb(158,202,225)',
                                   line = list(color = 'rgb(8,48,107)', width = 1.5)))
    fig4a <- fig4a %>% layout(title = "Top 10 Highest Health Index Countries",
                              xaxis = list(title = ""),
                              yaxis = list(title = ""))
    
    fig4a
  })
  
  output$out04_plot2 <- renderPlotly({
    fig4b <- plot_ly(tab4b(), x = ~country, y = ~health_index, type = 'bar', textposition = 'auto',
                     marker = list(color = 'rgb(158,202,225)',
                                   line = list(color = 'rgb(8,48,107)', width = 1.5)))
    fig4b <- fig4b %>% layout(title = "Top 10 Lowest Health Index Countries",
                              xaxis = list(title = ""),
                              yaxis = list(title = ""))
    
    fig4b
  })
  
  # Tab Country Testing Policy --------------------------------------
  tab5a <- reactive({
    in05_country <- input$in05_country
    q5 <- sprintf("SELECT b.date
      		-- , ct.convert_name as country
      		, a.value as Number_Of_Testing
      		, SUM(c.cases) as New_Case
      		, SUM(c.deaths) as New_Death
      		, SUM(c.recovered) as New_Recover
      		, (SUM(c.cases)+c.cumulate_cases) as Total_Cases
      		, (SUM(c.deaths)+c.cumulate_deaths) as Total_Deaths
      		, (SUM(c.recovered)+c.cumulate_recovered) as Total_Recovered
      		, e.value as Health_Index
      		-- , d.measure_value as Mitigation
      		-- , d.Category
      FROM country_testing_policy a
      JOIN country ct ON ct.country_id=a.country_id
      JOIN time b ON b.time_id=a.time_id 
      JOIN data c ON c.time_id=a.time_id and c.country_id=a.country_id
      JOIN (SELECT aa.country_id
      	  		, max(value) as value
      	  FROM country_health_index aa
      	  JOIN(SELECT country_id
      		   		, max(time_id) as time_id
      	  	   FROM country_health_index
      		     GROUP BY country_id) bb ON bb.time_id=aa.time_id and bb.country_id=aa.country_id
      	       GROUP BY aa.country_id
      	  ) e ON e.country_id=a.country_id
      JOIN measurement d ON d.country_id=a.country_id and d.time_id=a.time_id
      WHERE a.value != '0' AND ct.convert_name = '%s'
      GROUP BY b.date
      		, a.value
      		, c.cumulate_cases
      		, c.cumulate_deaths
      		, c.cumulate_recovered
      		, e.value
      		, ct.convert_name
      		, d.measure_value
      		, d.category
      HAVING SUM(c.cases) > 0
      Order by b.date asc", in05_country)
    DB <- connectDB()
    out05_table1 <- dbGetQuery(DB, q5)
    dbDisconnect(DB)
    out05_table1
  })
  
  tab5b <- reactive({
    in05_country <- input$in05_country
    q5 <- sprintf("SELECT b.date
      		-- , ct.convert_name as country
      		, e.value as Health_Index
      		, d.measure_value as Mitigation
      		, d.Category
      FROM country_testing_policy a
      JOIN country ct ON ct.country_id=a.country_id
      JOIN time b ON b.time_id=a.time_id 
      JOIN data c ON c.time_id=a.time_id and c.country_id=a.country_id
      JOIN (SELECT aa.country_id
      	  		, max(value) as value
      	  FROM country_health_index aa
      	  JOIN(SELECT country_id
      		   		, max(time_id) as time_id
      	  	   FROM country_health_index
      		     GROUP BY country_id) bb ON bb.time_id=aa.time_id and bb.country_id=aa.country_id
      	       GROUP BY aa.country_id
      	  ) e ON e.country_id=a.country_id
      JOIN measurement d ON d.country_id=a.country_id and d.time_id=a.time_id
      WHERE a.value != '0' AND ct.convert_name = '%s'
      GROUP BY b.date
      		, a.value
      		, c.cumulate_cases
      		, c.cumulate_deaths
      		, c.cumulate_recovered
      		, e.value
      		, ct.convert_name
      		, d.measure_value
      		, d.category
      HAVING SUM(c.cases) > 0
      Order by b.date asc", in05_country)
    DB <- connectDB()
    out05_table2 <- dbGetQuery(DB, q5)
    dbDisconnect(DB)
    out05_table2
  })
  
  output$out05_table1 <- renderDataTable({
    tab5a()
  })
  
  output$out05_table2 <- renderDataTable({
    tab5b()
  })
  
}