CREATE SCHEMA IF NOT EXISTS analytics;

CREATE OR REPLACE VIEW analytics.order_fact AS
WITH delivered_orders AS (
    SELECT
        order_id,
        customer_id,
        order_purchase_timestamp,
        order_delivered_customer_date,
        order_estimated_delivery_date
    FROM raw.orders
    WHERE order_status = 'delivered'
),
item_metrics AS (
    SELECT
        order_id,
        COUNT(order_item_id)::BIGINT AS order_item_count,
        SUM(price) AS item_revenue,
        SUM(freight_value) AS freight_value
    FROM raw.order_items
    GROUP BY order_id
),
payment_metrics AS (
    SELECT
        order_id,
        COUNT(payment_sequential)::BIGINT AS payment_row_count,
        SUM(payment_value) AS payment_value,
        COUNT(DISTINCT payment_type)::BIGINT AS payment_method_count
    FROM raw.payments
    GROUP BY order_id
),
ranked_reviews AS (
    SELECT
        order_id,
        review_score,
        review_creation_date,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY
                review_creation_date DESC,
                review_answer_timestamp DESC,
                review_id DESC
        ) AS review_rank
    FROM raw.reviews
),
latest_reviews AS (
    SELECT
        order_id,
        review_score,
        review_creation_date
    FROM ranked_reviews
    WHERE review_rank = 1
)
SELECT
    orders.order_id,
    orders.customer_id,
    customers.customer_unique_id,
    customers.customer_state,
    orders.order_purchase_timestamp,
    orders.order_delivered_customer_date,
    orders.order_estimated_delivery_date,
    item_metrics.order_item_count,
    item_metrics.item_revenue,
    item_metrics.freight_value,
    payment_metrics.payment_row_count,
    payment_metrics.payment_value,
    payment_metrics.payment_method_count,
    latest_reviews.review_score,
    latest_reviews.review_creation_date,
    EXTRACT(
        EPOCH FROM (
            orders.order_delivered_customer_date
            - orders.order_purchase_timestamp
        )
    ) / 86400.0 AS delivery_days
FROM delivered_orders AS orders
LEFT JOIN raw.customers AS customers
    ON customers.customer_id = orders.customer_id
LEFT JOIN item_metrics
    ON item_metrics.order_id = orders.order_id
LEFT JOIN payment_metrics
    ON payment_metrics.order_id = orders.order_id
LEFT JOIN latest_reviews
    ON latest_reviews.order_id = orders.order_id;
