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

The ERD for the dataset can be found [here](https://github.com/ericli0208/elist_customer_analysis/blob/main/ERD.md)

## Deep-Dive Insights

### Overview
Initial data cleaning log can be found here [here](https://github.com/ericli0208/elist_customer_analysis/blob/main/source_data/elist_issue_log.xlsx)

### Sales Trends
![image](https://github.com/user-attachments/assets/1611fe9f-ed65-40b8-9f18-89cc310b4c13)
![image](https://github.com/user-attachments/assets/7019f634-0505-43ba-afbd-33d6e395aa36)
- **Product View**: Apple Airpods are the most popular product by order count at 45% of total orders. The 27in 4K Gaming Monitor is Elist's top revenue generating product at almost $10M in total sales. Ultimately, Elist should prioritize marketing for the Airpods, Gaming Monitor, Macbook Air, and ThinkPad Laptop, as these 4 products are the top revenue generators at 96% total revenue.
- **Region View**: LATAM and APAC were the regions with lowest sales percentages at 6% and 12% respectively. However, APAC appears to have the highest average order value (AOV) by a significant margin at $280. Increasing brand reach within the APAC region could potentially drive future sales growth.
- **Country View**: Of the 191 total countries ordering on Elist, the top 20 produced 87% of total sales revenue at $24.5M. Elist should continue targeting these countries in order to maintain strong sales presence. Additional analysis from country to country may be useful in identifying similarities in sales data based on proximity and region. Furthermore, the highlighted countries could serve as a "hub" for increased product and consumer awareness to nearby/adjacent countries.

### Growth Rates
![image](https://github.com/user-attachments/assets/d5bd2c9d-86b8-487e-92dc-7796982a62fa)
![image](https://github.com/user-attachments/assets/8d681638-86fe-4837-8001-66821741cb2d)

- **Annual View**: From 2019 to 2022, average number of sales per year was 27K, with average yearly sale revenue of $7M and average order value of $254. 2021 saw the highest number of sales (36K), but 2020 had on average the most expensive sales (AOV of $300). Also interesting to note is the high overall sales activity occurring in 2020 compared to all other years, suggesting a spike in sales during the pandemic. The average order value rose by 31% in 2020 but has since returned to pre-pandemic levels.
- **Month View**: Elist sees consistent, year-to-year surges in sales in Q4, suggesting opportunities to increase holiday and end of year marketing campaigns. The worst sales months are in February and October, where sales drop ~27% on average. These are key timeframes to improve on moving forward. 
- **Growth Rates View**: 2020 had by far the highest growth rate, with more than double the number of sales and the total sales revenue than 2019. On average, 2020 sales were also 31% more expensive than 2019 sales. While 2021 exhibited positive growth in the number of sales, total sales revenue went down, as people purchased items that were an average of 15% less expensive than in 2021.
  
### Loyalty Program
![image](https://github.com/user-attachments/assets/2c8dc258-ae61-427b-a025-a31d113fc6c4)

During 2019 and 2020, loyalty program customers made fewer purchases than non-loyalty program customers, and their purchases were less expensive than non-loyalty customers. However, in more recent years (2021-2022), loyalty customers not only made more purchases than non-loyalty customers, but also purchased about $30 more on average in 2022. 

### Refund Rates
![image](https://github.com/user-attachments/assets/73332417-5e14-4ec1-8955-31b5506764f5)
![image](https://github.com/user-attachments/assets/9ab53f93-f9b3-46e4-975e-4da13a257202)

2020 had the highest amount of refunds at 10%, while 2022 had the lowest at 0%. Further determination is needed for why 2022 yielded no returns throughout the year, which may indicate a data input/completeness error. 

By product, The ThinkPad Laptop (12%) and Macbook Air Laptop (11%) have the highest refund rates, while the Apple Airpods Headphones (2,636) and 27in 4K Gaming Monitor (1,444) have the highest number of refunds.
