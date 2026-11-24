# Tata 1mg – SQL Data Analytics Project

## Project Overview

This is a SQL Data Analytics project based on a simulated Tata 1mg pharmacy and healthcare business.

I use MySQL to analyse business data and answer questions about revenue, customers, products, cities, lab tests, and consultations.

## Database Information

- Database: `tata1mg_db`
- Total tables: 9
- Analysis period: January 2025 – October 2026
- Tool: MySQL Workbench

## Tables

1. cities
2. customers
3. products
4. orders
5. order_items
6. lab_tests
7. phlebotomists
8. lab_bookings
9. consultations

## Work Completed

- Created the database and 9 tables.
- Loaded 103,403 simulated records.
- Checked table records using SQL validation queries.
- Created the first business KPI: Top 10 Cities by Pharmacy Revenue.
- Used joins, CTEs, aggregate functions, and window functions.

## SQL Skills

- Joins and Subqueries
- GROUP BY and HAVING
- CASE WHEN
- Common Table Expressions (CTEs)
- Window Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), LAG()
- Aggregate and Date Functions

## Project Structure

```text
Tata-1mg-SQL-Data-Analytics/

- schema.sql
- insert_data.sql
- data_validation.sql
- business_kpi.sql
- README.md
```

## How to Run

1. Open MySQL Workbench.
2. Run `schema.sql`.
3. Run `insert_data.sql`.
4. Run `data_validation.sql`.
5. Execute SQL queries from the `business_kpi.sql` file.

## Disclaimer

This project uses simulated data for learning and portfolio purposes. It is not actual Tata 1mg business data.
