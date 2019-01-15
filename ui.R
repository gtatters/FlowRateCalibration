library(shiny)

shinyUI(fluidPage(
    titlePanel("Flow Rate Calibration with Manometers and a Volumeter"),
    sidebarLayout(
      
      fluid=FALSE,
        sidebarPanel(
          position="left",
            helpText("Enter the measurement conditions here:"),
          
            numericInput("num_manom_press",
                         label = h6("Enter the manometer pressure reading (in mm Hg)"),
                         value = 760),
            numericInput("num_manom_temp",
                         label = h6("Enter the manometer temperature (in °C)"),
                         value = 23),
            numericInput("num_latitude",
                         label = h6("Enter your current latitude (in °)"),
                         value = 43),
   
            helpText("Enter the flow meter values here:"),  
            numericInput("num_backpressure",
                         label = h6("Enter the back pressure (in mm H2O)"),
                         value = 45),
            numericInput("num_volume",
                         label = h6("Enter the volume of gas collected (in mL)"),
                         value = 200),
            numericInput("num_seconds",
                         label = h6("Enter time required to collect gas (in seconds)"),
                         value = 23),    
                      
            actionButton("action_Calc", label = "Refresh & Calculate")        
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Output",
                    p(h5("Your entered values:")),
                    textOutput("text_manom_press"),
                    textOutput("text_manom_temp"),
                    textOutput("text_latitude"),
                    textOutput("text_backpressure"),
                    textOutput("text_volume"),
                    textOutput("text_seconds"),
                    br(),
                    p(h5("Calculated values:")),
                    textOutput("text_K"),
                    textOutput("text_bp_standard"),
                    textOutput("text_flowrate_standard")
                  
                ),
                tabPanel("Documentation",
                    p(h5("Pressure and Flow Conversions:")),
                    helpText("This application calculates local station pressure
                      corrected to 0°C and latitude for the purposes of 
                      calibrating a gas flow meter.  By measuring the time
                      required for a known, calibrated volume to be collected, 
                      the flow rate, corrected to 0°C can be determined"),
                    HTML("<u><b>Equations for calculation: </b></u>
                        <br> <br>
                        <b> M<sub>tc</sub> = [1 + L*(T-T<sub>s</sub>)] / 
                                        [1 + M * (T-T<sub>m</sub>)] </b>
                        <br>
                        where: <br>
                        <b>M<sub>tc</sub></b> is the temperature-correction multiplier for
                        Barometric Pressure <br>
                        <b>L</b> = coeff of linear thermal expansion of brass
                        = 0.0000184 m/m°C <br>
                        <b>M</b> = coeff of volume thermal expansion of mercury 
                        = 0.0001818 m<sup>3</sup>/m<sup>3</sup>°C<br>
                        <b>T<sub>m</sub></b> = standard temperature for mercury density 
                        (i.e., 0°C) <br>
                        <b>T<sub>s</sub></b> = standard temperature for scale (i.e., 0°C) <br>
                        <b>T</b> = barometer temperature (°C) <br>
                        <br>
                        <b> M<sub>gc</sub> = 980.616/980.665*[1 - 2.6363e-3*cos(2*theta) + 
                          5.9e-6*(cos<sup>2</sup>(2*theta)] </b> <br>
                        where: <br>
                        <b>M<sub>gc</sub></b> is the gravity-correction multiplier for
                        Barometric Pressure <br>
                        <b>theta</b> = latitude expressed as radians (latitude*pi/180)
                        <br>
                        <br>
                        <b>H<sub>b</sub> = BP * M<sub>tc</sub>*M<sub>gc</sub></b> <br>
                        where: <br>
                        <b>H<sub>b</sub></b> = Barometric pressure (mm Hg) corrected to 0°C and 
                        for gravity<br>
                        <b>BP</b> = Barometric pressure reading (mm Hg) from mercurial
                        barometer <br>
                        <br>
                        <b>K = [(T<sub>s</sub> + 273.15) / (T<sub>g</sub> + 273.15)] 
                              * [H<sub>b</sub> + H<sub>v</sub> / 13.600] / P<sub>s</sub></b> 
                        <br>
                        where: <br>
                        <b>K</b> = volumeter correction factor  <br>
                        <b>T<sub>s</sub></b> = Standard Temperature (i.e. 0°C)  <br>
                        <b>T<sub>g</sub></b> = Gas Temperature (i.e. same as barometer 
                          temperature, °C) <br>
                        <b>H<sub>b</sub></b> = Barometric pressure corrected to 0°C and 
                        for gravity<br>
                        <b>H<sub>v</sub></b> = Back pressure from volumeter exerted on gas flow
                        (mm H2O) <br>
                        <b>P<sub>s</sub></b> = Standard Pressure (i.e. 760 mm Hg) <br>
                        <br>
                        <b>F = 60 * V / t </b> <br>
                        where: <br>
                        <b>F</b> = Flow rate of gas, corrected to STP (0°C, 760 mm Hg) <br>
                        <b>V</b> = Volume of gas collected (mL, cubic centimeters) by
                        volumter during calibration <br>
                        <b>t</b> = Time (seconds) required to collect gas volume <br>
                        <br>
                        <br>
                        <br>
                         ")                
                ),
                tabPanel("Set-up",
                         p(h5("Volumeter Set-up:")),
                         img(src="VolumeterSetup.jpg", height = 400),
                         helpText("The volumeter calibration system consists of:"),
                         HTML("
                         <b>Volumeter</b> (calibrated glass cylinder for collecting gas) <br>       
                         <b>Mercurial Barometer</b> (for measuring barometric pressure) <br>
                         <b>Water Manometer</b> (for measuring the backpressure on the gas) <br>
                         <b>Stopwatch</b> (for measuring the time 
                          required for gas to traverse volume <br>
                         ") 
                )
            )
        )
    )
    
))
