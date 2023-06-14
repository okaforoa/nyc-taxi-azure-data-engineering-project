USE nyc_taxi_ldw; 


-- https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-external-tables?tabs=native
-- create External data source 

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'nyc_taxi_src')
    CREATE EXTERNAL DATA SOURCE nyc_taxi_src
    WITH
    (    LOCATION         = 'https://synapsecoursedl2023.dfs.core.windows.net/nyc-taxi-data' -- 'nyc-taxi-data' in ADLS
    );
