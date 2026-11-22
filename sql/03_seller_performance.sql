CREATE SCHEMA IF NOT EXISTS analytics;

CREATE OR REPLACE VIEW analytics.seller_performance AS
WITH delivered_orders AS (
    SELECT
        order_id,
        order_purchase_timestamp,
        order_delivered_customer_date,
        order_estimated_delivery_date
    FROM raw.orders
    WHERE order_status = 'delivered'
),
seller_order_items AS (
    SELECT
        seller_id,
        order_id,
        COUNT(*)::BIGINT AS item_count,
        SUM(price) AS item_revenue,
        SUM(freight_value) AS freight_value
    FROM raw.order_items
    GROUP BY seller_id, order_id
),
ranked_reviews AS (
    SELECT
        order_id,
        review_score,
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
    SELECT order_id, review_score
    FROM ranked_reviews
    WHERE review_rank = 1
),
seller_order_metrics AS (
    SELECT
        seller_order_items.seller_id,
        seller_order_items.order_id,
        seller_order_items.item_count,
        seller_order_items.item_revenue,
        seller_order_items.freight_value,
        EXTRACT(
            EPOCH FROM (
                delivered_orders.order_delivered_customer_date
                - delivered_orders.order_purchase_timestamp
            )
        ) / 86400.0 AS delivery_days,
        delivered_orders.order_delivered_customer_date::DATE
            - delivered_orders.order_estimated_delivery_date::DATE
            AS days_vs_estimated,
        latest_reviews.review_score
    FROM seller_order_items
    JOIN delivered_orders
        ON delivered_orders.order_id = seller_order_items.order_id
    LEFT JOIN latest_reviews
        ON latest_reviews.order_id = seller_order_items.order_id
)
SELECT
    seller_id,
    COUNT(*)::BIGINT AS seller_order_count,
    SUM(item_count)::BIGINT AS item_count,
    SUM(item_revenue) AS item_revenue,
    SUM(freight_value) AS freight_value,
    COUNT(delivery_days)::BIGINT AS delivery_observation_count,
    AVG(delivery_days) AS average_delivery_days,
    COUNT(days_vs_estimated)::BIGINT AS schedule_observation_count,
    AVG(days_vs_estimated) AS average_days_vs_estimated,
    COUNT(*) FILTER (WHERE days_vs_estimated > 0)::NUMERIC
        / NULLIF(COUNT(days_vs_estimated), 0) AS late_delivery_rate,
    COUNT(review_score)::BIGINT AS review_count,
    AVG(review_score) AS average_review_score,
    COUNT(*) FILTER (WHERE review_score <= 2)::NUMERIC
        / NULLIF(COUNT(review_score), 0) AS low_review_rate
FROM seller_order_metrics
GROUP BY seller_id;
