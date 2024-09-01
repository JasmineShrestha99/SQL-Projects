/*
    Author: Jasmine Shrestha
    File: Data_Cleaning_and_Management.sql
    Purpose: This script is meticulously designed to ensure the integrity, consistency, 
             and reliability of the Sales-related database, involving the following tables:
             - Customers
             - Clients
             - Employees_Data
             - Inventory_Records
             - Shipment_Details
             
             The operations include removal of duplicates, standardization of data formats, 
             handling of NULL values, and the implementation of triggers to automate 
             integrity checks and logging mechanisms.
*/

-- Customers Table Data Cleaning
/*
    The Customers table stores vital customer details including contact information. 
    This section ensures that:
    1. Duplicates based on CustomerName, ContactInfo, and Address are removed.
    2. NULL values are standardized with default values.
    3. Contact information is normalized to a consistent format.
*/

-- Removing duplicate customer entries
DELETE FROM Customers
WHERE CustomerID NOT IN (
    SELECT MIN(CustomerID)
    FROM Customers
    GROUP BY CustomerName, ContactInfo, Address
);

-- Handling NULL values in the Customers table
UPDATE Customers
SET ContactInfo = COALESCE(ContactInfo, 'Not Provided'),
    Address = COALESCE(Address, 'Unknown Address')
WHERE ContactInfo IS NULL OR Address IS NULL;

-- Standardizing email format in ContactInfo
UPDATE Customers
SET ContactInfo = LOWER(ContactInfo)
WHERE ContactInfo LIKE '%@%.%';

-- Clients Table Data Cleaning
/*
    The Clients table holds information about corporate clients. This section:
    1. Eliminates duplicates based on ClientName, ContactPerson, and ContactInfo.
    2. Replaces NULL values with appropriate placeholders.
    3. Normalizes the format of phone numbers to a standard pattern.
*/

-- Removing duplicate client entries
DELETE FROM Clients
WHERE ClientID NOT IN (
    SELECT MIN(ClientID)
    FROM Clients
    GROUP BY ClientName, ContactPerson, ContactInfo
);

-- Handling NULL values in the Clients table
UPDATE Clients
SET ContactPerson = COALESCE(ContactPerson, 'No Contact Person'),
    ContactInfo = COALESCE(ContactInfo, 'Not Provided')
WHERE ContactPerson IS NULL OR ContactInfo IS NULL;

-- Standardizing phone number format
UPDATE Clients
SET ContactInfo = REGEXP_REPLACE(ContactInfo, '[^0-9]', '')
WHERE ContactInfo LIKE '(___) ___-____';

-- Employees_Data Table Data Cleaning
/*
    The Employees_Data table stores records of all employees. This section:
    1. Removes duplicates based on EmployeeName, Position, and Department.
    2. Manages NULL values by assigning default values.
    3. Implements a trigger to log deletions for audit purposes.
*/

-- Removing duplicate employee entries
DELETE FROM Employees_Data
WHERE EmployeeID NOT IN (
    SELECT MIN(EmployeeID)
    FROM Employees_Data
    GROUP BY EmployeeName, Position, Department
);

-- Handling NULL values in Employees_Data
UPDATE Employees_Data
SET Position = COALESCE(Position, 'Unassigned Position'),
    Department = COALESCE(Department, 'Unassigned Department')
WHERE Position IS NULL OR Department IS NULL;

-- Trigger to log employee deletions for audit
CREATE TRIGGER trg_log_employee_deletion
BEFORE DELETE ON Employees_Data
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Deletion_Log(EmployeeID, DeletedAt)
    VALUES (OLD.EmployeeID, CURRENT_TIMESTAMP);
END;

-- Inventory_Records Table Data Cleaning
/*
    The Inventory_Records table tracks product inventory across various warehouses. 
    This section:
    1. Removes duplicate records based on ProductID, Quantity, and WarehouseID.
    2. Standardizes NULL values by setting them to defaults.
    3. Adds a trigger to automatically update the last modified timestamp.
*/

-- Removing duplicate inventory records
DELETE FROM Inventory_Records
WHERE RecordID NOT IN (
    SELECT MIN(RecordID)
    FROM Inventory_Records
    GROUP BY ProductID, Quantity, WarehouseID
);

-- Handling NULL values in Inventory_Records
UPDATE Inventory_Records
SET Quantity = COALESCE(Quantity, 0),
    WarehouseID = COALESCE(WarehouseID, 0)
WHERE Quantity IS NULL OR WarehouseID IS NULL;

-- Trigger to update the last modified date in Inventory_Records
CREATE TRIGGER trg_update_inventory_modified
BEFORE UPDATE ON Inventory_Records
FOR EACH ROW
BEGIN
    SET NEW.LastModifiedDate = CURRENT_TIMESTAMP;
END;

-- Shipment_Details Table Data Cleaning
/*
    The Shipment_Details table records the shipping information for customer orders. 
    This section:
    1. Removes duplicates based on OrderID, ShippingDate, and Carrier.
    2. Handles NULL values by setting them to appropriate defaults.
    3. Implements a trigger to ensure that each OrderID in Shipment_Details exists in the Orders table.
*/

-- Removing duplicate shipment entries
DELETE FROM Shipment_Details
WHERE ShipmentID NOT IN (
    SELECT MIN(ShipmentID)
    FROM Shipment_Details
    GROUP BY OrderID, ShippingDate, Carrier
);

-- Handling NULL values in Shipment_Details
UPDATE Shipment_Details
SET ShippingDate = COALESCE(ShippingDate, CURRENT_DATE),
    Carrier = COALESCE(Carrier, 'Unknown Carrier')
WHERE ShippingDate IS NULL OR Carrier IS NULL;

-- Trigger to ensure that OrderID exists in the Orders table
CREATE TRIGGER trg_check_order_existence
BEFORE INSERT ON Shipment_Details
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = NEW.OrderID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'OrderID does not exist in Orders table';
    END IF;
END;

-- Indexing for Performance Optimization
/*
    To optimize query performance, indexes are created on key columns:
    1. CustomerID in the Customers table.
    2. EmployeeID in the Employees_Data table.
    3. ProductID in the Inventory_Records table.
    4. OrderID in the Shipment_Details table.
*/

-- Creating index on CustomerID in Customers table
CREATE INDEX idx_customer_id ON Customers(CustomerID);

-- Creating index on EmployeeID in Employees_Data table
CREATE INDEX idx_employee_id ON Employees_Data(EmployeeID);

-- Creating index on ProductID in Inventory_Records table
CREATE INDEX idx_product_id ON Inventory_Records(ProductID);

-- Creating index on OrderID in Shipment_Details table
CREATE INDEX idx_order_id ON Shipment_Details(OrderID);
