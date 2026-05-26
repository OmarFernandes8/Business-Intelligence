# Business-Intelligence


# 🏪 Retail Data Warehouse & Business Intelligence Dashboard

### End-to-End BI Pipeline | SQL Server · Power BI · Medallion Architecture

[![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/en-us/sql-server)
[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/OmarFernandes8/Business-Intelligence)

> A complete, production-style data warehouse built for a multi-channel retail business — combining **in-store POS sales** and **online e-commerce** data into a unified analytics platform with interactive Power BI dashboards.

</div>

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#-architecture--medallion-architecture)
- [Repository Structure](#-repository-structure)
- [Bronze Layer](#-bronze-layer--raw-ingestion)
- [Silver Layer](#-silver-layer--cleansing--transformation)
- [Gold Layer](#-gold-layer--galaxy-schema)
- [Data Model](#-data-model)
- [Power BI Dashboard](#-power-bi-dashboard)
- [DAX Measures](#-dax-measures--calculations)
- [Business Questions](#-business-questions-answered)
- [Tech Stack](#-tech-stack)
- [How to Run](#-how-to-run)
- [Team](#-team)

---

## 🎯 Project Overview

This project delivers a **fully functional data warehouse** following industry best practices, built as part of the Business Intelligence & Data Analytics course (BINF 602) at GIU Cairo.

### What We Built

| Component | Description |
|---|---|
| **Data Source** | 20 CSV flat files from CRM & ERP systems |
| **Database** | SQL Server — `DataWarehouse` database |
| **Pipeline** | 3-layer Medallion Architecture (Bronze → Silver → Gold) |
| **Data Model** | Galaxy Schema with 2 star schemas + 4 conformed dimensions |
| **Dashboard** | 5-page Power BI dashboard with 20+ business questions |
| **Personas** | 3 user personas — CEO, Store Ops Manager, E-Commerce Manager |

### Business Context

The dataset represents a **US retail chain** operating across two channels:
- **In-Store POS** — physical stores across 4 regions (Midwest, Northeast, South, West) with ~14,962 transactions
- **Online Sales** — e-commerce platform fulfilled by 8 warehouses across the US with ~7,151 orders

---

## 🏗️ Architecture — Medallion Architecture

The project follows the **Medallion Architecture**, an industry-standard pattern that progressively improves data quality through three layers:

```
┌─────────────────────────────────────────────────────────────────┐
│                         DATA SOURCES                            │
│              20 CSV Files (CRM & ERP Systems)                   │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                      🥉 BRONZE LAYER                            │
│  • 20 raw tables mirroring source structure exactly             │
│  • BULK INSERT via stored procedure bronze.load_bronze          │
│  • Strategy: TRUNCATE & INSERT (full load)                      │
│  • Zero transformations — data as-is from source                │
│  • Audit log table for row counts & load timestamps             │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                      🥈 SILVER LAYER                            │
│  • 20 cleansed & enriched tables                                │
│  • Loaded via silver.load_silver stored procedure               │
│  • NULL handling, deduplication, standardization                │
│  • Derived columns: Full_Name, Line_Total, Years_of_Service     │
│  • Enrichment: Brand_Name & Department_Name joined into PRODUCTS│
│  • Audit log table for transformation tracking                  │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                      🥇 GOLD LAYER                              │
│  • Galaxy Schema = 2 Star Schemas + 4 Conformed Dimensions      │
│  • Surrogate keys on all dimension & fact tables                │
│  • Business-ready tables for direct BI consumption              │
│  • Referential integrity via surrogate key joins                │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    📊 POWER BI DASHBOARD                        │
│  • 5 pages · 20+ business questions · 3 user personas           │
│  • Time intelligence · Hierarchies · Calculation Groups         │
│  • Cross-schema analysis combining both fact tables             │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🗂️ Repository Structure

```
📦 Business-Intelligence/
│
├── 📁 Bronze Layer/
│   ├── 01_DATABASE_SETUP.sql               # Create DataWarehouse DB + schemas
│   ├── 02_BRONZE_CreateTables.sql           # 20 raw Bronze tables
│   └── 03_BRONZE_LoadProcedure.sql          # bronze.load_bronze stored procedure
│
├── 📁 Silver Layer/
│   ├── 04_SILVER_CreateTables.sql           # 20 Silver tables with proper data types
│   └── 05_SILVER_LoadProcedure.sql          # silver.load_silver stored procedure
│
├── 📁 Gold Layer/
│   └── 06_GOLD_CreateSchema.sql             # Galaxy schema — dims + facts + keys
│
├── 📁 Dashboards/
│   └── bi_final_project.pbix               # Power BI Desktop file
│
├── 05_EXECUTE.sql                           # Run all layers in sequence
└── README.md
```

---

## 🥉 Bronze Layer — Raw Ingestion

The Bronze layer ingests **raw data exactly as received** from the source CSV files, with no transformations applied.

### Tables Created (20 total)

| Table | Source |
|---|---|
| `bronze.BRANDS` | brands.csv |
| `bronze.CUSTOMERS` | customers.csv |
| `bronze.DELIVERIES` | deliveries.csv |
| `bronze.DELIVERY_PROVIDERS` | delivery_providers.csv |
| `bronze.DEPARTMENTS` | departments.csv |
| `bronze.EMPLOYEES` | employees.csv |
| `bronze.INVENTORY` | inventory.csv |
| `bronze.ONLINE_ORDER_ITEMS` | online_order_items.csv |
| `bronze.ONLINE_ORDERS` | online_orders.csv |
| `bronze.PAYMENTS` | payments.csv |
| `bronze.POS_TRANSACTIONS` | pos_transactions.csv |
| `bronze.PRODUCTS` | products.csv |
| `bronze.PRODUCT_SUPPLIERS` | product_suppliers.csv |
| `bronze.PROMOTIONS` | promotions.csv |
| `bronze.REGISTERS` | registers.csv |
| `bronze.STORES` | stores.csv |
| `bronze.SUPPLIERS` | suppliers.csv |
| `bronze.TRANSACTION_ITEMS` | transaction_items.csv |
| `bronze.WAREHOUSES` | warehouses.csv |
| `bronze.load_log` | Audit table |

### Load Strategy

```sql
-- Stored procedure: bronze.load_bronze
-- 1. TRUNCATE every Bronze table
-- 2. BULK INSERT from CSV files
-- 3. Log row counts, start time, end time, and status to load_log

EXEC bronze.load_bronze @csv_path = N'C:\Dataset1\';
```

---

## 🥈 Silver Layer — Cleansing & Transformation

The Silver layer reads from Bronze and applies **15 categories of transformations** to produce clean, standardized, business-ready data.

### Transformations Applied

| Category | What We Did | Example |
|---|---|---|
| **NULL Handling** | Replaced NULLs with sensible defaults | `Stock_Level` NULL → `0`, `Payment_Amount` NULL → `0` |
| **Whitespace Trimming** | `LTRIM(RTRIM(...))` on all text columns | Customer names, city names |
| **Duplicate Removal** | `ROW_NUMBER() OVER(PARTITION BY ...)` | Removed duplicate customer & product records |
| **Standardization** | Unified coded values | `'M'` → `'Male'`, `'F'` → `'Female'` |
| **Date Formatting** | Unified all dates to `DATETIME` | Consistent format across all tables |
| **Normalization** | Split/restructure columns | Split `Full_Name` → `First_Name` + `Last_Name` |
| **Derived Columns** | Computed new business columns | `Full_Name = First_Name + ' ' + Last_Name` |
| **Derived Columns** | Calculated metrics | `Line_Total = Quantity * Unit_Price` |
| **Derived Columns** | Tenure calculation | `Years_of_Service = DATEDIFF(year, Hire_Date, GETDATE())` |
| **Enrichment** | Joined lookup data | `Brand_Name` & `Department_Name` added to `PRODUCTS` |
| **NULL Promotion FK** | Handle missing foreign keys | `Promotion_ID` NULL → `0` (no promotion) |
| **Data Type Correction** | Proper SQL types | `DECIMAL(10,2)` for prices, `DATE` for dates |
| **Row Count Validation** | Quality check after load | Row count reconciliation Bronze vs Silver |
| **Audit Logging** | Full transparency | `silver.load_log` table tracks every table load |
| **Inconsistency Fixes** | Fix bad entries | Standardized `Order_Status` and `Delivery_Status` values |

### Load Strategy

```sql
-- Stored procedure: silver.load_silver
-- Reads from Bronze, applies all transformations, writes to Silver

EXEC silver.load_silver;
```

---

## 🥇 Gold Layer — Galaxy Schema

The Gold layer exposes **business-ready dimensional models** for direct Power BI consumption.

### Galaxy Schema Design

The Galaxy Schema consists of **2 star schemas sharing 4 conformed dimensions** — this is the industry best practice for cross-schema analysis.

```
                    ┌──────────────┐
                    │  dim_date    │ ← Conformed
                    └──────┬───────┘
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
┌────────┴──────┐  ┌───────┴────────┐  ┌────┴──────────────┐
│ dim_customer  │  │  dim_product   │  │  dim_promotion     │
│  (Conformed)  │  │  (Conformed)   │  │  (Conformed)       │
└───────┬───────┘  └───────┬────────┘  └────┬───────────────┘
        │                  │                │
        │         ┌────────┴────────┐       │
        └────────►│ fact_pos_sales  │◄──────┘
                  │  ~14,962 rows   │
                  └────────┬────────┘
                           │
                    ┌──────┴───────┐   ┌──────────────────┐
                    │  dim_store   │   │   dim_employee    │
                    └──────────────┘   └──────────────────┘

        └────────►│fact_online_sales│◄─────┘
                  │  ~7,151 rows    │
                  └────────┬────────┘
                           │
          ┌────────────────┼──────────────────┐
          │                │                  │
┌─────────┴──────┐ ┌───────┴────────┐ ┌──────┴───────────────┐
│ dim_warehouse  │ │dim_delivery_   │ │ dim_payment_method    │
│                │ │   provider     │ │                       │
└────────────────┘ └────────────────┘ └───────────────────────┘
```

### Surrogate Keys

Every dimension table has a surrogate key generated with `ROW_NUMBER()` or `IDENTITY`, completely independent from the source system's natural keys — following Kimball's dimensional modeling best practices.

### Conformed Dimensions (Shared by Both Schemas)

| Dimension | Columns | Used By |
|---|---|---|
| `dim_date` | date_key, full_date, day_name, month_name, month_number, quarter, year, is_weekend | Both |
| `dim_customer` | customer_key, full_name, gender, city, loyalty_level, email | Both |
| `dim_product` | product_key, product_name, brand_name, department_name, package_size, SKU | Both |
| `dim_promotion` | promotion_key, promo_type, discount_percent, start_date, end_date | Both |

---

## 📐 Data Model

The Power BI data model contains **13 relationships**, all set to Many-to-One with Single cross-filter direction:

| From (Fact) | Key | To (Dimension) | Active |
|---|---|---|---|
| fact_pos_sales | date_key | dim_date | ✅ Active |
| fact_pos_sales | customer_key | dim_customer | ✅ Active |
| fact_pos_sales | product_key | dim_product | ✅ Active |
| fact_pos_sales | promotion_key | dim_promotion | ✅ Active |
| fact_pos_sales | store_key | dim_store | ✅ Active |
| fact_pos_sales | employee_key | dim_employee | ✅ Active |
| fact_online_sales | order_date_key | dim_date | ✅ Active |
| fact_online_sales | customer_key | dim_customer | ✅ Active |
| fact_online_sales | product_key | dim_product | ✅ Active |
| fact_online_sales | promotion_key | dim_promotion | ✅ Active |
| fact_online_sales | warehouse_key | dim_warehouse | ✅ Active |
| fact_online_sales | provider_key | dim_delivery_provider | ✅ Active |
| fact_online_sales | payment_method_key | dim_payment_method | ✅ Active |

> `dim_date` is marked as the **Date Table** using `full_date`, enabling all Power BI time intelligence functions.

---

## 📊 Power BI Dashboard

### Page 1 — Executive Overview
*Designed for: CEO — Mohamed Ali*

| Visual | Fields | Business Question |
|---|---|---|
| KPI Card | Total Transactions by month | How many in-store transactions happened? |
| KPI Card | Total Online Orders | How many online orders were placed? |
| KPI Card | Avg Online Order Value | What is the average online basket size? |
| KPI Card | Total Revenue | What is the combined total revenue? |
| Line Chart | Total Revenue by month_name | How does revenue trend month by month? |
| Bar Chart | Total Revenue by brand_name | Which brands drive the most revenue? |
| Donut Chart | Total POS Revenue vs Total Online Revenue | What is the channel revenue split? |
| Bar Chart | Total Revenue by department_name | Which departments generate the most value? |

---

### Page 2 — In-Store Sales
*Designed for: Store Operations Manager — Ahmed Hassan*

| Visual | Fields | Business Question |
|---|---|---|
| KPI Card | Total POS Revenue by month | What is the in-store revenue trend? |
| KPI Card | Total Transactions | How many transactions were processed? |
| KPI Card | Total POS Quantity | How many units were sold in-store? |
| Gauge | Total Revenue vs Target Revenue | Are we hitting our revenue target? |
| Bar Chart | Total POS Quantity by region | Which region sells the most? |
| Bar Chart | Total POS Quantity by department_name | Which department moves the most units? |
| Bar Chart | Total POS Quantity by product_name | What are the top selling products? |
| Map | Total POS Quantity by city | Where are our strongest store markets? |

---

### Page 3 — Online Sales
*Designed for: E-Commerce Manager — Sara Mohamed*

| Visual | Fields | Business Question |
|---|---|---|
| KPI Card | Total Online Revenue vs Target | Are online sales on track? |
| KPI Card | Avg POS Order Value | What is the average online spend? |
| Stacked Bar | Online Quantity by warehouse + delivery_status | Which warehouses perform best? |
| Donut Chart | Total Online Orders by payment_method | Which payment method do customers prefer? |
| Line Chart | Total Online Orders by month_name | Is the online channel growing over time? |
| Bar Chart | Total Online Revenue by order_status | How much revenue is at risk from cancellations? |

---

### Page 4 — Customer Insights
*Designed for: CEO & Store Operations Manager*

| Visual | Fields | Business Question |
|---|---|---|
| KPI Card | Total POS Revenue | What is in-store revenue? |
| KPI Card | Total Online Orders | How many online orders? |
| KPI Card | Total Online Quantity | How many units ordered online? |
| KPI Card | Avg Online Order Value | What is the average basket? |
| Gauge | Total Revenue vs Target Revenue | Are we hitting the overall target? |
| Bar Chart | Total Revenue by full_name | Who are our top VIP customers? |
| Pie Map | Total Revenue by city + region | Which cities & regions generate most value? |
| Clustered Bar | Target Revenue vs Total Revenue by loyalty_level | Which loyalty tier is closest to target? |

---

### Page 5 — Cross-Schema Analysis ★
*Designed for: CEO — Strategic View (combines both fact tables)*

| Visual | Fields | Business Question |
|---|---|---|
| Clustered Bar | POS Revenue + Online Revenue by department | Which departments perform better online vs in-store? |
| Area Chart | Online Orders + Transactions by month | Which channel is growing faster? |
| Clustered Bar | Online Orders + Transactions by city | Which cities prefer online vs in-store? |
| Clustered Bar | POS Revenue + Online Revenue by city | What is the channel revenue mix per city? |

---

## 📏 DAX Measures & Calculations

### Revenue Measures
```dax
Total POS Revenue =
    SUM(gold_fact_pos_sales[line_total])

Total Online Revenue =
    SUM(gold_fact_online_sales[line_total])

Total Revenue =
    [Total POS Revenue] + [Total Online Revenue]

Target Revenue =
    4300000

Revenue vs Target =
    [Total Revenue] - [Target Revenue]

Target Achievement % =
    DIVIDE([Total Revenue], [Target Revenue]) * 100
```

### Volume Measures
```dax
Total Transactions =
    COUNTROWS(gold_fact_pos_sales)

Total Online Orders =
    COUNTROWS(gold_fact_online_sales)

Total POS Quantity =
    SUM(gold_fact_pos_sales[quantity])

Total Online Quantity =
    SUM(gold_fact_online_sales[quantity])
```

### Average Measures
```dax
Avg POS Order Value =
    DIVIDE([Total POS Revenue], [Total Transactions])

Avg Online Order Value =
    DIVIDE([Total Online Revenue], [Total Online Orders])
```

### Delivery Measures
```dax
Delivery Success Rate % =
    DIVIDE(
        CALCULATE(COUNTROWS(gold_fact_online_sales),
            gold_fact_online_sales[delivery_status] = "Delivered"),
        [Total Online Orders]
    ) * 100
```

### Target per Loyalty Tier
```dax
Target Revenue per Tier =
    DIVIDE(
        [Target Revenue],
        DISTINCTCOUNT(gold_dim_customer[loyalty_level])
    )
```

### Hierarchies
```
Year Hierarchy (dim_date):   year → quarter → month_name
Region Hierarchy (dim_store): region → city → store_name
```

### Calculation Group — Time Comparison
```
Current        → SELECTEDMEASURE()
YTD            → TOTALYTD(SELECTEDMEASURE(), dim_date[full_date])
vs Last Year   → CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR(dim_date[full_date]))
```

---

## ❓ Business Questions Answered

### Executive Overview (Q1–Q4)
1. What is the total revenue across all channels combined?
2. How many total transactions and orders were placed?
3. What is the average online order value?
4. How does total revenue trend month by month?

### In-Store Sales (Q5–Q8)
5. What is the total in-store revenue trend?
6. Which region generates the most in-store sales?
7. Which department moves the most units in-store?
8. What are the top selling products in-store?

### Online Sales (Q9–Q12)
9. Is the online channel growing over time?
10. Which warehouse fulfills the most online orders?
11. Which payment method do customers prefer online?
12. How much revenue is at risk from non-delivered orders?

### Customer Insights (Q13–Q16)
13. Which region has the most valuable customers?
14. Which cities generate the most revenue?
15. Which loyalty tier is closest to hitting revenue target?
16. Who are our top 10 VIP customers by total spend?

### Cross-Schema Analysis ★ (Q17–Q20)
17. ★ Which departments perform better online vs in-store?
18. ★ Which channel is growing faster month by month?
19. ★ Which cities prefer online vs in-store shopping?
20. ★ What is the revenue channel mix per city?

---

## 🛠️ Tech Stack

| Technology | Version | Purpose |
|---|---|---|
| **SQL Server** | 2019+ | Database engine & data warehouse |
| **SSMS** | 19+ | SQL development & execution |
| **Power BI Desktop** | Latest | Data modeling, DAX, dashboards |
| **PptxGenJS** | 3.x | Presentation generation |
| **Git / GitHub** | — | Version control & collaboration |

---

## 🚀 How to Run

### Prerequisites
- SQL Server 2019 or later installed
- SSMS (SQL Server Management Studio)
- Power BI Desktop (latest version)
- Dataset CSV files placed in a local folder (e.g. `C:\Dataset1\`)

### Step-by-Step

**1. Clone the repository**
```bash
git clone https://github.com/OmarFernandes8/Business-Intelligence.git
cd Business-Intelligence
```

**2. Set up the database**
```sql
-- Run in SSMS:
-- 01_DATABASE_SETUP.sql
-- Creates DataWarehouse database + bronze, silver, gold schemas
```

**3. Create & load Bronze layer**
```sql
-- Run: 02_BRONZE_CreateTables.sql
-- Run: 03_BRONZE_LoadProcedure.sql

-- Then execute (update path to your CSV folder):
EXEC bronze.load_bronze @csv_path = N'C:\Dataset1\';
```

**4. Create & load Silver layer**
```sql
-- Run: 04_SILVER_CreateTables.sql
-- Run: 05_SILVER_LoadProcedure.sql

-- Then execute:
EXEC silver.load_silver;
```

**5. Create Gold layer**
```sql
-- Run: 06_GOLD_CreateSchema.sql
-- Creates all dimension and fact tables with surrogate keys
```

**6. Open Power BI**
- Open `bi_final_project.pbix`
- If prompted, update the data source to your SQL Server instance
- Refresh all tables
- Explore all 5 dashboard pages

---

## 👥 Team

| Name | Student ID |
|---|---|
| Omar Ehab | 13006897 |
| Mohamed Waleed | 13007046 |
| Khaled El Mahady | 14002824 |
| Mostafa Omar | 13007782 |
| Yousef Rawy | 13006981 |
| Mohamed Amgad | 13001129 |

---

## 📚 Course Information

| | |
|---|---|
| **Course** | Business Intelligence & Data Analytics — BINF 602 |
| **Institution** | German International University (GIU), Cairo |
| **Instructor** | Dr. Shaimaa Masry |
| **Teaching Assistants** | Mr. Ahmed El Naggar · Ms. Toka Alsayed · Ms. Gannatuallah Assad |
| **Academic Year** | 2024–2025 |

---

<div align="center">

*Built with ❤️ by the BINF 602 Team — GIU Cairo 2025*

</div>
