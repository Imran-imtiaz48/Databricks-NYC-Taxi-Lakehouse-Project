USE nyc_taxi_project;

CREATE OR REPLACE TABLE bronze_trips
USING DELTA
AS
SELECT *
FROM samples.nyctaxi.trips;
