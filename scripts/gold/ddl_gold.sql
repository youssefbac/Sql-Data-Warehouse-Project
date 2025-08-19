/*
--Create Gold views

Script Purpose:
the script creates views for the gold layer in the data warehouse
the gold layer represents the final dimension and fact tables

Usage:
These view can be quired directly for analytics and reporting

*/

--create customers dimension

CREATE VIEW gold.dim_customers as 
SELECT 
    ROW_NUMBER() OVER (order by cst_id ) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_firstname as firstname,
	ci.cst_key as customer_number,
	ci.cst_lastname as last_name,
	ci.cst_marital_status as marital_status,
	la.cntry as country,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen,'n/a')
    END as new_gen,
	ca.bdate as bithdate,
	ci.cst_create_date as create_date
  FROM silver.crm_cust_info ci
  LEFT JOIN silver.erp_cust_az12 ca
  on ci.cst_key= ca.cid
  LEFT JOIN silver.erp_loc_a101 la
  on ci.cst_key=la.cid


--create products dimension
  
CREATE VIEW gold.dim_products AS
select 
   ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id as product_id,
	pn.cat_id as category_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.prd_cost as cost ,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance 
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL


  
select DISTINCT
	ci.cst_gndr,
	ca.gen,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen,'n/a')
    END as new_gen
FROM silver.crm_cust_info ci
  LEFT JOIN silver.erp_cust_az12 ca
  on ci.cst_key= ca.cid
  LEFT JOIN silver.erp_loc_a101 la
  on ci.cst_key=la.cid
  ORDER BY 1,2


--create fact sales   
CREATE VIEW gold.fact_sales as
select 
sd.sls_ord_num as order_number,
cu.customer_id,
pr.product_key,
sd.sls_cust_id,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_price as price
from silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id= cu.customer_id

--Foreign key integrity

select *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key= f.customer_id
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
where p.product_key IS NULL


