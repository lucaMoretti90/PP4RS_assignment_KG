#This R code cleans the datset

#clear directory
rm(list=ls())

#Load library

library(readr)
library(dplyr)
library(optparse)
library(ggplot2)
library(rlist)
library(stargazer)
#install.packages("stargazer")

option_list = list(
   make_option(c("-d", "--data"),
               type = "character",
               default = NULL,
               help = "a csv file name",
               metavar = "character"),
	make_option(c("-o", "--out"),
                type = "character",
                default = "out.rds",
                help = "output file name [default = %default]",
                metavar = "character"),
	make_option(c("-e", "--out2"),
                type = "character",
                default = "out.tex",
                help = "output file name [default = %default]",
                metavar = "character")
);

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

if (is.null(opt$data)){
 print_help(opt_parser)
 stop("Input data must be provided", call. = FALSE)
}

# Load data
print("Loading data")
data_analysis <- read_csv(opt$data)

#plot
names(data_analysis)
#List
#PF - personal fouls, G - Games, MP- Minutes played, 2P- two pointers 3P - 3 pointers
#TRB - total rebounds per game, AST - assists per game, STL - steals per game
#BLK-blocks per game, TOV - turnovers per game, PTS - points per game

#Running Regression
ols<-lm(PF~height+weight+Age+X2P+X3P+TRB+AST+STL+PTS,data=data_analysis)
summary(ols)

# Save output
list.save(ols, opt$out)

#Create table
table<-stargazer(ols, title="Correlates of fouls", label="foulreg",
          covariate.labels=c("Height", "Weight", "Age", "2-point", "3-point",
                             "Rebounds", "Assists", "Steals", "Points"),
                             column.labels = c("OLS"),
                             out = opt$out2)
