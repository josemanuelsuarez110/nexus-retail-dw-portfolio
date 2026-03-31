/* 
   🚀 NexusRetail: Platform-Specific SQL Optimizations
   Comparing BigQuery, Snowflake, and Redshift performance tuning.
*/

-- ---------------------------------------------------------
-- 🔵 1. GOOGLE BIGQUERY (PARTITIONING & CLUSTERING)
-- Strategy: Reduce scanned bytes using partition pruning.
-- ---------------------------------------------------------

CREATE OR REPLACE TABLE `nexus_dw.fact_orders_optimized`
PARTITION BY DATE(ordered_at)
CLUSTER BY customer_id, order_status
OPTIONS(
  description="Partitioned by day, clustered by customer for optimal cost control",
  require_partition_filter=true
)
AS
SELECT * FROM `nexus_dw.fact_orders`;

/* 🎯 BQ Tip: Always use `require_partition_filter` for multi-terabyte tables 
   to prevent accidental expensive full-table scans. */


-- ---------------------------------------------------------
-- ❄️ 2. SNOWFLAKE (MICRO-PARTITIONING & CLUSTERING KEYS)
-- Strategy: Use Automatic Clustering for large sorted tables.
-- ---------------------------------------------------------

-- Create table with explicit clustering key
CREATE OR REPLACE TABLE NEXUS_DW.FACT_ORDERS (
    ORDER_ID STRING,
    CUSTOMER_ID STRING,
    ORDER_DATE TIMESTAMP_NTZ,
    AMOUNT NUMBER(38, 2),
    STATUS STRING
) CLUSTER BY (DATE(ORDER_DATE), CUSTOMER_ID);

-- Set search optimization for point queries
ALTER TABLE NEXUS_DW.FACT_ORDERS ADD SEARCH OPTIMIZATION;

/* 🎯 Snowflake Tip: Snowflake handles most micro-partitioning automatically, 
   but CLUSTER BY is crucial for datasets > 1TB. */


-- ---------------------------------------------------------
-- 🔴 3. AMAZON REDSHIFT (SORT & DIST KEYS)
-- Strategy: Minimize data movement (Shuffling) with Distribution Keys.
-- ---------------------------------------------------------

CREATE TABLE nexus_dw.fact_orders_redshift (
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    order_date TIMESTAMP SORTKEY,
    amount DECIMAL(18,2),
    status VARCHAR(20)
)
DISTKEY(customer_id); -- Optimize Joins with Dim Customers distribution

/* 🎯 Redshift Tip: Use DISTSTYLE ALL for small dimension tables (e.g., dim_date) 
   to duplicate them across all nodes and eliminate network overhead during joins. */
