# Databricks NYC Taxi Lakehouse Project

## Overview

This repository contains an end to end data engineering project built entirely on **Databricks Free Edition** using built in sample data. The project follows the **Lakehouse architecture** and implements **Bronze, Silver, and Gold layers** using Delta tables, SQL, and PySpark.

The goal is to demonstrate practical data engineering skills that are easy to review on GitHub and credible for technical interviews.

---

## Dataset

**Source**: Databricks public sample dataset

```
samples.nyctaxi.trips
```

No external data ingestion is required. The dataset is available by default in Databricks Free Edition.

---

## Architecture

Bronze Layer
Raw ingestion of NYC taxi trip data

Silver Layer
Cleaned and filtered data with quality checks applied

Gold Layer
Business level aggregations for analytics and reporting

---

## Technology Stack

Databricks Free Edition
Delta Lake
Databricks SQL
PySpark
GitHub

---

## Project Structure

```
databricks-nyc-taxi-project
│
├── README.md
│
├── notebooks
│   ├── 01_create_database.sql
│   ├── 02_bronze_layer.sql
│   ├── 03_silver_layer.sql
│   ├── 04_gold_layer.sql
│   └── 05_analysis.sql

```

---

## Database Setup

```sql
CREATE DATABASE IF NOT EXISTS nyc_taxi_project;
USE nyc_taxi_project;
```

---

## Bronze Layer

Raw ingestion of the source dataset into a Delta table.

```sql
CREATE OR REPLACE TABLE bronze_trips
USING DELTA
AS
SELECT *
FROM samples.nyctaxi.trips;
```

Purpose
Preserve raw data for traceability and reprocessing.

---

## Silver Layer

Data cleaning and validation rules applied.

Rules
Remove trips with zero fare
Remove trips with zero distance
Ensure pickup time exists

```sql
CREATE OR REPLACE TABLE silver_trips
USING DELTA
AS
SELECT
  trip_id,
  pickup_datetime,
  dropoff_datetime,
  pickup_zip,
  dropoff_zip,
  passenger_count,
  trip_distance,
  fare_amount,
  payment_type
FROM bronze_trips
WHERE fare_amount > 0
AND trip_distance > 0
AND pickup_datetime IS NOT NULL;
```

Purpose
Create a trusted dataset suitable for analytics and reporting.

---

## Gold Layer

Business level aggregations built on top of Silver data.

### Revenue by Pickup ZIP Code

```sql
CREATE OR REPLACE TABLE gold_revenue_by_zip
USING DELTA
AS
SELECT
  pickup_zip,
  SUM(fare_amount) AS total_revenue,
  COUNT(*) AS total_trips
FROM silver_trips
GROUP BY pickup_zip;
```

### Overall Trip Metrics

```sql
CREATE OR REPLACE TABLE gold_trip_metrics
USING DELTA
AS
SELECT
  COUNT(*) AS total_trips,
  AVG(fare_amount) AS avg_fare,
  AVG(trip_distance) AS avg_distance
FROM silver_trips;
```

Purpose
Provide analytics ready tables for dashboards and reporting.

---

## Analytical Queries

Top revenue generating pickup areas

```sql
SELECT *
FROM gold_revenue_by_zip
ORDER BY total_revenue DESC
LIMIT 10;
```

Trip distribution by payment type

```sql
SELECT
  payment_type,
  COUNT(*) AS trips
FROM silver_trips
GROUP BY payment_type;
```

---

## PySpark Example

```python
df = spark.table("silver_trips")

(
  df.groupBy("pickup_zip")
    .sum("fare_amount")
    .withColumnRenamed("sum(fare_amount)", "total_revenue")
    .orderBy("total_revenue", ascending=False)
    .show(10)
)
```

---

## Pipeline

This project uses a **code driven pipeline**.

The pipeline is defined in a single SQL file:

```
pipeline/run_pipeline.sql
```

This file is the pipeline entry point. It sequentially executes all notebooks in the correct order:

1. Create database
2. Bronze ingestion
3. Silver transformation
4. Gold aggregation
5. Analysis

### How to run the pipeline

1. Upload the **entire project folder** to Databricks Workspace
2. Open the file:

```
pipeline/run_pipeline.sql
```

3. Click **Run**

Running this file executes the full end to end pipeline from ingestion to analytics.

---

## Author

Imran Imtiaz

Data Engineering and Analytics Portfolio Project
