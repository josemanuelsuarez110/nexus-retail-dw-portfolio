/* 
   🚀 NexusRetail: Advanced Analytics & KPIs
   Purpose: Performance analysis, user retention, and financial reporting.
   Techniques: Window Functions, CTEs, Running Totals.
*/

-- 🏆 1. Customer Lifetime Value (CLV)
-- Calculates the total revenue per customer and ranks them.
-- Skill: CTEs, Aggregations, Rank.

CREATE OR REPLACE TABLE `nexus_analysis.customer_lifetime_value` AS
WITH customer_revenue AS (
    SELECT 
        customer_id,
        SUM(total_amount) as lifetime_revenue,
        COUNT(order_id) as total_orders,
        MIN(ordered_at) as first_order_date,
        MAX(ordered_at) as last_order_date
    FROM `nexus_dw.fact_orders`
    WHERE order_status = 'COMPLETED'
    GROUP BY 1
)
SELECT 
    cr.*,
    RANK() OVER(ORDER BY lifetime_revenue DESC) as revenue_rank,
    -- Calculate days since last order
    DATE_DIFF(CURRENT_DATE(), EXTRACT(DATE FROM last_order_date), DAY) as recency_days
FROM customer_revenue cr;

-- 📈 2. Monthly Revenue Growth Rate
-- Uses Window Functions (LAG) to calculate month-over-month growth.
-- Skill: Window Functions, LAG.

CREATE OR REPLACE VIEW `nexus_analysis.monthly_revenue_growth` AS
WITH monthly_metrics AS (
    SELECT 
        FORMAT_DATE('%Y-%m', ordered_at) as month_key,
        SUM(total_amount) as monthly_revenue
    FROM `nexus_dw.fact_orders`
    WHERE order_status = 'COMPLETED'
    GROUP BY 1
)
SELECT 
    month_key,
    monthly_revenue,
    LAG(monthly_revenue) OVER(ORDER BY month_key) as prev_month_revenue,
    SAFE_DIVIDE(monthly_revenue - LAG(monthly_revenue) OVER(ORDER BY month_key), LAG(monthly_revenue) OVER(ORDER BY month_key)) * 100 as growth_percentage
FROM monthly_metrics;

-- 📊 3. Operational: Order Status Distribution
-- Quick aggregation for dashboard visualization.

CREATE OR REPLACE VIEW `nexus_analysis.order_status_insights` AS
SELECT 
    order_status,
    COUNT(*) as order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() , 2) as status_ratio_percent
FROM `nexus_dw.fact_orders`
GROUP BY 1;

-- 🔍 4. Retrospective: Top 5% of Customers (High Value)
-- Skill: NTILE for segmenting data.

SELECT * 
FROM (
    SELECT 
        customer_id,
        lifetime_revenue,
        NTILE(20) OVER(ORDER BY lifetime_revenue DESC) as revenue_percentile
    FROM `nexus_analysis.customer_lifetime_value`
)
WHERE revenue_percentile = 1; -- Top 5%
