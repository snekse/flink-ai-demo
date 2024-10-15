-- Create a model with the name 'sentiment_bot'
-- This model will accept a text string, perform sentiment analysis,
-- then output `sentiment` as POSITIVE, NEGATIVE, or NEUTRAL based on it's findings.
-- The analysis is performed based on the prompt we provide in conjunction with the text input.
-- The connection 'openai-chat-completions-connection' was a pre-established Flink connection.
-- That connection was created via the Confluent CLI to provide an OpenAI API key to Flink.
CREATE MODEL sentiment_bot
INPUT (text STRING)
OUTPUT (sentiment STRING)
COMMENT 'Determines the sentiment as one of 3 values'
WITH (
  'provider' = 'openai',
  'task' = 'classification',
  'openai.connection' = 'openai-chat-completions-connection',
  'openai.client_timeout' = '120',
  'openai.model_version' = 'gpt-3.5-turbo',
  'openai.system_prompt' = 'Analyze the sentiment of the text and return only POSITIVE, NEGATIVE, or NEUTRAL.'
);
