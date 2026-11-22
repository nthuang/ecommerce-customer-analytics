# E-Commerce Customer Analytics

## Overview

This project analyzes Brazilian e-commerce marketplace data to understand customer behavior, purchasing patterns, retention, order delivery, and customer satisfaction.

The source data contains approximately 100,000 orders from Olist, one of the largest Brazilian e-commerce marketplaces. The project will combine transactional, customer, product, seller, payment, review, and geographic data to build an end-to-end customer analytics workflow.

**Primary goal:** transform raw marketplace data into a reproducible analytics pipeline and deliver actionable insights for customer retention, revenue growth, and operational improvement.

## Business Questions

- What factors are associated with repeat purchases and customer retention?
- Which customer segments generate the most revenue and place the most orders?
- How do order value and payment behavior vary by customer segment?
- Which product categories contribute most to revenue and order volume?
- How does delivery performance relate to review scores and customer satisfaction?
- Which regions contain high-value or frequently purchasing customers?

## Current Status

Data discovery, exploratory analysis, customer feature engineering, and an initial rule-based customer segmentation are complete in pandas.

The notebooks are organized by task:

- `data_exploration.ipynb` profiles source tables and validates their keys and relationships.
- `eda.ipynb` explores revenue, category, repeat-purchase, delivery, geographic, and payment patterns.
- `customer_features.ipynb` builds validated order- and customer-level tables, assigns interpretable customer segments, and exports processed CSVs.
- `sql/` contains PostgreSQL raw-data loading and analytics-view definitions, including seller-level delivery and review measures. The order and customer views have been reconciled against the pandas outputs.

**Next milestone:** assemble and validate the Power BI report using the setup and measures in `powerbi/`. Churn modeling is deferred until a time-based target and observation window are defined.

## Executive Summary

The analysis uses delivered orders purchased between September 2016 and August 2018. Revenue is the sum of item prices and excludes freight.

- **Revenue and categories:** Delivered-order revenue peaked in November 2017 at R$987,765 across 7,289 orders. Health and beauty, watches and gifts, and bed, bath, and table were the top three categories by item revenue.
- **Repeat purchasing:** 2,801 of 93,358 customers with delivered orders purchased more than once in the observed period (3.00%). This is a historical repeat rate, not a lifetime churn measure.
- **Delivery and reviews:** Average delivery time was 12.52 days. One-star orders averaged 21.32 delivery days versus 10.68 days for five-star orders; the correlation was -0.334. This is an association, not proof of causation.
- **Customer segments:** Two higher-spend one-time-buyer segments represented about 48.5% of customers and 78.65% of item revenue. These median-based segments describe the historical dataset and are not a current customer contact list.

Potential actions are to test second-purchase campaigns with a holdout group, investigate delivery delays in the lowest-rated segments, and validate category margins before changing inventory or promotions. Campaign effectiveness and profitability are not measured in the current dataset.

## Dataset

The project uses the public Olist Brazilian E-Commerce Dataset. The raw data is organized into the following tables:

| Table | Description | Granularity |
|---|---|---|
| `customers` | Customer location and unique customer identifiers | Customer |
| `orders` | Purchase, approval, delivery, and status timestamps | Order |
| `order_items` | Products and sellers associated with each order | Order item |
| `payments` | Payment type, installments, and transaction value | Order payment |
| `reviews` | Customer review scores and written feedback | Review record |
| `products` | Product characteristics and category | Product |
| `sellers` | Seller location | Seller |
| `category_translation` | Portuguese-to-English product category names | Product category |
| `geolocation` | Geographic coordinates and Brazilian ZIP prefixes | Location |

Raw CSV files are stored in `data/raw/`.

## Project Roadmap

1. **Data quality assessment**
   - Document missing and inconsistent values
   - Identify status-dependent delivery fields
   - Validate joins and detect duplicate or orphaned records

2. **SQL data modeling**
   - PostgreSQL raw-table DDL and CSV load script executed
   - Order-fact and customer-feature views executed
   - Row counts, revenue, and customer features reconciled with pandas

3. **Customer feature engineering**
   - RFM-style recency, frequency, monetary value, average order value, and repeat-purchase features built in pandas
   - SQL feature view reconciled with the pandas output
   - Delivery-time and latest-review measures added at order grain
   - Add customer-level product-category preferences

4. **Customer segmentation**
   - Five rule-based, median-threshold segments created and profiled in pandas
   - Validate segments with cohort and category-level analysis
   - Consider clustering only if it adds interpretable value beyond the baseline segments

5. **Business analysis**
   - Revenue, category, repeat-purchase, geographic, payment, and delivery/review EDA completed
   - Seller-level delivery and review metrics built in SQL

6. **Reporting**
   - Executive summary drafted in this README
   - Power BI data model, measures, and report layout prepared
   - Assemble and validate the `.pbix` report in Power BI Desktop
   - Visualization exports
   - SQL and Python reproducibility

## Repository Structure

```text
ecommerce-customer-analytics/
|-- data/
|   `-- raw/                 # Source CSV datasets
|-- notebooks/
|   |-- data_exploration.ipynb
|   |-- eda.ipynb
|   `-- customer_features.ipynb
|-- sql/
|   |-- 00_load_raw.psql
|   |-- 01_order_fact.sql
|   |-- 02_customer_features.sql
|   |-- 03_seller_performance.sql
|   |-- 04_export_powerbi.psql
|   `-- README.md
|-- powerbi/
|   |-- README.md
|   `-- measures.dax
|-- requirements.txt
`-- README.md
```

Additional folders and scripts will be added as the transformation and reporting stages are completed.

## Environment Setup

### Prerequisites

- Python 3.10 or later
- A virtual environment tool

### Installation

From the project root:

```bash
# Create a virtual environment
python -m venv .venv

# Activate on Windows PowerShell
.venv\Scripts\Activate.ps1

# Install dependencies
python -m pip install -r requirements.txt
```

If PowerShell blocks virtual environment activation, run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Then activate the environment again.

### Launch the Notebook

```bash
jupyter notebook notebooks/eda.ipynb
```

## Tools and Technologies

- Python
- Pandas
- NumPy
- Jupyter Notebook
- Matplotlib
- SQLAlchemy
- PostgreSQL-compatible SQL
- PostgreSQL

## Example Analytics Outputs

As the project develops, key deliverables will include:

- Customer segment profiles
- RFM distribution and segment summaries
- Repeat-purchase rates
- Revenue and order trends
- Top product categories
- Regional sales performance
- Delivery-time and review-score analysis
- Prioritized business recommendations

## Key Skills Demonstrated

- Data cleaning and validation
- Relational data analysis
- SQL-based transformation and modeling
- Exploratory data analysis
- Customer segmentation
- Feature engineering
- Data visualization
- Statistical and business interpretation
- Reproducible analytics documentation

## Data Source

The source project is the Olist Brazilian E-Commerce Dataset. This project is an independent analysis of the public dataset and is not affiliated with Olist.