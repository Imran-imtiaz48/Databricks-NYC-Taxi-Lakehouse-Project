USE nyc_taxi_project;

SELECT *
FROM gold_revenue_by_zip
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
  payment_type,
  COUNT(*) AS trips
FROM silver_trips
GROUP BY payment_type;
