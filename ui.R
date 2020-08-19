library(shinydashboard)
library(recommenderlab)
library(dplyr)
library(TMDb)
library(e1071)

# Load the movie & ratings data
load('MovieDB.rda')
titles <- colnames(MovieDB)


#UI dashboard code 
shinyUI(dashboardPage(
  skin = "yellow",
  dashboardHeader(title = "Movie Recommendation Engine", titleWidth = 400),
  dashboardSidebar(sidebarMenu(
    menuItem("Movies", tabName = "movies", icon = icon("star-o")),
    menuItem("Plot", tabName = "plot", icon = icon("star-o")),
    menuItem(
      "Help",
      tabName = "help",
      icon = icon("question-circle")
    ),
    menuItem(h5("Plot"),
             list(
               radioButtons("plotoption", "Choose the Option:", choices = c("Histogram", "BarPlot", "Scatter", "Pie")),
               selectInput("colo", "Choose Varibale", choices = c('year'=3,'rating'=4,'votes'=5,'length'=6), selected = 'rating'),
               textInput("xaxisname", "Write X Axis Name"),
               textInput("yaxisname", "Write Y Axis Name"),
               textInput("title", "Write Title For the Graph"),
               submitButton('Submit')
             )),
    menuItem(h5("Movie Recommender System"),
      list(
      selectInput(
        "select",
        label = h5("Select 3 Movies That You Like"),
        choices = as.character(titles[order(titles)]),
        selectize = FALSE,
        selected = "Sherlock Holmes (2009)"
      ),
      selectInput(
        "select2",
        label = NA,
        choices = as.character(titles[order(titles)]),
        selectize = FALSE,
        selected = "Forrest Gump (1994)"
      ),
      selectInput(
        "select3",
        label = NA,
        choices = as.character(titles[order(titles)]),
        selectize = FALSE,
        selected = "Silence of the Lambs, The (1991)"
      ),
      submitButton("Submit")
    ))
  )),

#dashboard functionality
  dashboardBody(
    
    tags$head(tags$style(HTML('
                                /* logo */
                                .skin-blue .main-header .logo {
                                background-color: #f4b943;
                                }

                                /* logo when hovered */
                                .skin-blue .main-header .logo:hover {
                                background-color: #f4b943;
                                }

                                /* navbar (rest of the header) */
                                .skin-blue .main-header .navbar {
                                background-color: #f4b943;
                                }

                                /* main sidebar */
                                .skin-blue .main-sidebar {
                                background-color: #f4b943;
                                }

                                /* active selected tab in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                                background-color: #ff0000;
                                }

                                /* other links in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                                background-color: #00ff00;
                                color: #000000;
                                }

                                /* other links in the sidebarmenu when hovered */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                                background-color: #ff69b4;
                                }
                                /* toggle button when hovered  */
                                .skin-blue .main-header .navbar .sidebar-toggle:hover{
                                background-color: #ff69b4;
                                }

                                /* body */
                                .content-wrapper, .right-side {
                                background-color: #000000;
                                }

                                '))),

    tabItems(
      tabItem(tabName = "help",
              h2("About this App"),
              HTML('<br/>'),
              fluidRow(
                box(
                  title = "Creator: Nikhil Mishra",
                  background = "black",
                  width = 7,
                  collapsible = TRUE,
                  helpText(p(
                    strong(
                      "This app recommends you next 10 movies to watch based on your 3 choices , which tells the app about your favorite genres with the help of Machine Learning."
                    )
                  )),
                  helpText(p(strong(
                    "Tap on Movie Recommender System to start"
                  )
                  )),

                  helpText(
                    p(
                      "Please contact me in case of any problems with the app at my",
                      a(href = "https://www.linkedin.com/in/nikhil-mishra-906491180/", "LinkedIN", target = "_blank"),
                    )
                  )
                )
              )),
      tabItem(
        tabName = "movies",
        fluidRow(uiOutput("ui")),
        fluidRow(
          valueBoxOutput("tableRatings1"),
          valueBoxOutput("tableRatings2"),
          valueBoxOutput("tableRatings3"),
          HTML('<br/>')
        ),
        fluidRow(
          box(
            width = 6,
            status = "info",
            solidHead = TRUE,
            title = "Other Movies You Might Like",
            fluidRow(uiOutput("ui2")),
            tableOutput("table")
          )
        )
      ),
      tabItem(
        tabName = 'plot',
        fluidRow(
          plotOutput("plot")
        )
      )
    )
  )
))

