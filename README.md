# 🛒 Amazon Brazil E-commerce Data Analysis (SQL Project)

**Advanced Data-Driven Analysis Using SQL**  
By *Ansh Jain | NextLeap Data Analyst Fellow | June 2025*

---

## 📌 Project Objective
To analyze **Amazon Brazil’s real-world e-commerce dataset** using advanced SQL techniques and generate **actionable insights** that can help **Amazon India** optimize its:
- Market entry strategy  
- Customer segmentation  
- Product pricing  
- Operational efficiency  

---

## 🧠 Key Insights Derived
- 📦 **Product-level** pricing strategy and price consistency insights  
- 💳 **Customer preferences** in payment methods across value segments  
- 📈 **Seasonal trends**, top-performing categories, and customer types  
- 🧍 Advanced **customer segmentation** using recursive CTEs and window functions  
- 🛍️ Identification of **top-selling products** and **high-value buyers**  

---

## 🗂️ Files in This Repository

| File Name | Description |
|-----------|-------------|
| **Amazon Analysis.sql** | All 19 advanced SQL queries (joins, window functions, CTEs, recursive queries, segmentation) |
| **schema.png** | Entity-Relationship diagram showing the **6-table relational schema** of the dataset |
| **Advanced Data Analysis using SQL - By Ansh Jain.docx** | Detailed project report with problem statements, SQL breakdowns, visual outputs, and business recommendations |

---

## 🔍 Dataset Overview
**Source**: Next Leap  

**Tables Used**  
- **customers** – Geolocation & demographics  
- **orders** – Purchase and delivery timelines  
- **order_items** – Item-level details including price & quantity  
- **products** – Product categories and descriptions  
- **sellers** – Seller and fulfillment partner data  
- **payments** – Payment types, values, and methods  

---

## 🛠️ Tools & Technologies
- **SQL** (PostgreSQL syntax)  
- **pgAdmin / DBeaver** – SQL execution  
- **Excel** – Exporting results & visualization  
- **Git & GitHub** – Version control & documentation  

---

## 📊 SQL Techniques Used
- **Advanced Joins** (INNER, LEFT)  
- **Aggregation functions** (AVG, SUM, COUNT, STDDEV)  
- **Common Table Expressions (CTEs)**  
- **Recursive CTEs** – cumulative & monthly sales  
- **Window Functions** (RANK, DENSE_RANK, LAG)  
- **CASE statements** for segmentation  
- **Temporal operations** – seasonality & trend analysis  

---

## 📈 Business Questions Answered (19 in total)

### 🔹 Analysis I – Payment, Pricing & Product Insights
- Standardizing payment values  
- Distribution of payment types  
- Identifying smart products within price ranges  
- Top 3 months by total sales  
- Categories with high price variation  
- Most consistent payment methods  
- Products with incomplete or invalid category names  

### 🔹 Analysis II – Customer Behavior & Revenue Patterns
- Payment type preference across segments  
- Category-wise pricing statistics  
- Identifying repeat customers  
- Lifecycle segmentation: New, Returning, Loyal  
- Top revenue-generating product categories  

### 🔹 Analysis III – Time Series & Advanced Segmentation
- Seasonal comparison of sales  
- Identifying above-average sales products  
- Monthly revenue trends (2018)  
- CTE-based customer segmentation (Occasional, Regular, Loyal)  
- Top 20 high-value customers  
- Monthly cumulative sales (recursive CTE)  
- Month-over-month growth rate  

---

## 🧾 Sample Business Recommendation
📌 *“Credit cards show the highest transaction value (165 BRL). Amazon India should prioritize partnerships with top Indian credit card issuers, offering EMI and cashback options during festive sales.”*  

Every analysis is followed by **business use cases** and **recommendations** aligned with Amazon India’s e-commerce growth strategy.  

---

## 🚀 Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/amazon-brazil-sql-analysis.git
