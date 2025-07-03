
----------------------Quality checks -------------------------------------
/*
Store procedure : Load silver layer

Purpose: this store procedure performs the ETL process to create the silver schemas table from Bronze schemas table
- Null or primary key
- uwanted spaces in string fields 
- Data standardization and consistency
- invalid data ranges and orders

*/


---Data Exploration---

--check duplicate in primary key
select 
cst_id,
count(*)
from bronze.crm_cust_info
Group by cst_id
having count(*) > 1

--check for unwanted spaces
SELECT cst_firstname 
from bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--check distinct data 

select distinct cst_gndr
from bronze.crm_cust_info

--Check for invalid Dates

SELECT
NULLIF(sls_due_dt,0) sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_order_dt >= sls_ship_dt  OR sls_order_dt > sls_due_dt  



--check duplicate key from prd_info table
select prd_id,
count(*)
from bronze.crm_prd_info
GROUP BY prd_id
having COUNT(*) > 1 OR prd_id IS NULL

--check for invalid Date orders 
select *
from silver.crm_prd_info
where prd_end_dt < prd_start_dt
select top 10 * from silver.crm_prd_info


--check null values and negative values on prd_cost column
select 
prd_cost
from bronze.crm_prd_info
where prd_cost < 0 or prd_cost IS NULL


-- Check data consistency 
-- Sales= Qunatity * price
-- Values must not be null,zero or negative

SELECT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR  sls_quantity IS NULL or sls_price IS NULL
OR sls_sales  <=0 OR  sls_quantity  <=0 or sls_price <=0


SELECT DISTINCT 
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <=0 or sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <=  0
          THEN sls_sales / NULLIF(sls_quantity,0)
		  ELSE sls_price
END AS sls_sales
from bronze.crm_sales_details

