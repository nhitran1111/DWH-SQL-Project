/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Create data tables in Bronze layer by DDL
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts Purpose:
                This script create tables in Bronze. If the tables already exist, these table are dropped and recreated.
                The DDL structure of tables in Bronze schema will be re-defined if running the script.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
GO
  
CREATE TABLE bronze.crm_cust_info (
	cts_id INT,
	cts_key NVARCHAR(50),
	cts_firstname NVARCHAR(50), 
	cts_lastname NVARCHAR(50),
	cts_marital_status NVARCHAR(20),
	cts_gndr NVARCHAR(20),
	cts_create_date DATE,
);
GO

IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
GO
  
CREATE TABLE bronze.crm_prd_info (
  prd_id INT,
  prd_key	NVARCHAR(50),
  prd_nm	NVARCHAR(50),
  prd_cost INT,	
  prd_line NVARCHAR(10),
  prd_start_dt DATETIME,
  prd_end_dt DATETIME,
);
GO

IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
GO
  
CREATE TABLE bronze.crm_sales_details (
  sls_ord_num	NVARCHAR(50),
  sls_prd_key NVARCHAR(50),
  sls_cust_id INT,
  sls_order_dt INT,
  sls_ship_dt	INT,
  sls_due_dt INT,
  sls_sales INT,
  sls_quantity INT,
  sls_price INT
);
GO
  
IF OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
GO
  
CREATE TABLE bronze.erp_cust_az12 (
  cid NVARCHAR(50),
  bdate DATE,
  gen NVARCHAR(10)
);
GO

IF OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
GO
  
CREATE TABLE bronze.erp_loc_a101 (
  cid NVARCHAR(50),
  cntry NVARCHAR(50)
);
GO

IF OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
GO
  
CREATE TABLE bronze.erp_px_cat_g1v2 (
  id NVARCHAR(50),
  cat NVARCHAR(50),
  subcat NVARCHAR(50),
  maintenance NVARCHAR(10)
);
