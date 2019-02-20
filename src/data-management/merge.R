#This R code merges the datasets

#clear directory
rm(list=ls())

#Libraries
library(optparse)
library(rjson)
library(dplyr)

# CLI parsing
option_list = list(
 make_option(c("-d", "--data_players"),
               type = "character",
               default = NULL,
               help = "a csv file name",
               metavar = "character"),
 make_option(c("-d", "--data_seasons"),
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

opt_parser = OptionParser(option_list = option_list);
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
season_stats<-read.csv(opt$data_seasons)
#season_stats<-read.csv("../src/data/Seasons_Stats.csv")

#Merge datasets
data_merged<-left_join(season_stats,players,by="Player")

#Save the datset
write_csv(data_merged, opt$out)
