/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Create database and schemas
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
		This script creates a new database named 'DataWarehouse'. After checking, if the database named 'DataWarehouse' is already exist in the 
		server, this database is dropped and recreated. Once the new database has been successfully created, the scripts also set up three 
		schemas within the database including 'bronze', 'silver', 'gold'.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/
 
-- create database 'DataWarehouse'
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
	  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	  DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--create the three schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
