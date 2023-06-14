USE nyc_taxi_discovery

-- Identify number of trips made from each Barough
-------------------------------------------------
-- Use "PULocationID(PickUp)" from trip data JOINING "Zone" from taxi zone file with "LOCATIONID"
-- Step 1: check for NULL values in PULocationID
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE = 'nyc_taxi_data_raw'
    ) AS [result]
WHERE PULocationID IS NULL 
-- No NULL appears 

-- Step 2: Join both tables
SELECT taxi_zone.*, trip_data.*
    FROM OPENROWSET(
                    BULK 'trip_data_green_parquet/year=2020/month=01/',
                    FORMAT = 'PARQUET',
                    DATA_SOURCE = 'nyc_taxi_data_raw'
                ) AS trip_data
    JOIN 
        OPENROWSET(
                    BULK 'taxi_zone.csv',
                    DATA_SOURCE = 'nyc_taxi_data_raw',
                    FORMAT = 'CSV',
                    PARSER_VERSION = '2.0',
                    FIRSTROW = 2
                ) 
                WITH (
                    LocationID SMALLINT 1, 
                    Borough VARCHAR(15) 2, 
                    Zone VARCHAR(50) 3,
                    service_zone VARCHAR(15) 4
                )AS taxi_zone
    ON trip_data.PULocationID = taxi_zone.LocationID

-- Step 3: Count and Group by
SELECT taxi_zone.borough,
        COUNT(1) AS number_of_trips
    FROM OPENROWSET(
                    BULK 'trip_data_green_parquet/year=2020/month=01/',
                    FORMAT = 'PARQUET',
                    DATA_SOURCE = 'nyc_taxi_data_raw'
                ) AS trip_data
    JOIN 
        OPENROWSET(
                    BULK 'taxi_zone.csv',
                    DATA_SOURCE = 'nyc_taxi_data_raw',
                    FORMAT = 'CSV',
                    PARSER_VERSION = '2.0',
                    FIRSTROW = 2
                ) 
                WITH (
                    LocationID SMALLINT 1, 
                    Borough VARCHAR(15) 2, 
                    Zone VARCHAR(50) 3,
                    service_zone VARCHAR(15) 4
                )AS taxi_zone
    ON trip_data.PULocationID = taxi_zone.LocationID
GROUP BY taxi_zone.borough
ORDER BY number_of_trips;


