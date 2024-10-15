-- Create a table to hold an aggregated view of the example orders
-- This table is created in the `default` catalog in the `flink_ai_sandbox` database
-- We do not compact this table, thus the append mode
CREATE TABLE `default`.`flink_ai_sandbox`.`customer_product_orders` (
    order_id STRING,
    customer_id INT,
    customer_name STRING,
    customer_email STRING,
    product_id STRING,
    product_name STRING,
    product_brand STRING,
    product_vendor STRING
)
WITH (
  'changelog.mode' = 'append'
);
