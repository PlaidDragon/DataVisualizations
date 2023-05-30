library(openxlsx)
library(dplyr)
library(plotly)
library(tidyverse)

#Import data and clean to useable format
df <- read.xlsx("~//AdultStuff//PetStuff//Orion//Orion QOL Tracker.xlsx", sheet = 2) %>%
  mutate("Date" = as.Date(Date, origin="1899-12-30")) %>%
  mutate("Month-Year" = substr(Date,1,7)) %>%
  group_by(`Month-Year`, Type) %>%
  mutate("MonthYearSum" = sum(`Amount.(US$)`)) %>%
  ungroup()
head(df)


# Create Stacked Bar Graph with each bar representing a month of the year,
# and each color representing spending type
df %>%
  distinct(`Month-Year`, MonthYearSum, Type) %>%
  plot_ly(y=~MonthYearSum, x=~`Month-Year`, name = ~Type,  type='bar') %>%
  layout(uniformtext=list(minsize=8, mode='hide'),
         yaxis = list(title = "$US"),
         xaxis = list(title = "Year-Month"),
         title = "Orion's Spending By Month and Type",
         showlegend = TRUE,
         barmode = "stack"
  )

# Create list to be used to annotate the stacked line plot
a <- list(
  x = c("2020-12"),
  y = c(5000),
  text = c(paste0("Diagnosed With Stage 4<br> Kideny Disease")),
  xref = "x",
  yref = "y",
  showarrow = TRUE,
  arrowhead = 7,
  ax = -100,
  ay = -40
)

# Create Line chart to show the total spent every month, sum of all spending types
df %>%
  group_by(`Month-Year`) %>%
  mutate("MonthYearSum" = sum(`Amount.(US$)`)) %>%
  ungroup() %>%
  mutate("MonthYearSum" = as.numeric(MonthYearSum)) %>%
  distinct(`Month-Year`, MonthYearSum) %>%
  plot_ly() %>%
  layout(uniformtext=list(minsize=8, mode='hide'),
         yaxis = list(title = "US$"),
         xaxis = list(title = "Date"),
         title = paste0("Orion's Spending Over Time<br>Total Spent: $",sum(df$`Amount.(US$)`)),
         showlegend = FALSE,
         annotations=a
  ) %>%
  add_lines(y=~MonthYearSum, x=~`Month-Year`,
            line = list(shape = "spline")
  )



# Stacked line chart with color defined by spending type.
# This still looks pretty bad
df %>%
  group_by(`Month-Year`, Type) %>%
  mutate("MonthYearSum" = sum(`Amount.(US$)`)) %>%
  ungroup() %>%
  distinct(`Month-Year`,Type,  MonthYearSum) %>%
  plot_ly(x=~`Month-Year`, y=~MonthYearSum , color=~Type,
          type='scatter', mode='line', 
          stackgroup='one')


# Create annotation list for finalized plot
a <- list(
  x = c("2018-09", "2020-12","2021-09", "2021-10"),
  y = c(500, 3500,24000, 32000),
  text = c("Adopted (8 Weeks Old)", paste0("Diagnosed With Stage 4<br> Kidney Disease (2 Years Old)"), "Medication Loses Effect","Organs begin to Shut Down<br>At Home Euthenasia<br>(3 Years Old)"),
  xref = "x",
  yref = "y",
  showarrow = TRUE,
  arrowhead = 7,
  ax = c(50, -100,-90, -100),
  ay = c(-40, -40, -10, 50)
)


# Create new dataframe with a column representing the sum of each spending type 
# by month. The goal is to create a plot that shows the cummalitive spending over time
# rather than the choppy by-month spending in the above chart
joinDF <- df %>%
  group_by(Type, `Month-Year`) %>%
  mutate("MonthYearSum" = sum(`Amount.(US$)`)) %>%
  distinct(`Month-Year`, Type, MonthYearSum)

# create dataframe to be used for 
data.frame("Date" = rep(substr(seq.Date(as.Date("2018-09-01"), as.Date("2021-10-01"), 'month'), 1,7), 4),
                    "Type" = c(rep('vet',38), rep('toys/misc',38), rep('medicine', 38) ,rep('food', 38))
                    ) %>%
  left_join(joinDF, by = c('Date' = 'Month-Year', 'Type')) %>%
  mutate(MonthYearSum = ifelse(is.na(MonthYearSum), 0, MonthYearSum)) %>%
  arrange(Date, Type) %>%
  group_by(Type) %>%
  mutate("MonthYearSum" = cumsum(MonthYearSum)) %>%


  plot_ly(x=~`Date`, y=~MonthYearSum , color=~Type,
          type='scatter', mode='line', 
          stackgroup='one') %>%
  layout(uniformtext=list(minsize=8, mode='hide'),
         yaxis = list(title = "US$"),
         xaxis = list(title = "Date"),
         title = paste0("Best Boy's Cumulative Spending Over Time<br>Total Spent: ~$32,000<br><span style='color: gray; font-size:10'>Note: Toys/Food not Tracked before 2019-08</span>"),
         showlegend = TRUE,
         annotations=a
  )



  