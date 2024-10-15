-- We now transform the rows from `customer_product_orders`
-- and insert them into this `customer_product_orders_json` table.
-- If you are able to get multi-param text generation models to work, this is not needed.
-- You could also skip this by doing the JSON_OBJECT in the join with ML_PREDICT
-- this is just far cleaner for a demo
INSERT INTO `default`.`flink_ai_sandbox`.`customer_product_orders_json`
SELECT
    JSON_OBJECT(
        'order_id' VALUE order_id,
        'customer_id' VALUE customer_id,
        'customer_name' VALUE customer_name,
        'customer_email' VALUE customer_email,
        'product_id' VALUE product_id,
        'product_name' VALUE product_name,
        'product_brand' VALUE product_brand,
        'product_vendor' VALUE product_vendor
    ) AS json_data
FROM
    `default`.`flink_ai_sandbox`.`customer_product_orders`;

