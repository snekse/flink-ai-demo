-- Stream the results of joining orders, customers, and products
-- Insert the results into customer_product_orders
-- This is a temporal join using `$rowtime` so our view of customers and products
-- reflect their state at the time of the Order
INSERT INTO `default`.`flink_ai_sandbox`.`customer_product_orders`
SELECT
    o.order_id,
    o.customer_id,
    c.name AS customer_name,
    c.email AS customer_email,
    o.product_id,
    p.name AS product_name,
    p.brand AS product_brand,
    p.vendor AS product_vendor
FROM`examples`.`marketplace`.`orders` AS o
INNER JOIN `examples`.`marketplace`.`customers` FOR SYSTEM_TIME AS OF o.`$rowtime` AS c
   ON o.customer_id = c.customer_id
INNER JOIN `examples`.`marketplace`.`products` FOR SYSTEM_TIME AS OF o.`$rowtime` AS p
   ON o.product_id = p.product_id;
