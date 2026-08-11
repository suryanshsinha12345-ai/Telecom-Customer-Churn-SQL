<img width="907" height="504" alt="image" src="https://github.com/user-attachments/assets/c7f82264-9b5d-4b80-811f-1287698ba5d9" />

# 📞 Telecom Customer Churn Analysis | SQL

## 📊 Project Overview

This project analyzes **customer churn in a telecommunications business using PostgreSQL/SQL**.

The objective is to identify customer segments and service characteristics associated with higher churn and translate the analysis into actionable business insights that can support **customer retention and churn-reduction strategies**.

The analysis uses SQL to explore customer demographics, contracts, tenure, charges, payment methods, internet and phone services, and customer segments.

<img width="907" height="504" alt="image" src="https://github.com/user-attachments/assets/c7f82264-9b5d-4b80-811f-1287698ba5d9" />

---

## 🎯 Business Problem

Customer churn is a major challenge for subscription-based businesses because acquiring a new customer can be more expensive than retaining an existing one.

The key business question for this analysis is:

> **Which customer characteristics and service patterns are associated with higher churn, and what actions could the business take to improve customer retention?**

---

## 🎯 Business Objectives

The analysis aims to answer the following questions:

* What percentage of customers have churned?
* Which customer demographics have higher churn?
* Which contract types have the highest churn?
* How does customer tenure relate to churn?
* Does monthly charge level affect churn?
* Which payment methods are associated with higher churn?
* Do internet and phone services influence churn?
* Which customer segments are most at risk?
* What characteristics are common among churned customers?
* What retention strategies could reduce customer churn?

---

## 📂 Dataset

The project uses customer-level telecommunications data containing information about:

### Customer Information

* Customer ID
* Gender
* Senior Citizen status
* Partner status
* Dependents

### Account Information

* Tenure
* Contract type
* Payment method
* Paperless billing
* Monthly charges
* Total charges

### Services

* Phone service
* Multiple lines
* Internet service
* Online security
* Online backup
* Device protection
* Tech support
* Streaming TV
* Streaming movies

### Target Variable

* **Churn** — whether the customer left the company

---

## 🧹 Data Preparation

Before performing the analysis, the dataset was prepared for SQL-based analysis.

Key preparation activities included:

* Checking column data types
* Identifying missing or inconsistent values
* Validating customer records
* Preparing numerical fields for aggregation
* Standardizing categorical values
* Ensuring the churn field was suitable for segmentation
* Preparing the dataset for analytical queries

---

# 🔍 SQL Analysis

The project uses SQL to investigate churn across multiple dimensions.

---

## 👥 1. Customer Demographics

Customer churn was analyzed across demographic attributes such as:

* Gender
* Senior Citizen status
* Partner status
* Dependents

The analysis helps identify whether particular demographic segments experience disproportionately high churn.

---

## 📉 2. Overall Churn Analysis

The first step is to establish the overall churn level.

The analysis calculates:

* Total customers
* Churned customers
* Active customers
* Overall churn rate

Example:

```sql
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN churn = 'No' THEN 1 ELSE 0 END) AS active_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customers;
```

This establishes the baseline against which different customer segments can be compared.

---

## 📑 3. Contract Analysis

Customers were segmented according to their contract type.

The analysis compares churn across:

* Month-to-month contracts
* One-year contracts
* Two-year contracts

Example:

```sql
SELECT
    contract,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY contract
ORDER BY churn_rate DESC;
```

### Business Question

> Are customers with shorter contract commitments more likely to churn?

---

## ⏳ 4. Tenure Analysis

Customer tenure was analyzed to understand whether newer customers behave differently from long-term customers.

Customers can be grouped into tenure bands such as:

* 0–12 months
* 13–24 months
* 25–48 months
* 49+ months

This helps identify whether churn risk is concentrated among newer customers.

---

## 💰 5. Monthly Charges Analysis

Monthly charges were analyzed to investigate the relationship between pricing and churn.

Customers can be segmented into charge bands to compare:

* Customer count
* Churned customers
* Churn rate
* Average monthly charges

This can help determine whether customers paying higher monthly charges have different retention patterns.

---

## 💳 6. Payment Method Analysis

Customer churn was analyzed across payment methods.

The analysis compares:

* Electronic check
* Mailed check
* Bank transfer
* Credit card

This can help identify whether particular payment methods are associated with higher churn.

---

## 🌐 7. Internet & Phone Services

The analysis investigates churn across service subscriptions such as:

* DSL
* Fiber optic
* No internet service
* Phone service
* Multiple lines

Additional services such as:

* Online security
* Online backup
* Device protection
* Tech support
* Streaming services

are also considered.

The goal is to understand whether service combinations are associated with customer retention.

---

## 🧩 8. Customer Segmentation

Customers are segmented using combinations of important attributes.

Examples include:

* Contract type + churn
* Tenure + churn
* Internet service + churn
* Monthly charge band + churn
* Payment method + churn
* Senior citizen + contract + churn

This allows the analysis to move beyond individual variables and identify higher-risk customer groups.

---

# 🧠 Advanced SQL Techniques

This project demonstrates practical SQL techniques used in analytical workflows.

### SQL Fundamentals

* `SELECT`
* `WHERE`
* `ORDER BY`
* `GROUP BY`
* `HAVING`
* `DISTINCT`

### Conditional Analysis

* `CASE WHEN`
* Conditional aggregation

### Aggregations

* `COUNT`
* `SUM`
* `AVG`
* `MIN`
* `MAX`

### Advanced SQL

* `JOIN`
* `CTE`
* Subqueries
* Window functions
* Date functions
* Percentage calculations
* Customer segmentation

---

# 📈 Example Advanced SQL Query

A CTE can be used to calculate churn rates by customer segment:

```sql
WITH churn_summary AS (
    SELECT
        contract,
        COUNT(*) AS total_customers,
        SUM(
            CASE
                WHEN churn = 'Yes' THEN 1
                ELSE 0
            END
        ) AS churned_customers
    FROM customers
    GROUP BY contract
)

SELECT
    contract,
    total_customers,
    churned_customers,
    ROUND(
        100.0 * churned_customers / total_customers,
        2
    ) AS churn_rate
FROM churn_summary
ORDER BY churn_rate DESC;
```

This demonstrates how SQL can be used to transform raw customer records into business-level metrics.

---

# 💡 Key Business Insights

The analysis focuses on identifying patterns such as:

### 🔹 Contract Duration

Customers on shorter-term contracts can be compared with customers on longer-term contracts to identify differences in retention.

### 🔹 Customer Tenure

Newer customers can be evaluated separately from long-term customers to determine whether early-stage customers require additional retention efforts.

### 🔹 Monthly Charges

Higher monthly charges can be analyzed alongside churn to identify potentially price-sensitive customer segments.

### 🔹 Payment Method

Differences in churn across payment methods can highlight segments that may benefit from payment-process improvements or targeted retention campaigns.

### 🔹 Service Configuration

Customers using different internet, phone, and additional services can be compared to understand how service offerings relate to retention.

> **Important:** The final numerical findings should be populated from the actual query results rather than estimated values.

---

# 💼 Business Recommendations

Based on the churn analysis, potential retention strategies include:

### 1. Target high-risk contract segments

Customers with higher churn rates should receive targeted retention campaigns before their contracts or subscriptions reach renewal points.

### 2. Focus on early-tenure customers

If churn is concentrated among newer customers, the business could introduce stronger onboarding and early-life customer engagement programs.

### 3. Review high-charge customer segments

High monthly-charge customers with elevated churn should be investigated for pricing, perceived value, or service-quality issues.

### 4. Improve retention through service bundles

If customers using certain combinations of services show lower churn, bundled offerings could be evaluated as a retention strategy.

### 5. Investigate payment-related churn

If a particular payment method demonstrates significantly higher churn, the company should investigate whether payment friction contributes to customer loss.

---

# 📊 Business Impact

This analysis demonstrates how SQL can be used to move from:

**Raw Customer Data → Segmentation → Churn Analysis → Business Insights → Retention Recommendations**

The project focuses not only on writing SQL queries but also on understanding **why customers churn and what the business can potentially do about it**.

---

# 🛠️ Tools & Technologies

### Database

* **PostgreSQL**

### Query Language

* **SQL**

### Analysis Techniques

* Aggregation
* Customer segmentation
* Conditional analysis
* Churn-rate calculation
* CTEs
* Subqueries
* Window functions
* Joins
* Date-based analysis

---

# 📂 Project Structure

```text
Telecom-Customer-Churn-SQL/
│
├── telecom_customer_churn.sql
├── telecom_customer_churn.csv
├── README.md
└── dashboard/
    └── churn_analysis.png
```

---

# 🚀 Future Improvements

Potential extensions to this project include:

* Build a Power BI churn dashboard
* Create customer risk segments
* Develop a churn prediction model using Python
* Perform cohort analysis
* Analyze customer lifetime value
* Investigate revenue lost through churn
* Build automated churn reporting
* Compare churn before and after retention campaigns

---

# ⚠️ Analysis Limitations

* The analysis identifies associations rather than proving causation.
* Historical customer behavior may not fully represent future churn.
* The available dataset may not include customer satisfaction or competitor information.
* Churn drivers should be validated using additional operational and customer-feedback data.

---

# 🎓 Skills Demonstrated

This project demonstrates practical experience in:

* SQL
* PostgreSQL
* Data Cleaning
* Data Aggregation
* Customer Segmentation
* Churn Analysis
* CTEs
* Window Functions
* Joins
* Subqueries
* Conditional Aggregation
* Business KPI Development
* Analytical Problem Solving
* Business Insight Generation

---

## 👨‍💻 About

**Suryansh Sinha**

Aspiring Data Analyst | SQL | Python | Power BI | Excel

This project was created as part of my data analytics portfolio to demonstrate practical SQL and business-analysis skills.
