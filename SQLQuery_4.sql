SELECT 
ABS(TotalPurchaseYTD) AS TotalPurchase,
DateFirstPurchase,
BirthDate,
MaritalStatus,
YearlyIncome,
Gender,
TotalChildren,
Education,
Occupation,
HomeOwnerFlag,
NumberCarsOwned
FROM Sales.vPersonDemographics 
WHERE TotalChildren IS NOT NULL;