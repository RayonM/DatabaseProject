
Select AnnualSales, BusinessType, NumberEmployees
FROM Sales.vStoreWithDemographics


EXECUTE sp_execute_external_script
@LANGUAGE = N'R',
@SCRIPT = N'
OutputDataSet <- data.frame(.libPaths());
'
WITH RESULT SETS (([DefaultLibraryName]varchar(max)));


EXECUTE sp_execute_external_script
@LANGUAGE = N'R',
@SCRIPT = N'
OutputDataSet <- data.frame(installed.packages()[ , c("Package", "Version")])
'
WITH RESULT SETS (([Package] nvarchar(255), [Version] nvarchar(100)));
