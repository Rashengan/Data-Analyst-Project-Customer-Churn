Analyze customer churn patterns using SQL with the Kaggle Telco dataset. 
This project explores key drivers of churn, including tenure, contract type, internet service, and add-on features. 
Insights are derived using SQL queries and Common Table Expressions (CTEs) to segment and compare customer groups.

Objectives:
Analyze customer churn by demographic and service usage factors,
Identify which contract types or payment methods have higher churn rates,
Understand how tenure and monthly charges influence customer behavior,
Calculate churn rates by customer segments,
Prepare the data for possible integration into BI tools or ML pipelines

Dataset:
Source: Kaggle: Telco Customer Churn,
Size: ~7,000 customer records,
Fields: Gender, SeniorCitizen, Tenure, InternetService, Contract, MonthlyCharges, Churn, etc.

Key Questions Answered in SQL:
What is the overall churn rate?
Which contract types or payment methods have the highest churn?
Do long-tenure customers churn less?
Does monthly charge amount affect churn?
Which customer segments are most at risk?

🧠 SQL Techniques Used:
CASE WHEN for classification and flagging
Aggregation (COUNT, AVG, SUM)
Grouping (GROUP BY)
Subqueries and Common Table Expressions (CTEs)

