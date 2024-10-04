### **Orders_Data Tab**: 

(total of 108129 rows of transactions)

PURCHASE_TS - dates were incorrectly formatted (not in mm/dd/yyyy format), null and nonsensical values present
- Change values to Short Date
- Text to Columns - shifted incorrect dates as MDY format
- Changed "/N" value to blank to align with other blank values

REFUND_TS - 2 instances were future dated to 2025 (<1% error severity)
- removed 2025 values and left blank

PRODUCT_NAME - naming and syntax were inconsistent
- corrected instances of '27in"" 4k gaming monitor' to '27 In 4K Gaming Monitor'
- created new column with =PROPER() formula to enter all names as camel case, then converted to values only to reform new PRODUCT_NAME column

USD_PRICE, LOCAL_PRICE, AND CURRENCY - 158 instances of 0$ transactions (<1% error severity)
- left values as blank across all 3 columns
- products with null values include: 27 In 4K Gaming Monitor, Samsung Charging Cable Pack, Samsung Webcam, and Thinkpad Laptop

MARKETING_CHANNEL AND ACCOUNT_CREATION_METHOD - 1,387 instances of blank values (1.3% error severity)
- changed blank values to "unknown" 

COUNTRY_CODE - 140 blank values (<1% error severity)
- left as blank 


### **Country_Lookup Tab**: 
(total of 196 rows for countries & regions)
- Region for one instance of US was set to "North America"; changed to "NA" to align with other North American countries
- Region for one instance of US was set to "x"; changed to "NA"
- Country code "BJ" (Benin) had a missing region value; researched and assigned to "EMEA" region
- Country code "BM" (Bermuda) had a missing region value; researched and assigned to "LATAM" region
