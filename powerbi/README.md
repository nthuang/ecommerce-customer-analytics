# Power BI report

This folder contains the three-page Power BI report, screenshots, and a narrative summary of the findings. Open [`Ecommerce_Customer_Analytics.pbix`](Ecommerce_Customer_Analytics.pbix) in Power BI Desktop to inspect the interactive report. The screenshots in this folder are also embedded in the [main project README](../README.md).

The report uses three CSV tables: an order fact, customer segments, and seller performance. Detailed business interpretation is in [business_insights_and_recommendations.md](business_insights_and_recommendations.md).

## Report pages

### Order Performance

Shows delivered orders, item revenue, delivery time, review score, revenue by state, average delivery days by state, monthly revenue, and a state-level performance table. Revenue is item price and excludes freight.

### Customer Segmentation

Shows customer count and item revenue by historical customer segment, summary KPIs, a customer-state slicer, and a segment detail table. Segment recency and state describe the historical customer snapshot; they are not current customer attributes.

### Seller Performance

Shows top sellers by item revenue, seller-order counts, items sold, seller delivery and review measures, and a scatter plot of seller late-delivery rate against review score. Seller IDs are the dataset's opaque identifiers.

## Open or refresh the report

### Open the existing report

1. Open `Ecommerce_Customer_Analytics.pbix` in Power BI Desktop.
2. If Power BI prompts for missing CSV sources, recreate the CSVs as described below and point the queries to those files.
3. Refresh the queries after the source data or SQL views change.

### Recreate the CSV sources

The raw and processed CSVs are local files excluded from Git. Download the [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and extract it under `data/raw/`, preserving the original filenames.

1. Set up Python and run `customer_features.ipynb` from the `notebooks/` directory. This creates `data/processed/customer_segments.csv`. See the [main README](../README.md) for environment setup.
2. Configure `DATABASE_URL` for a dedicated PostgreSQL database. From the repository root, load the raw tables and build the views using the commands in [sql/README.md](../sql/README.md).
3. Run `sql/04_export_powerbi.psql` from the repository root to create:
   - `data/processed/powerbi_order_fact.csv`
   - `data/processed/powerbi_seller_performance.csv`
4. In Power BI Desktop, use **Get data → Text/CSV** to load the three files. Keep these table names:
   - `powerbi_order_fact`
   - `powerbi_seller_performance`
   - `customer_segments`
5. Create a one-to-many, single-direction relationship from `customer_segments[customer_unique_id]` to `powerbi_order_fact[customer_unique_id]`. Keep `powerbi_seller_performance` disconnected: it is aggregated by seller, while the order fact has no seller key.
6. Confirm `customer_segments[is_repeat_customer]` is Boolean and order timestamps are Date/Time.

The raw SQL loader stages customers, orders, order items, payments, and reviews. The Python notebooks use additional source CSVs for exploration and analysis. Run the loader only once against empty project tables; see [sql/README.md](../sql/README.md) for the full workflow and validation details.

The report model and its DAX measures are maintained in the PBIX. A separate `measures.dax` export is not required for this workflow; edit the measures in Power BI Desktop.

## Metric definitions and interpretation

- **Revenue:** item price in Brazilian reais; excludes freight, costs, and profit.
- **Revenue currency display:** revenue is formatted in Brazilian reais (**R$**) in the current report screenshots. Confirm the formatting remains correct after refreshing the CSV sources.
- **Order delivery average:** 12.56 days across 96,470 delivered orders with valid delivery timestamps. The EDA value of 12.52 days includes only the 95,824 delivered orders that also have a review.
- **Average order value:** the Order Performance KPI is calculated at order grain. The customer segment table summarizes customer-level average order value; its total is not the same measure.
- **Customer measures:** customer count, repeat rate, and segments use the full historical customer snapshot. A purchase-date slicer does not recalculate those snapshot metrics.
- **Seller totals:** the table total averages sellers equally. Its 6.91% late-delivery rate and 4.18 average review score differ from the marketplace's seller-order/review-weighted figures of about 6.69% and 4.14. Label the chosen aggregation clearly.
- **Seller delivery average:** the seller table averages seller-level delivery measures; it is not directly comparable to the order-weighted delivery KPI.
- **Seller reviews:** an order-level review may be associated with each seller on a multi-seller order. Seller review measures are descriptive, not independent causal ratings.
- **Correlation filter:** the seller scatter is filtered to sellers with at least 20 reviews, matching the subset used for the reported correlation of about -0.53. This is an exploratory threshold, not a guarantee of statistical reliability.

## Final dashboard checklist

1. Confirm revenue measures and columns retain Brazilian Real (`R$`) formatting after refresh. Keep the values numeric; do not use DAX `FORMAT()` for measures used in charts.
2. Label the customer table metric as **Average customer AOV** and the order-page metric as **Average order value** so the different grains are explicit.
3. Keep the existing per-seller averages if they are useful for comparing sellers, but use weighted measures for marketplace-wide late rate and review score. Add these measures in Power BI:

   ```DAX
   Marketplace Late Rate (weighted) =
   DIVIDE(
       SUMX(
           powerbi_seller_performance,
           powerbi_seller_performance[late_delivery_rate]
               * powerbi_seller_performance[schedule_observation_count]
       ),
       SUM(powerbi_seller_performance[schedule_observation_count])
   )
   ```

   ```DAX
   Marketplace Review Score (weighted) =
   DIVIDE(
       SUMX(
           powerbi_seller_performance,
           powerbi_seller_performance[average_review_score]
               * powerbi_seller_performance[review_count]
       ),
       SUM(powerbi_seller_performance[review_count])
   )
   ```

   These weight each seller's rate or score by its eligible seller-order or review count, respectively. Use them for marketplace-wide KPI cards; keep the per-seller values in seller comparisons.
4. Confirm the scatter plot retains its visual-level `review_count >= 20` filter so its displayed sellers match the subset used for the reported correlation.
5. Save the PBIX, close and reopen it to confirm it loads, then export fresh screenshots and replace the old PNGs in this folder.

## Report assets

- [Customer Segmentation screenshot](customer_segmentation.png)
- [Order Performance screenshot](order_performance.png)
- [Seller Performance screenshot](seller_performance.png)
- [Business insights and recommendations](business_insights_and_recommendations.md)
