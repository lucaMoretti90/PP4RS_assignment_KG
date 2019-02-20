library(optparse)
library(rjson)
library(readr)
library(ggplot2)
library(magrittr)

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

# Load data
print("Loading data")
df <- read_csv(opt$data)
data_analysis<-read_csv(opt$data)

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
ggsave(opt$out,plot)
