Question 1 :
Query 1 : [Top 5 Sold Products]
Code :
SELECT DISTINCT StockCode, SUM(Price * Quantity) OVER(PARTITION BY StockCode) AS Revenue
FROM tableRetail
ORDER BY Revenue DESC	
LIMIT 5;   / or FETCH FIRST 5 ROWS ONLY ; 
Business Meaning :
The query provides insights into which products are driving the most revenue for the business.
This information can be used by the business to make strategic decisions such as which products to focus on for marketing and promotion, which products to keep in stock, and which products to potentially discontinue or replace. By understanding which products generate the highest revenue.

###################
Query 2 : [Correlation]
Code : 
SELECT 
  DISTINCT Stockcode,
  ROUND(AVG(Quantity) OVER (PARTITION BY Stockcode), 2) AS AvgQuantity,
  ROUND(AVG(Price) OVER (PARTITION BY Stockcode), 2) AS AvgPrice,
  CORR(Quantity, Price) OVER (PARTITION BY Stockcode) AS Correlation
FROM tableRetail
order by Correlation ;


Business Meaning
This query calculates the correlation between the number of items in an order and the order price by using the CORR function, which calculates the Pearson correlation coefficient between two variables. This information can help businesses understand the relationship between order size and price and make pricing and inventory decisions accordingly. The business can identify which products are priced optimally and which ones may need adjustment to improve sales.



##################################
QUERY 3 :[Monthly Revenue]
Code :

SELECT 
  DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m') as Month, 
  ROUND(SUM(Price * Quantity), 0) as Revenue_of_Month , 
  ROUND(LAG(SUM(Price * Quantity), 1, 0) 
OVER (ORDER BY DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m')), 0) as Previous_Revenue,
  CASE 
  WHEN SUM(Price * Quantity) > LAG(SUM(Price * Quantity), 1, NULL) OVER (ORDER BY DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m')) THEN 'Increased'
 ELSE 'Decreased'
END AS Revenue_Growth
FROM tableRetail 
GROUP BY Month;

Business Meaning
The business meaning of this query is to help the retail business understand its monthly revenue trends and compare between previous month to figure out if there is any faults and mistakes must be improved and the to check why decrease in the profit takes place.

############################
QUERY 4 :[Top 5 customers in 2011]
Code :
SELECT Customer_ID, YEAR, COUNT_PURCHASE_DURING_YEAR
FROM (
SELECT Customer_ID, DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y') AS YEAR,      COUNT(*) AS COUNT_PURCHASE_DURING_YEAR,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS purchase_rank
  FROM tableRetail
  WHERE YEAR(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) = 2011
  GROUP BY Customer_ID, YEAR
) AS RANKING
WHERE purchase_rank <= 5;
Business Meaning
The business meaning behind this query is to identify the most valuable customers based on their purchase behavior during the year 2011 for loyalty programs, promotions, For example, businesses may notice that certain products or services are more popular among the top customers, and they can adjust their offerings accordingly to meet customer demand and drive revenue growth.

#################################

QUERY 5:[Average Customer Order Value]
Code :

WITH customer_order_values AS (
  SELECT 
    customer_id, quantity * price AS order_value,
    COUNT(*) OVER (PARTITION BY customer_id) AS order_count
  FROM  tableRetail )

SELECT 
  customer_id, round( AVG(order_value) , 2) AS Avg_Order_value
FROM   customer_order_values
WHERE   order_count > 1
GROUP BY   customer_id;

Business Meaning
The query identifies customers who have placed more than one order and then calculates the average value of each of their orders. This information can be useful for the business to understand customer behavior, such as which customers are more likely to place multiple orders and what the average value of those orders is. By understanding this information, the business can optimize its marketing strategies and promotions to target customers who are more likely to place repeat orders and increase their overall revenue.


