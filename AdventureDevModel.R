# libraries 
library(tidyverse)
library(caret) # CV and AutoML
library(ROCR) # model validation ROCR plot
library(randomForest) # modeling Random Forest
library(e1071) # modeling Random Forest tuning
library(ranger)


library(car) # modeling
library(glmnet) # logistic regression

library(MASS) # stepAIC(), lda(), predict.lda()

library(ggplot2)



# load CSV as data frame
githubdataurl <- 'https://raw.githubusercontent.com/RayonM/DatabaseProject/main/PersonDemographics2008.csv'
adventure.df <- read.csv(file = githubdataurl )

# LOAD ALT SQL TEXT???

str(adventure.df)
# convert date from factor to POSIX date type
# FirstOrderDate
as.Date( adventure.df$FirstOrderDate, "%Y-%m-%d") -> adventure.df$FirstOrderDate
# CustomerBday
as.Date( adventure.df$CustomerBday, "%Y-%m-%d") -> adventure.df$CustomerBday

# Making HomeOwnerFlag a factor
as.factor(adventure.df$HomeOwnerFlag) -> adventure.df$HomeOwnerFlag




str(adventure.df)
head(adventure.df)


summary(adventure.df$TotalPurchase)
hist(adventure.df$TotalPurchase)
# right skewed
# median is 115 and mean is 817


# creating bins for tenure
# Under_100
# Over_100

cut(adventure.df$TotalPurchase, 
    breaks = c(0,100,9999), 
    labels = c("Under_100","Over_100"),
    include.lowest = T
) -> adventure.df$TotalPurchaseCat

# validate accuracy new Annual Income categorical parameter
adventure.df[c(1,50,100,150,200,250,300,350,400,450),c("TotalPurchase","TotalPurchaseCat")]

adventure.df[adventure.df$TotalPurchase <= 100, c("TotalPurchase","TotalPurchaseCat")]
adventure.df[adventure.df$TotalPurchase >= 100, c("TotalPurchase","TotalPurchaseCat")]



# how is data split
table(adventure.df$TotalPurchaseCat)
# Under_100 Over_100 
# 9088      9396 


plot(adventure.df$TotalPurchaseCat,
     main = "Total Purchase Category")

# INT: TotalPurchase, CustomerAge, FirstOrderMonths

# Comparing Customer Length by Purchase Category
boxplot(adventure.df$FirstOrderMonths ~ adventure.df$TotalPurchaseCat,
        main = "Customer Length by Purchase Category",
        horizontal = T,
        xlab = "Months" )

# Comparing Total Purchase Numeric by Yearly Income Category
boxplot(adventure.df$TotalPurchase ~ adventure.df$YearlyIncome,
        main = "Total Purchase by Yearly Income",
        horizontal = T,
        xlab = "Dollars",
        col = rainbow(5),
        legend.text = levels(adventure.df$YearlyIncome)
        )

legend(2, 9, c("Ascorbic acid", "Orange juice"),
       fill = c("yellow", "orange"))




### DATA ONLY: CUSTOMERS BY EDUCATION & OCCUPATION

# TOTAL CUSTOMERS BY OCCUPATION 
table(adventure.df$Occupation)

# OCCUPATION FOR CUSTOMERS SPENDING OVER 100
table(adventure.df[adventure.df$TotalPurchaseCat == "Over_100", "Occupation" ])

# OCCUPATION FOR CUSTOMERS SPENDING UNDER 100
table(adventure.df[adventure.df$TotalPurchaseCat == "Under_100", "Occupation"])




# TOTAL CUSTOMERS BY EDUCATION
table(adventure.df$Education)

# EDUCATION FOR CUSTOMERS SPENDING OVER 100
table(adventure.df[adventure.df$TotalPurchaseCat == "Over_100", "Education" ])

# EDUATION FOR CUSTOMERS SPENDING UNDER 100
table(adventure.df[adventure.df$TotalPurchaseCat == "Under_100", "Education" ])



# TABLE OF BOTH EDUCATION & OCCUPATION
table(adventure.df[,c("Education", "Occupation")])

# TABLE OF BOTH EDUCATION & OCCUPATION ONLY FOR CUSTOMERS SPENDING OVER 100
table(adventure.df[adventure.df$TotalPurchaseCat == "Over_100" ,c("Education", "Occupation")])

# TABLE OF BOTH EDUCATION & OCCUPATION ONLY FOR CUSTOMERS SPENDING UNDER 100
table(adventure.df[adventure.df$TotalPurchaseCat == "Under_100" ,c("Education", "Occupation")])












### VISUAL + DATA: CUSTOMERS BY EDUCATION & OCCUPATION

# Customers by Occupation 
barplot( (adventure.df %>% dplyr::count(Occupation))$n, 
         horiz = T, 
         legend.text = (adventure.df %>% dplyr::count(Occupation))$Occupation,
         col = rainbow(5),
         main = "Total Customers by Occupation",
         xlab = "Customers")

table(adventure.df$Occupation)

# Customers by Education 
barplot( (adventure.df %>% dplyr::count(Education))$n, 
         horiz = T, 
         legend.text = (adventure.df %>% dplyr::count(Education))$Education,
         col = rainbow(5),
         main = "Total Customers by Education",
         xlab = "Customers")

table(adventure.df$Education)


# BOTH in table together

table(adventure.df[,c("Education", "Occupation")])






## EDUCATION & OCCUPATION FOR CUSTOMERS SPENDING OVER 100


# Customers by Occupation Spending Over 100
barplot( (adventure.df[adventure.df$TotalPurchaseCat == "Over_100", ] %>% dplyr::count(Occupation))$n, 
         horiz = T, 
         legend.text = (adventure.df[adventure.df$TotalPurchaseCat == "Over_100", ] %>% dplyr::count(Occupation))$Occupation,
         col = rainbow(5),
         main = "Customers by Occupation Spending Over 100",
         xlab = "Customers")

table(adventure.df[adventure.df$TotalPurchaseCat == "Over_100", "Occupation" ])


# Customers by Education Spending Over 100
barplot( (adventure.df[adventure.df$TotalPurchaseCat == "Over_100", ] %>% dplyr::count(Education))$n, 
         horiz = T, 
         legend.text = (adventure.df[adventure.df$TotalPurchaseCat == "Over_100", ] %>% dplyr::count(Education))$Education,
         col = rainbow(5),
         main = "Customers by Education Spending Over 100",
         xlab = "Customers")

table(adventure.df[adventure.df$TotalPurchaseCat == "Over_100", "Education" ])


# TABLE OF BOTH EDUCATION & OCCUPATION ONLY FOR CUSTOMERS SPENDING OVER 100
table(adventure.df[adventure.df$TotalPurchaseCat == "Over_100" ,c("Education", "Occupation")])




## EDUATION & OCCUPATION FOR CUSTOMERS SPENDING UNDER 100

# Customers by Occupation Spending Under 100
barplot( (adventure.df[adventure.df$TotalPurchaseCat == "Under_100", ] %>% dplyr::count(Occupation))$n, 
         horiz = T, 
         legend.text = (adventure.df[adventure.df$TotalPurchaseCat == "Under_100", ] %>% dplyr::count(Occupation))$Occupation,
         col = rainbow(5),
         main = "Customers by Occupation Spending Under 100",
         xlab = "Customers")

table(adventure.df[adventure.df$TotalPurchaseCat == "Under_100", "Occupation"])


# Customers by Education Spending Under 100
barplot( (adventure.df[adventure.df$TotalPurchaseCat == "Under_100", ] %>% dplyr::count(Education))$n, 
         horiz = T, 
         legend.text = (adventure.df[adventure.df$TotalPurchaseCat == "Under_100", ] %>% dplyr::count(Education))$Education,
         col = rainbow(5),
         main = "Customers by Education Spending Under 100",
         xlab = "Customers")

table(adventure.df[adventure.df$TotalPurchaseCat == "Under_100", "Education" ])


# TABLE OF BOTH EDUCATION & OCCUPATION ONLY FOR CUSTOMERS SPENDING UNDER 100
table(adventure.df[adventure.df$TotalPurchaseCat == "Under_100" ,c("Education", "Occupation")])








# Historgram of Customer Age Who Purchased Over 100
hist(adventure.df[adventure.df$TotalPurchaseCat == "Over_100","CustomerAge"], 
     #breaks = c(0,12,24,36,48,60,72), 
     main = "Customer Age: Over $100",
     xlab = "Customers",
     ylab = "Years")


# Historgram of Customer Age Who Purchased Under 100
hist(adventure.df[adventure.df$TotalPurchaseCat == "Under_100","CustomerAge"], 
     #breaks = c(0,12,24,36,48,60,72), 
     main = "Customer Age: Under $100",
     xlab = "Customers",
     ylab = "Years")






###### MODEL ###### 

### Data Split

# creating the 80 data partition 
adv_split <- createDataPartition(adventure.df$TotalPurchaseCat, p = 0.8, list = F)
# including 80 for training set
adv_train.df <- adventure.df[adv_split,] 
# excluding 80 for testing set
adv_test.df <- adventure.df[-adv_split,]

# validating
head(adv_test.df)





####### LOGISTIC MODEL

# create logistic regression model on train data
# R will automatically create dummy variables on factors
adv_train.logit <- glm(
  TotalPurchaseCat ~ CustomerAge + FirstOrderMonths + MaritalStatus + YearlyIncome + Gender + TotalChildren + Education + Occupation + HomeOwnerFlag + NumberCarsOwned, 
  data = adv_train.df, family = binomial("logit") 
  )

summary(adv_train.logit)


# visualize coefficients
as.data.frame(adv_train.logit$coefficients) %>% ggplot(aes(y = .[,1], x = rownames(.)) ) + geom_col() + theme( axis.text = element_text(angle = 90, size = rel(0.7)) )

as.data.frame(adv_train.logit$coefficients) %>% 
  ggplot(aes(y = .[,1], x = rownames(.)) ) + 
  geom_col() + 
  theme( axis.text = element_text(angle = 90, size = rel(0.7)) )


# DEFAULT VISUALS NOT USABLE
barplot(as.data.frame(adv_train.logit$coefficients)[,1],
        horiz = F,
        legend.text = row.names(as.data.frame(adv_train.logit$coefficients)),
        col = rainbow(nrow(as.data.frame(adv_train.logit$coefficients))),
        main = "Feature Coefficients"
        )




### MODEL EVALUATION

# generate predictions to compare to test set
predict(
  adv_train.logit, 
  newdata = adv_test.df,
  type = "response"
) -> adv_test.pred



# ROC Curve
# requires ROCR library for prediction() and performance()
# for measure options are: 
#acc = Accuracy 
#err = Error Rate [Wrong Predictions / Total Predictions] 
#fpr = False Positive Rate
#tpr = True Positive Rate
#tnr = True Negative Rate
#rec = Recall [same as tpr]
#sens = Sensitivity [same as tpr]
#spec = Specificity [same as tnr]
#prec = Precision [True Positives / All Positives]
#auc = Area Under Curve

### measure = "tpr",
### x.measure = "fpr"

performance(
  prediction(
    predictions = adv_test.pred, 
    labels = adv_test.df$TotalPurchaseCat),
  measure = "tpr",
  x.measure = "fpr"
) -> adv_logit.perf 

plot(adv_logit.perf)


# Model AUC
performance(
  prediction(
    predictions = adv_test.pred, 
    labels = adv_test.df$TotalPurchaseCat),
  measure = "auc"
)@y.values[[1]]

## Calculate Accuracy
# split into "Yes" and "No" based on 0.5 threadshold
as.numeric(adv_test.pred > 0.5 ) -> adv_test.pred.bool
# factor as Over or Under 100
dplyr::recode_factor(
  adv_test.pred.bool, 
  `1` = "Over_100", `0` = "Under_100"
) -> adv_test.pred.bool

# shows model accuracy
mean(adv_test.pred.bool == adv_test.df$TotalPurchaseCat )


# confusion matrix
caret::confusionMatrix(
  data = adv_test.pred.bool,
  reference = adv_test.df$TotalPurchaseCat
)


# specifying which factor level is the reference
caret::confusionMatrix(
  data = relevel(adv_test.pred.bool, ref = "Over_100"),
  reference = relevel(adv_test.df$TotalPurchaseCat, ref = "Over_100")
)





####### RANDOM FOREST MODEL

train(
  TotalPurchaseCat ~ CustomerAge + FirstOrderMonths + MaritalStatus + YearlyIncome + Gender + TotalChildren + Education + Occupation + HomeOwnerFlag + NumberCarsOwned,
  data = adv_train.df,
  method = "ranger",
  trControl = trainControl(
    "cv", 
    number = 5,
    allowParallel = T,
    savePredictions = "final",
    search = "random",
    verboseIter = F
    ),
  importance = 'impurity',
  metric = "Accuracy",
  tuneGrid = expand.grid(
    mtry = c(2,3,4,5),
    min.node.size = c(1,2),
    splitrule = c("gini")
    )
) -> adv_train.rf

#min.node.size
#splitrule

# best tuning parameter
adv_train.rf$bestTune

#final model
adv_train.rf$finalModel



#variable importance
adv_train.rf$modelInfo$varImp(adv_train.rf$finalModel)
ranger::importance(adv_train.rf$finalModel)
adv_train.rf$finalModel$variable.importance





### MODEL EVALUATION

# generate predictions to compare to test set
predict(
  adv_train.rf, 
  newdata = adv_test.df
) -> adv_test.rf.pred



# ROC Curve
# requires ROCR library for prediction() and performance()
# for measure options are: 
#acc = Accuracy 
#err = Error Rate [Wrong Predictions / Total Predictions] 
#fpr = False Positive Rate
#tpr = True Positive Rate
#tnr = True Negative Rate
#rec = Recall [same as tpr]
#sens = Sensitivity [same as tpr]
#spec = Specificity [same as tnr]
#prec = Precision [True Positives / All Positives]
#auc = Area Under Curve

### measure = "tpr",
### x.measure = "fpr"

performance(
  prediction(
    predictions = as.numeric(adv_test.rf.pred), 
    labels = as.numeric(adv_test.df$TotalPurchaseCat)),
  measure = "tpr",
  x.measure = "fpr"
) -> adv_test.rf.perf 

plot(adv_test.rf.perf)


# Model AUC
performance(
  prediction(
    predictions = as.numeric(adv_test.rf.pred), 
    labels = as.numeric(adv_test.df$TotalPurchaseCat)),
  measure = "auc"
)@y.values[[1]]

## Calculate Accuracy
# shows model accuracy
mean(adv_test.rf.pred == adv_test.df$TotalPurchaseCat )


# confusion matrix
caret::confusionMatrix(
  data = adv_test.rf.pred,
  reference = adv_test.df$TotalPurchaseCat
)


# specifying which factor level is the reference
caret::confusionMatrix(
  data = relevel(adv_test.rf.pred, ref = "Over_100"),
  reference = relevel(adv_test.df$TotalPurchaseCat, ref = "Over_100")
)


