--results from sql query defined in "input_data_1" will be the "InputDataSet" Dataframe in R
EXECUTE sp_execute_external_script
@language = N'R',
@script = N' 
InputDataSet -> adventure.df
cut(adventure.df$TotalPurchase, 
    breaks = c(0,100,9999), 
    labels = c("Under_100","Over_100"),
    include.lowest = T
) -> adventure.df$TotalPurchaseCat

OutputDataSet <- adventure.df
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
WITH RESULT SETS ((
    TotalPurchase MONEY,
    CustomerAge INT,
    FirstOrderMonths INT,
    MaritalStatus CHAR(2),
    YearlyIncome VARCHAR(30),
    Gender CHAR(2),
    TotalChildren INT,
    Education VARCHAR(25),
    Occupation VARCHAR(25),
    HomeOwnerFlag BINARY(5),
    NumberCarsOwned INT,
    TotalPurchaseCat VARCHAR(10)
))
;
