-- ELIST ANALYSIS - TARGETED BUSINESS QUESTIONS

-- Return the id, loyalty program status, and account creation date for customers who made an account on desktop or mobile. Rename the columns to more descriptive names.
SELECT id AS customer_id, 
  loyalty_program AS is_loyalty_program, 
  created_on AS account_creation_date
FROM elistcore.core.customers
WHERE account_creation_method IN ('desktop', 'mobile');

-- What were the total number of orders placed using each currency?
SELECT DISTINCT currency,
  COUNT(id) as count_of_orders
FROM elistcore.core.orders
WHERE currency IS NOT NULL
GROUP BY 1
ORDER BY 1;  

-- What is the total number of orders by shipping month, sorted from most recent to oldest?
SELECT DATE_TRUNC(ship_ts, MONTH) AS shipping_month,
  COUNT(distinct order_id) AS num_orders
FROM elistcore.core.order_status
GROUP BY 1, 2
ORDER BY 1 DESC;

-- What is the average order value by year? Can you round the results to 2 decimals?
SELECT EXTRACT(YEAR FROM purchase_ts) AS year, 
  ROUND(AVG(usd_price), 2) AS aov
FROM elistcore.core.orders
GROUP BY 1
ORDER BY 1;

-- Create a helper column `is_refund`  in the `order_status`  table that returns 1 if there is a refund, 0 if not. Return the first 20 records.
SELECT *, 
  CASE WHEN refund_ts IS NOT NULL THEN 1 ELSE 0 END AS is_refund
FROM core.order_status
LIMIT 20;

-- Return the product IDs and product names of all Apple products.
SELECT product_id, product_name
FROM elistcore.core.orders
WHERE product_name IN ('Apple Airpods Headphones','Apple iPhone','Macbook Air Laptop');
-- WHERE product_name LIKE '%Apple%' OR product_name = 'Macbook Air Laptop'

-- Calculate the time to ship in days for each order and return all original columns from the table.
SELECT *, 
  DATE_DIFF(ship_ts,purchase_ts, day) AS days_to_ship
FROM elistcore.core.order_status; 

-- Which months have the highest average time to ship? 
SELECT EXTRACT(month from os.purchase_ts),
  ROUND(AVG(DATE_DIFF(os.ship_ts, os.purchase_ts, day)), 2) AS days_to_ship
FROM elistcore.core.order_status os
LEFT JOIN elistcore.core.orders o
    ON os.order_id = o.id
GROUP BY 1 
ORDER BY 2 DESC; 

-- What were the order counts, sales, and AOV for Macbooks sold in North America for each quarter across all years? 
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

-- What is the average quarterly order count and total sales for Macbooks sold in NA?
WITH quarterly_metrics as (
  SELECT DATE_TRUNC(o.purchase_ts, quarter) as purchase_quarter,
    COUNT (distinct o.id) as order_count,
    ROUND(SUM(o.usd_price), 2) as total_sales
  FROM core.orders o
  LEFT JOIN core.customers c
    ON o.customer_id = c.id
  LEFT JOIN core.geo_lookup g
    ON c.country_code = g.country_code
  WHERE lower(o.product_name) LIKE '%macbook%'
    AND region = 'NA'
  GROUP BY 1
  ORDER BY 1 DESC ) 

SELECT ROUND(AVG(order_count), 2) as avg_quarterly_orders,
  ROUND(AVG(total_sales), 2) as avg_quarterly_sales
FROM quarterly_metrics;

-- For products purchased in 2022 on the website or products purchased on mobile in any year, which region has the average highest time to deliver? 
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

-- Which region had the highest time to deliver (in weeks) for website purchases made in 2022 or Samsung purchases made in 2021? 
SELECT g.region,
  ROUND(AVG(DATE_DIFF(os.delivery_ts, os.purchase_ts, week)), 2) as time_to_deliver_weeks
FROM core.order_status os
LEFT JOIN core.orders o
  ON os.order_id = o.id
LEFT JOIN core.customers c
  ON o.customer_id = c.id
LEFT JOIN core.geo_lookup g
  ON c.country_code = g.country_code
WHERE (EXTRACT(year from o.purchase_ts) = 2022 AND o.purchase_platform = 'website')
  OR (EXTRACT(year from o.purchase_ts) = 2021 AND LOWER(o.product_name) LIKE 'samsung%')
GROUP BY 1
ORDER BY 2 DESC;

-- What was the refund rate and refund count for each product overall?
SELECT DISTINCT product_name
FROM core.orders;

SELECT CASE WHEN o.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE product_name END AS product_name_cleaned, 
  COUNT(os.refund_ts) as refunded,
  AVG(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END) as refund_rate
FROM core.orders o
LEFT JOIN core.order_status os
  ON o.id = os.order_id
GROUP BY 1
ORDER BY 1;

-- What was the refund rate and refund count for each product per year? 
SELECT EXTRACT(year from o.purchase_ts) as purchase_year,
  CASE WHEN o.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE product_name END AS product_name_cleaned, 
  COUNT(os.refund_ts) as refunded,
  AVG(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END) * 100 as refund_rate_percent
FROM core.orders o
LEFT JOIN core.order_status os
  ON o.id = os.order_id
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Within each region, what is the most popular product?
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
SELECT CASE WHEN c.loyalty_program = 1 THEN 'loyalty' ELSE 'non-loyalty' END as loyalty,
  ROUND(AVG(DATE_DIFF(os.purchase_ts, c.created_on, day)), 1) as days_to_purchase,
  ROUND(AVG(DATE_DIFF(os.purchase_ts, c.created_on, month)), 1) as months_to_purchase
FROM core.customers c
LEFT JOIN core.orders o
  ON c.id = o.customer_id
LEFT JOIN core.order_status os
  ON os.order_id = o.id
GROUP BY 1; 

--  How many refunds were there for each month in 2021? What about each quarter and week?

-- by month
SELECT DATE_TRUNC(refund_ts, month) as month,
  COUNT(refund_ts) as refunds
FROM core.order_status
WHERE EXTRACT(year from refund_ts) = 2021
GROUP BY 1
ORDER BY 1;

-- by quarter
SELECT DATE_TRUNC(refund_ts, quarter) as quarter,
  COUNT(refund_ts) as refunds
FROM core.order_status
WHERE EXTRACT(year from refund_ts) = 2021
GROUP BY 1
ORDER BY 1;

-- by week
SELECT DATE_TRUNC(refund_ts, week) as week,
  COUNT(refund_ts) as refunds
FROM core.order_status
WHERE EXTRACT(year from refund_ts) = 2021
GROUP BY 1
ORDER BY 1;

-- For each region, what’s the total number of customers and the total number of orders? Sort alphabetically by region.
SELECT
  gl.region,
  COUNT(DISTINCT cust.id) AS customer_count,
  COUNT(DISTINCT ords.id) AS orders_count
FROM core.orders ords
LEFT JOIN core.customers cust
  ON cust.id = ords.customer_id
LEFT JOIN core.geo_lookup gl
  ON gl.country_code = cust.country_code
GROUP BY 1
ORDER BY 1;

-- What’s the average time to deliver for each purchase platform? 
SELECT purchase_platform,
  ROUND(AVG(DATE_DIFF(os.delivery_ts, os.purchase_ts, day)), 4) as avg_time_to_deliver
FROM core.order_status os
LEFT JOIN core.orders o
  ON os.order_id = o.id
GROUP BY 1; 

-- What were the top 2 regions for Macbook sales in 2020? 

SELECT gl.region,
  ROUND(SUM(o.usd_price), 2) as macbook_sales
FROM core.orders o
LEFT JOIN core.customers c
  ON o.customer_id = c.id
LEFT JOIN core.geo_lookup gl
  ON c.country_code = gl.country_code
WHERE lower(o.product_name) LIKE '%macbook%'
AND EXTRACT(year from purchase_ts) = 2020
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 2;

-- For each purchase platform, return the top 3 customers by the number of purchases and order them within that platform. If there is a tie, break the tie using any order. 

WITH customer_purchase_count as(
  SELECT purchase_platform,
    customer_id,
    COUNT(id) as num_purchases
  FROM core.orders
  GROUP BY 1,2
)

SELECT *,
  ROW_NUMBER() OVER (PARTITION BY purchase_platform ORDER BY num_purchases DESC) as order_ranking
FROM customer_purchase_count
QUALIFY ROW_NUMBER() OVER (PARTITION BY purchase_platform ORDER BY num_purchases DESC) <= 3;

-- What was the most-purchased brand in the APAC region?
SELECT CASE WHEN o.product_name LIKE 'Apple%' OR o.product_name LIKE 'Macbook%' THEN 'Apple'
  WHEN o.product_name LIKE 'Samsung%' THEN 'Samsung'
  WHEN o.product_name LIKE 'ThinkPad%' THEN 'ThinkPad'
  WHEN o.product_name LIKE 'bose%' THEN 'Bose'
  ELSE 'Unknown' END AS brand,
  COUNT(o.id) as order_count,
FROM core.orders o
LEFT JOIN core.customers c
  ON o.customer_id = c.id
LEFT JOIN core.geo_lookup gl
  ON c.country_code = gl.country_code
WHERE gl.region = 'APAC'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Of people who bought Apple products, which 5 customers have the top average order value, ranked from highest AOV to lowest AOV? 

WITH aov_apple AS (
  SELECT c.id as customer_id,
    AVG(usd_price) as aov,
  FROM core.orders o
  LEFT JOIN core.customers c
    ON o.customer_id = c.id
  WHERE lower(product_name) LIKE '%macbook%' OR lower(product_name) LIKE '%apple%'
  GROUP BY 1
)

SELECT *,
  ROW_NUMBER() OVER (ORDER BY aov DESC) as customer_ranking
FROM aov_apple
  QUALIFY ROW_NUMBER() OVER (ORDER BY aov DESC) <= 5;

-- Within each purchase platform, what are the top two marketing channels ranked by average order value?

WITH marketing_sales as (
  SELECT purchase_platform,
    marketing_channel,
    ROUND(AVG(usd_price), 2) as aov
  FROM core.orders
  LEFT JOIN core.customers
    ON orders.customer_id = customers.id
  GROUP BY 1,2)

SELECT *,
  ROW_NUMBER() OVER (PARTITION BY purchase_platform ORDER BY aov DESC) as ranking
FROM marketing_sales
QUALIFY ROW_NUMBER() OVER (PARTITION BY purchase_platform ORDER BY aov DESC) <= 2;
