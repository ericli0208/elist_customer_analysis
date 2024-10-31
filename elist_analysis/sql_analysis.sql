-- ELIST ANALYSIS  - TARGETED BUSINESS QUESTIONS

-- What is the date of the earliest and latest order?
SELECT MAX(purchase_ts) latest_order, 
  MIN(purchase_ts) earliest_order
FROM elistcore.core.orders; 

-- What is the average order value for purchases made in USD across all years?
SELECT DATE_TRUNC(purchase_ts, year) as year,
  AVG(usd_price) as aov
FROM elistcore.core.orders
WHERE currency = 'USD'
GROUP BY 1
ORDER BY 1; 

-- Return the id, loyalty program status, and account creation date for customers who made an account on desktop or mobile. Rename the columns to more descriptive names.
SELECT id AS customer_id, 
  loyalty_program AS is_loyalty_program, 
  created_on AS account_creation_date
FROM elistcore.core.customers
WHERE account_creation_method IN ('desktop', 'mobile');

-- What are all the unique products that were sold in AUD on website, sorted alphabetically?
SELECT DISTINCT product_name
FROM elistcore.core.orders
WHERE currency = 'AUD'
AND purchase_platform = 'website'
ORDER BY product_name; 

-- What are the first 10 countries in the North American region, sorted in descending alphabetical order?
SELECT * 
FROM elistcore.core.geo_lookup
WHERE region = 'NA'
ORDER BY country_code DESC
LIMIT 10; 

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




