# ETL-Ocaml

## Objective:

The objective of this ETL project is to process data from a source (a CSV file), apply transformations, and store the result in another resource (a new CSV file). The project is based on two tables that represent a small part of a management software: an orders table and another containing the items of each order. In a real-world scenario, direct access to the database may be impractical for security and performance reasons. Therefore, a daily process extracts the relevant data and generates a copy in a shared file. The ultimate goal is to provide the processed data to the manager, who will use this information to feed an aggregated order visualization dashboard.

### Use Cases:
- BI (Business Intelligence)
- ML Pipeline (Machine Learning Pipelines)
- Data Engineering

## What is ETL?

ETL stands for Extract, Transform, Load. It is a process used to gather data from various sources, including unstructured ones, transform it through conversions, cleaning, and applying rules or calculations, and finally store it in a processed and structured destination.