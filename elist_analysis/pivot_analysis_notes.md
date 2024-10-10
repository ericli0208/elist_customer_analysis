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
#### 
