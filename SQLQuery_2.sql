
EXECUTE sp_execute_external_script
@LANGUAGE = N'R',
@script = N'
print("Hello World")
'
EXECUTE sp_execute_external_script
@LANGUAGE = N'R',
@script = N'
print(version)
'

EXECUTE sp_execute_external_script
@LANGUAGE = N'R',
@script = N'
print(typeof(as.integer(10)))
'


EXECUTE sp_execute_external_script
@LANGUAGE = N'R',
@script = N'
advw.model=lm(AnnualSales~as.factor(BusinessType)+NumberEmployees,data=advw.StoreM)
'


--Testing Code
EXECUTE sp_execute_external_script
@LANGUAGE = N'R',
@script = N'
advw.model=lm(AnnualSales~as.factor(BusinessType)+NumberEmployees,data=advw.StoreM)
#print(summary(InputDataSet))
#QuickLook <- head(InputDataSet)
#print(QuickLook)
#OutputDataSet <- QuickLook
',
@input_data_1 = N'Select AnnualSales, BusinessType, NumberEmployees
FROM Sales.[vStoreWithDemographics]; '
WITH RESULT SETS (([Annual Sales] int, [Business Type] nvarchar(5), [Number of Employees] int))


EXECUTE sp_execute_external_script
@LANGUAGE = N'R',
@script = N'
OutputDataSet <- InputDataSet[1,]
',
@input_data_1 = N'Select AnnualSales, BusinessType, NumberEmployees
FROM Sales.[vStoreWithDemographics]; '
WITH RESULT SETS (([Annual Sales] int, [Business Type] nvarchar(5), [Number of Employees] int))







--Project Code
CREATE PROCEDURE MODEL
    @Count
AS 

EXECUTE sp_execute_external_script
@LANGUAGE = N'R',
@script = N'
advw.model=lm(AnnualSales~as.factor(BusinessType)+NumberEmployees,data=InputDataSet)
#print(summary(advw.model))
print(advw.model$fit)
predict(predict())
#OutputDataSet <- summary(advw.model) # Didnt work because OutputDataSet only takes data Frames.
',
@input_data_1 = N'Select AnnualSales, BusinessType, NumberEmployees
FROM Sales.[vStoreWithDemographics]; '


@params 
--WITH RESULT SETS (([Annual Sales] int, [Business Type] nvarchar(5), [Number of Employees] int))

