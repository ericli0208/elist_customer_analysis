## Initial Request

The main points in our analysis are:
- What were the overall trends in sales during this time?
- What were our monthly and yearly growth rates? *(focusing on sales, average order value (AOV), and product count)*
- How is the new loyalty program performing? Should we keep using it? *(focusing on sales, average order value (AOV), and product count)*
- What were our refund rates and average order values? *(focusing on Apple products and also including number of refunds as a metric)*

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

### Metrics Broken Down (Pivot Functions)
| Metrics | Pivot Info |
|---|---|
| Number of Orders | Count of Order_ID |
| Total Sales (USD)  | Sum of USD_Price |
| Average Order Value (AOV) | Average of USD_Price | 
| Time to Ship | Ship_TS - Purchase_TS_CLEANED (# Days) |
| Time to Deliver | Delivery_TS - Ship_TS (# Days) |
| Refund Rate | Average of Refunded (%) |
| Growth Rate | (Current Month Value - Previous Month Value) / Previous Month Value <br> OR <br> (Current Month Value / Previous Month Value) - 1 |

## Findings

See the full Excel pivot analysis [here](https://github.com/ericli0208/elist_customer_analysis/blob/main/elist_analysis/elist_analysis.xlsx)
### What were the overall trends in sales during this time? 
![image](https://github.com/user-attachments/assets/1611fe9f-ed65-40b8-9f18-89cc310b4c13)
### What were our monthly and yearly growth rates? *(focusing on sales, average order value (AOV), and product count)*
![image](https://github.com/user-attachments/assets/d5bd2c9d-86b8-487e-92dc-7796982a62fa)
![image](https://github.com/user-attachments/assets/b7f7bc8b-31bf-4ce5-854e-e15c6d80b906)
### How is the new loyalty program performing? Should we keep using it? *(focusing on sales, average order value (AOV), and product count)*
![image](https://github.com/user-attachments/assets/74b0337b-f815-4b47-9bc7-3e9ff894b8b4)
### What were our refund rates and average order values? *(focusing on Apple products and also including number of refunds as a metric)*
![image](https://github.com/user-attachments/assets/73332417-5e14-4ec1-8955-31b5506764f5)

