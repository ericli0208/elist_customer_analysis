-- ELIST ANALYSIS QUESTIONS
-- 1. What is the date of the earliest and latest order, returned in one query?
SELECT MAX(purchase_ts) latest_order, 
  MIN(purchase_ts) earliest_order
FROM elistcore.core.orders; 

-- 2. What is the average order value for purchases made in USD? What about average order value for purchases made in USD in 2019?
SELECT AVG(usd_price) aov
FROM elistcore.core.orders
WHERE currency = 'USD'
AND EXTRACT(YEAR FROM purchase_ts) = 2019; 
--and purchase_ts between '2019-01-01' and '2020-01-01'
--and purchase_ts >= '2019-01-01' and purchase_ts <= '2019-12-31'

-- 3. Return the id, loyalty program status, and account creation date for customers who made an account on desktop or mobile. Rename the columns to more descriptive names.
SELECT id AS customer_id, 
  loyalty_program AS is_loyalty_program, 
  created_on AS account_creation_date
FROM elistcore.core.customers
WHERE account_creation_method IN ('desktop', 'mobile');

-- 4. What are all the unique products that were sold in AUD on website, sorted alphabetically?
SELECT DISTINCT product_name
FROM elistcore.core.orders
WHERE currency = 'AUD'
AND purchase_platform = 'website'
ORDER BY product_name; 

-- 5. What are the first 10 countries in the North American region, sorted in descending alphabetical order?
SELECT * 
FROM elistcore.core.geo_lookup
WHERE region = 'NA'
ORDER BY country_code DESC
LIMIT 10; 

