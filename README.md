# 🛒 Retail Business Performance & SQL Analytics

<div align="center">

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Excel](https://img.shields.io/badge/Advanced%20Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

*End-to-end commercial retail sales analysis using MySQL, Advanced Excel, and Power BI to evaluate revenue performance, customer segmentation, order status, and sales channel attribution.*

</div>

---

## 📌 Project Overview

This project delivers a **full-cycle retail analytics solution** — from raw transactional data ingestion through SQL to executive-ready Power BI dashboards. It covers the complete retail analytics stack: data cleaning, SQL querying, Excel-based exploration, and BI visualization.

**Dataset Scale:**
| Metric | Volume |
|--------|--------|
| 📦 Transaction Logs | 11,965+ records |
| 👥 Customer Profiles | 3,525+ profiles |
| 📍 Sales Channels | Multiple channels |
| 🗓️ Analysis Period | Multi-year |

---

## 🎯 Business Objectives

| Objective | Metric |
|-----------|--------|
| Measure overall revenue performance | Total Revenue, GMV, AOV |
| Segment customers by value | RFM Segmentation — Recency, Frequency, Monetary |
| Analyse order lifecycle | Order Status Funnel (Placed → Shipped → Delivered → Returned) |
| Evaluate sales channel effectiveness | Revenue & Volume by Channel |
| Identify top-performing products | Product-level Revenue Ranking |
| Track regional performance | Revenue by Region / Geography |

---

## 🖼️ Dashboard Preview


| Revenue Overview | Customer Segments | Order Status |
|-|-|-|
|*<img width="1055" height="590" alt="image" src="https://github.com/user-attachments/assets/0d28d49b-eab6-4502-8055-c370549b0395" />*|*<img width="1054" height="595" alt="image" src="https://github.com/user-attachments/assets/3ad31576-9226-4536-b6bd-4cbd11cc25eb" />*|*<img width="1054" height="596" alt="image" src="https://github.com/user-attachments/assets/817b5bac-fc91-4cd6-83f1-af6125c7eeab" />*|

---

## 🔑 Key Features

- **📊 Revenue Performance Dashboard** — Total revenue, GMV, growth trends, and AOV across time periods
- **👥 Customer Segmentation (RFM)** — High-value, at-risk, and dormant customer identification
- **📦 Order Status Funnel** — End-to-end order lifecycle tracking with return rate analysis
- **📣 Sales Channel Attribution** — Revenue and volume breakdown by online, offline, and partner channels
- **🏆 Product Performance Ranking** — Top 10 / Bottom 10 products by revenue and quantity sold
- **🗺️ Regional Heat Map** — Geographic revenue concentration and growth comparison

---

## 🗃️ Database Schema

```sql
-- Core Tables
Customers        (customer_id, name, segment, region, join_date, email)
Orders           (order_id, customer_id, order_date, status, channel, total_amount)
Order_Items      (item_id, order_id, product_id, quantity, unit_price, discount)
Products         (product_id, product_name, category, sub_category, cost_price)
Sales_Channels   (channel_id, channel_name, channel_type)
```

---

## 🔍 Key SQL Queries

```sql
-- 1. Monthly Revenue Trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id)                  AS total_orders,
    ROUND(SUM(total_amount), 2)      AS total_revenue,
    ROUND(AVG(total_amount), 2)      AS avg_order_value
FROM Orders
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;

-- 2. Customer RFM Segmentation
SELECT
    customer_id,
    DATEDIFF(CURDATE(), MAX(order_date))  AS recency_days,
    COUNT(order_id)                        AS frequency,
    ROUND(SUM(total_amount), 2)            AS monetary_value
FROM Orders
GROUP BY customer_id
ORDER BY monetary_value DESC;

-- 3. Sales Channel Revenue Attribution
SELECT
    sc.channel_name,
    COUNT(o.order_id)           AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS channel_revenue,
    ROUND(SUM(o.total_amount) * 100.0 / SUM(SUM(o.total_amount)) OVER (), 2) AS revenue_share_pct
FROM Orders o
JOIN Sales_Channels sc ON o.channel_id = sc.channel_id
GROUP BY sc.channel_name
ORDER BY channel_revenue DESC;

-- 4. Top 10 Products by Revenue
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity)                           AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;
```

---

## 📊 Excel Analysis Highlights

- **Pivot Tables** — Revenue summaries by product, region, and channel
- **VLOOKUP / INDEX-MATCH** — Cross-table data enrichment
- **Conditional Formatting** — KPI traffic lights for performance thresholds
- **Dynamic Charts** — Interactive slicers for time-period filtering
- **What-If Analysis** — Scenario modelling for pricing and discount impact

---

## 📂 Repository Structure

```
retail-business-sql-analytics/
│
├── 📁 data/
│   ├── raw/                        # Raw CSV/Excel source files
│   └── processed/                  # Cleaned datasets
│
├── 📁 sql/
│   ├── schema_creation.sql         # Database & table creation scripts
│   ├── data_cleaning.sql           # Data quality & deduplication
│   ├── revenue_analysis.sql        # Revenue & GMV queries
│   ├── customer_segmentation.sql   # RFM analysis queries
│   ├── order_status_analysis.sql   # Order funnel queries
│   └── channel_attribution.sql     # Sales channel queries
│
├── 📁 excel/
│   └── Retail_Analysis.xlsx        # Excel workbook with pivot tables
│
├── 📁 dashboard/
│   └── Retail_Performance.pbix     # Power BI dashboard file
│
├── 📁 screenshots/
│   └── *.png                       # Dashboard screenshots
│
└── README.md
```

---

## 💡 Key Insights Uncovered

> *(Update with your actual findings)*

- 📦 **Total Revenue:** \$X across 11,965+ transactions
- 🏆 **Top Channel:** [Channel name] contributed X% of total revenue
- 👥 **High-Value Customers:** X% of customers drive X% of revenue (Pareto principle)
- 🔄 **Return Rate:** X% order return rate, highest in [category]
- 📍 **Top Region:** [Region] generated \$X in revenue — X% above average

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **MySQL** | Database design, data storage, and analytical SQL queries |
| **Advanced Excel** | Data exploration, pivot analysis, and scenario modelling |
| **Power BI Desktop** | Executive dashboard and interactive reporting |
| **Power Query (M)** | ETL — data shaping and transformation |

---

## 📬 Connect With Me

**Megharaju Vakiti** — Data Analyst

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Megharaju%20Vakiti-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/megharaju-vakiti)
[![GitHub](https://img.shields.io/badge/GitHub-Megharaju--Vakiti-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/Megharaju-Vakiti)

---

<div align="center">
  <em>⭐ If you found this project useful, please give it a star!</em>
</div>
