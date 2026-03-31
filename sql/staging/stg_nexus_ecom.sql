/* 
   🏢 NexusRetail: Silver Layer (Staging)
   Transformation: Ingested RAW to Structured Tables
   Handling: Deduplication, Type Casts, Schema Enforcement
*/

-- 🙋 Staging Customers
-- 1. Deduplicate by customer_id
-- 2. Cast strings to timestamps
-- 3. Standardize naming to snake_case

CREATE OR REPLACE VIEW `nexus_dw.stg_customers` AS
WITH raw_data AS (
    SELECT 
        customer_id,
        full_name,
        email,
        country,
        TIMESTAMP(registration_date) as registered_at,
        TIMESTAMP(ingested_at) as metadata_ingested_at,
        -- Generate unique hash for record comparison (SCD Type 2 prep)
        FARM_FINGERPRINT(CONCAT(full_name, email, country)) as row_hash
    FROM `nexus_raw.raw_customers`
),
deduplicated AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY metadata_ingested_at DESC) as rn
    FROM raw_data
)
SELECT 
    customer_id,
    full_name,
    email,
    country,
    registered_at,
    metadata_ingested_at,
    row_hash
FROM deduplicated
WHERE rn = 1;

-- 🛍️ Staging Orders
-- 1. Cast amount to decimal
-- 2. Handle nulls in status
-- 3. Filter test orders (example business logic)

CREATE OR REPLACE VIEW `nexus_dw.stg_orders` AS
WITH base_orders AS (
    SELECT 
        order_id,
        customer_id,
        TIMESTAMP(order_date) as ordered_at,
        CAST(amount AS NUMERIC) as total_amount,
        COALESCE(UPPER(status), 'UNKNOWN') as order_status,
        TIMESTAMP(ingested_at) as metadata_ingested_at
    FROM `nexus_raw.raw_orders`
    WHERE order_id IS NOT NULL
)
SELECT * FROM base_orders;
