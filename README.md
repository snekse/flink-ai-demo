# flink-ai-demo
Showing off the AI model capabilities available in Flink SQL on Confluent Cloud.

---

# TL;DR:

Quickly interact with or train AI models in 3 easy steps with Flink AI

### Step 1: Create your connection

``` shell
confluent flink connection create openai-connection \
--cloud GCP \
--region us-central1 \
--type openai \
--endpoint https://api.openai.com/v1/chat/completions \
--api-key <your-api-key>
```

### Step 2: Create your Flink AI Model

``` sql
CREATE MODEL my_model WITH ('provider' = 'openai', 'model_id' = 'gpt-3')
```

### Step 3: Use the model

``` sql
SELECT ML_PREDICT(my_model, input) FROM my_stream
```

---

# Establishing the Prerequisites
Sorry, this README will be written from a MacOS perspective. 

## Confluent Cloud Account
You can use your existing Confluent Cloud account if you know you have access to Flink, or you can [create a trial account with free credits](https://www.confluent.io/confluent-cloud/tryfree/). 

If given the option to name your environment, we used `flink_ai_sandbox`. 
Choosing the same name will make it easier to follow along. 

## Confluent CLI (v4.7+)
In order to run these demos you'll need the Confluent CLI for the very first step or be good friends with the admin who has access to run the one needed command to establish the connection to the AI APIs you plan to use.

### How to Install the Confluent CLI

#### Option 1: Homebrew
You can [install with Homebrew](https://docs.confluent.io/confluent-cli/current/install.html) which should work well enough for this demo.

#### Option 2: Confluent Platform + CLI
If you plan on doing more with the Kafka CLI, I recommend [installing Confluent Platform](https://docs.confluent.io/platform/current/installation/installing_cp/zip-tar.html#get-the-software). This comes with all of the Kafka CLI commands in addition to the Confluent CLI.

> ⚠️ Caveat
> 
> Confluent Platform contains an old version of Confluent CLI. 
> You will need to download the latest version of Confluent CLI 
> and replace the version Confluent Platform comes with.

##### Replacing Confluent CLI
Run `confluent --version` to check if you have version 4.7+.  If not, 
follow [their Quick Start guide](https://docs.confluent.io/confluent-cli/4.7/overview.html#quick-start) 
to download the CLI to a _new directory_; copying it to an isolated directory will just make life easier.

After you have downloaded and extracted the Confluent CLI, 
you can copy the `confluent` file from your new `/bin` to the Confluent Platform `/bin` 
which should already be in your path. You have now upgraded your version of `confluent`.
Check the version to verify.

#### Option 3: Other Methods
Follow the [Install Confluent CLI guides](https://docs.confluent.io/confluent-cli/4.7/install.html#tarball-or-zip-installation).

---

# Getting Started

Flink AI allows you to interact with many different AI platforms.  
For this demo we'll be using OpenAI with their GPT chat APIs. 
The demo also assumes Flink is running on GCP in a specific region. 
You'll need to change according to your Flink deployment.


## Creating the Flink Connection
The very first thing we'll need to do is to create the Flink Connection.  
This is what allows Flink to communicate with your AI model hosted on another platform.

### Getting Confluent CLI ready
You'll need to login to your Confluent Cloud account. This command also saves your login details.
``` shell
confluent login --save
```

### confluent flink connection create
The `confluent flink connection create` command  ([docs](https://docs.confluent.io/confluent-cli/current/command-reference/flink/connection/confluent_flink_connection_create.html#confluent-flink-connection-create)) is what we'll use to create this connection.

This command supplies Flink with the API key and service endpoint that it will interact with. 
The `cloud` and `region` flags are actually where your Flink cluster is running.


#### Creating a Flink to OpenAI Connection on GCP

``` shell
confluent flink connection create \ 
openai-chat-completions-connection \
--cloud gcp  \
--region us-central1 \
--type openai \
--endpoint https://api.openai.com/v1/chat/completions \
--api-key <YOUR API KEY HERE>
```

Note that each connection has an `endpoint`, 
so if there are multiple endpoints you want to interact with, 
you'll need to create multiple connections. 

As such, we chose to name this connection `openai-chat-completions-connection` 
to reflect the endpoint that it was targeted towards.

The `cloud` and `region` will change depending on where your Confluent Cloud is deployed. 
The `type` and `endpoint` will change depending on your model. 
And AWS connections such as Bedrock and SageMaker will need to also supply 
an `aws-access-key` and `aws-secret-key`.

##### Supported Values (as of Oct 2024)
<details>
  <summary>cloud</summary>

- aws
- azure
- gcp
</details>
<details>
  <summary>type</summary>

- openai
- azureml
- azureopenai
- bedrock
- sagemaker
- googleai
- vertexai
- mongodb
- elastic
- pinecone
</details>

#### More Examples

The Confluent _[Run an AI Model](https://docs.confluent.io/cloud/current/ai/ai-model-inference.html#)_ 
documentation provides some additional examples.

## Create a Flink Workspace

Login to Confluent Cloud, then navigate to "Stream Processing" on the left side.

### Try Example

For this demo, we selected `Try example` so Confluent Cloud will generate some initial data 
for us to work with. We'll use this later in our advanced example.

## The Basics - Create a Model ([Docs](https://docs.confluent.io/cloud/current/flink/reference/statements/create-model.html#create-model-statement-in-af-long))

``` sql
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
```

The first thing you'll want to do in order to make use of your AI endpoint connection is to 
wrap it in a Flink Model. This defines the inputs and outputs of your interaction,
the type of interaction you'll be performing, and the prompt or other params your model needs. 
This is what enables the real-time prediction and inference in your Flink environment.

This example comes almost directly from the 
[Confluent docs](https://docs.confluent.io/cloud/current/ai/ai-model-inference.html#sentiment-analysis-with-openai-llm). 


### Task Types ([docs](https://docs.confluent.io/cloud/current/flink/reference/statements/create-model.html#task-types))

- classification
- clustering
- embedding
- regression
- text_generation

### `WITH` Options

The `WTIH` options are where you will dive a lot of functionality. 
[Read the docs](https://docs.confluent.io/cloud/current/flink/reference/statements/create-model.html#with-options).


### Model Versioning

Running `CREATE MODEL my-model` several times will just end up creating new versions each time. 
Unless you alter the model, the latest versions will not be the default version.

You can use a specific version by referring to the version number e.g. `my-model$2` for version `2`.

Or you can update the model's default version:

``` sql
ALTER MODEL my-model SET ('default_version'='2');
```

See more details, including how to delete your model or specific versions, [in the docs](https://docs.confluent.io/cloud/current/flink/reference/statements/create-model.html#model-versioning).

## Use your model

Now that we have a Flink model available to us, 
we want to utilize it for things like model inference in our streaming queries.

### `ML_PREDICT`

``` sql
SELECT id, text, translation FROM text_stream, LATERAL TABLE(ML_PREDICT('translation-model', text));
```

`ML_PREDICT` is a [new function](https://docs.confluent.io/cloud/current/flink/reference/functions/model-inference-functions.html#ml-predict) added to Flink that runs against remote AI/ML models for prediction, classification, and text generation tasks.

### `ML_EVALUATE`

``` sql
-- Model evaluation with all versions
SELECT ML_EVALUATE(`my_model$all`, f1, f2) FROM `eval_data`;
```

`ML_EVALUATE` is a [new function](https://docs.confluent.io/cloud/current/flink/reference/functions/model-inference-functions.html#ml-evaluate) 
that enables benchmarking of your models to see how they compare against your streaming datasets.

### `FEDERATED_SEARCH`

![federated_search_airline_example.png](assets%2Ffederated_search_airline_example.png)

This diagram from the [Confluent blog](https://www.confluent.io/blog/mastering-real-time-retrieval-augmented-generation-rag-with-flink/) shows how `federated_search()` 
will be used to retrive content from a vector store.

---

# Additional Reading

### Flink AI: Real-Time ML and GenAI Enrichment of Streaming Data with Flink SQL on Confluent Cloud

[https://www.confluent.io/blog/flinkai-realtime-ml-and-genai-confluent-cloud/](https://www.confluent.io/blog/flinkai-realtime-ml-and-genai-confluent-cloud/)
> Invoking remote models is an important first step in enabling shift-left principles 
> within the data streaming platform on Confluent Cloud. Flink on Confluent Cloud 
> can easily rank, score, and rate event properties within data streams, 
> resulting in clean data at the source. This is a fundamental principle while building 
> modern data platforms and will greatly increase the value of information 
> extracted from such platforms.

### Let Flink Cook: Mastering Real-Time Retrieval-Augmented Generation (RAG) with Flink

[https://www.confluent.io/blog/mastering-real-time-retrieval-augmented-generation-rag-with-flink/](https://www.confluent.io/blog/mastering-real-time-retrieval-augmented-generation-rag-with-flink/)
> With AI model inference in Flink SQL, Confluent allows you to simplify the 
> development and deployment of RAG-enabled GenAI applications by providing a unified platform 
> for both data processing and AI tasks. By tapping into real-time, high-quality, 
> and trustworthy data streams, you can augment the LLM with proprietary and domain-specific data 
> using the RAG pattern and enable your LLM to deliver the most reliable, accurate responses.







