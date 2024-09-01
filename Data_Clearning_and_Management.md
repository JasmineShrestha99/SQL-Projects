# Sales Data Cleaning and Management

**Author:** Jasmine Shrestha  
**File:** Data_Cleaning_and_Management.sql

## Overview

This SQL script is designed to clean, standardize, and optimize data across several tables in the sales-related database. The script removes duplicate records, handles NULL values, standardizes data formats, and implements triggers to ensure data integrity and efficient performance.

## Tables

### 1. **Customers**
   - **Purpose:** Stores vital customer details, including contact information and addresses.
   - **Key Operations:**
     - **Duplicate Removal:** Ensures no duplicate records exist based on `CustomerName`, `ContactInfo`, and `Address`.
     - **NULL Handling:** Replaces missing contact information and addresses with default values.
     - **Standardization:** Normalizes email formats to lowercase for consistency.

### 2. **Clients**
   - **Purpose:** Contains information about corporate clients, including contact persons and contact information.
   - **Key Operations:**
     - **Duplicate Removal:** Eliminates duplicate client records based on `ClientName`, `ContactPerson`, and `ContactInfo`.
     - **NULL Handling:** Fills in missing contact details with placeholders.
     - **Standardization:** Formats phone numbers into a standardized pattern.

### 3. **Employees_Data**
   - **Purpose:** Records details of all employees, including their position and department.
   - **Key Operations:**
     - **Duplicate Removal:** Removes duplicate entries based on `EmployeeName`, `Position`, and `Department`.
     - **NULL Handling:** Assigns default values to missing positions and departments.
     - **Trigger:** Logs every deletion of an employee record to the `Employee_Deletion_Log` table, ensuring that any removal of employee data is tracked for audit purposes.

### 4. **Inventory_Records**
   - **Purpose:** Tracks product inventory across various warehouses.
   - **Key Operations:**
     - **Duplicate Removal:** Ensures each record is unique based on `ProductID`, `Quantity`, and `WarehouseID`.
     - **NULL Handling:** Sets default values for missing quantities and warehouse IDs.
     - **Trigger:** Updates the `LastModifiedDate` column automatically whenever an inventory record is updated, helping to track when the last changes were made.

### 5. **Shipment_Details**
   - **Purpose:** Manages the shipping information for customer orders.
   - **Key Operations:**
     - **Duplicate Removal:** Removes any duplicate shipment entries based on `OrderID`, `ShippingDate`, and `Carrier`.
     - **NULL Handling:** Defaults missing shipping dates to the current date and missing carrier information to 'Unknown Carrier'.
     - **Trigger:** Ensures that every `OrderID` in the `Shipment_Details` table corresponds to an existing `OrderID` in the `Orders` table, maintaining the integrity of the shipment data.

## Triggers

### 1. **`trg_log_employee_deletion`**
   - **Purpose:** Automatically logs the deletion of any record from the `Employees_Data` table into the `Employee_Deletion_Log` table.
   - **Description:** This trigger is executed before a record is deleted from the `Employees_Data` table. It captures the `EmployeeID` and the timestamp of deletion, ensuring that all deletions are tracked for audit purposes.

### 2. **`trg_update_inventory_modified`**
   - **Purpose:** Automatically updates the `LastModifiedDate` in the `Inventory_Records` table whenever a record is updated.
   - **Description:** This trigger is executed before an update operation on the `Inventory_Records` table. It sets the `LastModifiedDate` field to the current timestamp, providing a record of when the inventory data was last modified.

### 3. **`trg_check_order_existence`**
   - **Purpose:** Ensures that every `OrderID` in the `Shipment_Details` table exists in the `Orders` table.
   - **Description:** This trigger is executed before a new record is inserted into the `Shipment_Details` table. It checks the `Orders` table to ensure that the `OrderID` being referenced exists. If it does not, the trigger raises an error, preventing the insertion of invalid data.

## Indexes for Performance Optimization

- **Customers Table:** An index is created on `CustomerID` to speed up queries.
- **Employees_Data Table:** An index is created on `EmployeeID` for efficient querying.
- **Inventory_Records Table:** An index is created on `ProductID` to improve performance.
- **Shipment_Details Table:** An index is created on `OrderID` to optimize data retrieval.
