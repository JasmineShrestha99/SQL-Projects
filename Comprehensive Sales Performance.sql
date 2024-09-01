-- Comprehensive Sales Performance Analysis and Reporting
-- Project by Jasmine Shrestha

-- This SQL query analyzes sales data by aggregating it monthly, quarterly, and yearly. It classifies sales by value and region, 
   then compares yearly performance with trends and ranks. The final output includes metrics like total sales, average amount,
   and revenue categories, providing a detailed sales performance summary.



-- Step 1: Categorize sales and extract useful date information
WITH SalesCategory AS (
    SELECT
        s.sale_id,
        s.product_id,
        s.amount,
        s.sale_date,
        s.region,
        p.product_name,
        EXTRACT(YEAR FROM s.sale_date) AS sale_year,  -- Extract the year from sale_date
        EXTRACT(MONTH FROM s.sale_date) AS sale_month, -- Extract the month from sale_date
        CASE
            WHEN s.amount >= 1000 THEN 'High Value'
            WHEN s.amount >= 500 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS sale_value_category,  -- Classify sales into High, Medium, or Low Value based on amount
        CASE
            WHEN s.region IN ('North', 'South') THEN 'Domestic'
            WHEN s.region IN ('East', 'West') THEN 'International'
            ELSE 'Unknown'
        END AS sale_region_category  -- Classify sales into Domestic, International, or Unknown based on region
    FROM sales s
    JOIN products p ON s.product_id = p.product_id  -- Join with products table to get product_name
),

-- Step 2: Aggregate sales data on a monthly basis
SalesMonthlySummary AS (
    SELECT
        sale_year,
        sale_month,
        sale_value_category,
        sale_region_category,
        COUNT(*) AS total_sales,           -- Total number of sales
        SUM(amount) AS total_amount,       -- Total amount of sales
        AVG(amount) AS avg_amount          -- Average amount of sales
    FROM SalesCategory
    GROUP BY
        sale_year,
        sale_month,
        sale_value_category,
        sale_region_category
),

-- Step 3: Aggregate sales data on a quarterly basis
SalesQuarterlySummary AS (
    SELECT
        sale_year,
        EXTRACT(QUARTER FROM DATE_TRUNC('quarter', DATE_TRUNC('year', DATE_TRUNC('month', TO_DATE(sale_year::text || '-' || sale_month::text || '-01', 'YYYY-MM-DD'))))) AS sale_quarter, -- Calculate the quarter from the month
        sale_value_category,
        sale_region_category,
        COUNT(*) AS total_sales,
        SUM(amount) AS total_amount,
        AVG(amount) AS avg_amount
    FROM SalesMonthlySummary
    GROUP BY
        sale_year,
        sale_quarter,
        sale_value_category,
        sale_region_category
),

-- Step 4: Aggregate sales data on a yearly basis
SalesYearlySummary AS (
    SELECT
        sale_year,
        sale_value_category,
        sale_region_category,
        COUNT(*) AS total_sales,           -- Total number of sales for the year
        SUM(amount) AS total_amount,       -- Total amount of sales for the year
        AVG(amount) AS avg_amount          -- Average amount of sales for the year
    FROM SalesQuarterlySummary
    GROUP BY
        sale_year,
        sale_value_category,
        sale_region_category
),

-- Step 5: Compare yearly data and rank sales performance
SalesComparison AS (
    SELECT
        sale_year,
        sale_value_category,
        sale_region_category,
        total_sales,
        total_amount,
        avg_amount,
        LAG(total_amount, 1) OVER (PARTITION BY sale_value_category, sale_region_category ORDER BY sale_year) AS prev_year_amount,  -- Previous year's total amount for comparison
        RANK() OVER (PARTITION BY sale_year ORDER BY total_amount DESC) AS sales_rank,  -- Rank based on total amount within the year
        CASE
            WHEN LAG(total_amount, 1) OVER (PARTITION BY sale_value_category, sale_region_category ORDER BY sale_year) IS NULL THEN 'New Category'
            WHEN total_amount > LAG(total_amount, 1) OVER (PARTITION BY sale_value_category, sale_region_category ORDER BY sale_year) THEN 'Increased'
            WHEN total_amount < LAG(total_amount, 1) OVER (PARTITION BY sale_value_category, sale_region_category ORDER BY sale_year) THEN 'Decreased'
            ELSE 'No Change'
        END AS amount_trend  -- Determine the trend of the amount compared to the previous year
    FROM SalesYearlySummary
)

-- Step 6: Final output with detailed categorization and ordering
SELECT
    sale_year,
    sale_value_category,
    sale_region_category,
    total_sales,
    total_amount,
    avg_amount,
    CASE
        WHEN total_amount > 100000 THEN 'High Revenue'
        WHEN total_amount BETWEEN 50000 AND 100000 THEN 'Medium Revenue'
        ELSE 'Low Revenue'
    END AS revenue_category,  -- Categorize revenue based on total amount
    CASE
        WHEN avg_amount > 500 THEN 'High Average'
        WHEN avg_amount BETWEEN 200 AND 500 THEN 'Medium Average'
        ELSE 'Low Average'
    END AS average_amount_category,  -- Categorize average amount of sales
    amount_trend,  -- Include the trend of sales amount
    sales_rank    -- Include the rank of sales performance
FROM SalesComparison
ORDER BY sale_year, sale_value_category, sale_region_category, sales_rank;  -- Order the results for better readability