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

names(data_analysis)
#List
#PF - personal fouls, G - Games, MP- Minutes played, 2P- two pointers 3P - 3 pointers
#TRB - total rebounds per game, AST - assists per game, STL - steals per game
#BLK-blocks per game, TOV - turnovers per game, PTS - points per game

#Running Regression
#with all co-variates
ols<-lm(PF_M~ G+GS+PER+X3P.+X2P.+FTr+TRB.+AST.+
          STL.+BLK.+TOV.+FG.+FT.+height+weight+Age,data=data_analysis)
summary(ols)
#with lag dependent variable only
ols_per<-lm(PF_M~PF_M_lag,data=data_analysis)

# Save regression output

#Create table of regressions and save it
table<-stargazer(ols_per, title="Correlates of fouls", label="foulreg",
                             column.labels = c("OLS"),
                            out = opt$out)
