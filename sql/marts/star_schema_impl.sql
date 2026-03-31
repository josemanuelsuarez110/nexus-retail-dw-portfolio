/* 
   🥇 NexusRetail: Gold Layer (Marts)
   Model: Dimensional (Star Schema)
   Implementation: Fact Orders & Dim Customers (SCD Type 2)
*/

-- 1️⃣ Dimension: Date (Generated Utility)
CREATE OR REPLACE TABLE `nexus_dw.dim_date` AS
SELECT
    date,
    EXTRACT(YEAR FROM date) as year,
    EXTRACT(MONTH FROM date) as month,
    EXTRACT(QUARTER FROM date) as quarter,
    EXTRACT(DAY FROM date) as day,
    FORMAT_DATE('%B', date) as month_name,
    FORMAT_DATE('%A', date) as day_name,
    CASE WHEN EXTRACT(DAYOFWEEK FROM date) IN (1, 7) THEN TRUE ELSE FALSE END as is_weekend
FROM UNNEST(GENERATE_DATE_ARRAY('2022-01-01', '2025-12-31')) AS date;

-- 2️⃣ Dimension: Customers (SCD Type 2 Pattern)
-- Tracking history of changes (e.g., location or contact updates)

CREATE OR REPLACE TABLE `nexus_dw.dim_customers` AS
SELECT
    customer_id,
    full_name,
    email,
    country,
    registered_at,
    -- SCD Metadata
    metadata_ingested_at as valid_from,
    TIMESTAMP('9999-12-31') as valid_to, -- Current record indicator
    TRUE as is_active,
    row_hash
FROM `nexus_dw.stg_customers`;

-- 3️⃣ Fact: Orders
-- Optimized with Partitioning and Clustering for high performance querying

CREATE OR REPLACE TABLE `nexus_dw.fact_orders`
PARTITION BY DATE(ordered_at)
CLUSTER BY customer_id, order_status
AS
SELECT 
    order_id,
    customer_id,
    ordered_at,
    total_amount,
    order_status,
    -- Add Date Key for easy joining
    EXTRACT(DATE FROM ordered_at) as order_date_key
FROM `nexus_dw.stg_orders`;

/* 🎯 Business Logic Documentation:
   - Fact Orders is partitioned by day to reduce query cost in BI dashboards.
   - Dim Customers supports historical tracking (SCD Type 2).
   - Clustering on customer_id speeds up joins and customer-centric analytics.
*/
