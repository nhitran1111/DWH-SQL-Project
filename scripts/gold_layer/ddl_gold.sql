/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Create view in Gold layer
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts Purpose:
               Performing data transformation and combination from Silver layer.
                The Gold layer represent the dimension and fact table which provide business-ready dataset

Usage:
     Tables in Golde layer can be directly queried for analytics and reporting
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

IF OBJECT_ID ('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
ROW_NUMBER() OVER (ORDER BY c1.cts_id) AS customer_key, --surrogate key
c1.cts_id AS customer_id,
c1.cts_key AS customer_number,
c1.cts_firstname AS first_name,
c1.cts_lastname AS last_name,
c1.cts_marital_status AS marital_status,
c3.cntry AS country,
CASE WHEN c1.cts_gndr != 'N/A' THEN c1.cts_gndr
ELSE COALESCE(c2.gen,'N/A')
END AS gender,
c2.bdate AS birth_date,
c1.cts_create_date AS create_date
FROM silver.crm_cust_info c1 
LEFT JOIN silver.erp_cust_az12 c2 
ON c1.cts_key = c2.cid
LEFT JOIN silver.erp_loc_a101 c3
ON c1.cts_key = c3.cid

----------------------------------------------------------------------------
IF OBJECT_ID ('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT 
ROW_NUMBER() OVER (ORDER BY p1.prd_start_dt, p1.prd_key) AS product_key,
p1.prd_id AS product_id,
p1.prd_key AS product_number,
p1.prd_nm AS product_name,
p1.prd_line AS product_line,
p1.cat_id AS category_id,
p2.cat AS category,
p2.subcat AS subcategroy,
p2.maintenance,
p1.prd_cost AS cost,
p1.prd_start_dt AS start_date
FROM silver.crm_prd_info p1
LEFT JOIN silver.erp_px_cat_g1v2 p2
ON  p1.cat_id = p2.id -- filter out historical data
WHERE prd_end_dt IS NULL

----------------------------------------------------------------------------
IF OBJECT_ID ('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
s.sls_ord_num AS order_number,
p.product_key,
c.customer_key,
s.sls_order_dt AS order_date,
s.sls_ship_dt AS shipping_date,
s.sls_due_dt AS due_date,
s.sls_sales AS sales_amount,
s.sls_quantity AS quantity,
s.sls_price AS price
FROM silver.crm_sales_details s
LEFT JOIN gold.dim_products p
ON s.sls_prd_key = p.product_number
LEFT JOIN gold.dim_customers c
ON s.sls_cust_id = c.customer_id
