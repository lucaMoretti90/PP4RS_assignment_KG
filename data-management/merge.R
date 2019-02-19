#This R code merges the datasets

#clear directory 
rm(list=ls())

#Libraries 
library(dplyr)

#importing datasets
#player_data<-read.csv("../data/player_data.csv")
players<-read.csv("../data/players.csv")
season_stats<-read.csv("../data/Seasons_Stats.csv")

#Merge datasets
data_merged<-left_join(season_stats,players,by="Player")

#Save the datset
write.csv(data_merged, '../data/data_merged.csv')

