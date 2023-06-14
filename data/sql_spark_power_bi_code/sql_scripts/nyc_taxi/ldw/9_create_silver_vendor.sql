USE nyc_taxi_ldw

--To transform all file type to Parquet format
-- 3) Vendor (from CSV[Bronze] to Parquet[Silver])

IF OBJECT_ID(silver.vendor) IS NOT NULL
    DROP EXTERNAL TABLE silver.vendor

CREATE EXTERNAL TABLE silver.vendor
    WITH(
        DATA_SOURCE = nyc_taxi_src, 
        LOCATION = 'silver/vendor',
        FILE_FORMAT = parquet_file_format
    )
AS 
SELECT * FROM bronze.vendor;

-- Query 
SELECT * FROM silver.vendor