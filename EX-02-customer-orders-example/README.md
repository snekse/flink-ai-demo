# Customer Order Examples

In here we are going to go over a more complex, and more realistic example.
We will be ingesting a stream of customer orders and generating a "Thank You" email for each. 
We will be utilizing the example marketplace data for our Order creation.
We will be creating our own tables to join the marketplace tables into an aggregated view,
then we'll pass that data to our AI model so it can draft our email.

## Prerequisites

These examples require a little more than the simple examples, but not much 
- an existing Flink connection for your AI model provider as detailed in the project README 
- a Stream processing [Workspace](https://docs.confluent.io/cloud/current/flink/get-started/quick-start-cloud-console.html#step-1-create-a-workspace) on Confluent Cloud
- the `marketplace` examples database

### Marketplace Examples

If you don't already see the `examples` catalog with the `marketplace` database in your Flink UI, 
you can add it by going to the [Stream processing dashboard](https://confluent.cloud/flink) 
and selecting "Try example".

#### Marketplace Tables

The tables in here are kind of your basic customer order tables, but there are some things to note.
- An "Order" only ever contains 1 product
- Customer names and emails will not match
- I don't think a Customer ever places more than a single order
- The data is not static - it seems to be generated with `faker` for a constant stream of new data
- The `examples` catalog is read-only

### Our Own Database

Since the `examples` catalog is read-only, we'll need our own workspace.
I suggest creating a new one rather than using an existing one.

The examples are using the `default` catalog with a database named `flink_ai_sandbox`.

# 📝 Instructions

For each `.sql` file in this `EX-02-customer-orders-example` folder, create a "cell", 
paste the contents from the file to your workspace cell, 
then [Run the SQL](https://docs.confluent.io/cloud/current/flink/get-started/quick-start-cloud-console.html#step-2-run-sql-statements).

Repeat until you've completed running all the files.

When you are done, you should have seen examples of running Categorization against a stream of data, 
as well as an emoji translations provided by the Text Generation capabilities of your AI model.

# ⚠️ Wrapping up
Be sure to stop any running statements before you finish.
