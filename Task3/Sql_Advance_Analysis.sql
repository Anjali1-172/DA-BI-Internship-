/*
Monthly Sales Analysis
*/

SELECT
    DATE_FORMAT(order_date,'%Y-%m') AS Month,
    COUNT(order_id) AS Total_Orders,
    ROUND(SUM(sales),2) AS Total_Sales,
    ROUND(SUM(profit),2) AS Total_Profit,
    ROUND(AVG(sales),2) AS Average_Order_Value
FROM orders
GROUP BY Month
ORDER BY Month;

/*
Month-over-Month Sales Growth
Uses a Subquery + LAG Window Function
*/

SELECT
    Month,
    Monthly_Sales,
    Previous_Month_Sales,

    ROUND(
        ((Monthly_Sales-Previous_Month_Sales)
        /Previous_Month_Sales)*100,2
    ) AS Growth_Percentage

FROM
(
     SELECT
        DATE_FORMAT(order_date,'%Y-%m') AS Month,
        SUM(sales) AS Monthly_Sales,

        LAG(SUM(sales))
        OVER(ORDER BY DATE_FORMAT(order_date,'%Y-%m'))
        AS Previous_Month_Sales
    FROM orders
    GROUP BY Month
) MonthlyGrowth;

/*
Customer Business Classification
*/

SELECT
    customer_id,
    SUM(sales) AS Revenue,
    CASE
        WHEN SUM(sales)>=5000
            THEN 'High Value Customer'

        WHEN SUM(sales)>=2500
            THEN 'Medium Value Customer'

        ELSE 'Low Value Customer'

    END AS Customer_Category
FROM orders
GROUP BY customer_id
ORDER BY Revenue DESC;

/*
Regions Below Company Average Sales
*/

SELECT
    c.region,
    ROUND(SUM(o.sales),2) AS Region_Sales
FROM orders o
INNER JOIN customers c
ON o.customer_id=c.customer_id
GROUP BY c.region
HAVING SUM(o.sales)<
(
SELECT
AVG(TotalSales)
FROM
(
SELECT SUM(o.sales) AS TotalSales
FROM orders o
INNER JOIN customers c
ON o.customer_id=c.customer_id
GROUP BY region
) RegionSales
)
ORDER BY Region_Sales;


/*
Top 10 Customers by revennue.
*/
SELECT c.customer_name, SUM(o.sales) Revenue,
RANK() OVER(ORDER BY SUM(o.sales) DESC) Customer_Rank
FROM orders o JOIN customers c
ON o.customer_id=c.customer_id
GROUP BY c.customer_name;


/*
Product Category Perfoemance
*/
SELECT product_category,SUM(sales) Total_Sales,SUM(profit) Total_Profit,SUM(quantity) Quantity_Sold,
ROUND(SUM(profit)/SUM(sales)*100,2) Profit_Margin
FROM orders
GROUP BY product_category
ORDER BY Total_Sales DESC;

/*
Best Perfoeming region.
*/

SELECTregion,SUM(sales) Revenue
FROM orders o JOIN customers c
ON o.customer_id=c.customer_id
GROUP BY region
ORDER BY Revenue DESC
LIMIT 1;

/*
Profitability Ranking
*/
SELECT product_category,SUM(profit) Profit,
DENSE_RANK()OVER(ORDER BY SUM(profit) DESC) Profit_Rank
FROM orders
GROUP BY product_category;