#This R code cleans the datset 

#clear directory 
rm(list=ls())

#Install library 
library(ggplot2)
#install.packages("stargazer")
library(stargazer)

#import the data
data_analysis<-read.csv("../data/data_merged.csv")

#plot 
names(data_analysis)
#List 
#PF - personal fouls, G - Games, MP- Minutes played, 2P- two pointers 3P - 3 pointers 
#TRB - total rebounds per game, AST - assists per game, STL - steals per game
#BLK-blocks per game, TOV - turnovers per game, PTS - points per game
ols<-lm(PF~height+weight+Age+X2P+X3P+TRB+AST+STL+PTS+,data=data_analysis)
summary(ols)
table<-stargazer(ols, title="Correlates of fouls", label="foulreg",
          covariate.labels=c("Height", "Weight", "Age", "2-point", "3-point", 
                             "Rebounds", "Assists", "Steals", "Points"),
                             column.labels = c("OLS"))
plot1<-data_analysis  %>%
  group_by(Year) %>%
  summarise(mean_PF = mean(PF, na.rm = TRUE)) %>%
  ggplot() +
  geom_point(aes(x = Year, y = mean_PF)) +
  geom_smooth(aes(x = Year, y = mean_PF)) +
  theme_bw()  +
  labs(x = "Year", 
       y = "Mean of number of fouls")
#title = "Number of personal fauls over time"
ggsave("../graphs/plot1.eps",plot1)
#Regression 


