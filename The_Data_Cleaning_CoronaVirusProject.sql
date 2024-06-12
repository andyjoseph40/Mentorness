
-- Data Cleaning

CREATE DATABASE Corona_Virus_Dataset
USE Corona_Virus_Dataset

SELECT * 
FROM dbo.[Corona Virus Dataset]

EXEC sp_rename 'dbo.Corona Virus Dataset', 'CoronaVirusDataset'

SELECT *
FROM dbo.CoronaVirusDataset

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank values
-- 4. Remove Any Columns


-- Step 1: Create the corvir_staging table with the same structure as dbo.CoronaVirusDataset
SELECT TOP 0 *
INTO corvir_staging
FROM dbo.CoronaVirusDataset;

-- Step 2: Insert the data into corvir_staging from dbo.CoronaVirusDataset
INSERT INTO corvir_staging
SELECT *
FROM dbo.CoronaVirusDataset;


-- Verify the contents of corvir_staging
SELECT *
FROM corvir_staging;


-- 1. Removing Duplicates
SELECT *,
ROW_NUMBER() OVER (
		PARTITION BY Province, Country_Region, Latitude, Longitude, [Date], Confirmed, Deaths, Recovered
		ORDER BY (SELECT NULL)
			) AS row_num
FROM corvir_staging

-- Using CTE (common table expressions) or subquery to check for ro_num above 1

WITH duplicate_cte AS 
(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY Province, Country_Region, Latitude, Longitude, [date], Confirmed, Deaths, Recovered
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM corvir_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Based on the query, no duplicate was observed.

-- 2. Standardizing Data

SELECT *
FROM corvir_staging

SELECT DISTINCT (Province)
FROM corvir_staging
ORDER BY Province;

-- Update the row Taiwan which was spelt as Taiwan*
UPDATE corvir_staging
SET Province = 'Taiwan'
WHERE Province = 'Taiwan*';

SELECT DISTINCT Province
FROM corvir_staging
ORDER BY Province;

-- Checking other columns like the Country_Region and Date Column
SELECT DISTINCT Country_Region
FROM corvir_staging
ORDER BY Country_Region;


UPDATE corvir_staging
SET Country_Region = 'Taiwan'
WHERE Country_Region = 'Taiwan*';

SELECT DISTINCT Country_Region
FROM corvir_staging
ORDER BY Country_Region;


SELECT *
FROM corvir_staging


SELECT [Date],
	TRY_CONVERT(DATE, [Date], 101) AS formatted_date
FROM corvir_staging;

UPDATE corvir_staging
SET [Date] =  TRY_CONVERT(DATE, [Date], 101)

SELECT *
FROM corvir_staging

-- Step 3: Handling NULL and BLANK rows/values
SELECT *
FROM corvir_staging
WHERE Latitude IS NULL
AND Longitude is NULL;

-- Updating the NULL values with 0

UPDATE corvir_staging
SET Latitude = 0, Longitude = 0
WHERE Latitude IS NULL AND Longitude IS NULL;

SELECT *
FROM corvir_staging
WHERE Latitude IS NULL AND Longitude IS NULL;



-- Null values has been handled

-- Now we have a cleaned data, we can go on to analyse the cleaned data.


SELECT *
FROM corvir_staging

