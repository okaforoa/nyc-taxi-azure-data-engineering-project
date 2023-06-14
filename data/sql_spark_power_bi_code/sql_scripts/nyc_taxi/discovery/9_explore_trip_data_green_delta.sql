USE nyc_taxi_discovery;

-- Delta file, the table shows partitioned column itself. 
SELECT TOP 100
    *
    FROM OPENROWSET(
        BULK 'trip_data_green_delta/',  --point to main folder instead of file name
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'DELTA'
    ) AS trip_data

-- Get error will specify Subfolder 
SELECT TOP 100
    *
    FROM OPENROWSET(
        BULK 'trip_data_green_delta/year=2020',  
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'DELTA'
    ) AS trip_data

-- Let check Data Type 
EXEC sp_describe_first_result_set N'
SELECT TOP 100
    *
    FROM OPENROWSET(
        BULK ''trip_data_green_delta/'',  
        DATA_SOURCE = ''nyc_taxi_data_raw'',
        FORMAT = ''DELTA''
    ) AS trip_data'
-- Its show incorrect data type in 3 columns: varchar(8000) - store_and_fwd_flag, year, month 

-- Change Data Type
SELECT TOP 100
    *
    FROM OPENROWSET(
        BULK 'trip_data_green_delta/',  
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'DELTA'
    ) WITH(
        VendorID INT,
        lpep_pickup_datetime datetime2(7),
        lpep_dropoff_datetime datetime2(7),
        store_and_fwd_flag CHAR(1),
        RatecodeID INT,
        PULocationID INT,
        DOLocationID INT,
        passenger_count INT,
        trip_distance FLOAT,
        fare_amount FLOAT,
        extra FLOAT,
        mta_tax FLOAT,
        tip_amount FLOAT,
        tolls_amount FLOAT,
        ehail_fee INT,
        improvement_surcharge FLOAT,
        total_amount FLOAT,
        payment_type INT,
        trip_type INT,
        congestion_surcharge FLOAT,
        year VARCHAR(4),
        month VARCHAR(2)
    ) AS trip_data;

-- To select only some column 
SELECT TOP 100
    *
    FROM OPENROWSET(
        BULK 'trip_data_green_delta/',  
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'DELTA'
    ) WITH(
        trip_distance FLOAT,
        fare_amount FLOAT,
        year VARCHAR(4),    -- need to specify year(that was generated column by delta), it will be error if not specify
        month VARCHAR(2)    -- need to specify month(that was generated column by delta)
    ) AS trip_data;

-- Compare with WHERE clause and without WHERE -- data scanned usage is different! 
SELECT COUNT(DISTINCT(payment_type))
    FROM OPENROWSET(
        BULK 'trip_data_green_delta/',  
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'DELTA'
    ) AS trip_data;

SELECT COUNT(DISTINCT(payment_type))
    FROM OPENROWSET(
        BULK 'trip_data_green_delta/',  
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'DELTA'
    ) AS trip_data
WHERE year='2020' AND month='01';
