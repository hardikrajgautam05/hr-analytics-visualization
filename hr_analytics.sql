CREATE DATABASE project_hr;

USE project_hr;

SELECT * FROM hr;

CREATE TABLE hr_staging
LIKE hr;

INSERT INTO hr_staging
SELECT *
FROM hr;

SELECT * FROM hr_staging;

-- data cleaning and preprocessing

ALTER TABLE hr_staging
CHANGE COLUMN ï»¿id emp_id VARCHAR (20) NULL;

DESCRIBE hr_staging;

SELECT birthdate,
CASE
WHEN birthdate LIKE'%/%' THEN str_to_date(birthdate, '%m/%d/%Y')
WHEN birthdate LIKE '%-%' THEN str_to_date(birthdate, '%m-%d-%Y')
ELSE NULL
END AS dob
FROM hr_staging;

UPDATE hr_staging
SET birthdate = CASE
WHEN birthdate LIKE'%/%' THEN str_to_date(birthdate, '%m/%d/%Y')
WHEN birthdate LIKE '%-%' THEN str_to_date(birthdate, '%m-%d-%Y')
ELSE NULL
END;

ALTER TABLE hr_staging
MODIFY COLUMN birthdate DATE NULL;

UPDATE hr_staging
SET hire_date = CASE
WHEN hire_date LIKE'%/%' THEN str_to_date(hire_date, '%m/%d/%Y')
WHEN hire_date LIKE '%-%' THEN str_to_date(hire_date, '%m-%d-%Y')
ELSE NULL
END;

ALTER TABLE hr_staging
MODIFY COLUMN hire_date DATE NULL;

SELECT termdate, str_to_date(NULLIF(TRIM(REPLACE(termdate, 'UTC','')),''),'%Y-%m-%d %H:%i:%s')
FROM hr_staging;

UPDATE hr_staging
SET termdate = str_to_date(NULLIF(TRIM(REPLACE(termdate,'UTC','')),''),'%Y-%m-%d %H:%i:%s')
WHERE termdate IS NOT NULL;

ALTER TABLE hr_staging
MODIFY COLUMN termdate DATETIME NULL;

-- create age column 

ALTER TABLE hr_staging
ADD COLUMN age INT;

UPDATE hr_staging
SET age = timestampdiff(YEAR,birthdate,curdate());

SELECT min(age),max(age)
FROM hr_staging;

SELECT *
FROM hr_staging
WHERE termdate >= curdate();

-- Exploratory Data Analysis

-- 1. What is the gender breakdown of employees in the company?

SELECT gender, COUNT(*)
FROM hr_staging
WHERE termdate IS NULL
GROUP BY gender;

-- 2. What is the race breakdown of employees in the company?

SELECT race, Count(*)
FROM hr_staging
WHERE termdate IS NULL 
GROUP BY race;

-- 3. What is the age distribution of the employees in the company?

WITH age_data AS (
SELECT 
CASE
WHEN age>=20 AND age<=24 THEN '20-24'
WHEN age>=25 AND age<=34 THEN '25-34'
WHEN age>=35 AND age<=44 THEN '35-44'
WHEN age>=45 AND age<=54 THEN '45-54'
WHEN age>=55 AND age<=64 THEN '55-64'
ELSE '65+'
END AS age_group
FROM hr_staging
WHERE termdate IS NULL)

SELECT age_group, COUNT(*) AS count
FROM age_data
GROUP BY age_group
ORDER BY age_group;

-- 4 How many employees work at HQ vs Remote?

SELECT location, Count(*) AS count
FROM hr_staging
WHERE termdate IS NULL
GROUP BY location
ORDER BY count DESC;

-- 5. What is the average length of employement who have been terminated?
SELECT ROUND(AVG(timestampdiff(YEAR,hire_date,termdate))) AS length_of_employement
FROM hr_staging
WHERE termdate IS NOT NULL AND termdate <= curdate();

-- 6. How does the gender distribution vary across dept. and job titles?
SELECT * FROM hr_staging;

SELECT department,jobtitle,gender,Count(*)
FROM hr_staging
WHERE termdate IS NULL
GROUP BY department,jobtitle,gender
ORDER BY department,jobtitle,gender;

SELECT department,gender,Count(*)
FROM hr_staging
WHERE termdate IS NULL
GROUP BY department,gender
ORDER BY department,gender;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle,Count(*)
FROM hr_staging
WHERE termdate IS NULL
GROUP BY jobtitle;

-- 8. Which dept. has the highest turnover/termination rate?

SELECT * FROM hr_staging;

SELECT department,
COUNT(*) AS total_count,
COUNT(CASE
WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1
END) AS terminated_count,
ROUND((COUNT( CASE
WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1
END)/Count(*))*100,2) AS termination_rate
FROM hr_staging
GROUP BY department 
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across location_state

SELECT location_state, COUNT(*) AS count
FROM hr_staging
WHERE termdate IS NULL
GROUP BY location_state;

-- 10. How has the companies employee count changed over time based on hire and termination date

SELECT * FROM hr_staging;

SELECT
YEAR(termdate) AS year, COUNT(*) AS terminations
FROM hr_staging WHERE termdate IS NOT NULL
GROUP BY YEAR(termdate)
ORDER BY year;

SELECT 
YEAR(hire_date) AS year, COUNT(*) AS hires
FROM hr_staging
GROUP BY YEAR(hire_date)
ORDER BY year;

SELECT h.year, h.hires, COALESCE(t.terminations,0) AS terminations,
h.hires-COALESCE(t.terminations,0) AS net_change,
ROUND((COALESCE(t.terminations,0)/h.hires)*100.0,2) AS termination_to_hire_percent
FROM(
SELECT 
YEAR(hire_date) AS year, COUNT(*) AS hires
FROM hr_staging
GROUP BY YEAR(hire_date)
) h
LEFT JOIN
(SELECT
YEAR(termdate) AS year, COUNT(*) AS terminations
FROM hr_staging WHERE termdate IS NOT NULL
GROUP BY YEAR(termdate)
) t
ON h.year=t.year
ORDER BY h.year;

CREATE VIEW hiring_trends AS
SELECT h.year, h.hires, COALESCE(t.terminations,0) AS terminations,
h.hires-COALESCE(t.terminations,0) AS net_change,
ROUND((COALESCE(t.terminations,0)/h.hires)*100.0,2) AS termination_to_hire_percent
FROM(
    SELECT YEAR(hire_date) AS year, COUNT(*) AS hires
    FROM hr_staging
    GROUP BY YEAR(hire_date)
) h
LEFT JOIN(
    SELECT YEAR(termdate) AS year, COUNT(*) AS terminations
    FROM hr_staging WHERE termdate IS NOT NULL
    GROUP BY YEAR(termdate)
) t
ON h.year = t.year
ORDER BY h.year;

-- 11. What is the tenure distribution for each dept.

SELECT department, Round(Avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr_staging
WHERE termdate IS NOT NULL AND termdate <= curdate()
GROUP BY department;