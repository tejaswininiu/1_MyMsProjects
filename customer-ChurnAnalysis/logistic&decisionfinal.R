setwd("E:/TEJA/niuFALL19_SEM3/665/group_project")
loadData<-read.csv("telecomdatacleaned.csv")
View(loadData)
#Divide the data int 80 -20
trainData<-as.data.frame(loadData[1:6000,2:21])
View(trainData)
testData<-as.data.frame(loadData[6001:7043,2:21])
View(testData)
str(trainData)
#exploratory- Descriptive data analysis
table(trainData$Churn)
table(trainData$gender,trainData$Churn)
table(trainData$SeniorCitizen,trainData$Churn)
table(trainData$Partner,trainData$Churn)
table(trainData$Dependents,trainData$Churn)
table(trainData$PhoneService,trainData$Churn)
table(trainData$MultipleLines,trainData$Churn)
table(trainData$InternetService,trainData$Churn)
table(trainData$OnlineSecurity,trainData$Churn)
table(trainData$OnlineBackup,trainData$Churn)
table(trainData$DeviceProtection,trainData$Churn)
table(trainData$TechSupport,trainData$Churn)
table(trainData$StreamingTV,trainData$Churn)
table(trainData$StreamingMovies,trainData$Churn)
table(trainData$Contract,trainData$Churn)
table(trainData$PaperlessBilling,trainData$Churn)
table(trainData$PaymentMethod,trainData$Churn)
summary(trainData$tenure)
summary(trainData$MonthlyCharges)
summary(trainData$TotalCharges)
#churning rate in females and males
library(ggplot2)
ggplot(loadData)+geom_bar(aes(x = Churn,fill=Churn))+facet_wrap(~gender)
#exploratory= scatter plot between tenure and Monthly charges
plot(loadData$tenure, loadData$MonthlyCharges)
#exploratory = hexbin plot b/n tenure and monthly charges
d <- ggplot(loadData, aes(tenure, MonthlyCharges))
d + geom_hex()
# couldn't understand the relationship b/n the variables
#check the correlation factor
x<-cor(loadData$tenure,loadData$MonthlyCharges)
x
#fit linear regression model for gender, monthly charges, total charges, dependents
#check significance
linearRegression <- lm(tenure~gender + MonthlyCharges
                       + TotalCharges
                       + Dependents,traindata)
summary(linearRegression)
confint(linearRegression, level = .95)
with(linearRegression , {
  plot(fitted.values, residuals,ylim=c(-60,40) )
  points(c(min(fitted.values) ,max(fitted.values)),
         c(0,0) , type = "1") })
par(mfrow=c(2,2)) 
plot(linearRegression)


#can't perform correlation

#go for logistic regression with allthe variables
mylogitc<-glm(Churn~tenure+MonthlyCharges+as.factor(gender)+as.factor(SeniorCitizen)
             +as.factor(Dependents)+as.factor(Partner)+as.factor(PhoneService)+as.factor(MultipleLines)
             +as.factor(InternetService)+as.factor(OnlineSecurity)+as.factor(OnlineBackup)
             +as.factor(DeviceProtection)+as.factor(TechSupport)+as.factor(StreamingTV)
             +as.factor(StreamingMovies)+as.factor(Contract)+as.factor(PaperlessBilling)
             +as.factor(PaymentMethod),data=trainData,family=binomial(link = "logit"))
summary(mylogitc)
#remove partner

mylogitc2<-glm(Churn~tenure+MonthlyCharges+as.factor(gender)+as.factor(SeniorCitizen)
              +as.factor(Dependents)+as.factor(PhoneService)+as.factor(MultipleLines)
              +as.factor(InternetService)+as.factor(OnlineSecurity)+as.factor(OnlineBackup)
              +as.factor(DeviceProtection)+as.factor(TechSupport)+as.factor(StreamingTV)
              +as.factor(StreamingMovies)+as.factor(Contract)+as.factor(PaperlessBilling)
              +as.factor(PaymentMethod),data=trainData,family=binomial(link = "logit"))
summary(mylogitc2)
#log likelihood
pchisq(0,1,lower=FALSE)
#remove onlinesecurity
mylogitc3<-glm(Churn~tenure+MonthlyCharges+as.factor(gender)+as.factor(SeniorCitizen)
               +as.factor(Dependents)+as.factor(PhoneService)+as.factor(MultipleLines)
               +as.factor(InternetService)+as.factor(OnlineBackup)
               +as.factor(DeviceProtection)+as.factor(TechSupport)+as.factor(StreamingTV)
               +as.factor(StreamingMovies)+as.factor(Contract)+as.factor(PaperlessBilling)
               +as.factor(PaymentMethod),data=trainData,family=binomial(link = "logit"))
summary(mylogitc3)
pchisq(0.1,1,lower=FALSE)
#remove techsupport
mylogitc4<-glm(Churn~tenure+MonthlyCharges+as.factor(gender)+as.factor(SeniorCitizen)
               +as.factor(Dependents)+as.factor(PhoneService)+as.factor(MultipleLines)
               +as.factor(InternetService)+as.factor(OnlineBackup)
               +as.factor(DeviceProtection)+as.factor(StreamingTV)
               +as.factor(StreamingMovies)+as.factor(Contract)+as.factor(PaperlessBilling)
               +as.factor(PaymentMethod),data=trainData,family=binomial(link = "logit"))
summary(mylogitc4)
pchisq(0.3,1,lower=FALSE)
#remove gender
mylogitc5<-glm(Churn~tenure+MonthlyCharges+as.factor(SeniorCitizen)
               +as.factor(Dependents)+as.factor(PhoneService)+as.factor(MultipleLines)
               +as.factor(InternetService)+as.factor(OnlineBackup)
               +as.factor(DeviceProtection)+as.factor(StreamingTV)
               +as.factor(StreamingMovies)+as.factor(Contract)+as.factor(PaperlessBilling)
               +as.factor(PaymentMethod),data=trainData,family=binomial(link = "logit"))
summary(mylogitc5)
pchisq(0.3,1,lower=FALSE)
#remove paymentmethod
mylogitc6<-glm(Churn~tenure+MonthlyCharges+as.factor(SeniorCitizen)+as.factor(Dependents)
               +as.factor(PhoneService)+as.factor(MultipleLines)
               +as.factor(InternetService)+as.factor(OnlineBackup)
               +as.factor(DeviceProtection)+as.factor(StreamingTV)
               +as.factor(StreamingMovies)+as.factor(Contract)+as.factor(PaperlessBilling)
              ,data=trainData,family=binomial(link = "logit"))
summary(mylogitc6)
pchisq(22,2,lower=FALSE)
#remove dependents
mylogitc7<-glm(Churn~tenure+MonthlyCharges+as.factor(SeniorCitizen)
               +as.factor(PhoneService)+as.factor(MultipleLines)
               +as.factor(InternetService)+as.factor(OnlineBackup)
               +as.factor(DeviceProtection)+as.factor(StreamingTV)
               +as.factor(StreamingMovies)+as.factor(Contract)+as.factor(PaperlessBilling)
               ,data=trainData,family=binomial(link = "logit"))
summary(mylogitc7)
pchisq(3,1,lower=FALSE)

#time to test how the final proposed logistic regression model is predicting.
library(gplots)
install.packages("bitops")
library(bitops)
install.packages("caTools")
library(caTools)
install.packages("ROCR")
library(ROCR)

pred = predict(mylogitc7,newdata =testData , type="response")
#next 3 lines for confusion matrix
predicted_classes <- ifelse(pred > 0.5, "Yes", "No")
predicted_classes
t<-table(predictions=predicted_classes,actual_class=testData$Churn)
t
plot(t)
predObj = prediction(pred, testData$Churn)
rocObj = performance(predObj, measure="tpr", x.measure="fpr")
aucObj = performance(predObj, measure="auc") 
auc = aucObj@y.values[[1]]
auc
plot(rocObj, main = paste("Area under the curve:", auc))


#DecisionTree
#considering original dataset
loadData<-read.csv("telecomdata.csv")
View(loadData)
trainData<-as.data.frame(loadData[1:6000,2:21])
View(trainData)
testData<-as.data.frame(loadData[6001:7043,2:21])
View(testData)
str(trainData)
install.packages("rpart.plot")
library("rpart")
library("rpart.plot")

decision_tree <- rpart(Churn~ tenure+MonthlyCharges+gender+SeniorCitizen+
                       Dependents+Partner+PhoneService+MultipleLines
                       +InternetService+OnlineSecurity+OnlineBackup
                       +DeviceProtection+TechSupport+StreamingTV+StreamingMovies+Contract+PaperlessBilling
                       +PaymentMethod, method="class",data=trainData,control=rpart.control(minsplit=1),parms=list(split='information'))
summary(decision_tree)
rpart.plot(decision_tree, type=4, extra=2, clip.right.labs=FALSE,
           varlen=0)
predict_class<-predict(decision_tree,newdata=testData,type="class")
#next 3 lines for confusion matrix 
t<-table(predictions=predict_class,actual=testData$Churn)
t
plot(t)
ratio<-sum(diag(t))/sum(t)
ratio
install.packages("pROC")
library(pROC)
predict_prob<-predict(decision_tree,testData, type="prob")
predict_prob
auc<-auc(testData$Churn,predict_prob[,2])
auc
rocObj<-roc(testData$Churn, predict_prob[,2])
plot(rocObj,legacy.axes= TRUE,main =paste("Area under the curve:", auc))
