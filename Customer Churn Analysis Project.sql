CREATE DATABASE IF NOT EXISTS telco_db;
USE telco_db;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_telco_data.csv'
INTO TABLE telco_churn
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 1. BASIC SQL QUERIES 

-- 1. View all data
SELECT * FROM telco_churn;

-- 2. Count total records
SELECT COUNT(*) AS total_customers FROM telco_churn;

-- 3. View Unique Values in Churn
SELECT DISTINCT Churn FROM telco_churn;

-- 4. Count Churned vs Non-Churned Customers
SELECT Churn, COUNT(*) AS total FROM telco_churn
GROUP BY Churn;

-- 5. Gender Distribution
SELECT gender, COUNT(*) AS total FROM telco_churn
GROUP BY gender;

-- 6. Customers with Internet Service = 'Fiber optic'
SELECT * FROM telco_churn
WHERE InternetService = 'Fiber optic';

-- 7. Average Monthly Charges by Contract Type
SELECT Contract, AVG(MonthlyCharges) AS avg_monthly_charge
FROM telco_churn
GROUP BY Contract;

-- 8. Total Churn by Internet Service Type
SELECT InternetService, COUNT(*) AS churn_count
FROM telco_churn
WHERE Churn = 'Yes'
GROUP BY InternetService;

-- 9. Customers Who Have Both Partner and Dependents
SELECT * FROM telco_churn
WHERE Partner = 'Yes' AND Dependents = 'Yes';

-- 10. Top 10 Highest Paying Customers

SELECT customerID, MonthlyCharges, TotalCharges
FROM telco_churn
ORDER BY MonthlyCharges DESC
LIMIT 10;

-- 11. Count of Customers by Tenure Group (e.g. 0-12, 13-24 months)
SELECT 
  CASE 
    WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
    WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
    WHEN tenure BETWEEN 25 AND 36 THEN '25-36 months'
    WHEN tenure BETWEEN 37 AND 48 THEN '37-48 months'
    WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months'
    ELSE '60+ months'
  END AS tenure_group,
  COUNT(*) AS customer_count
FROM telco_churn
GROUP BY tenure_group;

-- 12 . Find Customers with the Highest and Lowest Total Charges
SELECT customerID, TotalCharges
FROM telco_churn
WHERE TotalCharges = (SELECT MAX(TotalCharges) FROM telco_churn)
   OR TotalCharges = (SELECT MIN(TotalCharges) FROM telco_churn);

-- 13. Customers Who Have Churned and Did Not Pay Their Final Bill
SELECT customerID, Churn, TotalCharges
FROM telco_churn
WHERE Churn = 'Yes' AND TotalCharges = 0;

-- 14. Customers Who Have a Specific Combination of Services (Multiple Conditions)
SELECT customerID, InternetService, OnlineSecurity
FROM telco_churn
WHERE InternetService = 'Fiber optic' AND OnlineSecurity = 'Yes';

-- 15 . Window Functions
-- 15.1  Ranking Customers by Monthly Charges
SELECT customerID, MonthlyCharges, 
       ROW_NUMBER() OVER (ORDER BY MonthlyCharges DESC) AS customer_rank
FROM telco_churn;

-- 15.2. Running Total of Total Charges by Customer
SELECT customerID, TotalCharges,
       SUM(TotalCharges) OVER (ORDER BY customerID) AS running_total
FROM telco_churn;

-- 15.3 Find the Average Monthly Charges for Each Customer's Contract Type
SELECT customerID, Contract, MonthlyCharges,
       AVG(MonthlyCharges) OVER (PARTITION BY Contract) AS avg_contract_charge
FROM telco_churn;














