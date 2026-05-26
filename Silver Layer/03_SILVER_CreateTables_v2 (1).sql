-- =============================================================================
-- SILVER LAYER | STEP 1 OF 2 : CREATE TABLES
-- Run after bronze load succeeds.
-- 
-- Improvements vs v1:
--   - silver.EMPLOYEES: added Years_of_Service (derived from Hire_Date)
--   - silver.PRODUCTS:  added Brand_Name, Department_Name (enriched via join)
--   - All tables: duplicate-safe (handled in load procedure via ROW_NUMBER)
-- =============================================================================

USE DataWarehouse;
GO

-- Audit log
IF OBJECT_ID('silver.load_log','U') IS NOT NULL DROP TABLE silver.load_log;
CREATE TABLE silver.load_log (
    log_id        INT IDENTITY(1,1) PRIMARY KEY,
    table_name    NVARCHAR(128) NOT NULL,
    rows_loaded   INT           NULL,
    load_start    DATETIME      NOT NULL DEFAULT GETDATE(),
    load_end      DATETIME      NULL,
    status        NVARCHAR(20)  NOT NULL DEFAULT 'RUNNING',
    error_message NVARCHAR(MAX) NULL
);

-- BRANDS
IF OBJECT_ID('silver.BRANDS','U') IS NOT NULL DROP TABLE silver.BRANDS;
CREATE TABLE silver.BRANDS (
    Brand_ID   INT           NOT NULL,
    Brand_Name NVARCHAR(100) NOT NULL
);

-- CUSTOMERS
IF OBJECT_ID('silver.CUSTOMERS','U') IS NOT NULL DROP TABLE silver.CUSTOMERS;
CREATE TABLE silver.CUSTOMERS (
    Customer_ID   INT           NOT NULL,
    First_Name    NVARCHAR(100) NOT NULL,
    Last_Name     NVARCHAR(100) NOT NULL,
    Full_Name     NVARCHAR(200) NOT NULL,   -- DERIVED: First_Name + ' ' + Last_Name
    Gender        NVARCHAR(10)  NOT NULL,
    City          NVARCHAR(100) NOT NULL,
    Loyalty_Level NVARCHAR(20)  NOT NULL,
    Email         NVARCHAR(200) NOT NULL
);

-- DATA_QUALITY_REPORT
IF OBJECT_ID('silver.DATA_QUALITY_REPORT','U') IS NOT NULL DROP TABLE silver.DATA_QUALITY_REPORT;
CREATE TABLE silver.DATA_QUALITY_REPORT (
    Table_Name NVARCHAR(128) NOT NULL,
    Row_Count  INT           NOT NULL
);

-- DELIVERIES
IF OBJECT_ID('silver.DELIVERIES','U') IS NOT NULL DROP TABLE silver.DELIVERIES;
CREATE TABLE silver.DELIVERIES (
    Delivery_ID     INT          NOT NULL,
    Order_ID        INT          NOT NULL,
    Provider_ID     INT          NOT NULL,
    Ship_Date       DATETIME     NULL,
    Delivery_Date   DATETIME     NULL,
    Delivery_Status NVARCHAR(50) NOT NULL
);

-- DELIVERY_PROVIDERS
IF OBJECT_ID('silver.DELIVERY_PROVIDERS','U') IS NOT NULL DROP TABLE silver.DELIVERY_PROVIDERS;
CREATE TABLE silver.DELIVERY_PROVIDERS (
    Provider_ID   INT           NOT NULL,
    Provider_Name NVARCHAR(100) NOT NULL,
    Phone         NVARCHAR(30)  NULL
);

-- DEPARTMENTS
IF OBJECT_ID('silver.DEPARTMENTS','U') IS NOT NULL DROP TABLE silver.DEPARTMENTS;
CREATE TABLE silver.DEPARTMENTS (
    Department_ID   INT           NOT NULL,
    Department_Name NVARCHAR(100) NOT NULL
);

-- EMPLOYEES
-- Derived: First_Name, Last_Name (split from Name), Years_of_Service
IF OBJECT_ID('silver.EMPLOYEES','U') IS NOT NULL DROP TABLE silver.EMPLOYEES;
CREATE TABLE silver.EMPLOYEES (
    Employee_ID      INT           NOT NULL,
    Full_Name        NVARCHAR(200) NOT NULL,
    First_Name       NVARCHAR(100) NOT NULL,   -- DERIVED: split from Full_Name
    Last_Name        NVARCHAR(100) NOT NULL,   -- DERIVED: split from Full_Name
    Gender           NVARCHAR(10)  NOT NULL,
    Position         NVARCHAR(100) NOT NULL,
    Store_ID         INT           NOT NULL,
    Hire_Date        DATE          NOT NULL,
    Years_of_Service INT           NOT NULL    -- DERIVED: DATEDIFF years from Hire_Date
);

-- INVENTORY
IF OBJECT_ID('silver.INVENTORY','U') IS NOT NULL DROP TABLE silver.INVENTORY;
CREATE TABLE silver.INVENTORY (
    Inventory_ID INT      NOT NULL,
    Store_ID     INT      NOT NULL,
    Product_ID   INT      NOT NULL,
    Stock_Level  INT      NOT NULL,   -- NULLs (180 rows) replaced with 0
    Last_Updated DATETIME NOT NULL
);

-- ONLINE_ORDER_ITEMS
IF OBJECT_ID('silver.ONLINE_ORDER_ITEMS','U') IS NOT NULL DROP TABLE silver.ONLINE_ORDER_ITEMS;
CREATE TABLE silver.ONLINE_ORDER_ITEMS (
    Order_Item_ID INT           NOT NULL,
    Order_ID      INT           NOT NULL,
    Product_ID    INT           NOT NULL,
    Promotion_ID  INT           NOT NULL,   -- 0 = no promotion
    Quantity      INT           NOT NULL,
    Unit_Price    DECIMAL(10,2) NOT NULL,
    Line_Total    DECIMAL(12,2) NOT NULL    -- DERIVED: Quantity * Unit_Price
);

-- ONLINE_ORDERS
IF OBJECT_ID('silver.ONLINE_ORDERS','U') IS NOT NULL DROP TABLE silver.ONLINE_ORDERS;
CREATE TABLE silver.ONLINE_ORDERS (
    Order_ID     INT           NOT NULL,
    Customer_ID  INT           NOT NULL,
    Warehouse_ID INT           NOT NULL,
    Order_Time   DATETIME      NOT NULL,
    Order_Status NVARCHAR(50)  NOT NULL,
    Order_Total  DECIMAL(12,2) NOT NULL    -- NULLs replaced with 0
);

-- PAYMENTS
IF OBJECT_ID('silver.PAYMENTS','U') IS NOT NULL DROP TABLE silver.PAYMENTS;
CREATE TABLE silver.PAYMENTS (
    Payment_ID     INT           NOT NULL,
    Order_ID       INT           NOT NULL,
    Payment_Method NVARCHAR(50)  NOT NULL,
    Payment_Amount DECIMAL(12,2) NOT NULL,  -- NULLs replaced with 0
    Payment_Time   DATETIME      NOT NULL
);

-- POS_TRANSACTIONS
IF OBJECT_ID('silver.POS_TRANSACTIONS','U') IS NOT NULL DROP TABLE silver.POS_TRANSACTIONS;
CREATE TABLE silver.POS_TRANSACTIONS (
    Transaction_ID   NVARCHAR(50) NOT NULL,
    Store_ID         INT          NOT NULL,
    Register_ID      INT          NOT NULL,
    Employee_ID      INT          NOT NULL,
    Customer_ID      INT          NOT NULL,
    Transaction_Time DATETIME     NOT NULL
);

-- PRODUCTS  (enriched: Brand_Name + Department_Name added via join)
IF OBJECT_ID('silver.PRODUCTS','U') IS NOT NULL DROP TABLE silver.PRODUCTS;
CREATE TABLE silver.PRODUCTS (
    Product_ID      INT           NOT NULL,
    SKU             NVARCHAR(50)  NOT NULL,
    Product_Name    NVARCHAR(200) NOT NULL,
    Brand_ID        INT           NOT NULL,
    Brand_Name      NVARCHAR(100) NOT NULL,   -- ENRICHED: joined from BRANDS
    Department_ID   INT           NOT NULL,
    Department_Name NVARCHAR(100) NOT NULL,   -- ENRICHED: joined from DEPARTMENTS
    Package_Size    NVARCHAR(50)  NOT NULL
);

-- PRODUCT_SUPPLIERS
IF OBJECT_ID('silver.PRODUCT_SUPPLIERS','U') IS NOT NULL DROP TABLE silver.PRODUCT_SUPPLIERS;
CREATE TABLE silver.PRODUCT_SUPPLIERS (
    Product_ID   INT           NOT NULL,
    Supplier_ID  INT           NOT NULL,
    Supply_Price DECIMAL(10,2) NOT NULL
);

-- PROMOTIONS
IF OBJECT_ID('silver.PROMOTIONS','U') IS NOT NULL DROP TABLE silver.PROMOTIONS;
CREATE TABLE silver.PROMOTIONS (
    Promotion_ID     INT          NOT NULL,
    Promo_Type       NVARCHAR(50) NOT NULL,
    Discount_Percent INT          NOT NULL,
    Start_Date       DATE         NOT NULL,
    End_Date         DATE         NOT NULL
);

-- REGISTERS
IF OBJECT_ID('silver.REGISTERS','U') IS NOT NULL DROP TABLE silver.REGISTERS;
CREATE TABLE silver.REGISTERS (
    Register_ID     INT NOT NULL,
    Store_ID        INT NOT NULL,
    Register_Number INT NOT NULL
);

-- STORES
IF OBJECT_ID('silver.STORES','U') IS NOT NULL DROP TABLE silver.STORES;
CREATE TABLE silver.STORES (
    Store_ID     INT           NOT NULL,
    Store_Name   NVARCHAR(200) NOT NULL,
    City         NVARCHAR(100) NOT NULL,
    State        NVARCHAR(10)  NOT NULL,
    Region       NVARCHAR(50)  NOT NULL,
    Opening_Date DATE          NOT NULL
);

-- SUPPLIERS
IF OBJECT_ID('silver.SUPPLIERS','U') IS NOT NULL DROP TABLE silver.SUPPLIERS;
CREATE TABLE silver.SUPPLIERS (
    Supplier_ID   INT           NOT NULL,
    Supplier_Name NVARCHAR(200) NOT NULL,
    Country       NVARCHAR(100) NOT NULL,
    Phone         NVARCHAR(30)  NULL
);

-- TRANSACTION_ITEMS
IF OBJECT_ID('silver.TRANSACTION_ITEMS','U') IS NOT NULL DROP TABLE silver.TRANSACTION_ITEMS;
CREATE TABLE silver.TRANSACTION_ITEMS (
    Line_ID        INT           NOT NULL,
    Transaction_ID NVARCHAR(50)  NOT NULL,
    Product_ID     INT           NOT NULL,
    Promotion_ID   INT           NOT NULL,   -- 0 = no promotion
    Quantity       INT           NOT NULL,
    Unit_Price     DECIMAL(10,2) NOT NULL,
    Line_Total     DECIMAL(12,2) NOT NULL    -- DERIVED: Quantity * Unit_Price
);

-- WAREHOUSES
IF OBJECT_ID('silver.WAREHOUSES','U') IS NOT NULL DROP TABLE silver.WAREHOUSES;
CREATE TABLE silver.WAREHOUSES (
    Warehouse_ID   INT           NOT NULL,
    Warehouse_Name NVARCHAR(200) NOT NULL,
    City           NVARCHAR(100) NOT NULL,
    State          NVARCHAR(10)  NOT NULL
);

PRINT '>> All 20 Silver tables created successfully.';
GO
