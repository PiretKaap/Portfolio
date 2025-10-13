-- This SQL query is for exploring sales data and comparing it to budget data.

-- 1. Using LIMIT to check the first 10 rows of the tables to get an overall understanding of:
-- 1.1 SalesTable
SELECT * FROM SalesTable LIMIT 10;
-- 1.2 SalesRepTable
SELECT * FROM SalesRepTable LIMIT 10;
-- 1.3 BudgetTable
SELECT * FROM BudgetTable LIMIT 10;

-- 2. Finding total sales by each sales year.
SELECT EXTRACT(
        YEAR
        FROM sale_date
    ) AS sales_year, ROUND(
        SUM(
            unit_price * quantity * (1 - discount)
        )::numeric, 0
    ) AS total_sales
FROM SalesTable
GROUP BY sales_year
ORDER BY sales_year asc;

--3. Comparing total sales by each sales year to the total budgeted sales each year.
WITH
    -- Creating a table for total_budget.
    B AS (
    SELECT EXTRACT(
            YEAR
            FROM DT 
        ) AS budget_year, ROUND(SUM(Budget)) AS total_budget 
    FROM BudgetTable 
    GROUP BY
        budget_year
    ),
    -- Creating a table for total_sales.
    S AS (
        SELECT EXTRACT(
                YEAR
                FROM sale_date
            ) AS sales_year, ROUND(
                SUM(
                    unit_price * quantity * (1 - discount)
                )::numeric, 0
            ) AS total_sales
        FROM SalesTable
        GROUP BY
            sales_year
        ORDER BY sales_year asc
    )
    -- Selecting the total budget sum and total sales sum into one table to compare the results.
SELECT B.budget_year, B.total_budget, S.total_sales, S.total_sales - B.total_budget AS difference,
FROM B
    LEFT JOIN S ON B.budget_year = S.sales_year;

-- Comparing the results.
--What is the average, minimum and maximum quantity sold by product in 2025?
SELECT product_id, round(avg(quantity)), min(quantity), max(quantity)
FROM sales_table
WHERE
    sale_date >= '2025-01-01'
GROUP BY
    product_id;