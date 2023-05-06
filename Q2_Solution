
-- To get Recency , Frequency m Monetary
WITH cte1 AS (
  SELECT Customer_ID, 
         DATEDIFF('2011-12-09 12:20:00', MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'))) AS Recency, 
         COUNT(distinct Invoice) AS Frequency, 
         ROUND(SUM(Price * Quantity), 2) AS Monetary 
  FROM tableRetail
  GROUP BY Customer_ID
), 
 -- To get scores 
cte2 AS (
  SELECT Customer_ID, Recency, Frequency, Monetary,
         NTILE(5) OVER (ORDER BY Recency desc) AS R_score,
        NTILE(5) OVER (ORDER BY Frequency ) AS F_score,
        NTILE(5) OVER (ORDER BY Monetary ) AS M_score
  FROM cte1
) ,
 -- To get FM_SCORE 
 cte3 AS ( SELECT Customer_ID, Recency, Frequency, Monetary, R_score,
 NTILE(5) OVER (ORDER BY avg( F_score + M_score )) AS FM_score 
 -- NTILE(5) OVER (ORDER BY ( F_score + M_score )/2) AS FM_score 
 From cte2
 group by Customer_ID
) , 
 -- To get Customer segment 
cte4 as ( Select Customer_ID Recency, Frequency, Monetary, R_score, FM_score ,
  CASE 
         --Lost
        WHEN R_score IN (1) AND FM_Score IN (1) THEN 'Lost'
	    --Hibernating
		WHEN R_score IN (1) AND FM_Score IN (2) THEN '	Hibernating'
		--Cannot Lose Them
		WHEN R_score IN (1) AND FM_Score IN (5,4) THEN 'Cannot lose them'
		-- At Risk
        WHEN R_score = 2 AND FM_Score in (5,4)  THEN 'At Risk'
		WHEN R_score = 1 AND FM_Score = 3 THEN 'At Risk'
		-- Customer Needing Attention
		WHEN R_score = 3 AND FM_Score = 2 THEN 'Customer Needing Attention'
		WHEN R_score IN (2) AND FM_Score IN (2,3) THEN 'Customer Needing Attention'
		-- Promising
		WHEN R_score IN (4,3) AND FM_Score IN (1) THEN 'Promising'
		--Recent Customers
	    WHEN R_score IN (5) AND FM_Score IN (1) THEN 'Recent Customers'
        --Loyal Customers
        WHEN R_score = 3 AND FM_Score in (5,4) THEN 'Loyal Customer'
		WHEN R_score = 4 AND FM_Score = 4 THEN 'Loyal Customer'
		WHEN R_score = 5 AND FM_Score = 3 THEN 'Loyal Customer'
        --Potential Loyalistis
		WHEN R_score IN (4,5) AND FM_Score IN (2) THEN 'Potential Loyalistis'
		WHEN R_score IN (4,3) AND FM_Score IN (3) THEN 'Potential Loyalistis'
		-- Champions
		WHEN R_score IN (5,4) AND FM_Score IN (5) THEN 'Champions' 
	    WHEN R_score = 5  AND FM_Score = 4  THEN 'Champions' 
        -- Else
        ELSE 'No Segment'
    END AS Cust_Segment
    from cte3
)
-- To show Final Result
SELECT *
FROM cte4
order by r_score;
