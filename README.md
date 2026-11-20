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

The project is in the data discovery and schema-validation stage.

The initial notebook:

- Loads and joins all available raw datasets
- Reviews table shapes and columns
- Identifies missing values
- Validates primary and foreign key relationships
- Checks row granularity across customers, orders, items, payments, and reviews
- Profiles the customer-to-order relationship

Planned work includes data cleaning, SQL transformations, customer-level feature engineering, RFM segmentation, churn or repeat-purchase modeling, interactive dashboards, and an executive findings summary.

## Dataset

The project uses the public Olist Brazilian E-Commerce Dataset. The raw data is organized into the following tables:

| Table | Description | Granularity |
|---|---|---|
| `customers` | Customer location and unique customer identifiers | Customer |
| `orders` | Purchase, approval, delivery, and status timestamps | Order |
| `order_items` | Products and sellers associated with each order | Order item |
| `payments` | Payment type, installments, and transaction value | Order payment |
| `reviews` | Customer review scores and written feedback | Order review |
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
   - Build a staging layer for cleaned source tables
   - Create an order-level fact table
   - Create a customer-level analytics table

3. **Customer feature engineering**
   - Recency, frequency, and monetary value
   - Average order value
   - Repeat-purchase indicator
   - Delivery-time metrics
   - Review-score metrics
   - Product-category preferences

4. **Customer segmentation**
   - RFM segmentation
   - Clustering using K-means or another interpretable method
   - Segment profiles and recommended marketing actions

5. **Business analysis**
   - Revenue and order trends
   - Customer and category concentration
   - Retention and repeat purchasing
   - Geographic performance
   - Delivery and review score relationships

6. **Reporting**
   - Interactive dashboard
   - Executive summary
   - Visualization exports
   - SQL and Python reproducibility

## Repository Structure

```text
ecommerce-customer-analytics/
|-- data/
|   `-- raw/                 # Source CSV datasets
|-- notebooks/
|   `-- data_exploration.ipynb
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
jupyter notebook notebooks/data_exploration.ipynb
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