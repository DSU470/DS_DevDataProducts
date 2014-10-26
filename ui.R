library(shiny)
library(ggplot2)

# Define UI for shinyCarsApp 
shinyUI(fluidPage(
  # Application title
  titlePanel( h3("Welcome to shinyCarsApp: Explore cars dataset") ),
  helpText('With the shineCarsApp it becomes easy to explore the datasets about cars. Each tab (on the right) shows a different capability of shinyCarsApp. To adjust what is shown on the tabs, please change the settings on the left.'),
  fluidRow(
    column(3,
           wellPanel(
             # Display a panel with options/settings for the data tab
             conditionalPanel(
               'input.tabType === "Data"',
               h5("Settings for data tab"),
               helpText('Select the columns that are to be displayed in the datagrid.'),
               checkboxGroupInput('show_columns', ' ',
                                  names(mtcars), selected = names(mtcars))
             ),
             # Display a panel with options/settings for the statistics tab
             conditionalPanel(
               'input.tabType === "Statistics"',
               h5("Settings for statistics tab"),
               helpText('Choose the type of statistics you would like to explore.'),
               selectizeInput('st', ' ', choices = NULL)         
             ),
             # Display a panel with options/settings for the plot tab
             conditionalPanel(
               'input.tabType === "Plot"',
               h5("Settings for plot tab"),
               helpText('Choose the plot you would like to draw.'),
               selectizeInput('plottype', ' ', choices = NULL)
             )
          ),
          wellPanel(
            tags$small(paste0(
              "Note: This shinyapp is for learning purposes only, far from ideal in terms of user experience.",
              " Have fun!"
            ))
          )
    ),
    # Display the main tab area, showing the output.
    column(9,
           wellPanel(
             tabsetPanel(id = 'tabType',
                         tabPanel('Data', dataTableOutput("mytable1")),
                         tabPanel("Statistics", verbatimTextOutput("statistics")),
                         tabPanel("Plot", plotOutput("plot"))
             )
           )
    )
  )
))