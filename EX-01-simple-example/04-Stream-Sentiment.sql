-- Join the text_stream table to our predictions with a LATERAL join
-- Use the new ML_PREDICT function with our 'sentiment_bot' model. Pass the `text` into the model.
-- Display the model prediction by adding `sentiment` to the SELECT statement.
SELECT text, sentiment FROM text_stream, LATERAL TABLE(ML_PREDICT('sentiment_bot', text)) LIMIT 10;
