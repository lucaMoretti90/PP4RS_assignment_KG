#clear directory
rm(list=ls())
getwd()
setwd("C:/Users/ksrinivasan/OneDrive/Zurich/Courses/others/programming_winter/PP4RS_assignment_KG")
#Load library

library(readr)
library(dplyr)
library(optparse)
library(ggplot2)
library(rlist)
library(stargazer)
library(tree) #install.packages("tree")
library(export)
library(ggploify)
library(randomForest)
print("Loading data")

data_analysis<-read.csv("./src/data/data_merged.csv")

#data_analysis$pos_short<-substr(data_analysis$Pos,1,1)
#table(data_analysis$pos_short)
#length(data_analysis$pos_short)

#table(data_analysis$pos_short)
#subset(data_analysis,pos_short=="C"&Year==2017))

data_analysis$PF_min<-100*data_analysis$PF/data_analysis$MP
data_analysis$PF_M<-round(data_analysis$PF_min,1)
data_analysis$PF_M[is.finite(data_analysis$PF_M)==F]<-NA
data_analysis$PF_G<-data_analysis$PF/data_analysis$G
data_analysis$PF_M_lag<-lag(data_analysis$PF_M,1)

graph <- data_analysis  %>%
  group_by(Year) %>%
  summarise(mean_PF = mean(PF_M, na.rm = TRUE)) %>%
  ggplot() +
  geom_point(aes(x = Year, y = mean_PF)) +
  geom_smooth(aes(x = Year, y = mean_PF)) +
  theme_bw()  +
  labs(x = "Year",
       y = "Mean of number of fouls")

summary(data_analysis$MP)

  #G-Games
  #GS- Games started
  #MP - Minutes played
  #PER - PLayer efficiency rating
  #X3PAr - 3-Point field goal percentage
  #FTr - Free throw rate
  #ORB. Offensive rebound %
  #DRB. Defensive rebound percentage
  #TRB Total rebounds
  #TOV Turnovers


data_analysis_2017<- subset(data_analysis, Year==2017)
tree.out<-tree(PF_M ~ G+GS+PER+X3P.+X2P.+FTr+TRB+AST+
                 STL+BLK+TOV+FG.+FT.+height+weight+Age
                 ,data=data_analysis_2017)

#MP
graph_base<-as.ggplot(~plot(tree.out))
plot.tree(tree.out)
text(tree.out,splits=TRUE,all=TRUE, pretty = 3, digits = 2)
text<-"Plot is from a decision tree where the splits are chosen based on a k-fold cross validation.
G-Games, GS- Games started, MP - Minutes played, PER - PLayer efficiency rating, X3PAr - 3-Point field goal percentage,
FTr - Free throw rate, ORB. Offensive rebound %, DRB. Defensive rebound percentage, TRB Total rebounds, TOV Turnovers."
mtext(text,1, adj = 0 , at=0, line=4)
graph_dec<-as.ggplot(~graph_base)


ggsave("graph_dec.pdf", graph_base,device=pdf)
png("./out/graphs/outplot_dec.png")

names(data_analysis)

#CHeck if pruning is required
ggtree(PF ~ G+GS+PER+X3P.+X2P.+FTr+TRB.+AST.+
         STL.+BLK.+TOV.+FG.+FT.+height+weight+Age
       ,data_analysis=data_analysis_2017)

tree.check.out<-tree(PF ~ G+GS+PER+X3P.+X2P.+FTr+TRB.+AST.+
                       STL.+BLK.+TOV.+FG.+FT.+height+weight+Age
                     ,data_analysis=data_analysis_2017)

cv.tree.out=cv.tree(tree.check.out)
cv.tree.out$dev
cv.tree.out$size
cv.tree.out$size[max(which(cv.tree.out$dev==min(cv.tree.out$dev)))]
prune.tree.out<-prune.misclass(tree.check.out,
                               best=cv.tree.out$size[max(which(cv.tree.out$dev==min
                                                               (cv.tree.out$dev)))])
summary(prune.tree.out)
prune.tree.out
#plot pruned tree in the subfolder Results/plots
png("./Results/plots/ptree.png",800,500)
plot(tree.check.out)
text(tree.check.out,splits=TRUE,all=TRUE, pretty = 2)
dev.off()

data_analysis_2017_s<-data_analysis_2017[complete.cases(data_analysis[,c(data_analysis$X3P.data_analysis$X2P.
                                                        )))
#
rf.out<-randomForest(PF_M ~ G+GS+PER+X3P.+X2P.+FTr+TRB.+AST.+
                       STL.+BLK.+TOV.+FG.+FT.+height+weight+Age
                     ,data=data_analysis_2017_s,ntree=50,importance=TRUE)
