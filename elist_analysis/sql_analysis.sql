-- ELIST ANALYSIS QUESTIONS
-- What is the date of the earliest and latest order, returned in one query?
SELECT MAX(purchase_ts) latest_order, 
  MIN(purchase_ts) earliest_order
FROM elistcore.core.orders; 

-- What is the average order value for purchases made in USD? What about average order value for purchases made in USD in 2019?
SELECT AVG(usd_price) aov
FROM elistcore.core.orders
WHERE currency = 'USD'
AND EXTRACT(YEAR FROM purchase_ts) = 2019; 
--and purchase_ts between '2019-01-01' and '2020-01-01'
--and purchase_ts >= '2019-01-01' and purchase_ts <= '2019-12-31'

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


