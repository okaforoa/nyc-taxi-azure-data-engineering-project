USE nyc_taxi_discovery

-- Number of trips made by duration in hours
-- Step 1 - Look at Pickup_datetime and dropoff_datetime from trip_data 
SELECT 
    lpep_pickup_datetime,
    lpep_dropoff_datetime
FROM OPENROWSET(
    BULK 'trip_data_green_parquet/year=2020/month=01/',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS trip_data

-- Step 2 - use DATEDIFF function
SELECT 
    lpep_pickup_datetime,
    lpep_dropoff_datetime,
    DATEDIFF(minute, lpep_pickup_datetime, lpep_dropoff_datetime) / 60 AS from_hour,
    (DATEDIFF(minute, lpep_pickup_datetime, lpep_dropoff_datetime) / 60) + 1 AS to_hour
FROM OPENROWSET(
    BULK 'trip_data_green_parquet/year=2020/month=01/',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS trip_data

-- Step 3 - COUNT
SELECT 
    DATEDIFF(minute, lpep_pickup_datetime, lpep_dropoff_datetime) / 60 AS from_hour,
    (DATEDIFF(minute, lpep_pickup_datetime, lpep_dropoff_datetime) / 60) + 1 AS to_hour,
    COUNT(1) AS number_of_trips
FROM OPENROWSET(
    BULK 'trip_data_green_parquet/year=2020/month=01/',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS trip_data
GROUP BY DATEDIFF(minute, lpep_pickup_datetime, lpep_dropoff_datetime) / 60,
    (DATEDIFF(minute, lpep_pickup_datetime, lpep_dropoff_datetime) / 60) + 1
ORDER BY from_hour, to_hour;