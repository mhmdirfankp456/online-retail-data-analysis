# Online Retail Sales Analysis

Cleaning and analysing a messy online retail dataset using **Python, SQL (MySQL) and Power BI**.

> The dataset is **synthetic** (computer generated). It contains no real customers, and phone numbers and emails were removed before analysis.

## Business Question
Which products, categories and regions drive revenue, and where are the problems (returns, cancellations)?

## Tools Used
| Tool | Purpose |
|---|---|
| Python (pandas, Google Colab) | Data cleaning |
| MySQL 8.0 (Workbench) | Business queries and analysis |
| Power BI | Dashboard (in progress) |
| GitHub | Version control and portfolio |

## Dataset
- Raw file: 6,885 rows, 17 columns (`online_retail_messy.csv`)
- Cleaned file: 6,201 rows, 16 columns (`online_retail_cleaned.csv`)
- Columns: order, customer, city, state, order date, category, product, quantity, price, discount, payment method, order status, delivery days, rating

## Data Cleaning (Python)
The raw data was deliberately messy. Main problems fixed:

| Problem | Example | Fix |
|---|---|---|
| Messy column names | `Quantity ` , `Order ID` | Lowercase, no spaces |
| Spelling and case variants | `Delivrd`, `DELIVERED`, `delivered` (22 variants of 3 values) | Standardised to Delivered / Returned / Cancelled |
| Category typos | `Fashon`, `Electronic`, `Home&Kitchen` | Mapped to 5 clean categories |
| State and city variants | `MH`, `Maharastra`, `Bengalur` | Mapped to full names (9 states, 10 cities) |
| Payment variants | `COD`, ` Upi` (67 variants) | Reduced to 6 payment methods |
| Mixed date formats | `2025-08-08`, `28/09/2025`, `April 19, 2024`, Excel serial numbers | Converted to one date format |
| Numbers stored as text | `Rs. 5317.93`, `two`, `10%`, `4 stars` | Converted to numeric columns |
| Duplicate orders | Same `order_id` repeated | Kept the first row per order |
| Test rows | `TEST001`, name `asdf` | Removed |
| Impossible values | quantity 100, price 999999, rating 10, future date 2030 | Set to missing |
| Personal data | phone, email | Dropped |

Added a `revenue` column: `quantity x unit_price x (1 - discount/100)`.

Notebook: `Online_Retail_Data_Cleaning.ipynb`

## SQL Analysis
11 queries in `online_retail_analysis.sql`: summary metrics, category / state / product revenue, monthly trend, payment mix, return rate, top customers, month-over-month growth (`LAG`) and best product per category (`RANK`).

## Key Findings
- 83% of orders were delivered, 11% were returned and 6% cancelled.
- Home & Kitchen is the top category (29% of delivered revenue), followed by Fashion and Electronics.
- Maharashtra and Karnataka together generate nearly half of delivered revenue.
- Sports has the highest return rate (about 13%), worth investigating.
- UPI is the most used payment method (about 37%), followed by Cash on Delivery (about 20%).
- The top 10 customers contribute only about 17% of revenue, so revenue does not depend on a few buyers.

## Assumptions
- Revenue is counted only for **Delivered** orders.
- Dates like `11/02/2024` were read as day/month/year (Indian format).
- Missing values were left blank, not guessed. A missing discount was treated as 0.
- Values outside realistic ranges (for example quantity above 10) were treated as data errors.

## Files
| File | Description |
|---|---|
| `online_retail_messy.csv` | Raw messy data |
| `online_retail_cleaned.csv` | Cleaned data |
| `Online_Retail_Data_Cleaning.ipynb` | Python cleaning notebook |
| `online_retail_analysis.sql` | MySQL queries |

## Dashboard
Power BI dashboard coming soon.

## Author
Mohammed Irfan K P, Data Analyst (fresher), Malappuram, Kerala, India
