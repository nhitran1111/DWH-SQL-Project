# Data Catalog for Gold Layer

## Introduction
The Gold Layer represents business-level data, structured to promote analytics and reporting. Where contains dimension tables and fact tables designed for specific business metrics.

---
## Description
### 1. **gold.dim_customers**
- Stores customer details enriched with demographic and geographic data.

| Column Name      | Data Type     | Description                                                                                      |
|------------------|---------------|--------------------------------------------------------------------------------------------------|
| customer_key     | INT           | A surrogate key serves as a unique identifier for each customer.                                 |
| customer_id      | INT           | Unique numerical identifier of each customer.                                                    |
| customer_number  | NVARCHAR(50)  | An alphanumeric code assigned to the customer for tracking and reference purposes.               |
| first_name       | NVARCHAR(50)  | The first name of the customer.                                                                  |
| last_name        | NVARCHAR(50)  | The last name of the customer.                                                                   |
| country          | NVARCHAR(50)  | The country associated with the customer's residence (e.g., 'United States, Germany',...).       |
| marital_status   | NVARCHAR(20)  | The marital status of the customer (e.g., 'Married', 'Single', 'N/A').                           |
| gender           | NVARCHAR(20)  | The gender of the customer (e.g., 'Male', 'Female', 'N/A').                                      |
| birthdate        | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1980-12-24).                   |
| create_date      | DATE          | The date when the customer record was created in the syste, formatted as YYYY-MM-DD              |

---

### 2. **gold.dim_products**
Provides information about the products and their attributes.

| Column Name         | Data Type     | Description                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key         | INT           | A surrogate key serves as a unique identifier for each product.                               |
| product_id          | INT           | Unique numerical identifier of each product for internal tracking and referencing.            |
| product_number      | NVARCHAR(50)  | An alphanumeric code assigned to the product, used for categorization or inventory.           |
| product_name        | NVARCHAR(50)  | Descriptive name of the product, incorporating key details like type, color, and size.        |
| category_id         | NVARCHAR(50)  | A unique identifier for the product category, connecting it to its high level classification. |
| category            | NVARCHAR(50)  | The broader classification of the product (e.g., Bikes, Components) to group related items.   |
| subcategory         | NVARCHAR(50)  | A detailed breakdown of the product under its category, specifying characteristics.           |
| maintenance         | NVARCHAR(50)  | Indicating if the product requires periodic maintenance (e.g., 'Yes', 'No').                  |
| cost                | INT           | The initial cost of the product, measured in currency units.                                  |
| product_line        | NVARCHAR(50)  | The designated product line or series that the product is part of (e.g., Road, Mountain).     |
| start_date          | DATE          | The date the product was released for sale, use or recorded in the system.                    |

---

### 3. **gold.fact_sales**
- Stores transactional sales data for analytical purposes.

| Column Name     | Data Type     | Description                                                                                        |
|-----------------|---------------|----------------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | A unique alphanumeric identifier for each sales order (e.g., 'SO54496').                           |
| product_key     | INT           | Surrogate key linking the order to the product dimension table.                                    |
| customer_key    | INT           | Surrogate key linking the order to the customer dimension table.                                   |
| order_date      | DATE          | The date when the order was placed, formatted as YYYY-MM-DD.                                       |
| shipping_date   | DATE          | The date when the order was shipped to the customer, formatted as YYYY-MM-DD.                      |
| due_date        | DATE          | The date when the order payment was due, formatted as YYYY-MM-DD.                                  |
| sales_amount    | INT           | The total monetary value of the sale for the line item                                             |
| quantity        | INT           | The number of units of the product ordered for the line item (e.g., 1).                            |
| price           | INT           | The price per unit of the product for the line item  
