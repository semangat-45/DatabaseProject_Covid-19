library(shiny)
library(shinydashboard)
library(DT)
library(DBI)
library(dashboardthemes)
library("sp", "gstat")
library(raster)
library(rgdal)
library(spdep)
library(prevR)
library(plotly)
source("conf.R")

countries <- dbGetQuery(connectDB(), "SELECT country_name FROM country")
years <- dbGetQuery(connectDB(), "SELECT year FROM time WHERE time_id IN (1, 6, 11, 16, 21, 26)")

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
          "COVID-19 Database Home Page"
        ),
        fluidRow(
          column(
            width = 4
          ),
          column(
            width = 4,
            htmlOutput("logo")
          ),
          column(
            width = 4
          )
        ),
        fluidRow(
          column(
            width = 6,
            tags$p(
              "Selamat datang di halaman proyek  database COVID-19. Dalam proyek ini, kamu akan dapat mengakses informasi mengenai banyak hal, seperti:"
            ),
            fluidRow(
              column(
                width = 12,
                fluidRow(
                  column(
                    width = 12,
                    tags$ul(
                      tags$li(
                        "Informasi jumlah kasus COVID-19 yang baru, meninggal, atau sembuh di seluruh dunia dari 1 Januari 2020 hingga 30 Juni 2020"
                      )
                    )
                  )
                ),
                fluidRow(
                  column(
                    width = 12,
                    tags$ul(
                      tags$li(
                        "Informasi mengenai indeks kesehatan yang dicapai 210 negara di seluruh dunia sejak tahun 1990"
                      )
                    )
                  )
                ),
                fluidRow(
                  column(
                    width = 12,
                    tags$ul(
                      tags$li(
                        "Informasi mengenai mitigasi yang dilakukan oleh negara-negara di dunia dalam menangani COVID-19"
                      )
                    )
                  )
                )
              )
            )
          ),
          column(
            width = 6
          )
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
        plotlyOutput(
          outputId = "out02_plot1"
        ),
        plotlyOutput(
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
        )
      ),
      tabItem(
        tabName = "health_index",
        h1(
          "Health Index Statistics Dashboard"
        ),
        selectInput(
          inputId = "in04_year",
          label = "Masukkan Tahun",
          choices = years,
          width = "60%"
        ),
        fluidRow(
          column(
            width = 6,
            dataTableOutput(
              outputId = "out04_table1"
            )
          ),
          column(
            width = 6,
            dataTableOutput(
              outputId = "out04_table2"
            )
          )
        ),
        plotlyOutput(
          outputId = "out04_plot1"
        ),
        plotlyOutput(
          outputId = "out04_plot2"
        ),
        uiOutput(
          outputId = "out04_ui"
        ),
        dataTableOutput(
          outputId = "out04_table3"
        ),
      ),
      tabItem(
        tabName = "testing",
        h1(
          "Testing Policy Dashboard"
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

