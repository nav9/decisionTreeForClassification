#Author & date: Navin K Ipe. July 2018
#License: MIT
#Decision tree for Cardiotocographic data

library(readr)
library(dplyr)
library(party)
library(rpart)
library(rpart.plot)
library(ROCR)
set.seed(100)

if(!is.null(dev.list())) dev.off()#clear old plots
cat("\f")#clear console
#rm(list = setdiff(ls(), lsf.str()))#remove all objects except functions
#rm(list=ls())#remove all objects loaded into R
#rm(list=lsf.str())#remove all functions but not variables
#rm(list=ls(all=TRUE))#clear all variables

fileName = "CTG.csv"
stR = 2; enR = 2127; stC = 7; enC = 28; aC = 40
message("Loading data from: ", fileName)
dat<-read.csv(fileName, header=FALSE, sep=",")
dat <- select(dat,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,V40)
dat <- dat[stR:enR,]
print(dat); cat("Data dimensions:", dim(dat))



# #----------- ROC curve example
# outlook = c('rain', 'overcast', 'rain', 'sunny', 'rain',
#             'rain', 'sunny', 'overcast', 'overcast', 'overcast',
#             'sunny', 'sunny', 'rain', 'rain', 'overcast',
#             'sunny', 'overcast', 'overcast', 'sunny', 'sunny',
#             'sunny', 'overcast')
# humidity = c(79, 74, 80, 60, 65, 79, 60, 74, 77, 80,
#              71, 70, 80, 65, 70, 56, 80, 70, 56, 70,
#              71, 77)
# windy = c(T, T, F, T, F, T, T, T, T, F, T, F, F, F, T, T, F, T, T, F, T, T)
# play = c(F, F, T, F, T, F, F, T, T, T, F, F, T, T, T, T, T, T, F, T, F, T)
#
# game = data.frame(outlook, humidity, windy, play)
# game$score = NA
#
# attach(game)
# game$score[outlook == 'sunny' & humidity <= 70] = 5/8
# game$score[outlook == 'sunny' & humidity > 70] = 1 - 3/4
# game$score[outlook == 'overcast'] = 4/5
# game$score[outlook == 'rain' & windy == T] = 1 - 2/2
# game$score[outlook == 'rain' & windy == F] = 3/3
# detach(game)
#
# game$predict = game$score >= 0.5
# game$correct = game$predict == game$play
#
# library(ROCR)
#
# pred = prediction(game$score, game$play)
# roc = performance(pred, measure="tpr", x.measure="fpr")
# plot(roc, main="ROC", col="orange", lwd=2)
# lines(x=c(0, 1), y=c(0, 1), col="red", lwd=2)
#
# auc = performance(pred, 'auc')
# slot(auc, 'y.values')
