# Data Warehouse and analytics Project

welcome to the **Data Warehouse And analytics Project** repository
this project demonstrates a comprehensicve data warehousing and analytics solution from building a data warehouse to generating actionable insights. 

## Project Requirements

### Building the Data Warehouse

#### Objectives

Develop a modern data warehouse with Sql Server to consolidate sales data and informed decision making.


#### Specifications 

**Data Sources** :Import data from two source systems ERP and CRM.

**Data Quality** : Clean and resolve data quality issues prior to analysis.

**Integration** : Combine both sources into a single user friendly data model

**Scope**: Focus on the latest dataset only: historization not required

**Documentation**: Provide clear documentation

### BI : Analytics & Reporting

#### Objective
Develop SQL-based analytics to deliver detailed insights into:

**Customer Behavior**

**Product Performance**

**Sales Trends**
These insights empower stakeholders with key business metrics, enabling strategic decision_making


#### Data Architecture

The data architecture fot this project follows medallion Architecture Bronze,Silver and Gold layers 

<img width="748" height="690" alt="image" src="https://github.com/user-attachments/assets/e0568603-6ade-4bbc-aa96-7714a1354890" />

1. Bronze layer Stores raw data as is from the source systems. Details ingested from CSV files into SQL Server Database.
2. Silver Layer this layer includes data cleaning standardization and normalization to prepare data for analytics.
3. Gold Layer Houses business ready data modeled into star schema required for reporting and analytics.










=> Empowering stackeholders with key business metrics

