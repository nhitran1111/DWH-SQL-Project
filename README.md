# SQL Server Data Warehouse
## 📌 Objective
This project aim to build a contemporary data warehouse with SQL Server to integrate sales data, facilitating analytical reporting and data-driven decision-making.

---
## 📃 Requirement
- **Data Sources**: Import data from two primary systems ERP and CRM provided in CSV format.
- **Data Quality**: Perform data cleansing and resolve any quality issues before analysis.
- **Integration**: Merge data from both sources into a single, structured data model for analytical queries.
- **Scope**: Focus to the most recent dataset; historical data is not required.
- **Documentation**: Provide documentation of the data model to support business stakeholders and analytics teams.
---
## 🖼️ Description
This project involved Data Architecture, ETL Process, Data Modeling as described below:

### 1. Data Architecture: Using Medallion Architecture 
This approach includes Bronze, Silver, and Gold layers.
- Bronze Layer where Stores raw data from the source systems. In this project, data is ingested from CSV Files into SQL Server Database.
- Silver Layer Where perform data cleansing, standardization, and normalization processes to prepare data for analysis, but not apply business rules yet.
- Gold Layer where contains business-ready dataset modeled into a star schema required for reporting and analytics purpose.
![Data_Architeture](documents/Data_Architecture.png)
  
### 2. ETL Process: 
Extracting, transforming, and loading data from source systems into the warehouse as per below approaches:

⚒️ **Extraction**
- *Extraction method* : Pull extraction,
- *Extraction type* : Full load
- *Extraction technique* : File parsing

⚙️ **Transformation**
- Data Cleansing
- Data Enchrichment
- Data Integration
- Derived Column
- Data Normalization
- Business Rules & Logics
- Data Aggregations

 🔃 **Load**
- *Processing type* : Batch processing
- *Load method* : Fullload 
- *Slowly changing dimension*: Overwrite

### 3.Data Modeling
Developing fact and dimension tables optimized for analytical queries, following star schema model
![Data_Model](documents/Data_Model.png)
---
## ⛏️Toolkit: 
`SQL Server Express` `SQL Server Managerment Studio` `Draw.io` `Notion`


