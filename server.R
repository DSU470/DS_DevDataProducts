library(shiny)
library(datasets)
library(ggplot2)

shinyServer(
  
  function(input, output, session) {

    # Populate the control with available data columns, reactive to input$show_columns
    output$mytable1 = renderDataTable({
      mtcars[, input$show_columns, drop = FALSE]
    }, options = list(orderClasses = TRUE, 
                      lengthMenu = c(10, 20, 30, 40), 
                      pageLength = 10
                      ))
    
    # Populate the control with available types of summary stats, reactive to input$st
    updateSelectizeInput(session, 'st', choices = list(
      Descriptive = c(`Datatypes` = 'D', `First rows` = 'F', `Summary` = 'S'),
      Visual = c(`Histogram (unavailable)` = 'H', `Boxplot (unavailable)` = 'B')
    ), selected = 'D')
    
    # Populate the control with available plots, reactive to input$plottype
    updateSelectizeInput(session, 'plottype', choices = list(
      Visual = c(`Regression line (y=mpg, x=hp, by cylinder)` = 'L',`Regression line (y=mpg, x=weight, by gears)` = 'H', `Boxplot (unavailable)` = 'B')
    ), selected = 'L')
    
    
    # The output$statistics depends on the datasetInput reactive
    # expression, so will be re-executed whenever datasetInput is
    # invalidated (i.e. whenever the input$dataset changes)
    output$statistics <- renderPrint({
      dataset <- mtcars
      if (input$st=='F') head(dataset)
      else if (input$st=='D') str(dataset)
      else if (input$st=='S') summary(dataset)
      else "You just choose an unsupported option...this was added just for fun!"
    })

    # Fill in the spot we created for a plot
    output$plot <- renderPlot({
      
      # Render one of the 2 selectable plots
      if (input$plottype=='L') qplot(hp,
                                     mpg,
                                     data=mtcars,
                                     xlab="Engine power (hp)",
                                     ylab="Miles per gallon",
                                     main="Regression of mpg (outcome) and engine power(input) by number of cylinders",
                                     geom=c("point","smooth"),
                                     method="lm",
                                     facets=.~cyl)
      else if (input$plottype=='H') qplot(wt,
                                          mpg,
                                          data=mtcars,
                                          xlab="Weight (1000lb)",
                                          ylab="Miles per gallon",
                                          main="Regression of mpg (outcome) and weight(input) by number of gear",
                                          geom=c("point","smooth"),
                                          method="lm",
                                          facets=.~gear)
      
    })      
})