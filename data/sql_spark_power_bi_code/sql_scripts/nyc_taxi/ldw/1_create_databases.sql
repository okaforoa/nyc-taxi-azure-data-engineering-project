USE master
GO 

-- Create new database
CREATE DATABASE nyc_taxi_ldw
GO 

ALTER DATABASE nyc_taxi_ldw COLLATE Latin1_General_100_BIN2_UTF8
GO

USE nyc_taxi_ldw
GO 

-- Create Schema for BRONZE, SILVER and GOLD 
CREATE SCHEMA bronze
GO 

CREATE SCHEMA silver
GO

CREATE SCHEMA gold
GO