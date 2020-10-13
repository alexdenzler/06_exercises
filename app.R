library(shiny)
library(rsconnect)
library(readr)
library(tidyverse)

covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")


ui <- fluidPage(
  selectInput(inputId = "states",
              label = "State:",
              choices = unique(covid19$state),
              selected = "Washington",
              multiple = TRUE),
  plotOutput(outputId = "covidTime")
)
server <- function(input, output) {
  output$covidTime <- renderPlot({
    covid19 %>%
      group_by(state) %>%
      filter(cases >= 20) %>%
      mutate(daysSince = as.numeric(difftime(date, lag(date, 1))),
             Between = ifelse(is.na(daysSince), 0, daysSince),
             daysSince20 = cumsum(as.numeric(Between))) %>%
      select(-daysSince, -Between) %>%
      filter(state %in% input$states) %>%
      ggplot(aes(x = daysSince20, y = cases,
                 color = state)) +
      geom_line() +
      scale_y_log10() +
      labs(title = "Days Since 20 Cumulative Covid Cases by State",
           x = "Days Since 20 Cases",
           y = "Total Cases",
           color = "State")
  })
}
shinyApp(ui = ui, server = server)
