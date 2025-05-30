SELECT * FROM TelcoCustomerChur

-- What is the overall churn rate?
SELECT COUNT(*) AS total_customers, SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS ChurnRatePercent
FROM TelcoCustomerChur;
 
 -- How many customers are active vs churned?
 SELECT Churn,COUNT(*) AS CustomerCount
FROM TelcoCustomerChur
GROUP BY Churn;

-- How many customers are in each contract type (Month-to-month, One year, Two year)?
SELECT Contract, Count(*) AS CustomerCount
FROM TelcoCustomerChur
GROUP BY Contract

-- Which gender has a higher churn rate?
SELECT gender, Count(*) AS CustomerCount,
ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS ChurnRatePercent
FROM TelcoCustomerChur
GROUP BY gender
ORDER BY ChurnRatePercent DESC

-- Do senior citizens churn more often than younger customers?
SELECT CASE
    WHEN SeniorCitizen = 1 THEN 'Senior'
    ELSE 'Young Customer'
    END AS CustomerType,
    SeniorCitizen,
ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS ChurnRatePercent
FROM TelcoCustomerChur
GROUP BY SeniorCitizen;

-- How does churn vary by customer tenure (e.g., <12 months, 12–24, >24)?

WITH tenure_groups AS (
  SELECT CASE 
      WHEN tenure < 12 THEN '<12 months'
      WHEN tenure BETWEEN 12 AND 24 THEN '12-24 months'
      ELSE '>24 months'
    END AS tenure_group,
    Churn
  FROM TelcoCustomerChur
)
SELECT tenure_group, COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
  ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM tenure_groups
GROUP BY tenure_group

-- What is the churn rate by customer type: single vs married?
SELECT CASE
    WHEN Partner = 'Yes' THEN 'Has Partner'
    ELSE 'Single'
    END AS CustomerType,
Count(Partner) AS TotalCustomer,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM TelcoCustomerChur
GROUP BY Partner

-- Which payment methods have the highest churn rate?
SELECT PaymentMethod,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM TelcoCustomerChur
GROUP BY PaymentMethod

-- Do customers with paperless billing churn more than those with mailed bills?
SELECT PaperlessBilling,
COUNT(*) AS TotalCustomer,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM TelcoCustomerChur
GROUP BY PaperlessBilling

-- Does having internet service affect churn?
SELECT InternetService,
COUNT(*) AS TotalCustomer,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM TelcoCustomerChur
GROUP BY InternetService

-- Which internet service type (DSL, Fiber optic, None) has the highest churn?
SELECT InternetService,
COUNT(*) AS TotalCustomer,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM TelcoCustomerChur
GROUP BY InternetService
ORDER BY ChurnRatePercent DESC

-- Do customers with multiple add-on services (streaming, backup, tech support) churn more?
SELECT add_on_count,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM (
SELECT customerID,
        -- Count how many of these services are "Yes" for each customer
        (
            (CASE WHEN StreamingTV = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN StreamingMovies = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END)
        ) AS add_on_count,
        churn
    FROM TelcoCustomerChur
) AS addons_summary
GROUP BY add_on_count
ORDER BY add_on_count;

-- What is the churn rate for customers with vs. without phone service?
SELECT CASE
WHEN PhoneService = 'Yes' THEN 'Enable' ELSE 'Disable' END
AS PhoneServiceUsage,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM TelcoCustomerChur;

-- Does tenure (length of stay) impact churn?
WITH CustomerWithBucket AS (
    SELECT 
        *,
        CASE 
            WHEN tenure < 12 THEN 'New (<12 months)'
            WHEN tenure BETWEEN 12 AND 24 THEN 'Mid-term (12–24 months)'
            ELSE 'Loyal (>24 months)'
        END AS tenure_bucket
    FROM TelcoCustomerChur
)
SELECT tenure_bucket,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM CustomerWithBucket
GROUP BY tenure_bucket
ORDER BY MIN(tenure);

-- What’s the average tenure of churned customers vs retained ones?

SELECT 
    CASE WHEN Churn = 'Yes' THEN 'Churned' ELSE 'Retained' END AS customer_status,
    COUNT(*) AS customer_count,
    ROUND(AVG(tenure), 2) AS average_tenure_months,
    ROUND(MIN(tenure), 2) AS min_tenure,
    ROUND(MAX(tenure), 2) AS max_tenure
FROM TelcoCustomerChur
GROUP BY Churn
