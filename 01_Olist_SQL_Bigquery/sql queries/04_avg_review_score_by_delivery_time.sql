SELECT
  CASE
    WHEN TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY) <= 3 THEN '0-3 days'
    WHEN TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY) <= 7 THEN '4-7 days'
    WHEN TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY) <= 14 THEN '8-14 days'
    WHEN TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY) <= 30 THEN '15-30 days'
    WHEN TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY) <= 60 THEN '31-60 days'
    ELSE 'over 60 days'
  END AS delivery_time,
  AVG(r.review_score) AS avg_review_score,
  COUNT(*) AS num_orders
FROM `olist.orders_dataset` AS o
JOIN `olist.order_reviews` AS r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_time
ORDER BY delivery_time
