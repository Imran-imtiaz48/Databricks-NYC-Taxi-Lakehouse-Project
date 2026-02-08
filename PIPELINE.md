# Pipeline Design

This project uses a code driven pipeline instead of UI based orchestration.

The pipeline is defined in a single SQL file that sequentially executes each notebook.

Execution Order
1. Create database
2. Bronze ingestion
3. Silver transformation
4. Gold aggregation
5. Analysis

This approach keeps orchestration version controlled and easy to understand.
