-- Join customer_product_orders_json with our predictions using a LATERAL join
-- Display the original JSON input plus our AI response email
SELECT json_data, thank_you_output
FROM customer_product_orders_json as cpoj,
     LATERAL TABLE(ML_PREDICT('thank_you_bot', json_data))
  LIMIT 10;
