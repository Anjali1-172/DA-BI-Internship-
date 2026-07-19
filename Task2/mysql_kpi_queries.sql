-- See previous response content
CREATE TABLE customers(customer_id VARCHAR(20) PRIMARY KEY,customer_name VARCHAR(100),region VARCHAR(30),segment VARCHAR(30));
CREATE TABLE orders(order_id VARCHAR(20) PRIMARY KEY,order_date DATE,customer_id VARCHAR(20),product_category VARCHAR(50),sales DECIMAL(10,2),quantity INT,profit DECIMAL(10,2),discount DECIMAL(5,2));
-- INNER JOIN
SELECT o.order_id,o.order_date,c.customer_name,c.region,c.segment,o.product_category,o.sales,o.quantity,o.profit,o.discount
FROM orders o INNER JOIN customers c ON o.customer_id=c.customer_id;
SELECT SUM(sales) AS total_sales FROM orders;
SELECT SUM(profit) AS total_profit FROM orders;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT AVG(sales) AS avg_order_value FROM orders;
SELECT c.customer_name,SUM(o.sales) revenue FROM orders o JOIN customers c ON o.customer_id=c.customer_id GROUP BY c.customer_name ORDER BY revenue DESC LIMIT 10;
SELECT DATE_FORMAT(order_date,'%Y-%m') month,SUM(sales) monthly_sales FROM orders GROUP BY month ORDER BY month;
SELECT c.region,SUM(o.sales) sales FROM orders o JOIN customers c ON o.customer_id=c.customer_id GROUP BY c.region;
SELECT c.segment,SUM(o.sales) sales FROM orders o JOIN customers c ON o.customer_id=c.customer_id GROUP BY c.segment;
SELECT product_category,SUM(sales) sales,SUM(profit) profit FROM orders GROUP BY product_category;
SELECT product_category,ROUND(SUM(profit)/SUM(sales)*100,2) profit_margin_pct FROM orders GROUP BY product_category;
