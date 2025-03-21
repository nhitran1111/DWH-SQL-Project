/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Quality checks after loading data into silver layer
---------------------------------------------------------------------------------------------------------------------------------------------------------
Script Purpose:
      To make sure data across silver schema is conistency, accuracy and standardized by checking for the following:
      - Nulls or Duplicates in Primary Key
      - Unwanted spaces in string fields
      - Data stardardization and Consistency
      - Invalid date range

Usage:
      Run the queries after loading data into silver layer. 
---------------------------------------------------------------------------------------------------------------------------------------------------------
============================================================
Validating Data in table: silver.crm_cust_info
============================================================
*/

--check for Null & Dupplicates in Primary Key
--Expectation: No result
SELECT 
cts_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cts_id
HAVING COUNT(*) > 1 OR cts_id  IS NULL

--check for unwanted spaces
--expectation: No results
SELECT cts_firstname
FROM silver.crm_cust_info
WHERE cts_firstname != TRIM(cts_firstname)

SELECT cts_lastname
FROM silver.crm_cust_info
WHERE cts_lastname != TRIM(cts_lastname)

--data stardardization & consistency
SELECT DISTINCT cts_gndr
FROM silver.crm_cust_info

SELECT DISTINCT cts_marital_status
FROM silver.crm_cust_info

/*
============================================================
Validating Data in table: silver.crm_prd_info
============================================================
*/
--check for Nulls & Dupplicates in Primary Key
--Expectation: No result
SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id  IS NULL

--check for unwanted spaces
--expectation: No results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--check for NULLs or Negative Numbers
--expectation: No results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--data stardardization & consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

--check for Invalid Date order
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt

/*
============================================================
Validating Data in table: silver.crm_sales_details
============================================================
*/
--check for Invalid dates
SELECT 
NULLIF(sls_ship_dt,0) AS sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_ship_dt <= 0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20300101
OR sls_ship_dt < 19500101

--check for Invalid Date order
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt  > sls_ship_dt OR sls_order_dt > sls_due_dt

--check data consistency: Between Sales, Quantity & Price
--Value must not be Null, zero or negative
SELECT 
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity*sls_price
OR sls_sales IS NULL OR  sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR  sls_quantity <= 0 OR sls_price <= 0
ORDER BY
sls_sales,
sls_quantity,
sls_price

/*
============================================================
Validating Data in table: silver.erp_cust_az12
============================================================
*/
--Identify out of range date of birthdate column
SELECT 
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1920-01-01' OR bdate > GETDATE()

--Check for data standardization & Consistency
SELECT 
DISTINCT gen
FROM silver.erp_cust_az12

/*
============================================================
Validating Data in table: silver.erp_loc_a101
============================================================
*/
--check for Data standardization & Consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101

/*
============================================================
Validating Data in table: silver.erp_cust_az12
============================================================
*/
--check for unwanted spaces
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance)

--check for Data standardization and consistency
SELECT 
DISTINCT cat
FROM silver.erp_px_cat_g1v2
ORDER BY cat

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2
ORDER BY subcat

SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2
ORDER BY maintenance
