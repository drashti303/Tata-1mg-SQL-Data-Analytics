USE tata1mg_db;

SHOW TABLES;

SELECT 'cities' AS table_name, COUNT(*) AS total_rows FROM cities
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'lab_tests', COUNT(*) FROM lab_tests
UNION ALL
SELECT 'phlebotomists', COUNT(*) FROM phlebotomists
UNION ALL
SELECT 'lab_bookings', COUNT(*) FROM lab_bookings
UNION ALL
SELECT 'consultations', COUNT(*) FROM consultations;
