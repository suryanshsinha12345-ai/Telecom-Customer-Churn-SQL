CREATE TABLE customer_churn (
    state VARCHAR(5),
    account_length INT,
    area_code VARCHAR(20),
    international_plan VARCHAR(5),
    voice_mail_plan VARCHAR(5),
    number_vmail_messages INT,
    total_day_minutes DECIMAL(8,2),
    total_day_calls INT,
    total_day_charge DECIMAL(8,2),
    total_eve_minutes DECIMAL(8,2),
    total_eve_calls INT,
    total_eve_charge DECIMAL(8,2),
    total_night_minutes DECIMAL(8,2),
    total_night_calls INT,
    total_night_charge DECIMAL(8,2),
    total_intl_minutes DECIMAL(8,2),
    total_intl_calls INT,
    total_intl_charge DECIMAL(8,2),
    number_customer_service_calls INT,
    churn VARCHAR(5)
);

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_percentage
FROM customer_churn;

-- The company has an overall churn rate of 14.07%.
-- Approximately 1 out of every 7 customers has left the service.
-- The remaining 85.93% of customers are retained.

SELECT
    churn,
    COUNT(*) AS customers,
    ROUND(AVG(account_length), 2) AS avg_account_length,
    MIN(account_length) AS min_account_length,
    MAX(account_length) AS max_account_length
FROM customer_churn
GROUP BY churn;

-- Customers who churned had an average account length of 102.14, compared to 99.92 for retained customers. The small difference suggests that tenure is not a strong predictor of churn, indicating that behavioral and service-related variables should be investigated further.

SELECT
    international_plan,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY international_plan
ORDER BY churn_rate DESC;

-- Customers with an international plan have a 42.17% churn rate.
-- Customers without an international plan have only an 11.18% churn rate.
-- The churn rate is almost 4 times higher among international plan subscribers.
-- Conclusion

-- The international plan is a strong indicator of churn. Customers subscribed to this plan are significantly more likely to leave the company.

SELECT
    churn,
    COUNT(*) AS customers,
    ROUND(AVG(number_customer_service_calls), 2) AS avg_service_calls,
    MIN(number_customer_service_calls) AS min_calls,
    MAX(number_customer_service_calls) AS max_calls
FROM customer_churn
GROUP BY churn;

-- Customers who churned made more customer service calls on average than customers who stayed.
-- Non-churned customers: 1.44 calls
-- Churned customers: 2.28 calls
-- This means churned customers contacted customer service approximately 58% more often.
-- Conclusion
-- There is a positive relationship between the number of customer service calls and churn. Customers who repeatedly contact support are more likely to leave, suggesting unresolved issues or dissatisfaction.

/*
Compare average day, evening, and night call charges
for churned vs. non-churned customers.
*/

SELECT
    churn,
    ROUND(AVG(total_day_charge), 2) AS avg_day_charge,
    ROUND(AVG(total_eve_charge), 2) AS avg_evening_charge,
    ROUND(AVG(total_night_charge), 2) AS avg_night_charge
FROM customer_churn
GROUP BY churn;

/*
Business Insight

• Churned customers incur higher average charges across all time periods.
• The largest difference is observed in daytime charges.
• This indicates that customers with higher usage and higher bills are more likely to churn.
Conclusion
Higher telecom charges, particularly during the day, appear to be associated with an increased likelihood of customer churn.
Recommendation

The company should identify high-billing customers and offer
personalized plans, discounts, or usage alerts to improve retention.
*/

/*==================================================
 Voice Mail Plan Analysis
==================================================*/

SELECT
    voice_mail_plan,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY voice_mail_plan
ORDER BY churn_rate DESC;

/*
Business Insight

• Customers without a voice mail plan have a churn rate of 16.44%.
• Customers with a voice mail plan have a churn rate of only 7.37%.

Conclusion

Customers who subscribe to a voice mail plan are significantly less
likely to churn. The churn rate is more than twice as high among
customers without a voice mail plan.

Recommendation

Increase adoption of voice mail plans through promotions or bundles,
as they appear to improve customer retention.
*/

/*==================================================
Day Calls Analysis
====================================================
Business Question:
Is there a relationship between the total number of
day calls and customer churn?
==================================================*/

SELECT
    churn,
    COUNT(*) AS customers,
    ROUND(AVG(total_day_calls), 2) AS avg_day_calls,
    MIN(total_day_calls) AS min_day_calls,
    MAX(total_day_calls) AS max_day_calls
FROM customer_churn
GROUP BY churn;

/*
Business Insight

• Non-churned customers make an average of 99.81 day calls.
• Churned customers make an average of 100.48 day calls.

Conclusion

There is almost no difference in the average number of day calls
between churned and non-churned customers.

Unlike day minutes and day charges, the number of day calls
does not appear to be a strong predictor of churn.

Recommendation

Instead of focusing on call frequency, the company should focus on
call duration and customer billing patterns, which showed a much
stronger relationship with churn.
*/

SELECT
    CASE
        WHEN total_eve_charge < 15 THEN 'Low'
        WHEN total_eve_charge BETWEEN 15 AND 20 THEN 'Medium'
        ELSE 'High'
    END AS evening_charge_group,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY evening_charge_group
ORDER BY evening_charge_group;

/*
==================================================
Business Insight
==================================================

• Customers with high evening charges have the highest churn rate (18.20%).
• Customers with medium evening charges have a churn rate of 13.62%.
• Customers with low evening charges have the lowest churn rate (11.61%).

Conclusion

The churn rate increases as evening charges increase,
suggesting that customers with higher evening usage
or higher bills are more likely to leave the service.

Recommendation

Offer customized plans or discounts for customers with
high evening usage to improve customer retention.
*/

/*==================================================
Area Code Analysis
====================================================

Business Question:
Which area codes have the highest churn rate?

==================================================*/

SELECT
    area_code,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY area_code
ORDER BY churn_rate DESC;

/*==================================================
Business Insight
====================================================

• area_code_510 has the highest churn rate (15.06%).
• area_code_415 has the lowest churn rate (13.61%).

Conclusion

Although area_code_510 has the highest churn rate, the differences
between the three area codes are relatively small (around 1.5%).

This suggests that area code alone is not a strong predictor of churn.

Recommendation

Instead of targeting customers solely based on area code, prioritize
behavioral factors such as international plans, customer service calls,
and high usage patterns, which have shown a much stronger relationship
with churn.
*/

/*==================================================
Service Call Threshold Analysis
====================================================

Business Question:
Does churn increase significantly after multiple
customer service calls?

==================================================*/

SELECT
    CASE
        WHEN number_customer_service_calls <= 1 THEN '0-1 Calls'
        WHEN number_customer_service_calls <= 3 THEN '2-3 Calls'
        ELSE '4+ Calls'
    END AS service_call_group,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY service_call_group
ORDER BY service_call_group;

/*==================================================
Business Insight
====================================================

• Customers with 0–1 service calls have a churn rate of 10.91%.
• Customers with 2–3 service calls have a similar churn rate of 10.96%.
• Customers with 4 or more service calls have a churn rate of 50.75%.

Conclusion

Customers making four or more customer service calls are at
significantly higher risk of churn. Their churn rate is nearly
five times higher than customers making three or fewer calls.

Recommendation

Implement an automated retention strategy for customers who
contact customer support four or more times. These customers
should receive priority support, issue escalation, and proactive
follow-up to reduce churn.
*/

/*==================================================
Tenure Segmentation Analysis
====================================================

Business Question:
Does customer tenure influence churn?

==================================================*/

SELECT
    CASE
        WHEN account_length < 50 THEN 'New (0-49)'
        WHEN account_length BETWEEN 50 AND 150 THEN 'Medium (50-150)'
        ELSE 'Long-term (151+)'
    END AS tenure_group,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY tenure_group
ORDER BY tenure_group;

/*==================================================
Business Insight
====================================================

• New customers (0–49) have the lowest churn rate (12.35%).
• Medium-tenure customers (50–150) have a churn rate of 14.15%.
• Long-term customers (151+) have the highest churn rate (15.16%).

Conclusion

Contrary to common expectations, newer customers are not the most
likely to churn. Churn increases slightly as customer tenure increases.

Recommendation

The company should not focus retention efforts solely on new
customers. Long-term customers should also receive loyalty programs,
personalized offers, and regular engagement to reduce churn.
*/

/*===============================================
International Plan Impact
====================================================

Business Question:
How do international usage and churn differ between
customers with and without an international plan?

==================================================*/

SELECT
    international_plan,
    COUNT(*) AS customers,
    ROUND(AVG(total_intl_minutes), 2) AS avg_intl_minutes,
    ROUND(AVG(total_intl_charge), 2) AS avg_intl_charge,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY international_plan
ORDER BY churn_rate DESC;

/*==================================================
Business Insight
====================================================

• Customers with an international plan have an average of
  10.46 international minutes and an average charge of $2.82.
• Customers without an international plan have an average of
  10.24 international minutes and an average charge of $2.76.
• Despite very similar international usage, customers with
  an international plan have a much higher churn rate (42.17%).

Conclusion

The high churn rate cannot be explained by international
usage alone. Customers with international plans use almost
the same number of international minutes as customers without
the plan.

Recommendation

Review the pricing, value proposition, and customer experience
of the international plan. The plan itself may be driving
customer dissatisfaction rather than actual usage.
*/

/*==================================================
Evening Usage Pattern Analysis
====================================================

Business Question:
Compare evening usage between churned and
non-churned customers.

==================================================*/

SELECT
    churn,
    COUNT(*) AS customers,
    ROUND(AVG(total_eve_minutes), 2) AS avg_evening_minutes,
    ROUND(AVG(total_eve_calls), 2) AS avg_evening_calls,
    ROUND(AVG(total_eve_charge), 2) AS avg_evening_charge
FROM customer_churn
GROUP BY churn;

/*==================================================
Business Insight
====================================================

• Churned customers spend more time on evening calls
  (209.96 minutes) than non-churned customers (198.57 minutes).
• The average number of evening calls is almost identical
  for both groups (99.84 vs. 100.23).
• Churned customers incur slightly higher evening charges
  ($17.85 vs. $16.88).

Conclusion

Evening call frequency has little relationship with churn.
However, customers who churn tend to spend more time on
evening calls, resulting in higher evening charges.

Recommendation

Focus on customers with high evening usage by offering
better pricing plans or bundled packages. However,
customer service interactions and international plans
remain much stronger predictors of churn.
*/

/*==================================================
Voice Mail Messages Analysis
====================================================

Business Question:
Does the number of voice mail messages influence
customer churn?

==================================================*/

SELECT
    voice_mail_plan,
    ROUND(AVG(number_vmail_messages), 2) AS avg_voice_messages,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY voice_mail_plan
ORDER BY churn_rate DESC;

/*==================================================
Business Insight
====================================================

• Customers without a voice mail plan do not use voice mail
  messages and have a churn rate of 16.44%.
• Customers with a voice mail plan use an average of
  29.17 voice mail messages and have a much lower churn
  rate of 7.37%.

Conclusion

Customers who subscribe to and actively use the voice mail
service are significantly less likely to churn. Voice mail
appears to be a valuable service that improves customer
engagement and retention.

Recommendation

Encourage customers to adopt and use the voice mail service
through promotional offers, onboarding campaigns, and feature
education to improve customer retention.
*/

/*==================================================
Q18. Usage Inflection Point Analysis
====================================================

Business Question:
Is there a usage threshold where churn increases?

==================================================*/

SELECT
    CASE
        WHEN total_day_minutes < 150 THEN 'Low Usage'
        WHEN total_day_minutes BETWEEN 150 AND 250 THEN 'Medium Usage'
        ELSE 'High Usage'
    END AS usage_group,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY usage_group
ORDER BY usage_group;

/*==================================================
Business Insight
====================================================

• Customers with high daytime usage (>250 minutes)
  have the highest churn rate at 48.94%.
• Customers with medium usage (150–250 minutes)
  have the lowest churn rate at 9.39%.
• Customers with low usage (<150 minutes)
  have a churn rate of 11.95%.

Conclusion

There is a clear usage inflection point. Once customers
exceed 250 daytime minutes, the likelihood of churn
increases dramatically.

Recommendation

Identify customers approaching 250 daytime minutes
and proactively offer unlimited or discounted daytime
calling plans before they exceed this threshold.
*/