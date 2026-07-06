-- Working in Microsoft Fabric 
-- Metrices of Sales
-- Fields in Table : OrderID, OrderDate, CustomerName, Region, ProductCategory, Revenue, Quantity, Status
-- By: Anjali 

select top 5 * from tbl_sales



-- Region with highest revenue
SELECT TOP 5 Region, SUM(Revenue) AS total_revenue
FROM tbl_sales
GROUP BY Region
ORDER BY total_revenue DESC;



-- Product category with highest revenue
SELECT TOP 5 ProductCategory, SUM(Revenue) AS total_revenue, SUM(Quantity)
FROM tbl_sales
GROUP BY ProductCategory
ORDER BY total_revenue DESC;



-- Year Extracting 
SELECT DISTINCT(RIGHT(OrderDate, 4)) AS [SalesYear]
FROM tbl_sales;

-- Total revenue in each year by product category
SELECT RIGHT(OrderDate, 4) AS [SalesYear], ProductCategory, SUM(Revenue) AS total_revenue
FROM tbl_sales
GROUP BY RIGHT(OrderDate, 4), ProductCategory
ORDER BY [SalesYear] DESC, total_revenue DESC;



-- Monthly Revenue Trends 
SELECT 
    RIGHT(OrderDate, 4) AS [SalesYear],
    SUBSTRING(OrderDate, 4, 2) AS [SalesMonth],
    SUM(Revenue) AS total_revenue
FROM tbl_sales
GROUP BY 
    RIGHT(OrderDate, 4),
    SUBSTRING(OrderDate, 4, 2)
ORDER BY 
    [SalesYear] ASC, 
    [SalesMonth] ASC;



-- Customers with highest revenue (Top 10)
SELECT Top 10 CustomerName, Region, Revenue, Quantity
from tbl_sales
order by Revenue DESC;



-- Order Status Insights
SELECT Status, SUM(Quantity) AS total_quantity, ROUND(AVG(Revenue),2) AS average_revenue
from tbl_sales
GROUP BY Status
ORDER BY total_quantity desc;



-- Running Total Revenue by each Month
WITH MonthlySales AS (
    SELECT 
        RIGHT(OrderDate, 4) AS [SalesYear],
        SUBSTRING(OrderDate, 4, 2) AS [SalesMonth],
        SUM(Revenue) AS monthly_revenue
    FROM tbl_sales
    GROUP BY 
        RIGHT(OrderDate, 4),
        SUBSTRING(OrderDate, 4, 2)
)
SELECT 
    [SalesYear],
    [SalesMonth],
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY [SalesYear] ASC, [SalesMonth] ASC) AS running_total_revenue
FROM MonthlySales
ORDER BY 
    [SalesYear] ASC, 
    [SalesMonth] ASC;

