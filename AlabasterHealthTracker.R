library(tidyr)
library(dplyr)
library(viridis)
library(sugrrants)
library(openxlsx)

#-----------PURPOSE-----------------
# Since adopting Alabaster (canine) he has had seemingly random gastrointestinal issues
# The xlsx sheet was used to track his ailments on any given day, but I wanted to experiment
# with a way to look at the data that could make it easier to spot any patterns in his symptoms

importDF <- read.xlsx("~\\AdultStuff\\PetStuff\\Alabaster\\AlabasterSymptomTracker.xlsx", sheet = 3)

#Combine data into Dataframe with 24-hour segmented days
calDF <- data.frame("Date" = rep(seq(as.Date("2023-01-01"), as.Date("2023-03-28"), 1), 24)) %>%
  mutate("holder1" = rep(0, 2088), #holders are just to make it look prettier
         "Diarrhea" = rep(importDF$Diarhhea, 24),
         "Vommiting" = rep(importDF$Vommiting, 24),
         "No Appetite" = rep(importDF$Lack.of.Appetite, 24),
         "Antibiotics" = rep(importDF$Antibiotic, 24),
         "Bland Diet" = rep(importDF$Bland.Diet, 24),
         "Gastro Diet" = rep(importDF$Gastro.Prescription.Food, 24),
         "Dewormer" = rep(importDF$Dewormer, 24),
         "holder" = rep(0, 2088)
         ) 

#Assign numeric values to be used as horizontal placement in calandar
start = 1
for(c in 2:ncol(calDF)){
  calDF[which(calDF[,c] != ""), c] <- start
  calDF[,c] <- as.numeric(calDF[,c])
  start <- start + 1
}

#Change data to long format with time column that indicates hour
##Since I want a full length horizontal bar, this will be the same value for 1-24
longCal <- calDF %>%
  pivot_longer(cols=c("Diarrhea", "Vommiting", "No Appetite", "Antibiotics", "Bland Diet", "Gastro Diet", "Dewormer","holder1", "holder"),
               names_to = "Ailment"
  ) %>%
  group_by(Date, Ailment) %>%
  mutate("Time" = sort(rep(1:24))) %>%
  ungroup()
  
#Create Calandar.
##I don't like how the days for the 30th and 31st do not appear at the bottom of the calandar
## so I hard-coded a fix in
alaCal <- longCal %>%
  frame_calendar(x = Time, y = value, date = Date, ncol = 4)
alaCal$.Time[alaCal$Date == "2023-01-30"] <- alaCal$.Time[alaCal$Date == "2023-02-27"]
alaCal$.Time[alaCal$Date == "2023-01-31"] <- alaCal$.Time[alaCal$Date == "2023-02-28"]


#Create a dataframe to be used for annotating the day number on the calandar
annotDF <- alaCal %>%
  filter(Ailment == "holder") %>%
  group_by(Date) %>%
  filter(Time == max(Time)) %>%
  ungroup() %>%
  distinct(Date, .Time, .value) %>%
  rename("labelTime" = ".Time", "labely" = .value) %>%
  mutate("label" = substr(Date, 09,10))


#Drop the holder columns and join in annotation data
alaCal <- alaCal %>%
  filter(!Ailment %in% c("holder1", "holder")) %>%
  left_join(annotDF, by = c("Date"))

colors = c("#838A41", "#8188E6", "#E6D181", "#BFDA69", "#DA698D", "#69D7DA", "#F49DF1")

#create plot using ggplot
p4 <- ggplot(alaCal)
  
for(i in 2:(ncol(calDF)-1)){
  p4 <- p4 + 
    geom_line(
      data = filter(alaCal, Ailment == colnames(calDF)[i]),
      aes(.Time, .value, group = Date,colour=Ailment), size=3, name=colnames(calDF)[i]
    ) + 
    geom_text(aes(x=labelTime, y=labely, label=label),
              color="grey", size=2.1 , angle=0, nudge_x = -0.01)#fontface="bold" )
}


p4 <- p4 +
  ggtitle("Alabaster Winter Daily Symptoms", subtitle = "Adopted 2023-01-13")
prettify(p4)
