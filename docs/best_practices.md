# 🛡️ Data Governance & Best Practices

To ensure a production-grade environment, NexusRetail follows strict engineering standards.

## 🏷️ Naming Conventions

*   **Schemas/Datasets**:
    *   `nexus_raw`: Bronze layer (Ingestion)
    *   `nexus_dw`: Silver/Gold layers (Internal Warehouse)
    *   `nexus_analysis`: Reporting layer (Views & Marts)
*   **Tables**: `[prefix]_[entity]` (e.g., `stg_customers`, `fact_orders`).
*   **Columns**: Always `snake_case`.

---

## 🔐 Security & Access Control

### 1. Role-Based Access Control (RBAC)
*   **Data_Engineer**: Read/Write on all layers (Bronze/Silver/Gold).
*   **Data_Analyst**: Read-only on Gold/Analysis layers.
*   **Service_Account**: Restricted to specific ingestion roles.

### 2. Row & Column Level Security
*   **PII Masking**: Columns like `email` or `phone` should be masked for Analysts.
*   **RLS**: Analysts in the 'EMEA' region should only see records where `country` belongs to EMEA.

---

## 💰 Cost Optimization Strategies

### Google BigQuery
*   **Slot Management**: Use `AUTOSCALING` or `RESERVATION` based on workload.
*   **Byte Control**: Always use `require_partition_filter` to force users to filter by date.
*   **Storage**: Tables not queried for 90 days automatically transition to **Long-term Storage** (lower price).

### Snowflake
*   **Auto-Resume/Suspend**: Set `AUTO_SUSPEND = 60` to avoid paying for idle compute.
*   **Search Optimization**: Enable only for columns with high cardinality (IDs).

---

## 🧪 Data Quality (DQ) Checks

We implement "Contract Testing" at the Silver layer:
1.  **Uniqueness**: `COUNT(DISTINCT id) == COUNT(*)`.
2.  **Nullability**: Ensure `order_id` and `customer_id` are never NULL.
3.  **Referential Integrity**: All `orders.customer_id` must exist in `dim_customers`.
