CREATE DATABASE hr_workforce_analytics;

USE hr_workforce_analytics;

CREATE TABLE employees (
    Employee_ID VARCHAR(10) PRIMARY KEY,
    Age INT,
    Gender VARCHAR(20),
    Department VARCHAR(50),
    Job_Role VARCHAR(50),
    Location VARCHAR(50),
    Education VARCHAR(50),
    Hire_Date DATE,
    Monthly_Salary_INR DECIMAL(10,2),
    Total_Experience_Years DECIMAL(4,1),
    Employment_Type VARCHAR(20),
    Overtime VARCHAR(5),
    Job_Satisfaction INT,
    Work_Life_Balance INT,
    Performance_Rating INT,
    Training_Hours_Last_Year INT,
    Years_Since_Last_Promotion INT,
    Absence_Days_Last_Year INT,
    Commute_Distance_KM INT,
    Exit_Date DATE,
    Attrition VARCHAR(5)
);

SHOW TABLES;

DESCRIBE employees;

SELECT COUNT(*) AS Total_Employees
FROM employees;

SELECT 
    MIN(Employee_ID) AS First_ID,
    MAX(Employee_ID) AS Last_ID,
    COUNT(*) AS Total_Rows
FROM employees;

SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    SUM(CASE WHEN Exit_Date IS NULL THEN 1 ELSE 0 END) AS Blank_Exit_Date
FROM employees;

TRUNCATE TABLE employees;
SELECT COUNT(*) AS Total_Employees
FROM employees;

ALTER TABLE employees
MODIFY Exit_Date VARCHAR(20);

SELECT COUNT(*) AS Total_Employees
FROM employees;

TRUNCATE TABLE employees;

ALTER TABLE employees
MODIFY Job_Satisfaction VARCHAR(10);

-- Convert blank Exit_Date values to NULL
UPDATE employees
SET Exit_Date = NULL
WHERE Exit_Date = '';

-- Convert blank Job_Satisfaction values to NULL
UPDATE employees
SET Job_Satisfaction = NULL
WHERE Job_Satisfaction = '';

-- Convert Exit_Date back to DATE datatype
ALTER TABLE employees
MODIFY Exit_Date DATE;

-- Convert Job_Satisfaction back to INT datatype
ALTER TABLE employees
MODIFY Job_Satisfaction INT;

-- Validate total number of employee records
SELECT COUNT(*) AS Total_Employees
FROM employees;

-- Validate employee count by attrition status
SELECT
    Attrition,
    COUNT(*) AS Employee_Count
FROM employees
GROUP BY Attrition;

-- Validate missing values retained during data cleaning
SELECT
    SUM(CASE WHEN Job_Satisfaction IS NULL THEN 1 ELSE 0 END) AS Missing_Job_Satisfaction,
    SUM(CASE WHEN Exit_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Exit_Date
FROM employees;


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- SQL Analysis 1 — Overall Attrition Rate
-- Calculate the overall employee attrition rate

SELECT
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees;


-- SQL Analysis 2 — Department-wise Attrition Rate
-- Calculate attrition rate for each department

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Department
ORDER BY Attrition_Rate_Percent DESC;

-- SQL Analysis 3 — Overtime vs Attrition:
-- Analyze the relationship between overtime and employee attrition

SELECT
    Overtime,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Overtime
ORDER BY Attrition_Rate_Percent DESC;

-- SQL Analysis 4 — Job Satisfaction vs Attrition
-- Analyze attrition rate across job satisfaction levels

SELECT
    Job_Satisfaction,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
WHERE Job_Satisfaction IS NOT NULL
GROUP BY Job_Satisfaction
ORDER BY Job_Satisfaction;

-- SQL Analysis 5 — Employment Type vs Attrition
-- Compare attrition rates across different employment types

SELECT
    Employment_Type,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Employment_Type
ORDER BY Attrition_Rate_Percent DESC;

-- SQL Analysis 6 — Average Salary: Stayed vs Left
-- Compare average monthly salary of employees who stayed versus those who left

SELECT
    Attrition,
    COUNT(*) AS Total_Employees,
    ROUND(AVG(Monthly_Salary_INR), 2) AS Average_Monthly_Salary
FROM employees
GROUP BY Attrition;

-- SQL Analysis 7 — Work-Life Balance vs Attrition
-- Analyze attrition rate across work-life balance ratings

SELECT
    Work_Life_Balance,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Work_Life_Balance
ORDER BY Work_Life_Balance;

-- SQL Analysis 8 — Commute Distance
-- Analyze attrition across different commute distance groups

SELECT
    CASE
        WHEN Commute_Distance_KM <= 10 THEN '0-10 KM'
        WHEN Commute_Distance_KM <= 25 THEN '11-25 KM'
        ELSE '26+ KM'
    END AS Commute_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Commute_Group
ORDER BY MIN(Commute_Distance_KM);

-- SQL Analysis 9 — Experience Level vs Attrition
-- Analyze attrition across employee experience levels

SELECT
    CASE
        WHEN Total_Experience_Years < 3 THEN 'Less than 3 Years'
        WHEN Total_Experience_Years < 7 THEN '3-6 Years'
        WHEN Total_Experience_Years < 12 THEN '7-11 Years'
        ELSE '12+ Years'
    END AS Experience_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Experience_Group
ORDER BY MIN(Total_Experience_Years);

-- SQL Analysis 10 — Years Since Last Promotion
-- Analyze attrition based on years since last promotion

SELECT
    CASE
        WHEN Years_Since_Last_Promotion <= 2 THEN '0-2 Years'
        WHEN Years_Since_Last_Promotion <= 5 THEN '3-5 Years'
        ELSE '6+ Years'
    END AS Promotion_Gap,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Promotion_Gap
ORDER BY MIN(Years_Since_Last_Promotion);

-- SQL Analysis 11 — Age Group vs Attrition
-- Analyze attrition across different employee age groups

SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age < 35 THEN '30-34'
        WHEN Age < 40 THEN '35-39'
        WHEN Age < 45 THEN '40-44'
        ELSE '45+'
    END AS Age_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Age_Group
ORDER BY MIN(Age);

-- SQL Analysis 12 — Job Role vs Attrition
-- Analyze attrition rate across different job roles

SELECT
    Job_Role,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Job_Role
ORDER BY Attrition_Rate_Percent DESC;

-- SQL Analysis 13 — Overtime + Job Satisfaction
-- Analyze the combined effect of overtime and job satisfaction on attrition

SELECT
    Overtime,
    Job_Satisfaction,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
WHERE Job_Satisfaction IS NOT NULL
GROUP BY Overtime, Job_Satisfaction
ORDER BY Overtime, Job_Satisfaction;