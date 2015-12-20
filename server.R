library(datasets)
library(stats)
library(zoo)

data("AirPassengers")

shinyServer(
    function(input, output)
    {
        model <- reactive(
            {
                start <- input$year[1]
                end <-   max(((input$year[2] - start)), 5) * 12
                
                period <- as.integer(input$interval)
                data <- window(AirPassengers, start = start, c(start, end))
                
                modelFit <- arima(data, order = c(1, 0, 0), list(order = c(2,1, 0), period = 12))
                
                fit <- predict(modelFit, n.ahead = period)
                
                list(fit = fit, data = data)
            }
        )
        
        output$output_text1 <- renderText(
            {
                start <- input$year[1]
                end  <-  start + max(((input$year[2] - start)), 5)
                
                toDate <- end + (as.integer(input$interval) / 12)
                
                text <- paste("Airline Passengers Trend Forecast From Year [", end, " - ", toDate,
                               "], Based On Observed Airline Traffic From Year [", start, " - ", end, "]" ,  sep = "") 
              
                text
            })
        
        output$output_text2 <- renderText(
            {
                start <- input$year[1]
                end  <-  start + max(((input$year[2] - start)), 5)
                
                toDate <- end + (as.integer(input$interval) / 12)
                
                text <- paste("Airline Passengers Forecast From Year [", end, " - ", toDate,
                              "], Based On Observed Airline Traffic From Year [", start, " - ", end, "]" ,  sep = "") 
                
                text
            })
        
        output$prediction <- renderDataTable(
            {
                prediction <- model()
                
                data <- data.frame(Year = as.Date(as.yearmon(time(prediction$fit$pred))),
                                     Passengers = as.matrix(as.integer(prediction$fit$pred * 1000)))
                
                data
            }, options = list(aLengthMenu = c(5, 30, 50), iDisplayLength = 12))
        
        output$airlinePlot <-  renderPlot(
            {
                prediction <- model()
                
                fit <- prediction$fit
                
                # error bounds at 95% confidence level
                upperBound <- fit$pred + 2 * fit$se
                lowerBound <- fit$pred - 2 * fit$se
                
                ts.plot(prediction$data, fit$pred, upperBound, lowerBound,
                        col = c(1, 2, 4, 4), lty = c(1, 1, 2, 2),
                        gpars=list(xlab="Year", ylab="Passengers (in Thousands)"))
                
                legend("topleft", col = c(1, 2, 4), lty = c(1, 1, 2),
                       c("Actual (in Thousands)", "Forecast (in Thousands)", "95% Confidence Interval"))
            }
        )
    }
)