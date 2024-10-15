-- In theory we should be able to pass multiple params into ML_PREDICT
-- In practice that caused errors I was unable to investigate
-- This is a work around.
-- We will create a JSON representation of each `customer_product_orders` row
-- which is stored in a this table.
CREATE TABLE `default`.`flink_ai_sandbox`.`customer_product_orders_json` (
  json_data STRING
) WITH (
  'changelog.mode' = 'append'
);
