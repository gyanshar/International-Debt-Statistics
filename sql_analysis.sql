CREATE DATABASE debt_stats;
USE debt_stats;

-- Loading the dataset

CREATE TABLE IDS_ALLCountries_Data (
	Country_Name VARCHAR(50),
	Country_Code VARCHAR(3),	
	Counterpart_Area_Name VARCHAR(5),	
	Counterpart_Area_Code VARCHAR(3),
	Series_Name	VARCHAR(100),
	Series_Code VARCHAR(19),	
	`1970` DECIMAL(40,10),	
	`1971` DECIMAL(40,10),	
	`1972` DECIMAL(40,10),	
	`1973` DECIMAL(40,10),	
	`1974` DECIMAL(40,10),
	`1975` DECIMAL(40,10),	
	`1976` DECIMAL(40,10),	
	`1977` DECIMAL(40,10),	
	`1978` DECIMAL(40,10),	
	`1979` DECIMAL(40,10),	
	`1980` DECIMAL(40,10),	
	`1981` DECIMAL(40,10),	
	`1982` DECIMAL(40,10),	
	`1983` DECIMAL(40,10),
	`1984` DECIMAL(40,10),
	`1985` DECIMAL(40,10),
	`1986` DECIMAL(40,10),
	`1987` DECIMAL(40,10),
	`1988` DECIMAL(40,10),	
	`1989` DECIMAL(40,10),
	`1990` DECIMAL(40,10),
	`1991` DECIMAL(40,10),	
	`1992` DECIMAL(40,10),
	`1993` DECIMAL(40,10),	
	`1994` DECIMAL(40,10),
	`1995` DECIMAL(40,10),	
	`1996` DECIMAL(40,10),	
	`1997` DECIMAL(40,10),	
	`1998` DECIMAL(40,10),	
	`1999` DECIMAL(40,10),	
	`2000` DECIMAL(40,10),	
	`2001` DECIMAL(40,10),	
	`2002` DECIMAL(40,10),	
	`2003` DECIMAL(40,10),	
	`2004` DECIMAL(40,10),	
	`2005` DECIMAL(40,10),	
	`2006` DECIMAL(40,10),	
	`2007` DECIMAL(40,10),	
	`2008` DECIMAL(40,10),	
	`2009` DECIMAL(40,10),	
	`2010` DECIMAL(40,10),	
	`2011` DECIMAL(40,10),	
	`2012` DECIMAL(40,10),	
	`2013` DECIMAL(40,10),	
	`2014` DECIMAL(40,10),	
	`2015` DECIMAL(40,10),	
	`2016` DECIMAL(40,10),
	`2017` DECIMAL(40,10),
	`2018` DECIMAL(40,10),
	`2019` DECIMAL(40,10),
	`2020` DECIMAL(40,10),
	`2021` DECIMAL(40,10),
	`2022` DECIMAL(40,10),
	`2023` DECIMAL(40,10),	
	`2024` DECIMAL(40,10),	
	`2025` DECIMAL(40,10),	
	`2026` DECIMAL(40,10),	
	`2027` DECIMAL(40,10),	
	`2028` DECIMAL(40,10),	
	`2029` DECIMAL(40,10),
	`2030` DECIMAL(40,10)
);

LOAD DATA LOCAL INFILE "D:/Projects/International_Debt_Statistics_Analysis/IDS_ALLCountries_Data.csv"
INTO TABLE IDS_ALLCountries_Data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM IDS_ALLCountries_Data;

-- Creating a Table for Debt

CREATE TABLE international_debt
AS 
SELECT Country_Name, Country_Code, Series_Code, Series_Name,
		(`1971`+`1972`+`1973`+`1974`+`1975`+`1976`+`1977`+`1978`+`1979`+`1980`+
		`1981`+`1982`+`1983`+`1984`+`1985`+`1986`+`1987`+`1988`+`1989`+`1990`+
        `1991`+`1992`+`1993`+`1994`+`1995`+`1996`+`1997`+`1998`+`1999`+`2000`+
        `2001`+`2002`+`2003`+`2004`+`2005`+`2006`+`2007`+`2008`+`2009`+`2010`+
        `2011`+`2012`+`2013`+`2014`+`2015`+`2016`+`2017`+`2018`+`2019`+`2020`+
        `2021`+`2022`+`2023`) AS Debt
FROM IDS_ALLCountries_Data
WHERE Country_Name NOT LIKE '%income%' AND LOWER(Country_Name) NOT LIKE '%ida%';

SELECT * FROM international_debt;

-- Cleaning Data

WITH CTE AS (
	SELECT * 
	FROM international_debt
	WHERE Country_Name LIKE '%Date%' OR Country_Name LIKE 'Data%' OR Country_Name LIKE ''
	)
DELETE FROM international_debt
WHERE Country_Name in (SELECT Country_Name FROM CTE);
  
SELECT * FROM international_debt;


-- Queries
-- 1. Number of Countries

SELECT COUNT(DISTINCT Country_Code) AS distinct_countriescode_count
FROM international_debt;

SELECT COUNT(DISTINCT Country_Name) AS distinct_countries_count
FROM international_debt;


-- 2. Total Debt by Country

SELECT Country_Name, SUM(Debt) 
FROM international_debt
GROUP BY Country_Name;


-- 3. Top 5 countries with Highest Debt

SELECT Country_Name, ROUND(SUM(Debt),3)
FROM international_debt
GROUP BY Country_Name
ORDER BY SUM(Debt) DESC
LIMIT 6;


-- 4. Top Country with Highest Debt

SELECT Country_Name, ROUND(SUM(Debt),3) AS Total_Debt
FROM international_debt
GROUP BY Country_Name
ORDER BY SUM(Debt) DESC
LIMIT 1;


-- 5. Average Debt Per Country

SELECT Country_Name, ROUND(AVG(Debt),3) AS Average_Debt
FROM international_debt
GROUP BY Country_Name;
