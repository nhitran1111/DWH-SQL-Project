/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Loading data from source into Bronze using Stored Procedure
---------------------------------------------------------------------------------------------------------------------------------------------------------
Script Purpose:
      Truncating tables in Bronze schema before data loading.
      Using the 'BULK INSERT' command to load data from external csv files.

Usage:
      Run the query: EXEC bronze.load_bronze
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '============================================================';
		PRINT 'LOADING BRONZE LAYER'
		PRINT '============================================================';

		PRINT '------------------------------------------------------------';
		PRINT 'LOADING CRM TABLES';
		PRINT '------------------------------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';

		TRUNCATE TABLE bronze.crm_cust_info
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';

		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Nhi\dwh_project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT '>> Inserting Data Into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Nhi\dwh_project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT '>> Inserting Data Into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Nhi\dwh_project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'seconds';

		PRINT '------------------------------------------------------------';
		PRINT 'LOADING ERP TABLES';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Nhi\dwh_project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';


		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Nhi\dwh_project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Nhi\dwh_project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
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
		PRINT 'ERROR OCCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS VARCHAR);
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS VARCHAR);
		PRINT '============================================================';
	END CATCH
END
