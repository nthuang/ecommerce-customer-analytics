# Business Insights and Recommendations

## Scope

These findings describe delivered Olist orders from September 2016 through August 2018. Item revenue is the sum of item prices and excludes freight, costs, and profit. Customer segments are historical, median-based groups; they are not a current customer contact list.

## 1. Business insights

### Order Performance

1. **Revenue is geographically concentrated.** Sao Paulo generated R$5.07M (38.33% of delivered-order revenue), followed by Rio de Janeiro at R$1.76M (13.31%) and Minas Gerais at R$1.55M (11.74%). Together, these states account for about 63.38% of revenue, so service levels in these major markets have an outsized effect on sales.
2. **Delivery times vary substantially by state, and the difference is relevant to customer experience.** In the Power BI order fact, average delivery was 12.56 days across 96,470 delivered orders with valid delivery timestamps. Sao Paulo averaged 8.76 days, while Roraima (29.39 days, 41 orders), Amapa (27.19 days, 67 orders), and Amazonas (26.43 days, 145 orders) were slower. Bahia is a higher-volume opportunity: 19.34 days across 3,256 orders. Separately, among orders with both a review and delivery time, one-star orders averaged 21.32 days versus 10.68 for five-star orders (r = -0.334). These patterns justify investigation, not a claim that delivery time alone caused low ratings.
3. **Revenue grew rapidly before stabilizing at a higher level.** Monthly delivered-order revenue rose from R$111,798 in January 2017 to R$987,765 across 7,289 orders in November 2017. During January-August 2018, monthly revenue ranged from about R$826,000 to R$978,000. The peak is useful for seasonal planning, while the later range is a better guide to the sustained run rate than a single peak month.

### Customer Segmentation

1. **Repeat purchasing is uncommon in the observed period.** 2,801 of 93,358 customers (3.00%) placed more than one delivered order, and repeat buyers contributed 5.51% of item revenue. This points to a potential second-purchase opportunity, but the rate is historical—not a lifetime churn measure—and customers had different amounts of time to return.
2. **Higher-spend one-time buyers account for most revenue.** The two higher-spend one-time segments generated about R$10.40M—78.65% of item revenue—from 48.5% of customers. A relevant follow-up purchase could protect substantial revenue; blanket discounting would be risky because margins and campaign outcomes are not measured here.
3. **The two higher-spend groups differ in recency.** The more-recent group is 24.5% of customers and 39.57% of revenue, with 112.48 average recency days in the dashboard; the less-recent group is 24.0% of customers and 39.08% of revenue, with 364.91 average recency days. The segments use one-time-buyer median cutoffs of 219 recency days and R$86.96 in item spend. After segmentation, the higher-spend recent and less-recent groups have median recencies of 115 and 346 days, respectively. In a live dataset, the first group could receive a timely second-purchase message while the second receives a separate win-back test. These recency labels refer to the 2018 snapshot, not today.

### Seller Performance

1. **A small group of sellers contributes a disproportionate share, but revenue also depends on more than order volume.** The 10 highest-revenue sellers generated about R$1.75M (13.27% of R$13.22M) while representing only 0.34% of 2,970 sellers. The top seller generated R$226,988 across 1,124 seller-orders; the second generated R$217,940 across 348—about R$202 versus R$626 in item revenue per seller-order. Product mix and revenue per order therefore matter alongside order count, and seller programs should support both top performers and the broader marketplace.
2. **Late delivery is a measurable operational issue.** Across 97,811 seller-order records with both delivery and estimate dates, the count-weighted late rate is 6.69%—roughly one in 15 eligible records. The dashboard's total row displays 6.91% because it averages each seller's late rate equally; use the weighted figure for the marketplace-wide rate, or label 6.91% as the average seller rate.
3. **Seller-level late rates and ratings move in opposite directions.** Across 800 sellers with at least 20 reviews, the correlation between late-delivery rate and average review score was about -0.53. A 20-order threshold gives a similar estimate across 804 sellers. The seller scatter is filtered to the same 20-review subset used for the reported correlation. This is a useful screening signal, not proof of seller fault: an order-level review can be associated with multiple sellers on a multi-seller order.

## 2. Actionable recommendations

### Improve customer retention

- For a current customer base, identify first-time buyers soon after delivery and test a relevant second-purchase message or offer. Use a randomized holdout so incremental repeat orders can be separated from purchases that would have happened anyway.
- Test recent high-spend and lapsed high-spend audiences separately. Compare incremental revenue after discount and fulfillment costs, not just clicks or gross sales; avoid treating these historical 2018 segments as current prospects.
- Define customer cohorts with a consistent observation window before labeling customers as churned. Track second-purchase rate, time to second purchase, and contribution margin by cohort and campaign.

### Improve delivery performance

- Break late deliveries and low ratings down by seller, origin/destination region, product category, and purchase period. Prioritize combinations with both meaningful order volume and poor outcomes.
- Review carrier handoffs, dispatch timing, and promised-versus-actual delivery for the highest-impact problem areas. Pilot corrective actions before changing customer-facing delivery estimates.
- Monitor late-delivery rate, median and upper-percentile delivery days, and review scores together. Treat the observed delivery-rating relationship as a hypothesis to test, not a causal conclusion.
- Prioritize high-volume service gaps such as Bahia for broad impact, while separately diagnosing extreme delays in low-volume northern states before committing substantial resources there.

### Improve seller quality

- Use a seller scorecard with order counts, review counts, late rate, average delivery days, and average review score. Show denominators and apply the 20-review threshold when ranking; it is a screening rule, not a statistical guarantee.
- Investigate sellers with both elevated late rates and weaker ratings, then agree on specific improvement actions and recheck results over a fixed period. Avoid penalizing sellers from a low review score alone because reviews are attached at order level.
- Learn from high-performing sellers' product mix and operating practices, and test assortment expansion only where margins, customer demand, and fulfillment capacity support it.
- Calculate marketplace-wide rates from their underlying counts (for example, late seller-orders divided by eligible seller-orders), rather than taking an unweighted average of seller percentages. This prevents low-volume sellers from influencing the overall KPI as much as high-volume sellers.

## Interpretation limits

- The dataset ends in August 2018. Findings are useful for demonstrating analysis and forming hypotheses, not for current customer targeting or present-day operating decisions.
- The Power BI order-fact average delivery time (12.56 days) uses 96,470 delivered orders with valid delivery timestamps. The EDA notebook's 12.52-day average uses 95,824 orders that also have a review. Keep the population and denominator explicit when presenting or comparing delivery averages.
- The customer page's R$137.04 order-level average order value differs from the R$137.51 customer-level average shown in the segment table; label those measures by their grain.
- Seller dashboard totals also use different grains: the displayed 6.91% and 4.18 are unweighted averages across sellers, while order-weighted late rate and review score are about 6.69% and 4.14. Decide whether each KPI describes the average seller or the average seller-order/review, and label it accordingly.
- Item revenue is not profit; the available analysis does not measure margin, promotion costs, or campaign effectiveness.
- Seller review measures are descriptive. A single order-level review may be attributed to each seller on a multi-seller order, so seller-level comparisons are not independent or causal ratings.

## Overall conclusion

The strongest opportunities are to earn more second purchases, reduce regional delivery friction, and manage seller quality with reliable denominators. Pilot retention and fulfillment actions, compare them against clear baselines or control groups, and scale only when incremental customer value and service improvements are demonstrated.
