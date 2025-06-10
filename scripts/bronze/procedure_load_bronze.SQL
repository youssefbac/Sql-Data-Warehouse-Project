/*
Store Procedure: Load bronze layer from the source to bronze

==========
script purpose:
    -Truncate the bronze tables before loading data
    - use oo 'bulk insert' command to load data from csv files
Parameters:
       -None


*/




USE DataWarehouse

--create procedure
CREATE OR ALTER PROCEDURE bronze.load_bronze AS

BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME,@batch_end_time DATETIME;
	BEGIN TRY
		PRINT '=================================';
		PRINT 'Loading bronze layer :';
		PRINT '=================================';

		PRINT 'Loading CRM tables'

		--Get the time when we start loading
		SET @start_time = GETDATE();
		PRINT 'TRUNCATING TABLE : crm_cust_info';

		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT 'INSERTING DATA INTO TABLE crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		from 'D:\OneDrive\Documents\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
				FIRSTROW = 2,
				FIELDTERMINATOR= ',',
				TABLOCK 
		);
		SET @end_time=GETDATE();
		PRINT 'Load duration :' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
		PRINT '=========>'

	
		select count(*) from bronze.crm_cust_info

		--Get the time when we start loading
		SET @start_time = GETDATE();
	
		PRINT 'TRUNCATING TABLE : crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT 'INSERTING DATA INTO TABLE crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		from 'D:\OneDrive\Documents\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
				FIRSTROW = 2,
				FIELDTERMINATOR= ',',
				TABLOCK 
		);

		SET @end_time=GETDATE();
		--Calculate loading duration 
		PRINT 'Load duration :' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';

		--Get the time when we start loading
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT 'INSERTING DATA INTO TABLE crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		from 'D:\OneDrive\Documents\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
				FIRSTROW = 2,
				FIELDTERMINATOR= ',',
				TABLOCK 
		);
		SET @end_time=GETDATE();
		--Calculate loading duration 
		PRINT 'Load duration :' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
		select count(*) from bronze.crm_sales_details

		PRINT '=================================';
		PRINT 'Loading ERP tables';
		PRINT '=================================';

		SET @end_time=GETDATE();
		PRINT 'TRUNCATING TABLE : ERP_CUST_AZ12'
		TRUNCATE TABLE bronze.erp_CUST_AZ12;
		PRINT 'INSERTING DATA INTO TABLE erp_CUST_AZ12'
		BULK INSERT bronze.erp_CUST_AZ12
		from 'D:\OneDrive\Documents\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
				FIRSTROW = 2,
				FIELDTERMINATOR= ',',
				TABLOCK 
		);
		SET @end_time=GETDATE();
		--Calculate loading duration 
		PRINT 'Load duration :' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
		select count(*) from bronze.erp_CUST_AZ12;

		PRINT 'TRUNCATING TABLE : ERP_LOC_A101'
		TRUNCATE TABLE bronze.erp_LOC_A101;
		PRINT 'INSERTING DATA INTO TABLE erp_LOC_A101'
		BULK INSERT bronze.erp_LOC_A101
		from 'D:\OneDrive\Documents\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
				FIRSTROW = 2,
				FIELDTERMINATOR= ',',
				TABLOCK 
		);


		SET @end_time=GETDATE();
		--Calculate loading duration 
		PRINT 'Load duration :' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
		select count(*) from bronze.erp_LOC_A101

		--Get the time when we start loading
		SET @start_time = GETDATE();
		PRINT 'TRUNCATING TABLE : ERP_CAT_G1V2'
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

		PRINT 'INSERTING DATA INTO TABLE erp_PX_CAT_G1V2'
		BULK INSERT bronze.erp_PX_CAT_G1V2
		from 'D:\OneDrive\Documents\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
				FIRSTROW = 2,
				FIELDTERMINATOR= ',',
				TABLOCK 
		);
		SET @end_time=GETDATE();
		--Calculate loading duration 
		PRINT 'Load duration :' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
		select count(*) from bronze.erp_PX_CAT_G1V2

		SET @batch_end_time=GETDATE();
		PRINT '==============='
		PRINT 'Loading bronze layer is completed'
		PRINT 'Total Load Duration' + CAST (DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT '============='

	END TRY
	--Catch errors
	BEGIN CATCH
		PRINT '======================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message'+ ERROR_Message();
		PRINT 'Error Message'+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR Message'+ CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================='
	END CATCH
END


EXEC bronze.load_bronze
