CREATE SCHEMA IF NOT EXISTS analytics;

CREATE OR REPLACE VIEW analytics.customer_features AS
WITH customer_metrics AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id)::BIGINT AS order_count,
        SUM(item_revenue) AS total_item_revenue,
        AVG(item_revenue) AS average_order_value,
        SUM(freight_value) AS total_freight_value,
        MIN(order_purchase_timestamp)::DATE AS first_order_date,
        MAX(order_purchase_timestamp)::DATE AS last_order_date
    FROM analytics.order_fact
    GROUP BY customer_unique_id
),
ranked_customer_states AS (
    SELECT
        customer_unique_id,
        customer_state,
        ROW_NUMBER() OVER (
            PARTITION BY customer_unique_id
            ORDER BY order_purchase_timestamp DESC, order_id DESC
        ) AS state_rank
    FROM analytics.order_fact
),
latest_customer_state AS (
    SELECT customer_unique_id, customer_state
    FROM ranked_customer_states
    WHERE state_rank = 1
),
analysis_snapshot AS (
    SELECT MAX(order_purchase_timestamp)::DATE AS snapshot_date
    FROM analytics.order_fact
)
SELECT
    metrics.customer_unique_id,
    latest_customer_state.customer_state,
    metrics.order_count,
    metrics.total_item_revenue,
    metrics.average_order_value,
    metrics.total_freight_value,
    metrics.first_order_date,
    metrics.last_order_date,
    analysis_snapshot.snapshot_date,
    analysis_snapshot.snapshot_date - metrics.last_order_date AS recency_days,
    metrics.order_count > 1 AS is_repeat_customer
FROM customer_metrics AS metrics
JOIN latest_customer_state
    ON latest_customer_state.customer_unique_id = metrics.customer_unique_id
CROSS JOIN analysis_snapshot;
