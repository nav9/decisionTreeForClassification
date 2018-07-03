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
stR = 2; enR = 2126; stC = 7; enC = 28; aC = 40
message("Loading data from: ", fileName)
dat<-read.csv(fileName, header=TRUE, sep=",")
dat <- select(dat,LB,AC,FM,UC,ASTV,MSTV,ALTV,MLTV,DL,DS,DP,DR,Width,Min,Max,Nmax,Nzeros,Mode,Mean,Median,Variance,Tendency,NSP)#choose relevant columns
dat <- dat[stR:enR,]#choose relevant rows
cat("Loaded data dimensions:", dim(dat));#print(paste("Loaded data with ", nrow(dat), "rows", ncol(dat),"columns"))

dat$NSPF <- as.factor(dat$NSP)
str(dat)

#splitting the data into training and validate
set.seed(1)
#Below code will partition the data into 2 sets. When we run the pd code, the data is created with 1 & 2 values
# training data is considered 80% and validation data is 20%
pd=sample(2,nrow(dat),replace=TRUE,prob=c(0.8,0.2))
train=dat[pd==1,]
validate=dat[pd==2,]
#View the structure of train and validate data
str(train)
str(validate)
library(party)
#ctree is for classification tree
#for illustration we are using only few variables
#Building the tree on the train data
tree=ctree(NSPF~LB+AC+FM+UC+ASTV+MSTV+ALTV+MLTV+DL+DS+DP+DR+Width+Min+Max+Nmax+Nzeros+Mode+Mean+Median+Variance+Tendency, data=train)
tree
plot(tree)
#Pruning the tree with controls option(to reduce the branches)
#mincriterion=0.99 specifies the confidence level, i.e., 99% confident that the variable is significant
#minsplit=1100 specifies that the branch will be split into 2 only when the sample is 1100 which restricts the growth of the tee
tree=ctree(NSPF~LB+AC+FM+UC+DL+DS+DP+ASTV+MSTV+ALTV+MLTV, data=train, controls=ctree_control(mincriterion=0.99, minsplit=1800))
tree
plot(tree,type="simple")
plot(tree)
#Predict function is used to predict the probabilities using the tree which is built above on the validate data
predict(tree,validate,type="prob")

#Predict NSP
predict(tree,validate)

########################################
#Misclassification error
#######################################

#Misclassification error on training data
tab<-table(predict(tree), train$NSPF)
#All the values in Diagonal are predicted correctly. Off diagonal values are incorrect prediction
print(tab)
#Below is the output of the above statements in R.

#The left 1,2,3 are the actual NSP values in the data and the top 1,2,3 are the predicted values.
tab<-table(predict(tree), train$NSPF)
print(tab)
# % of misclassification is provided based on the training data
1-sum(diag(tab))/sum(tab)
#Misclassification error of the above statement : [1] 0.1560284

#Misclassification error on validate data
testpred=predict(tree, newdata=validate)

tab<-table(testpred, validate$NSPF)
print(tab)
# % of misclassification is provided based on the Validation data

1-sum(diag(tab))/sum(tab)





# fitTree <- rpart(LB~., data = dat, method="class")
# summary(fitTree)
# predicted = predict(fitTree, dat)
# #rpart.plot(fitTree)



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
