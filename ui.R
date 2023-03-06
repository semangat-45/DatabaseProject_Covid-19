library(shiny)
library(shinydashboard)
library(DT)
library(DBI)
library(dashboardthemes)
source("server.R")

countries <- dbGetQuery(connectDB(), "SELECT country_name FROM country")

dashboardPage(
  title = "COVID-19 Database",
  dashboardHeader(
    title = "COVID-19 Database"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        text = "Home",
        tabName = "home",
        icon = icon("house")
      ),
      menuItem(
        text = "COVID-19 by Date",
        tabName = "date",
        icon = icon("calendar")
      ),
      menuItem(
        text = "COVID-19 by Country",
        tabName = "country",
        icon = icon("building-flag")
      ),
      menuItem(
        text = "COVID-19 by Date & Country",
        tabName = "date_country",
        icon = icon("calendar-plus")
      ),
      menuItem(
        text = "Health Index Statistics",
        tabName = "health_index",
        icon = icon("heart-pulse")
      ),
      menuItem(
        text = "Testing Policy",
        tabName = "testing",
        icon = icon("syringe")
      )
    )
  ),
  dashboardBody(
    shinyDashboardThemes(
      theme = "poor_mans_flatly"
    ),
    tabItems(
      tabItem(
        tabName = "home",
        h1(
          "Home"
        )
      ),
      tabItem(
        tabName = "date",
        h1(
          "COVID-19 by Date Dashboard"
        ),
        dateInput(
          inputId = "in01_date",
          label = "Masukkan Tanggal",
          width = "60%"
        ),
        dataTableOutput(
          outputId = "out01_table"
        ),
        plotOutput(
          outputId = "out01_plot1"
        ),
        plotOutput(
          outputId = "out01_plot2"
        ),
        plotOutput(
          outputId = "out01_plot3"
        )
      ),
      tabItem(
        tabName = "country",
        h1(
          "COVID-19 by Country Dashboard"
        ),
        selectInput(
          inputId = "in02_country",
          label = "Masukkan Negara",
          choices = countries,
          width = "60%"
        ),
        dataTableOutput(
          outputId = "out02_table"
        ),
        plotOutput(
          outputId = "out02_plot1"
        ),
        plotOutput(
          outputId = "out02_plot2"
        )
      ),
      tabItem(
        tabName = "date_country",
        h1(
          "COVID-19 by Date & Country Dashboard"
        ),
        dateInput(
          inputId = "in03_date",
          label = "Masukkan Tanggal",
          width = "50%"
        ),
        selectInput(
          inputId = "in03_country",
          label = "Masukkan Negara",
          choices = countries,
          width = "50%"
        ),
        dataTableOutput(
          outputId = "out03_table"
        ),
        plotOutput(
          outputId = "out03_plot1"
        ),
        plotOutput(
          outputId = "out03_plot2"
        )
      ),
      tabItem(
        tabName = "health_index",
        h1(
          "Health Index Statistics Dashboard"
        ),
        dateInput(
          inputId = "in04_date",
          label = "Masukkan Tanggal",
          width = "60%"
        ),
        fluidRow(
          column(
            width = 6,
            dataTableOutput(
              outputId = "in04_date2"
            )
          ),
          column(
            width = 6,
            dataTableOutput(
              outputId = "out04_table1"
            )
          )
        ),
        plotOutput(
          outputId = "out04_plot1"
        ),
        plotOutput(
          outputId = "out04_plot2"
        ),
        selectInput(
          inputId = "in04_country",
          label = "Masukkan Negara",
          choices = countries,
          width = "60%"
        ),
        dataTableOutput(
          outputId = "out04_table2"
        )
      ),
      tabItem(
        tabName = "testing",
        h1(
          "Testing Policy Dashboard"
        ),
        dateRangeInput(
          inputId = "in05_date",
          label = "Masukkan Rentang Tanggal",
          width = "100%"
        ),
        selectInput(
          inputId = "in05_country",
          label = "Masukkan Negara",
          choices = countries,
          width = "60%"
        ),
        dataTableOutput(
          outputId = "out05_table1"
        ),
        dataTableOutput(
          outputId = "out05_table2"
        )
      )
    )
  )
)

