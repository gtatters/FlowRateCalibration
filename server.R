library(shiny)
#library(car)    # Import library to use recode() function

shinyServer(function(input, output) {
    
    values <- reactiveValues()
    # Calculate the interest and amount    
    observe({
        input$action_Calc
        
        radians<-input$num_latitude * pi / 180
        
        values$Mtc<-((1+0.0000184*(input$num_manom_temp-0))/
                  (1+0.0001818*(input$num_manom_temp-0)))
        
        values$Mgc<-980.616/980.665*(1-0.0026373*cos(2*radians) +
                            0.0000059*(cos(2*radians))^2)
        
        values$bp_standard<-input$num_manom_press * values$Mtc * values$Mgc
        
        values$K<-(0+273.15)/(input$num_manom_temp+273.15) * 
                  (values$bp_standard + input$num_backpressure/13.6)/760
        
        values$flowrate_standard<-input$num_volume / input$num_seconds * 60 * values$K
           
    })
   
    # Display values entered
    output$text_manom_press <- renderText({
      input$action_Calc
      paste("Barometric Pressure:     ", isolate(input$num_manom_press), " mm Hg")
    })
    
    output$text_manom_temp <- renderText({
        input$action_Calc
        paste("Manometer Temperature:     ", isolate(input$num_manom_temp), " °C")
    })
    
    output$text_latitude <- renderText({
      input$action_Calc
      paste("Latitude:     ", isolate(input$num_latitude), " °")
    })
    
    output$text_backpressure <- renderText({
      input$action_Calc
      paste("Back Pressure:     ", isolate(input$num_backpressure), " mm H2O")
    })
    
    output$text_volume <- renderText({
      input$action_Calc
      paste("Volume gas collected:     ", isolate(input$num_volume), " mL")
    })
    
    output$text_seconds <- renderText({
      input$action_Calc
      paste("Time to collect gas:     ", isolate(input$num_seconds), " seconds")
    })
  
    
    # Display calculated values
    output$text_K <- renderText({
      if(input$action_Calc == 0) ""
      else
      paste("Volumeter correction factors: ", round(values$K, digits=4))
    })
    
    output$text_bp_standard <- renderText({
      if(input$action_Calc == 0) ""
      else
        paste("Station Pressure (corrected to 0°C): ", round(values$bp_standard, digits=2), 
              " mm Hg")
    })
    
    output$text_flowrate_standard <- renderText({
      if(input$action_Calc == 0) ""
      else
        paste("Flow rate (corrected to 0°C):", round(values$flowrate_standard, digits=2),
              " mL/min")
    })
   

})
    