# Power BI dashboard

This folder contains the model setup and report plan for a Power BI report. The `.pbix` file must be created and saved from Power BI Desktop; it is not generated in this Linux workspace.

## Load the data

1. From the repository root, export the PostgreSQL views:
   ```bash
   psql -d ecommerce_analytics -v ON_ERROR_STOP=1 -f sql/04_export_powerbi.psql
   ```
   This creates `data/processed/powerbi_order_fact.csv` and `data/processed/powerbi_seller_performance.csv`.
2. Confirm `data/processed/customer_segments.csv` exists. If it does not, run the customer-feature notebook first.
3. In Power BI Desktop, use **Get data → Text/CSV** to load all three CSVs:
   - `powerbi_order_fact.csv`; rename the table to `order_fact`.
   - `powerbi_seller_performance.csv`; rename the table to `seller_performance`.
   - `customer_segments.csv`; rename the table to `CustomerSegments`.
4. In Model view, create a one-to-many, single-direction relationship from `CustomerSegments[customer_unique_id]` to `order_fact[customer_unique_id]`. Keep `seller_performance` disconnected: it is already aggregated by seller, while `order_fact` has one row per order and no seller key.
5. Confirm `CustomerSegments[is_repeat_customer]` is a True/False column and the order timestamps are typed as Date/Time.
6. Add the measures in [`measures.dax`](./measures.dax).

The exports are local and ignored by Git; no database credentials are needed in Power BI. After rebuilding the SQL views or customer segments, rerun the export and refresh the CSV queries in Power BI.

## Report pages

### Executive overview

- KPI cards: item revenue, delivered orders, average order value, customer count, repeat-customer rate, average delivery days, and average review score.
- Monthly line chart: item revenue by `order_fact[order_purchase_timestamp]` date hierarchy.
- Add a purchase-date slicer. Keep the report's revenue definition as item price, excluding freight.
- Customer counts, repeat rate, and segment metrics are based on the full historical customer snapshot; a purchase-date slicer does not recalculate them.

### Customer segments

- Bar chart: customer count by segment.
- Bar or treemap: customer revenue by segment, with the revenue-share measure in the tooltip.
- Table: segment, customer count, revenue, repeat rate, and average recency.
- Add segment and customer-state slicers from `CustomerSegments`; state is each customer's latest recorded state, not necessarily their location at every order date.

### Seller operations

- Table or bar charts by seller for average review score, late-delivery rate, and average days versus estimate.
- Include seller-order count and review count in tooltips.
- Apply a visual-level filter of at least 20 reviews when ranking sellers; this is a suggested exploratory threshold, not a statistical guarantee.

Seller metrics describe delivered seller-order records. An order-level review is associated with every seller on a multi-seller order, so seller review comparisons are not causal seller ratings. The seller table is disconnected from the customer/order tables; its slicers do not filter the other pages.
