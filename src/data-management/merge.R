#This R code merges the datasets

#clear directory
rm(list=ls())

#Libraries
library(optparse)
library(haven)
library(readr)
library(dplyr)

# CLI parsing
option_list = list(
 make_option(c("-d", "--data_players"),
               type = "character",
               default = NULL,
               help = "a csv file name",
               metavar = "character"),
 make_option(c("-e", "--data_seasons"),
               type = "character",
               default = NULL,
               help = "a csv file name",
               metavar = "character"),
 make_option(c("-o", "--out"),
             type = "character",
               default = "out.csv",
               help = "output file name [default = %default]",
               metavar = "character")
);

opt_parser = OptionParser(option_list = option_list, add_help_option=FALSE);
opt = parse_args(opt_parser);

if (is.null(opt$data_players)){
 print_help(opt_parser)
 stop("Input data must be provided", call. = FALSE)
}
if (is.null(opt$data_seasons)){
 print_help(opt_parser)
 stop("Input data must be provided", call. = FALSE)
}

# Load data
print("Loading data")
#player_data<-read.csv("../data/player_data.csv")
players<-read.csv(opt$data_players)
#players <- rename(players, Player = name)
season_stats<-read.csv(opt$data_seasons)
#season_stats<-read.csv("../src/data/Seasons_Stats.csv")

#Merge datasets
data_merged<-left_join(season_stats,players, by="Player")

#Create new variables 
data_merged$PF_min<-100*data_merged$PF/data_merged$MP
data_merged$PF_M<-round(data_merged$PF_min,1)
data_merged$PF_M[is.finite(data_merged$PF_M)==F]<-NA
data_merged$PF_G<-data_merged$PF/data_merged$G
data_merged$PF_M_lag<-lag(data_merged$PF_M,1) 

#Save the datset
write_csv(data_merged, opt$out)
