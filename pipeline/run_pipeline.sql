-- Pipeline entry point
-- Executes the full Databricks workflow

RUN ./notebooks/01_create_database.sql;
RUN ./notebooks/02_bronze_layer.sql;
RUN ./notebooks/03_silver_layer.sql;
RUN ./notebooks/04_gold_layer.sql;
RUN ./notebooks/05_analysis.sql;
