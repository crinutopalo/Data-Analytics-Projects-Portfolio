SELECT
  p.payment_type AS payment_type,
  AVG(r.review_score) AS avg_review_score,
  COUNT(*) AS num_orders
FROM `olist.order_payments` AS p
JOIN `olist.order_reviews` AS r
  ON p.order_id = r.order_id
GROUP BY p.payment_type
ORDER BY avg_review_score DESC
