SELECT order_status, COUNT(*) AS how_many
FROM `olist.orders_dataset`
GROUP BY order_status
ORDER BY how_many DESC
