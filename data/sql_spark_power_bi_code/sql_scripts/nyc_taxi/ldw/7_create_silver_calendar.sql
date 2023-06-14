USE nyc_taxi_ldw

--transforms all file types to Parquet format
-- 2) Calendar (from CSV[Bronze] to Parquet[Silver])

IF OBJECT_ID(silver.calendar) IS NOT NULL
    DROP EXTERNAL TABLE silver.calendar
GO

CREATE EXTERNAL TABLE silver.calendar
    WITH
    (
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/calendar',
        FILE_FORMAT = parquet_file_format
    )
AS
SELECT *
  FROM bronze.calendar;

-- Query 
SELECT * FROM silver.calendar