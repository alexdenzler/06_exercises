---
title: 'Weekly Exercises #6'
author: "Alex Denzler"
output: 
  html_document:
    keep_md: TRUE
    toc: TRUE
    toc_float: TRUE
    df_print: paged
    code_download: true
---





```r
library(tidyverse)     # for data cleaning and plotting
library(googlesheets4) # for reading googlesheet data
library(lubridate)     # for date manipulation
library(openintro)     # for the abbr2state() function
library(palmerpenguins)# for Palmer penguin data
library(maps)          # for map data
library(ggmap)         # for mapping points on maps
library(gplots)        # for col2hex() function
library(RColorBrewer)  # for color palettes
library(sf)            # for working with spatial data
library(leaflet)       # for highly customizable mapping
library(ggthemes)      # for more themes (including theme_map())
library(plotly)        # for the ggplotly() - basic interactivity
library(gganimate)     # for adding animation layers to ggplots
library(gifski)        # for creating the gif (don't need to load this library every time,but need it installed)
library(transformr)    # for "tweening" (gganimate)
library(shiny)         # for creating interactive apps
library(patchwork)     # for nicely combining ggplot2 graphs  
library(gt)            # for creating nice tables
library(rvest)         # for scraping data
library(robotstxt)     # for checking if you can scrape data
gs4_deauth()           # To not have to authorize each time you knit.
theme_set(theme_minimal())
```


```r
# Lisa's garden data
garden_harvest <- read_sheet("https://docs.google.com/spreadsheets/d/1DekSazCzKqPS2jnGhKue7tLxRU3GVL1oxi-4bEM5IWw/edit?usp=sharing") %>% 
  mutate(date = ymd(date))

#COVID-19 data from the New York Times
covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")
```

## Put your homework on GitHub!

Go [here](https://github.com/llendway/github_for_collaboration/blob/master/github_for_collaboration.md) or to previous homework to remind yourself how to get set up. 

Once your repository is created, you should always open your **project** rather than just opening an .Rmd file. You can do that by either clicking on the .Rproj file in your repository folder on your computer. Or, by going to the upper right hand corner in R Studio and clicking the arrow next to where it says Project: (None). You should see your project come up in that list if you've used it recently. You could also go to File --> Open Project and navigate to your .Rproj file. 

## Instructions

* Put your name at the top of the document. 

* **For ALL graphs, you should include appropriate labels.** 

* Feel free to change the default theme, which I currently have set to `theme_minimal()`. 

* Use good coding practice. Read the short sections on good code with [pipes](https://style.tidyverse.org/pipes.html) and [ggplot2](https://style.tidyverse.org/ggplot2.html). **This is part of your grade!**

* **NEW!!** With animated graphs, add `eval=FALSE` to the code chunk that creates the animation and saves it using `anim_save()`. Add another code chunk to reread the gif back into the file. See the [tutorial](https://animation-and-interactivity-in-r.netlify.app/) for help. 

* When you are finished with ALL the exercises, uncomment the options at the top so your document looks nicer. Don't do it before then, or else you might miss some important warnings and messages.

## Your first `shiny` app 

  1. This app will also use the COVID data. Make sure you load that data and all the libraries you need in the `app.R` file you create. Below, you will post a link to the app that you publish on shinyapps.io. You will create an app to compare states' cumulative number of COVID cases over time. The x-axis will be number of days since 20+ cases and the y-axis will be cumulative cases on the log scale (`scale_y_log10()`). We use number of days since 20+ cases on the x-axis so we can make better comparisons of the curve trajectories. You will have an input box where the user can choose which states to compare (`selectInput()`) and have a submit button to click once the user has chosen all states they're interested in comparing. The graph should display  a different line for each state, with labels either on the graph or in a legend. Color can be used if needed.


```r
covid192 <- covid19 %>% 
  as.list(date)
```



```r
# ui <- fluidPage(
#   selectInput(inputId = "dates",
#               label = "Date:",
#               choices = list(date)),
#   plotOutput(outputId = "covidTime")
# )
# server <- function(input, output) {
#   output$covidTime <- renderPlot({
#   covid19 %>% 
#     group_by(state) %>% 
#     mutate(totalCases = cumsum(cases)) %>% 
#     filter(totalCases >= 20) %>% 
#     mutate(daysSince = as.numeric(difftime(date, lag(date, 1))), 
#            Between = ifelse(is.na(daysSince), 0, daysSince), 
#            daysSince20 = cumsum(as.numeric(Between))) %>% 
#     select(-daysSince, -Between) %>% 
#     filter(state == input$state, 
#            daysSince20 == input$daysSince20, 
#            totalCases == input$totalCases) %>% 
#     ggplot(aes(x = input$daysSince20, y = input$totalCases, 
#                color = input$state)) + 
#     geom_line() + 
#     scale_y_log10() + 
#     scale_x_discrete() + 
#     labs(title = "Days Since 20 Cumulative Covid Cases by State",
#          x = "Days Since 20 Cases",
#          y = "Total Cases",
#          color = "State")
#     })
# }
# shinyApp(ui = ui, server = server)
```
  
  
## Warm-up exercises from tutorial

  2. Read in the fake garden harvest data. Find the data [here](https://github.com/llendway/scraping_etc/blob/main/2020_harvest.csv) and click on the `Raw` button to get a direct link to the data. 
  

```r
fake_harvest <- read_csv("https://raw.githubusercontent.com/llendway/scraping_etc/main/2020_harvest.csv", 
    col_types = cols(X1 = col_skip(), weight = col_number()), 
    na = "MISSING", skip = 2)
```
  
  3. Read in this [data](https://www.kaggle.com/heeraldedhia/groceries-dataset) from the kaggle website. You will need to download the data first. Save it to your project/repo folder. Do some quick checks of the data to assure it has been read in appropriately.

  4. Write code to replicate the table shown below (open the .html file to see it) created from the `garden_harvest` data as best as you can. When you get to coloring the cells, I used the following line of code for the `colors` argument:
  

```r
colors = scales::col_numeric(
      palette = paletteer::paletteer_d(
        palette = "RColorBrewer::YlGn"
      ) %>% as.character()
```


  5. Create a table using `gt` with data from your project or from the `garden_harvest` data if your project data aren't ready.
  

```r
tab1 <- garden_harvest %>% gt(
  rowname_col = "date",
  groupname_col = "vegetable"
) %>% 
  fmt_date(columns = vars(date),
           date_style = 4) %>% 
  cols_hide(columns = vars(units)) %>% 
  tab_footnote(
    footnote = "Weight in grams",
    locations = cells_column_labels(
      columns = vars(weight)
    )
  ) %>% 
  tab_header(title = "Lisa's Garden Harvest Data") %>% 
  tab_options(column_labels.background.color = "lightblue",
              )
  
  
tab1
```

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ayympwigio .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ayympwigio .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ayympwigio .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ayympwigio .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ayympwigio .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ayympwigio .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ayympwigio .gt_col_heading {
  color: #333333;
  background-color: lightblue;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ayympwigio .gt_column_spanner_outer {
  color: #333333;
  background-color: lightblue;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ayympwigio .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ayympwigio .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ayympwigio .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ayympwigio .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#ayympwigio .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ayympwigio .gt_from_md > :first-child {
  margin-top: 0;
}

#ayympwigio .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ayympwigio .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ayympwigio .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#ayympwigio .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ayympwigio .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ayympwigio .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ayympwigio .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ayympwigio .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ayympwigio .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ayympwigio .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ayympwigio .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ayympwigio .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ayympwigio .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ayympwigio .gt_left {
  text-align: left;
}

#ayympwigio .gt_center {
  text-align: center;
}

#ayympwigio .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ayympwigio .gt_font_normal {
  font-weight: normal;
}

#ayympwigio .gt_font_bold {
  font-weight: bold;
}

#ayympwigio .gt_font_italic {
  font-style: italic;
}

#ayympwigio .gt_super {
  font-size: 65%;
}

#ayympwigio .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="ayympwigio" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="3" class="gt_heading gt_title gt_font_normal" style>Lisa's Garden Harvest Data</th>
    </tr>
    <tr>
      <th colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1"></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">variety</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">weight<sup class="gt_footnote_marks">1</sup></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">lettuce</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-06</td>
      <td class="gt_row gt_left">reseed</td>
      <td class="gt_row gt_right">20</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-08</td>
      <td class="gt_row gt_left">reseed</td>
      <td class="gt_row gt_right">15</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-09</td>
      <td class="gt_row gt_left">reseed</td>
      <td class="gt_row gt_right">10</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-11</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">12</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-13</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">19</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-17</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">48</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-18</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">47</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-19</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">39</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-19</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">38</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-20</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">22</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-20</td>
      <td class="gt_row gt_left">Tatsoi</td>
      <td class="gt_row gt_right">18</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-21</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">95</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-22</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">52</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-22</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">18</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-24</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">122</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-25</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">30</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-27</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">52</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-27</td>
      <td class="gt_row gt_left">Tatsoi</td>
      <td class="gt_row gt_right">89</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-28</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">111</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-29</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">58</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-29</td>
      <td class="gt_row gt_left">mustard greens</td>
      <td class="gt_row gt_right">23</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-29</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">82</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-01</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">60</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-02</td>
      <td class="gt_row gt_left">Tatsoi</td>
      <td class="gt_row gt_right">144</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-03</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">217</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-03</td>
      <td class="gt_row gt_left">Tatsoi</td>
      <td class="gt_row gt_right">216</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-04</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">147</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-06</td>
      <td class="gt_row gt_left">Tatsoi</td>
      <td class="gt_row gt_right">189</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-07</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">67</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-07</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">13</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-08</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">39</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-08</td>
      <td class="gt_row gt_left">Tatsoi</td>
      <td class="gt_row gt_right">75</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-09</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">61</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-11</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">79</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-12</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">83</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-13</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">53</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-13</td>
      <td class="gt_row gt_left">Tatsoi</td>
      <td class="gt_row gt_right">137</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-16</td>
      <td class="gt_row gt_left">Farmer's Market Blend</td>
      <td class="gt_row gt_right">61</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">Tatsoi</td>
      <td class="gt_row gt_right">123</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-22</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">23</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-23</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">130</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">16</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-26</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">81</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">99</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-28</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">91</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">73</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-30</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">94</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">107</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-03</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">65</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">56</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">98</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">19</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">92</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-12</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">73</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">80</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-15</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">56</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">45</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">67</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">87</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">99</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Tatsoi</td>
      <td class="gt_row gt_right">322</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">111</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-24</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">134</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-27</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">14</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-28</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">85</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-16</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">8</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-26</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">95</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-29</td>
      <td class="gt_row gt_left">Lettuce Mixture</td>
      <td class="gt_row gt_right">139</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">radish</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-06</td>
      <td class="gt_row gt_left">Garden Party Mix</td>
      <td class="gt_row gt_right">36</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-11</td>
      <td class="gt_row gt_left">Garden Party Mix</td>
      <td class="gt_row gt_right">67</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-13</td>
      <td class="gt_row gt_left">Garden Party Mix</td>
      <td class="gt_row gt_right">53</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-20</td>
      <td class="gt_row gt_left">Garden Party Mix</td>
      <td class="gt_row gt_right">16</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-21</td>
      <td class="gt_row gt_left">Garden Party Mix</td>
      <td class="gt_row gt_right">37</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-03</td>
      <td class="gt_row gt_left">Garden Party Mix</td>
      <td class="gt_row gt_right">88</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-07</td>
      <td class="gt_row gt_left">Garden Party Mix</td>
      <td class="gt_row gt_right">43</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-13</td>
      <td class="gt_row gt_left">Garden Party Mix</td>
      <td class="gt_row gt_right">50</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">Garden Party Mix</td>
      <td class="gt_row gt_right">39</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">spinach</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-11</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">9</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-13</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">14</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-17</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">58</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-18</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">59</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-19</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">58</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-20</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">25</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-21</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">71</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-21</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">51</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-22</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">37</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-23</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">41</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-25</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">22</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-27</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">60</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-28</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">99</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-30</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">80</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-02</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">16</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-11</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">19</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-15</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">39</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-21</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">21</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">31</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">44</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">30</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Catalina</td>
      <td class="gt_row gt_right">39</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">beets</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-11</td>
      <td class="gt_row gt_left">leaves</td>
      <td class="gt_row gt_right">8</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-18</td>
      <td class="gt_row gt_left">leaves</td>
      <td class="gt_row gt_right">25</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-19</td>
      <td class="gt_row gt_left">leaves</td>
      <td class="gt_row gt_right">11</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-21</td>
      <td class="gt_row gt_left">leaves</td>
      <td class="gt_row gt_right">57</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-07</td>
      <td class="gt_row gt_left">Gourmet Golden</td>
      <td class="gt_row gt_right">62</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-07</td>
      <td class="gt_row gt_left">Sweet Merlin</td>
      <td class="gt_row gt_right">10</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-08</td>
      <td class="gt_row gt_left">Gourmet Golden</td>
      <td class="gt_row gt_right">83</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-09</td>
      <td class="gt_row gt_left">Sweet Merlin</td>
      <td class="gt_row gt_right">69</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-12</td>
      <td class="gt_row gt_left">Sweet Merlin</td>
      <td class="gt_row gt_right">89</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-18</td>
      <td class="gt_row gt_left">Sweet Merlin</td>
      <td class="gt_row gt_right">172</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">Gourmet Golden</td>
      <td class="gt_row gt_right">107</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">Sweet Merlin</td>
      <td class="gt_row gt_right">49</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">Gourmet Golden</td>
      <td class="gt_row gt_right">149</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-30</td>
      <td class="gt_row gt_left">Sweet Merlin</td>
      <td class="gt_row gt_right">101</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Sweet Merlin</td>
      <td class="gt_row gt_right">198</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Gourmet Golden</td>
      <td class="gt_row gt_right">308</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Sweet Merlin</td>
      <td class="gt_row gt_right">2209</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Gourmet Golden</td>
      <td class="gt_row gt_right">2476</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">kale</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-13</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">10</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-21</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">60</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-14</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">128</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-18</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">61</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-19</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">113</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">128</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-25</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">121</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">280</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-03</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">383</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">305</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-15</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">71</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">173</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-24</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">117</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-12</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">108</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-20</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">163</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Heirloom Lacinto</td>
      <td class="gt_row gt_right">28</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">peas</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-17</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">8</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-17</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">121</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-20</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">71</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-20</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">148</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-22</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">40</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-22</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">19</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-23</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">40</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-23</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">165</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-24</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">34</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-26</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">425</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-27</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">333</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-28</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">793</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-29</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">625</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-29</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">561</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-02</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">798</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-02</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">743</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-04</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">285</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-04</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">457</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-06</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">433</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-06</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">48</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-08</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">75</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-08</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">252</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-13</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">40</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-14</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">207</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-14</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">526</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-19</td>
      <td class="gt_row gt_left">Magnolia Blossom</td>
      <td class="gt_row gt_right">140</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">Super Sugar Snap</td>
      <td class="gt_row gt_right">336</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">chives</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-17</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">8</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">strawberries</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-18</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">40</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-22</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">19</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-26</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">17</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-11</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">77</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-13</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">85</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-17</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">88</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-19</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">37</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">93</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">113</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">23</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">asparagus</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-20</td>
      <td class="gt_row gt_left">asparagus</td>
      <td class="gt_row gt_right">20</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">Swiss chard</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-21</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">19</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-21</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">13</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-30</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">32</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-08</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">96</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-16</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">29</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">178</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-23</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">466</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-09</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">302</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-10</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">309</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">517</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">256</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-09</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">228</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">24</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-10-03</td>
      <td class="gt_row gt_left">Neon Glow</td>
      <td class="gt_row gt_right">232</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">cilantro</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-23</td>
      <td class="gt_row gt_left">cilantro</td>
      <td class="gt_row gt_right">2</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-17</td>
      <td class="gt_row gt_left">cilantro</td>
      <td class="gt_row gt_right">33</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">cilantro</td>
      <td class="gt_row gt_right">17</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">basil</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-23</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">5</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-03</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">9</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-06</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">17</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-07</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">11</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-10</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">150</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-17</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">16</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-21</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">7</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">3</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">137</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-10</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">13</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">12</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-15</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">25</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">27</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">34</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">Isle of Naxos</td>
      <td class="gt_row gt_right">24</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">raspberries</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-06-29</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">30</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-09</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">131</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-10</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">61</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-11</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">60</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-11</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">105</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-14</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">152</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-18</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">77</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">32</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">29</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-28</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">29</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-18</td>
      <td class="gt_row gt_left">perrenial</td>
      <td class="gt_row gt_right">137</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">zucchini</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-06</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">175</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-12</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">492</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-13</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">145</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-15</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">393</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-18</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">81</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-19</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">344</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">134</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-21</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">110</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-22</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">76</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">1321</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">1542</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">457</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">1215</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">164</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-02</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">1175</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-03</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">252</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">427</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">1219</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">445</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-09</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">443</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">731</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">1774</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">371</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-15</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">859</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">660</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">1151</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">834</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">1122</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">2436</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">920</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-28</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">3244</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">2831</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-07</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">3284</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-08</td>
      <td class="gt_row gt_left">Romanesco</td>
      <td class="gt_row gt_right">1300</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">beans</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-06</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">235</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-08</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">178</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-09</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">140</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-11</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">701</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-13</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">443</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-15</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">743</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-18</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">660</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">519</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-21</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">21</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-22</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">351</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-23</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">129</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">100</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">728</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">305</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">592</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-03</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">572</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-05</td>
      <td class="gt_row gt_left">Classic Slenderette</td>
      <td class="gt_row gt_right">41</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-05</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">234</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">Chinese Red Noodle</td>
      <td class="gt_row gt_right">108</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">Classic Slenderette</td>
      <td class="gt_row gt_right">122</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">545</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">755</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Chinese Red Noodle</td>
      <td class="gt_row gt_right">78</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Classic Slenderette</td>
      <td class="gt_row gt_right">245</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">468</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Classic Slenderette</td>
      <td class="gt_row gt_right">122</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Chinese Red Noodle</td>
      <td class="gt_row gt_right">65</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">693</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Classic Slenderette</td>
      <td class="gt_row gt_right">350</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Chinese Red Noodle</td>
      <td class="gt_row gt_right">105</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">225</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Classic Slenderette</td>
      <td class="gt_row gt_right">328</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">287</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Classic Slenderette</td>
      <td class="gt_row gt_right">186</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">320</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Classic Slenderette</td>
      <td class="gt_row gt_right">160</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-27</td>
      <td class="gt_row gt_left">Bush Bush Slender</td>
      <td class="gt_row gt_right">94</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-28</td>
      <td class="gt_row gt_left">Classic Slenderette</td>
      <td class="gt_row gt_right">81</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">cucumbers</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-08</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">181</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-09</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">78</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-12</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">130</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-13</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">47</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-14</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">152</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-15</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">1057</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-17</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">347</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-18</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">294</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-19</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">531</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">179</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-22</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">655</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">525</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-25</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">901</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">785</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-28</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">76</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">514</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-30</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">626</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">174</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">1130</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-03</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">1155</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">127</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">1327</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">1697</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">1029</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">599</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-15</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">351</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">2888</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">233</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">70</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">997</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">747</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">pickling</td>
      <td class="gt_row gt_right">179</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">tomatoes</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-11</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">24</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-21</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">86</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-21</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">137</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-21</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">339</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">31</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">140</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">247</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">220</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-25</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">463</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-25</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">106</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-26</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">148</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">801</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-28</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">611</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-28</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">203</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-28</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">312</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-28</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">315</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-28</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">131</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">153</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">442</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">240</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">209</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-29</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">40</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-30</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">91</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">307</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">197</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">633</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">290</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-31</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">100</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">435</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">320</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">619</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">97</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">436</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">168</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-02</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">509</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-02</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">857</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-02</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">336</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-02</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">156</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-02</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">211</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-02</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">102</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-03</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">308</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">387</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">231</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">73</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">339</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">118</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-05</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">563</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-05</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">290</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-05</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">781</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-05</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">223</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-05</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">382</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-05</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">217</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-05</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">67</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">393</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">307</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">175</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">303</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">359</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">356</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">233</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">364</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">1045</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">562</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">292</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">162</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">81</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">564</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-08</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">184</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-09</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">179</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-09</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">591</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-09</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">1102</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-09</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">308</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-09</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">54</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-09</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">64</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-10</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">216</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-10</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">241</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">302</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">307</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">160</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">218</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">802</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">354</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">359</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">506</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">421</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">332</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">727</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">642</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-13</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">413</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">711</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">238</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">525</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">181</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">266</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">490</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">126</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">477</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">328</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">543</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">599</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">560</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">291</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">238</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-16</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">397</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">364</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">305</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">588</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">764</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">436</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">306</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">608</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">136</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">148</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">317</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">105</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">271</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">872</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">579</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">615</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">997</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">335</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">264</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">451</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">306</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">333</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">483</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">632</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">360</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">230</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">344</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">1010</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">493</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">1601</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">842</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">1538</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">428</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">243</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">330</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">265</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">562</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">1542</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">801</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">436</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">1573</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">704</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">446</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">269</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-24</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">75</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">578</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">871</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">115</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">629</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">488</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">506</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">1400</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">993</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-25</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">1026</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">1886</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">666</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">1042</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">593</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">216</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">309</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">497</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">261</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">819</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">380</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">737</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">1033</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">1097</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">566</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">861</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">460</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">2934</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">599</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">155</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">822</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">589</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">393</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">752</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-30</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">833</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">1953</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">805</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">178</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Cherokee Purple</td>
      <td class="gt_row gt_right">201</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">1537</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">773</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">1202</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-03</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">1131</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-03</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">610</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-03</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">1265</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">2160</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">2899</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">442</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">1234</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">1178</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">255</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">430</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-06</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">2377</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-06</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">710</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-06</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">1317</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-06</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">1649</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-06</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">615</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-10</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">692</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-10</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">674</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-10</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">1392</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-10</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">316</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-10</td>
      <td class="gt_row gt_left">Jet Star</td>
      <td class="gt_row gt_right">754</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-10</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">413</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-10</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">509</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-15</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">258</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-15</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">725</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-17</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">212</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-18</td>
      <td class="gt_row gt_left">Brandywine</td>
      <td class="gt_row gt_right">714</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-18</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">228</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-18</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">670</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-18</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">1052</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-18</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">1631</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">2934</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">304</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">1058</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-21</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">714</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-21</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">95</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Bonny Best</td>
      <td class="gt_row gt_right">477</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Amish Paste</td>
      <td class="gt_row gt_right">2738</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Black Krim</td>
      <td class="gt_row gt_right">236</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Old German</td>
      <td class="gt_row gt_right">1823</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">grape</td>
      <td class="gt_row gt_right">819</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Mortgage Lifter</td>
      <td class="gt_row gt_right">2006</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Big Beef</td>
      <td class="gt_row gt_right">659</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Better Boy</td>
      <td class="gt_row gt_right">1239</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">volunteers</td>
      <td class="gt_row gt_right">1978</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">onions</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-16</td>
      <td class="gt_row gt_left">Delicious Duo</td>
      <td class="gt_row gt_right">50</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">102</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-23</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">91</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">129</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-30</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">19</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">Delicious Duo</td>
      <td class="gt_row gt_right">182</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">195</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-09</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">118</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-15</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">137</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">126</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">113</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">Long Keeping Rainbow</td>
      <td class="gt_row gt_right">289</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">Delicious Duo</td>
      <td class="gt_row gt_right">33</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">jalapeño</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-17</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">20</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">197</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-01</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">74</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">162</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">87</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">509</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">352</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-02</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">43</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-03</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">102</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-04</td>
      <td class="gt_row gt_left">giant</td>
      <td class="gt_row gt_right">58</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">hot peppers</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">thai</td>
      <td class="gt_row gt_right">12</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-20</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">559</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">thai</td>
      <td class="gt_row gt_right">24</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">40</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">thai</td>
      <td class="gt_row gt_right">31</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">carrots</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-23</td>
      <td class="gt_row gt_left">King Midas</td>
      <td class="gt_row gt_right">56</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">King Midas</td>
      <td class="gt_row gt_right">178</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">Dragon</td>
      <td class="gt_row gt_right">80</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">King Midas</td>
      <td class="gt_row gt_right">174</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-28</td>
      <td class="gt_row gt_left">King Midas</td>
      <td class="gt_row gt_right">160</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-30</td>
      <td class="gt_row gt_left">Bolero</td>
      <td class="gt_row gt_right">116</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-30</td>
      <td class="gt_row gt_left">King Midas</td>
      <td class="gt_row gt_right">107</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">Bolero</td>
      <td class="gt_row gt_right">164</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">Dragon</td>
      <td class="gt_row gt_right">442</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-07</td>
      <td class="gt_row gt_left">Bolero</td>
      <td class="gt_row gt_right">255</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-10</td>
      <td class="gt_row gt_left">Bolero</td>
      <td class="gt_row gt_right">221</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-21</td>
      <td class="gt_row gt_left">Dragon</td>
      <td class="gt_row gt_right">457</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">Bolero</td>
      <td class="gt_row gt_right">888</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">greens</td>
      <td class="gt_row gt_right">169</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-17</td>
      <td class="gt_row gt_left">King Midas</td>
      <td class="gt_row gt_right">160</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-17</td>
      <td class="gt_row gt_left">Bolero</td>
      <td class="gt_row gt_right">168</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-10-01</td>
      <td class="gt_row gt_left">Dragon</td>
      <td class="gt_row gt_right">883</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-10-02</td>
      <td class="gt_row gt_left">Bolero</td>
      <td class="gt_row gt_right">449</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">peppers</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-24</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">68</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">270</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">192</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-04</td>
      <td class="gt_row gt_left">green</td>
      <td class="gt_row gt_right">81</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">112</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">green</td>
      <td class="gt_row gt_right">252</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-20</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">70</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-24</td>
      <td class="gt_row gt_left">green</td>
      <td class="gt_row gt_right">115</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">627</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-02</td>
      <td class="gt_row gt_left">green</td>
      <td class="gt_row gt_right">370</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-02</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">60</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">variety</td>
      <td class="gt_row gt_right">84</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">broccoli</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-07-27</td>
      <td class="gt_row gt_left">Yod Fah</td>
      <td class="gt_row gt_right">372</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-09</td>
      <td class="gt_row gt_left">Main Crop Bravado</td>
      <td class="gt_row gt_right">102</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-16</td>
      <td class="gt_row gt_left">Main Crop Bravado</td>
      <td class="gt_row gt_right">219</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-25</td>
      <td class="gt_row gt_left">Main Crop Bravado</td>
      <td class="gt_row gt_right">75</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-30</td>
      <td class="gt_row gt_left">Main Crop Bravado</td>
      <td class="gt_row gt_right">134</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">potatoes</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">purple</td>
      <td class="gt_row gt_right">317</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-06</td>
      <td class="gt_row gt_left">yellow</td>
      <td class="gt_row gt_right">439</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-10</td>
      <td class="gt_row gt_left">yellow</td>
      <td class="gt_row gt_right">272</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-10</td>
      <td class="gt_row gt_left">purple</td>
      <td class="gt_row gt_right">168</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">purple</td>
      <td class="gt_row gt_right">323</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-19</td>
      <td class="gt_row gt_left">yellow</td>
      <td class="gt_row gt_right">278</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">purple</td>
      <td class="gt_row gt_right">262</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">yellow</td>
      <td class="gt_row gt_right">716</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-09</td>
      <td class="gt_row gt_left">yellow</td>
      <td class="gt_row gt_right">843</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-16</td>
      <td class="gt_row gt_left">Russet</td>
      <td class="gt_row gt_right">629</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">edamame</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">edamame</td>
      <td class="gt_row gt_right">109</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-18</td>
      <td class="gt_row gt_left">edamame</td>
      <td class="gt_row gt_right">527</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-29</td>
      <td class="gt_row gt_left">edamame</td>
      <td class="gt_row gt_right">483</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-05</td>
      <td class="gt_row gt_left">edamame</td>
      <td class="gt_row gt_right">1644</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">corn</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-11</td>
      <td class="gt_row gt_left">Dorinny Sweet</td>
      <td class="gt_row gt_right">330</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-14</td>
      <td class="gt_row gt_left">Dorinny Sweet</td>
      <td class="gt_row gt_right">1564</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-15</td>
      <td class="gt_row gt_left">Golden Bantam</td>
      <td class="gt_row gt_right">383</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-17</td>
      <td class="gt_row gt_left">Golden Bantam</td>
      <td class="gt_row gt_right">344</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-23</td>
      <td class="gt_row gt_left">Dorinny Sweet</td>
      <td class="gt_row gt_right">661</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-08-26</td>
      <td class="gt_row gt_left">Dorinny Sweet</td>
      <td class="gt_row gt_right">1607</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-02</td>
      <td class="gt_row gt_left">Dorinny Sweet</td>
      <td class="gt_row gt_right">798</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-05</td>
      <td class="gt_row gt_left">Dorinny Sweet</td>
      <td class="gt_row gt_right">214</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">pumpkins</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">saved</td>
      <td class="gt_row gt_right">4758</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">saved</td>
      <td class="gt_row gt_right">2342</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Cinderella's Carraige</td>
      <td class="gt_row gt_right">7350</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Cinderella's Carraige</td>
      <td class="gt_row gt_right">1311</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Cinderella's Carraige</td>
      <td class="gt_row gt_right">6250</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">saved</td>
      <td class="gt_row gt_right">1154</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">saved</td>
      <td class="gt_row gt_right">1208</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">saved</td>
      <td class="gt_row gt_right">2882</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">saved</td>
      <td class="gt_row gt_right">2689</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">saved</td>
      <td class="gt_row gt_right">3441</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">saved</td>
      <td class="gt_row gt_right">7050</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">1109</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">1028</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">1131</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">1302</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">1570</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">1359</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">1608</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">2277</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">1743</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">New England Sugar</td>
      <td class="gt_row gt_right">2931</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">squash</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Blue (saved)</td>
      <td class="gt_row gt_right">3227</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-01</td>
      <td class="gt_row gt_left">Blue (saved)</td>
      <td class="gt_row gt_right">5150</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">307</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">397</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">537</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">314</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">494</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">484</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">454</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">480</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">252</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">294</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">delicata</td>
      <td class="gt_row gt_right">437</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Waltham Butternut</td>
      <td class="gt_row gt_right">1834</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Waltham Butternut</td>
      <td class="gt_row gt_right">1655</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Waltham Butternut</td>
      <td class="gt_row gt_right">1927</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Waltham Butternut</td>
      <td class="gt_row gt_right">1558</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Waltham Butternut</td>
      <td class="gt_row gt_right">1183</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Red Kuri</td>
      <td class="gt_row gt_right">1178</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Red Kuri</td>
      <td class="gt_row gt_right">706</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Red Kuri</td>
      <td class="gt_row gt_right">1686</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Red Kuri</td>
      <td class="gt_row gt_right">1785</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Blue (saved)</td>
      <td class="gt_row gt_right">1923</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Blue (saved)</td>
      <td class="gt_row gt_right">2120</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Blue (saved)</td>
      <td class="gt_row gt_right">2325</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-19</td>
      <td class="gt_row gt_left">Blue (saved)</td>
      <td class="gt_row gt_right">1172</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">kohlrabi</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-17</td>
      <td class="gt_row gt_left">Crispy Colors Duo</td>
      <td class="gt_row gt_right">191</td>
    </tr>
    <tr class="gt_group_heading_row">
      <td colspan="3" class="gt_group_heading">apple</td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_stub">2020-09-26</td>
      <td class="gt_row gt_left">unknown</td>
      <td class="gt_row gt_right">156</td>
    </tr>
  </tbody>
  
  <tfoot>
    <tr class="gt_footnotes">
      <td colspan="3">
        <p class="gt_footnote">
          <sup class="gt_footnote_marks">
            <em>1</em>
          </sup>
           
          Weight in grams
          <br />
        </p>
      </td>
    </tr>
  </tfoot>
</table></div><!--/html_preserve-->
  
  
  6. Use `patchwork` operators and functions to combine at least two graphs using your project data or `garden_harvest` data if your project data aren't read.


```r
garden_harvestL <- garden_harvest %>% 
  filter(vegetable %in% "lettuce")

lettuce <- garden_harvestL %>% 
  ggplot(aes(y = fct_rev(fct_infreq(variety)))) + 
  geom_bar(fill = "green4", color = "black") +
  labs(title = "Frequency of Lettuce Harvest by Variety",
       x = "Count",
       y = "Variety")

garden_harvestT <- garden_harvest %>% 
  filter(vegetable == "tomatoes")

tomato <- garden_harvestT %>% 
  ggplot(aes(y = fct_rev(fct_infreq(variety)))) + 
  geom_bar(fill = "red4", color = "black") +
  labs(title = "Frequency of Tomatoes Harvest by Variety",
       x = "Count",
       y = "Variety")

lettuce | tomato
```

![](06_exercises_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

  
  7. COMING SOON! Web scraping problem.

  
**DID YOU REMEMBER TO UNCOMMENT THE OPTIONS AT THE TOP?**
