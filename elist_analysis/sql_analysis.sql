-- What were the order counts, sales, and AOV for Macbooks sold in North America for each quarter across all years? 

-- fields: year + quarter (date_trunc purchase_ts, aggregates(count of order id, sum of usd price, average of usd price)
-- filters: product name LIKE macbook, region = NA
-- tables: orders, customers, geo_lookup

SELECT EXTRACT(year from o.purchase_ts) as year,
  CONCAT("Q", EXTRACT(quarter from o.purchase_ts)) as quarter,
  COUNT(DISTINCT o.id) as order_count,
  ROUND(SUM(o.usd_price),2) as sales,
  ROUND(AVG(o.usd_price),2) as aov
FROM elistcore.core.orders o 
LEFT JOIN elistcore.core.customers c 
ON o.customer_id = c.id
LEFT JOIN elistcore.core.geo_lookup g
ON c.country_code = g.country_code
WHERE LOWER(o.product_name) LIKE 'macbook%'
AND g.region= 'NA'
GROUP BY 1, 2
ORDER BY 1, 2;

-- ELIST ANALYSIS - BUSINESS QUESTIONS

-- For products purchased in 2022 on the website or products purchased on mobile in any year, which region has the average highest time to deliver? 

-- fields: region, time to deliver (datediff of deliver ts - purchase ts)
-- first filter: year (extract) = 2022 and purchase_platform = website
-- second filter: purchase_platform = mobile
-- order by time to deliver desc
-- tables: order_status (main), order, customer

SELECT g.region,
  AVG(DATE_DIFF(os.delivery_ts, os.purchase_ts, day)) as time_to_deliver
FROM elistcore.core.order_status os
LEFT JOIN elistcore.core.orders o 
  ON os.order_id = o.id
LEFT JOIN elistcore.core.customers c
  ON o.customer_id = c.id
LEFT JOIN elistcore.core.geo_lookup g
  ON c.country_code = g.country_code
WHERE (EXTRACT(year from os.purchase_ts) = 2022 AND LOWER(o.purchase_platform) = 'website')
  OR LOWER(o.purchase_platform) = 'mobile app'
GROUP BY 1
ORDER BY 2 DESC;

-- What was the refund rate and refund count for each product overall?

-- fields: product_name, refunded (count(refund_ts), refund rate (avg of case when refund_ts is not null then 1 else 0)
-- no filters
-- tables: order_status and orders

SELECT DISTINCT product_name
FROM core.orders;

SELECT CASE WHEN product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE product_name END AS product_name_cleaned, 
  COUNT(refund_ts) as refunded,
  AVG(CASE WHEN refund_ts IS NOT NULL THEN 1 ELSE 0 END) as refund_rate
FROM core.orders o
LEFT JOIN core.order_status os
  ON o.id = os.order_id
GROUP BY 1
ORDER BY 1;

-- Within each region, what is the most popular product?

-- assuming popular = highest order_counts
-- we will need CTEs to break this down
-- CTE 1: count total orders per product
-- CTE 2: rank each product and region  by the total orders in a new CTE
-- need partition region and order by order_count

WITH order_count_cte as (
  SELECT g.region,
    o.product_name,
    COUNT(DISTINCT o.id) as order_count
  FROM core.orders o
  LEFT JOIN core.customers c
    ON o.customer_id = c.id
  LEFT JOIN core.geo_lookup g
    ON g.country_code = c.country_code
  GROUP BY 1,2) ,

ranking_cte as (
  SELECT *,
    row_number() OVER (PARTITION BY region ORDER BY order_count DESC) as ranking
  FROM order_count_cte)

SELECT * 
FROM ranking_cte
WHERE ranking = 1; 

-- using qualify to filter using row_number without the second CTE 

WITH order_count_cte as (
  SELECT g.region,
    o.product_name,
    COUNT(DISTINCT o.id) as order_count
  FROM core.orders o
  LEFT JOIN core.customers c
    ON o.customer_id = c.id
  LEFT JOIN core.geo_lookup g
    ON g.country_code = c.country_code
  GROUP BY 1,2)

SELECT *,
  row_number() OVER (PARTITION BY region ORDER BY order_count DESC) as ranking
FROM order_count_cte
QUALIFY row_number() over (PARTITION BY region ORDER BY order_count DESC) = 1;

-- How does the time to make a purchase differ between loyalty customers vs. non-loyalty customers? 

-- time_to_purchase = datediff(account_creation_date, customer's first purchase ts) - both days and months
-- break loyalty_program into loyalty and non-loyalty with a case when
-- tables: customers, orders, order status

SELECT CASE WHEN c.loyalty_program = 1 THEN 'loyalty' ELSE 'non-loyalty' END as loyalty,
  ROUND(AVG(DATE_DIFF(os.purchase_ts, c.created_on, day)), 1) as days_to_purchase,
  ROUND(AVG(DATE_DIFF(os.purchase_ts, c.created_on, month)), 1) as months_to_purchase
FROM core.customers c
LEFT JOIN core.orders o
  ON c.id = o.customer_id
LEFT JOIN core.order_status os
  ON os.order_id = o.id
GROUP BY 1; 
