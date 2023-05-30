library(dplyr)
library(plotly)
library(tidyr)
#https://worldpopulationreview.com/state-rankings/gun-ownership-by-state


raw <- openxlsx::read.xlsx("~\\CoolStuff\\Shooting Data\\Mother Jones Mass Shootings Database.xlsx")
raw$latitude[1:2] <- c(29.2097, 42.8864)
raw$longitude[1:2] <- c(-99.7862, -78.8784)
colnames(raw)[8] <- "shootingLocation"
raw$date <- as.Date(raw$date, origin = "1899-12-30")




#--------------Total Fatalities by Location----------------
geoMap <- raw %>% 
  filter(total_victims < 600) %>%
  select(location, longitude, latitude, fatalities, injured, total_victims, year) %>%
  mutate_at(vars(latitude, longitude), ~as.numeric(.))



# geo styling
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showland = TRUE,
  landcolor = toRGB("gray95"),
  subunitcolor = toRGB("gray85"),
  countrycolor = toRGB("gray85"),
  countrywidth = 0.5,
  subunitwidth = 0.5
)

p1 <- plot_geo(geoMap, lat = ~latitude, lon = ~longitude, colors = c("#57DFD7","#081B1A"),showlegend = FALSE) %>%
  add_markers(
    text = ~paste("Year: ", year, "<br>Location: ",location, "<br>Deaths: ", fatalities, "<br>Injuries: ", injured, paste("<br>Total Victims:", total_victims)),
    color = ~total_victims, symbol = I("square"), size = I(8), hoverinfo = "text",
    marker = list(size = 08)
    ) %>% 
  colorbar(title = "Total Victims", y=0.85) %>%
  layout(
  title = 'Mass Shootings from 1982-2022',
  geo = g
  )


#-----------------Gun Ownership by State----------------------------
stateDF <- data.frame("Abbr" = state.abb, "State" = state.name)

ownership <- read.csv("~\\CoolStuff\\Shooting Data\\GunOwnership2022.csv") %>%
  rename("State" = "ï..State") %>%
  left_join(stateDF, by = "State") %>%
  mutate("text" = paste0(round(gunOwnership*100,2), "% |", State))


p2 <- plot_geo(ownership, colors = c("#301980","#DDDF5D")) %>%
  add_trace(type = "choropleth", z=~gunOwnership, locations=~Abbr, color=~gunOwnership, text = ~text,
            locationmode = 'USA-states', span = I(1)) %>%
  colorbar(title = "Percentage of Population with Guns", tickformat=".0%", y = 0.35) %>%
  
  layout(
    title = list(text="Is there a Relationship to Guns and Mass Shootings?",
                 pad = list(t=50)),
    geo = g
  )








#------------------Combine Plots-----
anno = list( 
  list( 
    x = 0.5,  
    y = .93,  
    text = "<br>Mass Shootings from 1982 to 2022<br>From Mother Theresa's Mass Shooting Database",  
    xref = "paper",  
    yref = "paper",  
    xanchor = "center",  
    yanchor = "bottom",  
    showarrow = FALSE 
  ),  
  list( 
    x = 0.5,  
    y = 0.40,  
    text = "Population Percentage with Guns",  
    xref = "paper",  
    yref = "paper",  
    xanchor = "center",  
    yanchor = "bottom",  
    showarrow = FALSE 
  )
)
  
subplot(p1,p2, nrows = 2) %>%
  layout(annotations = anno, showLegend = FALSE, pad = list(t=100))
  

        