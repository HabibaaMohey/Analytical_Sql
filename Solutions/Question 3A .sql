
-- To create Table Cust_Id , Purchase_Date , Amount_LE
create table customers_data ( Cust_Id int , Purchase_Date varchar(45)  , Amount_LE float );
-- To load Data in Table from csv file 
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\new.csv"
INTO TABLE ok 
FIELDS TERMINATED BY ','; 

-- Code 

--  Format the purchase date and get the previous purchase date for each customer
-- Creating date with datatype date caused errors !!!!
WITH cte1 AS (
    SELECT 
        Cust_Id, 
        DATE_FORMAT(STR_TO_DATE(Purchase_Date, '%m/%d/%Y %H:%i'), '%Y/%m/%d') AS Formatted_purchasedate,
        LAG(DATE_FORMAT(STR_TO_DATE(Purchase_Date, '%m/%d/%Y %H:%i'), '%Y/%m/%d')) OVER (PARTITION BY Cust_Id ORDER BY DATE_FORMAT(STR_TO_DATE(Purchase_Date, '%m/%d/%Y %H:%i'), '%Y/%m/%d')) AS Previous_Purchase
    FROM customers_data
    ORDER BY Cust_Id, Formatted_purchasedate 
    
), 

-- Calculate the number of consecutive days between purchases for each customer
cte2 AS (
    SELECT 
        Cust_Id, 
        Formatted_purchasedate, 
        Previous_Purchase, 
        CASE
            WHEN datediff(Formatted_purchasedate, Previous_Purchase) = 1 THEN '1' 
            ELSE 'More than 1 '
        END AS COUNT
    FROM cte1 
) 

-- Group consecutive purchases by customer and count the number of consecutive days
,cte3 AS (
    SELECT 
        Cust_Id, 
        Formatted_purchasedate, 
        COUNT,
        ROW_NUMBER() OVER (PARTITION BY Cust_Id ORDER BY Formatted_purchasedate) - ROW_NUMBER() OVER (PARTITION BY Cust_Id, COUNT ORDER BY Formatted_purchasedate) AS grp
    FROM cte2
)

-- Query to calculate the maximum number of consecutive days for each customer
SELECT 
    Cust_Id, 
    MAX(Consecutive_Days) AS Max_Consecutive_Days
FROM (
    SELECT 
        Cust_Id, 
        COUNT(*) AS Consecutive_Days 
    FROM cte3
    GROUP BY Cust_Id, grp
    ORDER BY Cust_Id, Consecutive_Days DESC
) AS subquery
GROUP BY Cust_Id
LIMIT 20;