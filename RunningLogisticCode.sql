--USING REVOSCALER RXLOGIT
EXECUTE sp_execute_external_script
@language = N'R',
@script = N' 
InputDataSet -> adventure.df
cut(adventure.df$TotalPurchase, 
    breaks = c(0,200,9999), 
    labels = c("Under_200","Over_200"),
    include.lowest = T
) -> adventure.df$TotalPurchaseCat

library(RevoScaleR)
adv.glm <- rxLogit(
    formula = TotalPurchaseCat ~ CustomerAge + MaritalStatus + YearlyIncome + TotalChildren + Education + Occupation,
    data = adventure.df
)

serialize(adv.glm, NULL) -> adv.glm.serial

rxPredict(
    modelObject = adv.glm, 
    data = adventure.df, 
    outData = NULL,
    predVarNames = "Score",
    type = "response",
    overwrite = TRUE
    ) -> adv.pred 

print(data.frame(adv.pred))
#print(data.frame(adv.glm.serial))
OutputDataSet <- data.frame(adv.pred,adventure.df$TotalPurchaseCat)
',
@input_data_1 = N'
SELECT
ABS(TotalPurchaseYTD) AS "TotalPurchase",
CAST(GETDATE() - (BirthDate + 5479) AS int) / 365 AS "CustomerAge",
CAST(GETDATE() - (DateFirstPurchase + 5479) AS int) / 12 AS "FirstOrderMonths",
MaritalStatus,
YearlyIncome,
Gender,
TotalChildren,
Education,
Occupation,
HomeOwnerFlag,
NumberCarsOwned 
FROM Sales.vPersonDemographics WHERE TotalChildren IS NOT NULL;
'
WITH RESULT SETS (([Odds] float, [Actual] nvarchar(20)))