# DataVisualizations
Examples of Various Data Visualizations

# Table of contents
1. [Stacked Area Chart (Along with Simple Time Series)](#stackedAreaChart)
2. [Simple Violin Plot Comparison](#violinPlots)
3. [Simple Bar Chart](#barChart)
4. [Geographic and Choropleth Plots](#geoPlots)
5. [Custom Calandar](#custCal)






## **Orion's Spending Tracker:**<a name="stackedAreaChart"></a>

**Files included:** Orion QOL Tracker.xlsx, OrionSpendingGraphs.R

**Purpose:** Orion was diagnosed with stage 4 renal failure when he was two years old. He was given 2 weeks to live,
but somehow, he kept getting better. He lived life as a normal dog for the next 11 months
I was curious how much was spent on him over his lifespan.


**Libraries used:** dplyr, tidyverse, plotly, openxlsx

**Output:**

![image](https://github.com/PlaidDragon/DataVisualizations/assets/135033377/3d4f76ce-9ca2-479f-8e15-c279d7ae73e2)


![image](https://github.com/PlaidDragon/DataVisualizations/assets/135033377/93cc55c2-143a-48c3-8e42-b92fbaadbf6a)


## **Simple Violin Plots for AB Analysis**<a name="violinPlots"></a>

**Code**:

```
df %>% 
  filter(device == "Desktop") %>%
  select(Flag, firstByte) %>%
  plot_ly(y=~as.numeric(firstByte), name = ~Flag,  type='violin',
          box = list(visible = T),
          meanline = list(visible = T)
  ) %>%
  layout(uniformtext=list(minsize=8, mode='hide'),
         yaxis = list(title = "Time (ms)"),
         xaxis = list(title = ""),
         title = "Time to First Byte Distribution",
         showlegend = FALSE
  )

```

**Purpose:** A client wanted to determine if a change impliemnted on their website lowered their site's Time to First Byte KPI. The first step (becides calling data from their performance tool's API which is not shown here for security reasons) was to look at the distibution of both data sets (before and after the change was implimented). I prefer Violin plots to bar and histogram charts, as I feel they offer more information than either of the prior do. The plots showed the 'control' group had a higher TTFB, however the distribution was much tighther than the 'treatment' group, which was more normalized, but with a wider deviation and lower median and mean.

**Libraries used:** dplyr, plotly

**Output:**


![image](https://github.com/PlaidDragon/DataVisualizations/assets/135033377/8210cc22-d9e7-4456-959d-492190c3d812)




## **Simple Bar Plot**<a name="barChart"></a>

**Code**:

```library(plotly)
x <- c("Husband/MIL did not want" , "Fetus had cognitive abnormality", "Last child too young","Economic reasons","Male fetus", "Female fetus", "Health did not permit", "Pregnancy complications","Contraceptive failure","Unplanned pregnancy", "Other")
y <- c(0.041, 0.033, 0.097, 0.034, 0.0040, 0.021, 0.113, 0.091, 0.036, 0.476, 0.053)
colors = c("#A4A6A6", "#A4A6A6","#6AB8A7", "#A4A6A6", "#A4A6A6", "#A4A6A6", "#6AB8A7", "#A4A6A6", "#A4A6A6", "#6AB8A7", "#A4A6A6")
data <- data.frame("reason" = x, "perc" = y, "colors" = colors)

plot_ly(data, x = ~round(perc,2), y = ~reason, type = 'bar', marker = list(color = ~colors)) %>% 
  layout(title = 'Women in India Most Commonly Get Abortions Due to <span style="color: #6AB8A7"><b>Unplanned Pregnancy</b></span><br>Data Taken from women aged 15-49 who had an abortion within the last five years in 2019-2021<br><br>',
         xaxis = list(title = "% of Women"),
         yaxis = list(title = "", 
                      categoryorder = "total ascending"),
         margin = list(t = 100)
  ) %>%
  layout(xaxis = list(tickformat = ".2f")) %>%
  add_annotations(text = paste0(data$perc*100, "%"), x = data$perc-0.011, 
                  y = data$reason, 
                  showarrow = FALSE) %>%
  add_annotations(text = 'North India has highest reports <br>of <span style="color: #6AB8A7"><b>unplanned pregnancies</b></span>', x = 0.3, 
                  y = "Last child too young", 
                  showarrow = FALSE) %>%
  add_annotations(text = '40% of Women in Ladakh reported their<br> <span style="color: #6AB8A7"><b> health did not permit</b></span> them to have a child', x = 0.3, 
                  y = "Economic Reasons", 
                  showarrow = FALSE)

```


**Purpose:** India released a large file of census data. I found a pie plot of the above data and felt I could improve on the plot, making it more informative

**Libraries used:** dplyr, plotly

**Output:**


![image](https://github.com/PlaidDragon/DataVisualizations/assets/135033377/8ad59f46-dd6e-4a5d-8d57-6e7ff65329f6)


## **Mother Theresa's Shooting Databse Geographic Plots:**<a name="geoPlots"></a>

**Files included:** MassShootingDashboard.R, Mother Jones Mass Shootings Database.xlsx, GunOwnership2022.csv

**Purpose:** With the media attention on Mass Shootings, but the media's poor ability to give meaningful statistics to the numbers they report on, I wanted to dive deeper into the actual numbers. The first thing I did was to create these two plots that compare the percentage of people with guns in each state to the number of mass shootings. Overall, it seems the percentage of people with guns does not matter as much as the population density of the state itself. This is not a full analysis of the data, just initial exploritory analysis of the datasets.

**note: This is not an attempt to make any politcal statement and should not be used to do so (see above note on explortitory analysis only)


**Libraries used:** dplyr, tidyr, plotly

**Output:**:

![image](https://github.com/PlaidDragon/DataVisualizations/assets/135033377/05352e5a-90e0-4e6b-b20b-dfc397db20d4)



## **Alabster's Symptom Tracker:**<a name="custCal"></a>

**Files included:** AlabasterHealthTracker.R, AlabasterSymptomTracker.xlsx

**Purpose:** Alabster has been experiencing sporatic gastrointestinal issues from an undiagnosed cause. The xlsx sheet was used to track his symptoms on a daily basis for his specialist, but I wanted to find a better way to highlight any potential patterns in his health. The result was the .R file.

**Libraries used:** dplyr, tidyr, viridis, sugrrants, openxlsx

**Output:**


![image](https://github.com/PlaidDragon/DataVisualizations/assets/135033377/72da81d8-493d-4126-b305-faa0dea446f9)

