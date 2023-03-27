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
library(bslib)
source("conf.R")

countries <-
  dbGetQuery(connectDB(), "SELECT country_name FROM country")
years <-
  dbGetQuery(connectDB(),
             "SELECT year FROM time WHERE time_id IN (1, 6, 11, 16, 21, 26)")

dashboardPage(
  skin = "black",
  title = "COVID-19 Database",
  dashboardHeader(title = "COVID-19 Database"),
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
    shinyDashboardThemes(theme = "poor_mans_flatly"),
    tabItems(
      tabItem(
        tabName = "home",
        h1("COVID-19 Database Home Page"),
        fluidRow(
          column(width = 4,
                 div(
                   style = "display: inline-block; width: 33%;",
                   img(
                     src = "https://upload.wikimedia.org/wikipedia/commons/d/d2/Solid_white.png",
                     height = 150,
                     width = 150
                   )
                 )),
          column(
            width = 4,
            div(
              style = "display: inline-block; width: 100%",
              align = "center",
              img(
                src = "https://raw.githubusercontent.com/semangat-45/DatabaseProject_Covid-19/main/docs/logo.PNG",
                height = 150,
                width = 150
              )
            )
          ),
          column(width = 4,
                 div(
                   style = "display: inline-block; width: 33%;",
                   img(
                     src = "https://upload.wikimedia.org/wikipedia/commons/d/d2/Solid_white.png",
                     height = 150,
                     width = 150
                   )
                 ))
        ),
        fluidRow(
          column(
            width = 6,
            fluidRow(column(
              width = 12,
              tags$p(
                "Selamat datang di halaman proyek  database COVID-19. Dalam proyek ini, kamu akan dapat mengakses informasi mengenai banyak hal, seperti:"
              )
            )),
            column(
              width = 12,
              fluidRow(column(width = 12,
                              tags$ul(
                                tags$li(
                                  "Informasi jumlah kasus COVID-19 yang baru, meninggal, atau sembuh di seluruh dunia dari 1 Januari 2020 hingga 30 Juni 2020"
                                )
                              ))),
              fluidRow(column(width = 12,
                              tags$ul(
                                tags$li(
                                  "Informasi mengenai indeks kesehatan yang dicapai 210 negara di seluruh dunia sejak tahun 1990"
                                )
                              ))),
              fluidRow(column(width = 12,
                              tags$ul(
                                tags$li(
                                  "Informasi mengenai mitigasi yang dilakukan oleh negara-negara di dunia dalam menangani COVID-19"
                                )
                              )))
            ),
            fluidRow(column(
              width = 12,
              tags$p(
                "Project ini merupakan tugas kelompok mata kuliah STA1562 Manajemen Data Statistika. Project ini dibimbing oleh Alfa Nugraha Pradana S.Kom. dengan anggota project kelompok sebagai berikut:"
              ),
              tags$ul(
                tags$li(
                  "Rizki Alifah Putri (G1501221005 - rizkialifah@apps.ipb.ac.id) as Database Manager"
                ),
                tags$li(
                  "Nur Khamidah (G1501221023 - nur.khamidah@apps.ipb.ac.id) as Back-end Shiny Developer"
                ),
                tags$li(
                  "Bayu Paramita (G1501222052 - bayu.paramita@apps.ipb.ac.id) as Front-end Shiny Developer"
                ),
                tags$li(
                  "Kristuisno M. Kapiluka (G1501221034 - kris009kapiluka@apps.ipb.ac.id) as Technical Writer"
                )
              )
            )),
            fluidRow(column(
              width = 12,
              tags$p("Adapun project ini dapat juga diakses melalui link berikut:"),
              tags$a(href = "https://github.com/semangat-45/DatabaseProject_Covid-19", "GITHUB PROJECT COVID-19 DATABASE")
            ))
          ),
          column(
            width = 6,
            div(
              style = "display: inline-block; margin-left:40px; margin-right:50px;
                width: 33%; margin-bottom:10px; margin-top:50px",
              img(src = "https://images.pexels.com/photos/6366444/pexels-photo-6366444.jpeg", width = 500)
            ),
            tags$p(style = 'margin-left:40px', "Sumber: Pexels/Atypeek Dgn")
          )
        ),
        fluidRow(column(
          width = 12,
          align = "center",
          tags$h3(style = 'padding-top:30px; padding-bottom:20px', "OUR TEAM")
        )),
        fluidRow(
          column(width = 3,
                 fluidRow(column(
                   width = 12,
                   div(
                     style = "display: inline-block; width: 100%",
                     align = "center",
                     img(
                       src = "https://raw.githubusercontent.com/semangat-45/DatabaseProject_Covid-19/main/docs/FE.PNG",
                       height = 150,
                       width = 150
                     )
                   )
                 )),
                 fluidRow(
                   column(width = 12,
                          align = "center",
                          tags$b("Bayu Paramita"))
                 ),),
          column(width = 3,
                 fluidRow(column(
                   width = 12,
                   div(
                     style = "display: inline-block; width: 100%",
                     align = "center",
                     img(
                       src = "https://raw.githubusercontent.com/semangat-45/DatabaseProject_Covid-19/main/docs/BE.PNG",
                       height = 150,
                       width = 150
                     )
                   )
                 )),
                 fluidRow(
                   column(width = 12,
                          align = "center",
                          tags$b("Nur Khamidah"))
                 ),),
          column(width = 3,
                 fluidRow(column(
                   width = 12,
                   div(
                     style = "display: inline-block; width: 100%",
                     align = "center",
                     img(
                       src = "https://raw.githubusercontent.com/semangat-45/DatabaseProject_Covid-19/main/docs/DBM.PNG",
                       height = 150,
                       width = 150
                     )
                   )
                 )),
                 fluidRow(
                   column(width = 12,
                          align = "center",
                          tags$b("Rizki Alifah Putri"))
                 ),),
          column(width = 3,
                 fluidRow(column(
                   width = 12,
                   div(
                     style = "display: inline-block; width: 100%",
                     align = "center",
                     img(
                       src = "https://raw.githubusercontent.com/semangat-45/DatabaseProject_Covid-19/main/docs/TW.PNG",
                       height = 150,
                       width = 150
                     )
                   )
                 )),
                 fluidRow(
                   column(width = 12,
                          align = "center",
                          tags$b("Kristuisno M. Kapiluka"))
                 ),)
        )
      ),
      tabItem(
        tabName = "date",
        h1("COVID-19 by Date Dashboard"),
        dateInput(
          inputId = "in01_date",
          label = "Masukkan Tanggal",
          width = "60%"
        ),
        dataTableOutput(outputId = "out01_table"),
        fluidRow(
          column(width = 6,
                 plotOutput(outputId = "out01_plot1")),
          column(width = 6,
                 plotOutput(outputId = "out01_plot2"))
        )
      ),
      tabItem(
        tabName = "country",
        h1("COVID-19 by Country Dashboard"),
        selectInput(
          inputId = "in02_country",
          label = "Masukkan Negara",
          choices = countries,
          width = "60%"
        ),
        dataTableOutput(outputId = "out02_table"),
        fluidRow(
          column(width = 6,
                 plotlyOutput(outputId = "out02_plot1")),
          column(width = 6,
                 plotlyOutput(outputId = "out02_plot2"))
        )
      ),
      tabItem(
        tabName = "date_country",
        h1("COVID-19 by Date & Country Dashboard"),
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
        dataTableOutput(outputId = "out03_table"),
        plotOutput(outputId = "out03_plot1")
      ),
      tabItem(
        tabName = "health_index",
        h1("Health Index Statistics Dashboard"),
        selectInput(
          inputId = "in04_year",
          label = "Masukkan Tahun",
          choices = years,
          width = "60%"
        ),
        fluidRow(
          column(width = 6,
                 dataTableOutput(outputId = "out04_table1")),
          column(width = 6,
                 dataTableOutput(outputId = "out04_table2"))
        ),
        fluidRow(
          column(width = 6,
                 plotlyOutput(outputId = "out04_plot1")),
          column(width = 6,
                 plotlyOutput(outputId = "out04_plot2"))
        ),
        uiOutput(outputId = "out04_ui"),
        dataTableOutput(outputId = "out04_table3"),
      ),
      tabItem(
        tabName = "testing",
        h1("Testing Policy Dashboard"),
        selectInput(
          inputId = "in05_country",
          label = "Masukkan Negara",
          choices = countries,
          width = "60%"
        ),
        dataTableOutput(outputId = "out05_table1"),
        dataTableOutput(outputId = "out05_table2")
      )
    )
  )
)
