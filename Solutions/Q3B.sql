-- To get total spending of customet
WITH cte1 AS (
SELECT
CUST_ID,
DATE_FORMAT(STR_TO_DATE(Purchase_Date, '%m/%d/%Y %H:%i'), '%Y-%m-%d') AS Transaction_Date,
SUM(amount_LE) OVER (PARTITION BY CUST_ID ORDER BY  DATE_FORMAT(STR_TO_DATE(Purchase_Date, '%m/%d/%Y %H:%i'), '%Y-%m-%d') ) AS Total_Sum
FROM
customers_data
),-- To get whom are customers that didn't reach target(250L.E)
cte2 AS (
SELECT *
FROM
cte1
WHERE
total_sum < 250
),-- To get whom are customers that reached target and more (>=250L.E)
cte3 AS (
SELECT *
FROM
cte1
WHERE
total_sum >= 250
), -- To get number of days took for each customer to reach the threshold
cte4 AS (
SELECT
CUST_ID,
COUNT(*) AS DAYS_THRESHOLD
FROM
cte2
WHERE
CUST_ID IN (SELECT CUST_ID FROM cte3)
GROUP BY
CUST_ID
ORDER BY
CUST_ID)
-- To get average of threshold 
SELECT round(AVG(DAYS_THRESHOLD),0) as AVG_DAYS
FROM cte4;