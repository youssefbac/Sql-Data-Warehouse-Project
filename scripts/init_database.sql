/*

Create database and schemas

this script creates a new database named DataWarehouse after cheking if it already exists
if the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
bronze,silver,gold
 
*/
USE master;

--Drop and recreate the datawarehouse database
IF EXISTS(SELECT 1 FROM sys.databases where name='DataWarehouse')
BEGIN
   ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP DATABASE DataWarehouse;
END;
GO


-- Create Database 'DataWarehouse 
CREATE DATABASE  DataWarehouse;

USE DataWarehouse;


-- Create Schemas 
GO
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO 
CREATE SCHEMA gold;
 
