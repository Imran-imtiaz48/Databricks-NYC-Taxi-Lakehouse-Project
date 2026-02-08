USE nyc_taxi_project;

CREATE OR REPLACE TABLE gold_revenue_by_zip
USING DELTA
AS
SELECT
  pickup_zip,
  SUM(fare_amount) AS total_revenue,
  COUNT(*) AS total_trips
FROM silver_trips
GROUP BY pickup_zip;

CREATE OR REPLACE TABLE gold_trip_metrics
USING DELTA
AS
SELECT
  COUNT(*) AS total_trips,
  AVG(fare_amount) AS avg_fare,
  AVG(trip_distance) AS avg_distance
FROM silver_trips;
