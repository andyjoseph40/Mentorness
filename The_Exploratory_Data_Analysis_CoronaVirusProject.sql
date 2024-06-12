-- Exploratory Data Analysis

SELECT *
FROM corvir_staging

-- Q1. Write a code to check NULL values and Q2. If NULL values are present, update them with zeros for all columns.

-- Question 1 & 2 has been done already during the cleaning process.

-- Q3. check total number of rows

SELECT COUNT(*) AS total_rows
FROM corvir_staging;

-- Q4. Check what is start_date and end_date
SELECT 
    MIN([date]) AS [start_date], 
    MAX([date]) AS end_date
FROM corvir_staging;



-- Q5. Number of month present in dataset
SELECT COUNT(DISTINCT YEAR([date]) * 100 + MONTH([date])) AS number_of_months
FROM corvir_staging;



-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT YEAR([Date]) AS [year],
		MONTH([Date]) AS [month],
		AVG(Confirmed) AS avg_confirmed, 
		AVG(Deaths) AS avg_deaths, 
		AVG(Recovered) AS avg_recovered
FROM corvir_staging
GROUP BY YEAR([Date]), MONTH([Date])
ORDER BY [year], [month]



-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
-- Using CTE common table expression
WITH MonthlyCounts AS (
    SELECT 
        YEAR([date]) AS year,
        MONTH([date]) AS month,
        Confirmed,
        Deaths,
        Recovered,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR([date]), MONTH([date]) 
            ORDER BY COUNT(*) DESC, Confirmed, Deaths, Recovered
        ) AS rn
    FROM corvir_staging
    GROUP BY YEAR([date]), MONTH([date]), Confirmed, Deaths, Recovered
)
SELECT 
    year,
    month,
    Confirmed AS most_frequent_confirmed,
    Deaths AS most_frequent_deaths,
    Recovered AS most_frequent_recovered
FROM MonthlyCounts
WHERE rn = 1
ORDER BY year, month;


-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
    YEAR([date]) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM corvir_staging
GROUP BY YEAR([date])
ORDER BY year;


-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR([date]) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM corvir_staging
GROUP BY YEAR([date])
ORDER BY year;


-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    YEAR([date]) AS year,
    MONTH([date]) AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM corvir_staging
GROUP BY YEAR([date]), MONTH([date])
ORDER BY year, month;


-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(Confirmed) AS total_confirmed,
    AVG(Confirmed) AS average_confirmed,
    VAR(Confirmed) AS variance_confirmed,
    STDEV(Confirmed) AS stdev_confirmed
FROM corvir_staging;


-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
	YEAR([Date]) [year],
	MONTH([Date]) [month],
    SUM(Confirmed) AS total_deaths,
    AVG(Confirmed) AS average_deaths,
    VAR(Confirmed) AS variance_deaths,
    STDEV(Confirmed) AS stdev_deaths
FROM corvir_staging
GROUP BY YEAR([Date]), MONTH([Date])
ORDER BY year, month


-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(Recovered) AS total_recovered,
    AVG(Recovered) AS average_recovered,
    VAR(Recovered) AS variance_recovered,
    STDEV(Recovered) AS stdev_recovered
FROM corvir_staging;


-- Q14. Find Country having highest number of the Confirmed case
SELECT Country_Region, 
		SUM(Confirmed) AS total_confirmed
FROM corvir_staging
GROUP BY Country_Region
ORDER BY total_confirmed DESC


-- Q15. Find Country having lowest number of the death case
SELECT Country_Region, 
		SUM(Deaths) AS total_deaths
FROM corvir_staging
GROUP BY Country_Region
ORDER BY total_deaths 


-- Q16. Find top 5 countries having highest recovered case
SELECT Country_Region, 
		SUM(Recovered) AS total_recovered
FROM corvir_staging
GROUP BY Country_Region
ORDER BY total_recovered DESC

