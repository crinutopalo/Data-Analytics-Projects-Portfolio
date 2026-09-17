WITH category_scores AS (
  SELECT
    p.product_category_name AS category_pt,
    t.string_field_1 AS category_en,
    AVG(r.review_score) AS avg_score,
    COUNT(*) AS num_orders
  FROM `olist.order_items` AS oi
  JOIN `olist.products_dataset` AS p ON oi.product_id = p.product_id
  JOIN `olist.order_reviews` AS r ON oi.order_id = r.order_id
  JOIN `olist.category_name_translation` AS t ON p.product_category_name = t.string_field_0
  GROUP BY category_pt, category_en
  HAVING COUNT(*) >= 100
)
SELECT
  category_pt,
  category_en,
  avg_score,
  num_orders,
  RANK() OVER (ORDER BY avg_score DESC) AS category_rank
FROM category_scores
ORDER BY avg_score ASC
