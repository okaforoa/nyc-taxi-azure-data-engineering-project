USE nyc_taxi_discovery

/* Identify the percentage of cash and credit card trips by Borough
Example Data as below
----------------------------------------------------------------------------------------------------
borough      total_trips    cash_trips   card_trips   cash_trips_percentage    card_trip_percentage
----------------------------------------------------------------------------------------------------
Bronx        2019           751          1268         37.20                     62.80
Brooklyn     6435           2192         4243         34.06                     65.94
----------------------------------------------------------------------------------------------------
*/ 

WITH v_payment_type AS
(
    SELECT CAST(JSON_VALUE(jsonDoc,'$.payment_type') AS SMALLINT) AS payment_type, 
           CAST(JSON_VALUE(jsonDoc,'$.payment_type_desc') AS VARCHAR(15)) AS payment_type_desc
    FROM OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'csv',
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a'
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type
), 
v_taxi_zone AS
(
    SELECT
    *
    FROM
        OPENROWSET(
            BULK 'taxi_zone.csv',
            DATA_SOURCE = 'nyc_taxi_data_raw',
            FORMAT = 'CSV',
            PARSER_VERSION = '2.0',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        ) 
        WITH (
            LocationID SMALLINT 1, 
            Borough VARCHAR(15) 2, 
            Zone VARCHAR(50) 3,
            service_zone VARCHAR(15) 4
        )AS [result]
),
v_trip_data AS
(
    SELECT
        *
    FROM
        OPENROWSET(
            BULK 'trip_data_green_parquet/year=2021/month=01/**',
            FORMAT = 'PARQUET',
            DATA_SOURCE = 'nyc_taxi_data_raw'
        ) AS [result]
)
-- JOIN data 
SELECT 
        v_taxi_zone.borough,
        COUNT(1) AS total_trip,
        SUM(CASE WHEN v_payment_type.payment_type_desc = 'Cash' THEN 1 ELSE 0 END) AS cash_trips,
        SUM(CASE WHEN v_payment_type.payment_type_desc = 'Credit card' THEN 1 ELSE 0 END) AS card_trips, 
        CAST((SUM(CASE WHEN v_payment_type.payment_type_desc = 'Cash' THEN 1 ELSE 0 END) / CAST(COUNT(1) AS DECIMAL)) * 100 AS DECIMAL(5,2)) AS cash_trips_percentage,
        CAST((SUM(CASE WHEN v_payment_type.payment_type_desc = 'Credit card' THEN 1 ELSE 0 END) / CAST(COUNT(1) AS DECIMAL)) * 100 AS DECIMAL(5,2)) AS card_trips_percentage
    FROM v_trip_data
    LEFT JOIN v_payment_type ON (v_trip_data.payment_type = v_payment_type.payment_type)
    LEFT JOIN v_taxi_zone ON (v_trip_data.PULocationId = v_taxi_zone.LocationID)
WHERE v_payment_type.payment_type_desc IN ('Cash', 'Credit card')
GROUP BY v_taxi_zone.borough
ORDER BY v_taxi_zone.borough;





