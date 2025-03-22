/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Quality checks after loading data into Gold layer
---------------------------------------------------------------------------------------------------------------------------------------------------------
Script Purpose:
     To make sure data across Gold schema is the integrity, consistency, and accuracy. These checks ensure:
      - Uniqueness of surrogate keys in dimension tables.
      - Referential integrity between fact and dimension tables.
      - Validation of relationships in the data model for analytical purposes.

Usage:
    - Run the queries after loading data into silver layer. 
---------------------------------------------------------------------------------------------------------------------------------------------------------
============================================================
Validating Data in view: 'gold.dim_customers'
============================================================
*/

-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;
/*
============================================================
Validating Data in view: 'gold.dim_products'
============================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results
*/
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;
/*
============================================================
Validating Data in view: 'gold.fact_sales'
============================================================
*/
-- Check for model connectivity between fact and dimensions tables
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
