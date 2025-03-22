# DWH-SQL-Project
## Objective
---
- This project aim to build a contemporary data warehouse with SQL Server to integrate sales data, facilitating analytical reporting and data-driven decision-making.
---
## Requirement
- Data Sources: Import data from two primary systems ERP and CRM provided in CSV format.
- Data Quality: Perform data cleansing and resolve any quality issues before analysis.
- Integration: Merge data from both sources into a single, structured data model for analytical queries.
- Scope: Focus to the most recent dataset; historical data is not required.
- Documentation: Provide documentation of the data model to support business stakeholders and analytics teams.
---
## Description
This project involved in
1. Data Architecture
2. ETL Process
3. Data Modelling


#### 1. Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
##### - Bronze Layer where Stores raw data from the source systems. In this project, data is ingested from CSV Files into SQL Server Database.
##### - Silver Layer Where perform data cleansing, standardization, and normalization processes to prepare data for analysis, but not apply business rules yet.
##### - Gold Layer where contains business-ready dataset modeled into a star schema required for reporting and analytics purpose.

3. ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
Extraction method: Pull extraction,
Extraction type: Full load
Extraction technique: File parsing
Load
Processing type: Batch processing

/

Load method: Fullload - Truncate & Insert 
Slowly changing dimension: SCD2: Overwrite
Data Modeling: Developing fact and dimension tables optimized for analytical queries.


