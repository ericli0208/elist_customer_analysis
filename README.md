# Elist Sales Analysis

## Company Background
Founded in 2018, **Elist is an e-commerce company that sells popular electronics products** and has since expanded to a global customer base. 
Like most e-commerce companies, Elist sells products through their online site as well as through their mobile app. 
They use a variety of marketing channels to reach customers, including Email campaigns, SEO, and affiliate links. 
Over the last few years, their more popular products have been products from Apple, Samsung, and ThinkPad.

## Overview
There is an upcoming company-wide town hall, in which leadership would like to present a walkthrough of order trends from 2019-2022. Furthermore, a deeper understanding of Elist's performance will improve day-to-day processes and help the company deliver top-notch products to customers around the world. The following questions require further analysis from the analytics team: 
- What were the overal trends in sales during this time?
- What were our monthly and yearly growth rates?
- How is the new loyalty program performing? Should we keep using it?
- What were our refund rates and average order value?
  
The company has a core dataset consisting of orders, order statuses, customers, products, and geographic information. 

The ERD for the dataset can be found [here](https://github.com/ericli0208/elist_customer_analysis/blob/main/ERD.md).

All analysis files (Excel and SQL) can be found [here](https://github.com/ericli0208/elist_customer_analysis/tree/main/elist_analysis).

The interactive Tableau dashboard for Sales and Order can be found [here](https://public.tableau.com/app/profile/ericli0208/viz/ElistAnalysis/Dashboard1)

## Deep-Dive Insights

Our north star metrics and key dimensions for analysis are as follows: 

| North Star Metrics  |
|---|
| Number of Orders |
| Total Sales (USD)  |
| Average Order Value (AOV) |
| Time to Ship |
| Time to Deliver |
| Refund Rate |

| Key Dimensions | 
|---|
| Time (month, quarter, year) |
|  Geography (country, region, currency |
| Product (item, brand) |
| User (marketing channel, account creation method, account creation date, loyalty program) |
| Platform (purchase platform, registration platform) |

#### Metrics Broken Down (Pivot Functions)
| Metrics | Pivot Info |
|---|---|
| Number of Orders | Count of Order_ID |
| Total Sales (USD)  | Sum of USD_Price |
| Average Order Value (AOV) | Average of USD_Price | 
| Time to Ship | Ship_TS - Purchase_TS_CLEANED (# Days) |
| Time to Deliver | Delivery_TS - Ship_TS (# Days) |
| Refund Rate | Average of Refunded (%) |
| Growth Rate | (Current Month Value - Previous Month Value) / Previous Month Value <br> OR <br> (Current Month Value / Previous Month Value) - 1 |

Initial data cleaning log can be found [here](https://github.com/ericli0208/elist_customer_analysis/blob/main/source_data/elist_issue_log.xlsx)

### Sales Trends
![image](https://github.com/user-attachments/assets/1611fe9f-ed65-40b8-9f18-89cc310b4c13)
![image](https://github.com/user-attachments/assets/f1bbbfa4-6fca-4c90-aba6-21ca8e5a442f)
![image](https://github.com/user-attachments/assets/7019f634-0505-43ba-afbd-33d6e395aa36)
![image](https://github.com/user-attachments/assets/283f1e66-1d88-4414-942a-f3c199f92395)

- **Product View**: Apple Airpods are the most popular product by order count at 45% of total orders. The 27in 4K Gaming Monitor is Elist's top revenue generating product at almost $10M in total sales. 
- **Region View**: LATAM and APAC were the regions with lowest sales percentages at 6% and 12% respectively. However, APAC appears to have the highest average order value (AOV) by a significant margin at $280. Increasing brand reach within the APAC region could potentially drive future sales growth.
- **Country View**: Of the 191 total countries ordering on Elist, the top 20 produced 87% of total sales revenue at $24.5M. Elist should continue targeting these countries in order to maintain strong sales presence. Additional analysis from country to country may be useful in identifying similarities in sales data based on proximity and region. Furthermore, the highlighted countries could serve as a "hub" for increased product and consumer awareness to nearby/adjacent countries.

### Growth Rates
![image](https://github.com/user-attachments/assets/76eaa1b4-ba29-4652-9eca-f113d4f60f64)
![image](https://github.com/user-attachments/assets/1f7c5d9f-a5f2-46c0-8771-fd71b423a3ce)
![image](https://github.com/user-attachments/assets/3b030f6e-adcd-4935-9c0f-1f20ee5158a6)
![image](https://github.com/user-attachments/assets/62974b20-c8c3-4aeb-b770-1bd90faf6fa2)

- **Annual View**: From 2019 to 2022, average number of sales per year was 27K, with average yearly sale revenue of $7M and average order value of $254. 2021 saw the highest number of sales (36K), but 2020 had on average the most expensive sales (AOV of $300). Also interesting to note is the high overall sales activity occurring in 2020 compared to all other years, suggesting a spike in sales during the pandemic. The average order value rose by 31% in 2020 but has since returned to pre-pandemic levels.
- **Month View**: Elist sees consistent, year-to-year surges in sales in Q4, suggesting opportunities to increase holiday and end of year marketing campaigns. The worst sales months are in February and October, where sales drop ~27% on average. These are key timeframes to improve on moving forward. 
- **Growth Rates View**: 2020 had by far the highest growth rate, with more than double the number of sales and the total sales revenue than 2019. On average, 2020 sales were also 31% more expensive than 2019 sales. While 2021 exhibited positive growth in the number of sales, total sales revenue went down, as people purchased items that were an average of 15% less expensive than in 2021.
  
### Loyalty Program
![image](https://github.com/user-attachments/assets/e4678443-b5be-4013-bafe-84d72f19a12a)
![image](https://github.com/user-attachments/assets/5972794d-5e2c-46da-96eb-e979f68903d5)
![image](https://github.com/user-attachments/assets/15c9f06b-8c79-4615-8314-e00fa788e527)
![image](https://github.com/user-attachments/assets/5e16f809-71d7-4827-8d4b-621d1b4ec280)

During 2019 and 2020, loyalty program customers made fewer purchases than non-loyalty program customers, and their purchases were less expensive than non-loyalty customers. However, in more recent years (2021-2022), loyalty customers not only made more purchases than non-loyalty customers, but also purchased about $30 more on average in 2022. The loyalty program has seen significant growth over the past few years; members contributed 9% of of total sales revenue in 2019, which grew to 57% in 2022. The direct marketing channel appears to be the most effective method, for both non-loyalty (82% of total orders) and loyalty members (72%). 

### Refund Rates
![image](https://github.com/user-attachments/assets/44090d65-4065-4362-9339-a2bf0360ef9b)
![image](https://github.com/user-attachments/assets/d82fdd81-dba4-4bf5-98f2-8b26c149fc4a)

2020 had the highest amount of refunds at 10%, while 2022 had the lowest at 0%. Further determination is needed for why 2022 yielded no returns throughout the year, which may indicate a data input/completeness error. 

By product, The ThinkPad Laptop (12%) and Macbook Air Laptop (11%) have the highest refund rates, while the Apple Airpods Headphones (2,636) and 27in 4K Gaming Monitor (1,444) have the highest number of refunds.

### Additional SQL Insights
- Loyalty members had a lower average **time to purchase** (between the account creation and first purchase date) at 50 days, while non-loyalty members averaged around 70 days. 
- Apple Airpods Headphones were the most popular product across all regions (the highest was 18K units sold in North America).
- In North America, Macbook sales averaged 98 units and $155K in revenue per quarter.
- Customer and Order Count by Region is as follows (excluding null region values):

| region | customer_count | order_count |
|--------|----------------|-------------|
| APAC   | 9,020          | 9,786       |
| EMEA   | 21,829         | 23,766      |
| LATAM  | 4,963          | 5,322       |
| NA     | 38,714         | 41,874      |

- Purchases made on the website and mobile app had very similar average **time to deliver** stats (between purchase and delivery date) at ~ 7.5 days
- North America held the most Macbook sales across all years at $2,485,793.47.
- APAC's highest purchased brand was Apple.
- Based on average order value, social media marketing performed best for purchases made on the mobile app, and affiliate marketing performed best for purchases made on the website.

## Recommendations 
### Product
- Continue prioritizing marketing incentives on the Airpods, Gaming Monitor, Macbook Air, and ThinkPad Laptop, as these 4 products are the top revenue generators at 97% total revenue.
- Diversify the product portfolio and perform usability and focus group testing to expand into new product lines (i.e. Apple charging cables), in order to provide high upsell opportunities for existing products. 
### Loyalty Program
- Offer consistent campaigns to increase loyalty program acquisition and customer lifetime value of existing members using promotions, one-time offers, and free shipping.
- In order to convert non-members, consider offering a one-time sign-up discount paired with increased general marketing of membership benefits and savings.
### Marketing
- Continue to make investments into the direct and email marketing channels. These continue to provide strong growth and contributions to sales.
- Consider increasing marketing efforts on social media channels and through affiliates, as both yield strong average order values for mobile app and website purchases.
- Plan and execute special promotions, launches, and events in historically underperforming months (February and October) in order to boost overall sales.
### Refunds
- Investigate the reason for high refund rates associated with the Apple iPhone, Gaming Monitor, ThinkPad and Macbook Air Laptops.
- Plan for strategies to improve overall customer satisfaction (updating product descriptions, building online customer review sections, implementing stricter product quality checks, etc). 
- Confirm whether a no-refund policy was implemented or if no data was collected in 2022.
