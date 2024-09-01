# Comprehensive Sales Performance Analysis and Reporting

**Project Author:** Jasmine Shrestha

## Overview

This project focuses on the comprehensive analysis and reporting of sales data by aggregating it across different time frames (monthly, quarterly, and yearly). The SQL script is designed to classify sales by value and region, compare yearly performance, identify trends, and rank sales metrics. The final output provides a detailed summary that includes key metrics such as total sales, average sales amount, and revenue categories, allowing for in-depth insights into sales performance.

## Key Features

### 1. Data Categorization and Date Extraction
   - **Sales Categorization:** Sales are categorized based on the value (High, Medium, Low) and region (Domestic, International, Unknown).
   - **Date Extraction:** The script extracts the year and month from the sales date to facilitate aggregation by time periods.

### 2. Monthly Sales Aggregation
   - **Monthly Summary:** The script aggregates sales data on a monthly basis, providing key metrics such as total sales, total amount, and average sales amount for each month.

### 3. Quarterly Sales Aggregation
   - **Quarterly Summary:** Sales data is further aggregated on a quarterly basis. This includes calculating the quarter from the month and summarizing the sales data to provide quarterly performance metrics.

### 4. Yearly Sales Aggregation
   - **Yearly Summary:** The script then aggregates the data on a yearly basis, offering insights into the overall sales performance for each year.

### 5. Yearly Comparison and Ranking
   - **Comparison with Previous Year:** The script compares yearly sales data with the previous year, identifying trends such as increases, decreases, or no change in sales.
   - **Sales Ranking:** Sales performance is ranked within each year based on the total sales amount.

### 6. Final Detailed Output
   - **Revenue Categorization:** The final output categorizes revenue based on total sales amount into High, Medium, or Low Revenue.
   - **Average Sales Categorization:** The average sales amount is also categorized into High, Medium, or Low Average.
   - **Sales Trends:** The output includes sales trends and ranks to provide a comprehensive view of sales performance.

## SQL Concepts and Techniques Used

- **WITH Clauses:** Used for creating temporary result sets to structure the query more logically.
- **CASE Statements:** Employed for classifying sales into different categories based on value and region.
- **Date Functions:** EXTRACT and DATE_TRUNC functions are used for breaking down the sale date into meaningful components.
- **Window Functions:** LAG and RANK functions are utilized to compare sales data year-over-year and to rank sales performance within each year.
- **Aggregation:** SUM, COUNT, and AVG functions are used to compute key metrics across different time frames.

## Output

The final output of this project is a well-organized and detailed summary of sales performance, which includes:

- Total Sales
- Total Sales Amount
- Average Sales Amount
- Revenue Categories
- Sales Trends (Increased, Decreased, No Change)
- Sales Rank

This output is ordered by year, sales value category, region, and rank, ensuring clear and actionable insights.

## Usage

This SQL script is designed to be executed in an environment where sales data is stored across tables, typically in a relational database management system. The script provides a powerful tool for sales analysts and business decision-makers to understand sales trends, identify areas of strength and opportunities for improvement, and make informed strategic decisions.