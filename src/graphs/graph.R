#This R code creates a plot

#Load library
library(readr)
library(optparse)
library(rjson)
library(ggplot2)
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
