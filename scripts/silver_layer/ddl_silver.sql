/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Create data tables in Silver layer by DDL
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts Purpose:
                This script create tables in Silver. If the tables already exist, these table are dropped and recreated.
                The DDL structure of tables in Silver schema will be re-defined if running the script.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
	cts_id INT,
	cts_key NVARCHAR(50),
	cts_firstname NVARCHAR(50), 
	cts_lastname NVARCHAR(50),
	cts_marital_status NVARCHAR(20),
	cts_gndr NVARCHAR(20),
	cts_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id 	NVARCHAR(50),
	prd_key	NVARCHAR(50),
	prd_nm	NVARCHAR(50),
	prd_cost INT,	
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
	sls_ord_num	NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt	DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(10),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
	cid NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(10),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
