ALTER VIEW EmployeeDesc
AS
SELECT 
p.Title,
p.FirstName,
p.LastName,
p.BusinessEntityID,
e.Gender,
e.BirthDate,
YEAR(e.BirthDate) AS BirthdayYear,
e.HireDate,
YEAR(e.HireDate) AS HireYear,
e.JobTitle,
e.MaritalStatus,
e.VacationHours,
d.GroupName,
d.Name AS Department_Name,
a.City, a.PostalCode,
sp.Name AS StateProvinceName,
cr.CountryRegionCode,
cr.Name AS CountryName
FROM ADV.Person.Person AS p
JOIN ADV.HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID
JOIN ADV.HumanResources.EmployeeDepartmentHistory as ed ON e.BusinessEntityID = ed.BusinessEntityID
JOIN ADV.HumanResources.Department as d ON ed.DepartmentID = d.DepartmentID
JOIN ADV.Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN ADV.Person.Address as a ON bea.AddressID = a.AddressID
JOIN ADV.Person.StateProvince as sp ON a.StateProvinceID = sp.StateProvinceID
JOIN ADV.Person.CountryRegion as cr ON sp.CountryRegionCode = cr.CountryRegionCode


CREATE VIEW Gender_Numbers 
AS
SELECT Gender, COUNT(Gender) AS number_of_male_female
FROM dbo.EmployeeDesc
GROUP BY Gender;

CREATE VIEW Marital_Status_Numbers
AS
SELECT
MaritalStatus, COUNT(MaritalStatus) AS Marital_Status_Num
FROM dbo.EmployeeDesc
GROUP BY MaritalStatus;

CREATE VIEW Department_Numbers
AS
SELECT 
Department_Name, COUNT(Department_Name) AS Num_of_departments
FROM dbo.EmployeeDesc
GROUP BY Department_Name;

CREATE VIEW NumOfPeopleInCountry
AS
SELECT
CountryName, COUNT(CountryName) AS NumOfPeopleInCountry
FROM dbo.EmployeeDesc
GROUP BY CountryName;

CREATE VIEW EmployeeBirthYear
AS
SELECT 
BirthdayYear, COUNT(BirthdayYear) AS CountBirthYear
FROM dbo.EmployeeDesc
GROUP BY BirthdayYear;

CREATE VIEW EmployeeHireYear
AS
SELECT 
HireYear, COUNT(HireYear) AS CountHireYear
FROM dbo.EmployeeDesc
GROUP BY HireYear;