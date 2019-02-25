#This R code creates a plot

#Load library
library(readr)
library(optparse)
library(rjson)
library(readr)
library(ggplot2)
library(magrittr)
library(dplyr)
library(rlist)
library(stargazer)


# CLI parsing
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
data_analysis<-read_csv(opt$data)

#create a graph of fouls over time 
graph <- data_analysis  %>%
  group_by(Year) %>%
  summarise(mean_PF_M = mean(PF_M, na.rm = TRUE)) %>%
  ggplot() +
  geom_point(aes(x = Year, y = mean_PF_M)) +
  geom_smooth(aes(x = Year, y = mean_PF_M)) +
  theme_bw()  +
  labs(x = "Year",
       y = "Mean number of fouls per 100 minutes played")

#title = "Number of personal fauls over time"
ggsave(opt$out, graph)

###create a decision tree of fouls 
# subset data to 2017 
data_analysis_2017<- subset(data_analysis, Year==2017) 

#run decisio tree 
tree.out<-tree(PF_M ~ G+GS+PER+X3P.+X2P.+FTr+TRB+AST+
                 STL+BLK+TOV+FG.+FT.+height+weight+Age
               ,data=data_analysis_2017)

#plot tree
graph_dec<-plot(tree.out)
text(tree.out,splits=TRUE,all=TRUE, pretty = 3, digits = 2)
text<-"Plot is from a decision tree where the splits are chosen based on a k-fold cross validation.
G-Games, GS- Games started, MP - Minutes played, PER - PLayer efficiency rating, X3PAr - 3-Point field goal percentage,
FTr - Free throw rate, ORB. Offensive rebound %, DRB. Defensive rebound percentage, TRB Total rebounds, TOV Turnovers."
mtext(text,1, adj = 0 , at=0, line=4)


#save plot to png 
png(opt$graph_dec,graph_dec)





