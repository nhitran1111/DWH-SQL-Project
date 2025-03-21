/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Loading data from Bronze layer into Silver layer using Stored Procedure
---------------------------------------------------------------------------------------------------------------------------------------------------------
Script Purpose:
      Performing ETL process to populate data from Bronze schema to Silver schema
      Truncating tables in Silver schema before populating data, then inserting transformed
      and cleansed data into tables in Silver schema
    

Usage:
      Run the query: EXEC sliver.load_silver
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time  = GETDATE()
		PRINT '============================================================';
		PRINT 'LOADING SILVER LAYER'
		PRINT '============================================================';
		PRINT '------------------------------------------------------------';
		PRINT 'LOADING CRM TABLES';
		PRINT '------------------------------------------------------------';
		SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info
		PRINT 'Inserting Data Into Table: silver.crm_cust_info'
		INSERT INTO silver.crm_cust_info (
		cts_id,
		cts_key,
		cts_firstname, 
		cts_lastname, 
		cts_marital_status, 
		cts_gndr,
		cts_create_date
		)

		SELECT
		cts_id,
		cts_key,
		TRIM(cts_firstname) AS cts_firstname,
		TRIM(cts_lastname) AS cts_lastname,
		CASE WHEN UPPER(TRIM(cts_marital_status)) = 'M'  THEN 'Married'
			 WHEN UPPER(TRIM(cts_marital_status)) = 'S'  THEN 'Single'
			 ELSE 'N/A'
		END AS cts_marital_status, -- Normalize marital status values to readable format and handling missing value
		CASE WHEN UPPER(TRIM(cts_gndr)) = 'F'  THEN 'Female'
			 WHEN UPPER(TRIM(cts_gndr)) = 'M'  THEN 'Male'
			 ELSE 'N/A'
		END AS cts_gndr, --Normalize gender status value to readable format and handling missing value
		cts_create_date
		FROM (SELECT 
			  *,
			  ROW_NUMBER() OVER (PARTITION BY cts_id ORDER BY cts_create_date DESC) AS last_nb
			  FROM bronze.crm_cust_info
			  WHERE cts_id IS NOT NULL
			 ) tp
		WHERE last_nb = 1 -- select the latest record of each customer
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		PRINT '------------------------------------------------------------'
		SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info
		PRINT 'Inserting Data Into Table: silver.crm_prd_info'
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		SELECT
		prd_id,
		REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, -- Extract Category ID
		SUBSTRING(prd_key,7, LEN(prd_key)) AS prd_key, -- Extract product key
		prd_nm,
		ISNULL(prd_cost,0) AS prd_cost, -- Handle missing information
		CASE  UPPER(TRIM(prd_line))
			 WHEN 'M' THEN 'Mountain'
			 WHEN 'R' THEN 'Road'
			 WHEN 'S' THEN 'Other Sales'
			 WHEN 'T' THEN 'Touring'
			 ELSE 'N/A'
		END AS prd_line,  -- map product line codes to descriptive values
		CAST(prd_start_dt AS DATE) AS prd_start_dt,
		CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
		-- in bronze layer, a lot of records have prd_start_dt > prd_end_dt, it is illogical => suppose prd_end_dt is the day before the next start date
		FROM bronze.crm_prd_info
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		PRINT '------------------------------------------------------------'
		SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details
		PRINT 'Inserting Data Into Table: silver.crm_sales_details'
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)

		SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
			 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- change data to correct data type and handle the invalid value
		END AS sls_order_dt,
		CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
			 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END AS sls_ship_dt,
		CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
			 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END AS sls_due_dt,
		CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
			 ELSE sls_sales
		END AS sls_sales, -- recalculate if the original value is missing or incorrect
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <= 0  THEN sls_sales / NULLIF(sls_quantity,0)
			 ELSE sls_price --derive price if the original is invalid
		END AS sls_price
		FROM bronze.crm_sales_details
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		PRINT '------------------------------------------------------------'
		PRINT 'LOADING ERP TABLES';
		PRINT '------------------------------------------------------------';
		SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12
		PRINT 'Inserting Data Into Table: silver.erp_cust_az12'
		INSERT INTO silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)
		SELECT 
		CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
			 ELSE cid
		END AS cid,
		CASE WHEN bdate > GETDATE() THEN NULL
			 ELSE bdate
		END AS bdate,
		CASE WHEN UPPER(TRIM(gen)) IN ('Female','F') THEN 'Female'
			 WHEN UPPER(TRIM(gen)) IN ('Male','M') THEN 'Male'
			 ELSE 'N/A'
		END AS gen
		FROM bronze.erp_cust_az12
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		PRINT '------------------------------------------------------------';
		SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_loc_a101
		PRINT 'Inserting Data Into Table: silver.erp_loc_a101'
		INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry
		)

		SELECT 
		REPLACE(cid,'-','') AS cid,
		CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			 WHEN TRIM(cntry) = '' OR TRIM(cntry) IS NULL THEN 'N/A'
			 ELSE TRIM(cntry)
		END AS cntry -- normalize and handle missing value
		FROM bronze.erp_loc_a101
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		PRINT '------------------------------------------------------------'
		SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		PRINT 'Inserting Data Into Table: silver.erp_px_cat_g1v2'
		INSERT INTO silver.erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)

		SELECT 
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_px_cat_g1v2
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '============================================================';
		PRINT 'Total Load Duration: ' + CAST(DATEDIFF(SECOND,@batch_start_time ,@batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '============================================================';
	END TRY
	BEGIN CATCH
		PRINT '============================================================';
		PRINT 'ERROR OCCCURED DURING LOADING SILVER LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS VARCHAR);
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS VARCHAR);
		PRINT '============================================================';
	END CATCH
END
