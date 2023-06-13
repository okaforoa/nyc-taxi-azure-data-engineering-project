# NYC Taxi Azure Data Engineering Project
![Azure Synapse Analytics](https://github.com/okaforoa/nyc-taxi-azure-data-engineering-project/blob/8404c1e5b2843024bad9557fd63fde20964e63e8/Azure%20Synapse%20Analytics.jpg)

### Introduction
In this [Udemy course project](https://www.udemy.com/course/azure-synapse-analytics-for-data-engineers) created by Ramesh Retnasamy, I implemented a data engineering solution using all services available onAzure Synapse Analytics to analyze and report on NYC Taxi trips data.

### What is Azure Synapse Analytics
Azure Synapse Analytics is a limitless analytics service that brings together data integration, enterprise data warehousing and big data analytics. 


### Solution Architecture - Serverless SQL Pool
![Serverless Pool](https://github.com/okaforoa/nyc-taxi-azure-data-engineering-project/blob/main/SQL%20Serverless%20Solution%20Arch.png)

### About Dataset
This data contains information NYC Green Trip data from 2020 and 2021. - [NYC Green Trip Data](https://1drv.ms/u/s!Aku-bu-I9uuYiFZRUJvhqGJ_Q9sM?e=4Fke0N)

### Services Used
1. **Amazon S3:** Amazon S3 (Simple Storage Service) is a web-based cloud storage service by Amazon Web Services (AWS), designed for storing and retrieving data from anywhere on the web. It's known for its scalability, security, and durability, making it ideal for applications ranging from backup and restore, to content distribution and disaster recovery. 

2. **AWS Lambda:** AWS Lambda is a serverless computing service provided by Amazon Web Services (AWS) that runs your code in response to events and automatically manages the computing resources for you. It enables developers to build applications that respond quickly to new information, scale on demand, and operate without the need for server management.

3. **Amazon CloudWatch:** Amazon CloudWatch is a monitoring and observability service offered by Amazon Web Services (AWS) that provides data and actionable insights for AWS, hybrid, and on-premises applications and infrastructure. It collects and tracks metrics, collects and monitors log files, sets alarms, and automatically reacts to changes in your AWS resources, helping you to keep your applications running smoothly.

4. **AWS Glue Crawler:** AWS Glue Crawler is a service provided by Amazon Web Services that automates the process of data discovery, cataloging, and schema inference in your data lake or database. It connects to your source data, processes it to extract metadata (like table schema and statistics), and stores this metadata in the AWS Glue Data Catalog for use in data exploration, data transformation, and job scheduling.

5. **AWS Glue Data Catalog:** AWS Glue Data Catalog is a fully managed, scalable, metadata storage service provided by Amazon Web Services (AWS) that makes data discoverable and accessible for ETL, data preparation, and analytics. It integrates with Amazon S3, Amazon RDS, Amazon Redshift, and other data stores, providing a unified view of all your data sources, enabling centralized data management across various AWS services.

6. **Amazon Athena:** Amazon Athena is an interactive query service provided by Amazon Web Services (AWS) that makes it easy to analyze data stored in Amazon S3 using standard SQL. It's serverless, so there's no infrastructure to manage, allowing you to start analyzing your data immediately without the need for complex data warehouses or clusters to set up.

### Install Packages
```
pip install pandas
pip install numpy
pip install spotipy
```

### Project Execution Flow 
Extract Data from API -> Lambda Trigger (every 1 hour) -> Run Extract Code -> Store Raw Data -> Trigger Transformation Function -> Transform Data and Load It -> Query Using Athena
