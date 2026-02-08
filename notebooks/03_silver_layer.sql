USE nyc_taxi_project;

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
