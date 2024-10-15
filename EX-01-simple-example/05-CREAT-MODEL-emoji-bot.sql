-- Create a model with the name 'emoji_sentiment_bot'
-- This model will accept a text string, perform sentiment analysis,
-- This time we will use text_generation, the responses will not be limited to predefined values.
-- Response will, however, be entirely in emoji form.
-- The analysis is performed based on the prompt we provide in conjunction with the text input.
-- The connection 'openai-chat-completions-connection' was a pre-established Flink connection.
-- That connection was created via the Confluent CLI to provide an OpenAI API key to Flink.
CREATE MODEL emoji_sentiment_bot
INPUT (text STRING)
OUTPUT (sentiment STRING)
COMMENT 'Determines the sentiment as expressed by emoji'
WITH (
  'provider' = 'openai',
  'task' = 'text_generation',
  'openai.connection' = 'openai-chat-completions-connection',
  'openai.client_timeout' = '120',
  'openai.model_version' = 'gpt-3.5-turbo',
  'openai.system_prompt' = 'Analyze the sentiment of the text.  Reply by translating the sentiment into emoji form. Your response must only contain emoji. You must have at least 1 emoji, but you can use more if it helps express the sentiment. You might see "Flink" mentioned.  The Flink mascot is a squirrel. There is no squirrel emoji, but the chipmunk emoji is close enough e.g. "I Love Flink" might be "❤️🐿️"'
);
