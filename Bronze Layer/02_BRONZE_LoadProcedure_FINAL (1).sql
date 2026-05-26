-- =============================================================================
-- BRONZE LAYER | STEP 2 OF 2 : LOAD STORED PROCEDURE
-- Run this after 01_BRONZE_CreateTables.sql
--
-- Creates bronze.load_bronze which:
--   1. Truncates every bronze table
--   2. BULK INSERTs each CSV file
--   3. Logs every load (start time, end time, row count, status)
--
-- !! BEFORE RUNNING: update @csv_path on line 22 to your actual folder path.
--    Example:  N'C:\Users\YourName\Desktop\Dataset1\'
--    The path must end with a backslash \.
-- =============================================================================

USE DataWarehouse;
GO

IF OBJECT_ID('bronze.load_bronze','P') IS NOT NULL
    DROP PROCEDURE bronze.load_bronze;
GO

CREATE PROCEDURE bronze.load_bronze
    @csv_path NVARCHAR(500) = N'C:\Dataset1\'   -- << CHANGE THIS TO YOUR PATH
AS
BEGIN
    SET NOCOUNT ON;

    -- Ensure path ends with backslash
    IF RIGHT(@csv_path,1) <> '\'
        SET @csv_path = @csv_path + '\';

    DECLARE @log_id  INT;
    DECLARE @rows    INT;
    DECLARE @sql     NVARCHAR(MAX);
    DECLARE @file    NVARCHAR(600);

    PRINT '=====================================================';
    PRINT ' bronze.load_bronze  START: ' + CONVERT(NVARCHAR,GETDATE(),120);
    PRINT '=====================================================';

    -- ------------------------------------------------------------------
    -- Macro used for every table:
    --   1) Insert a RUNNING log entry
    --   2) TRUNCATE the table
    --   3) BULK INSERT from CSV  (FIRSTROW=2 skips header)
    --   4) Count rows and mark SUCCESS  /  catch errors and mark FAILED
    -- ------------------------------------------------------------------

    -- BRANDS -------------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.BRANDS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.BRANDS;
        SET @file=@csv_path+'BRANDS.csv';
        SET @sql=N'BULK INSERT bronze.BRANDS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.BRANDS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.BRANDS]              ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.BRANDS]              FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- CUSTOMERS ----------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.CUSTOMERS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.CUSTOMERS;
        SET @file=@csv_path+'CUSTOMERS.csv';
        SET @sql=N'BULK INSERT bronze.CUSTOMERS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.CUSTOMERS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.CUSTOMERS]           ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.CUSTOMERS]           FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- DATA_QUALITY_REPORT ------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.DATA_QUALITY_REPORT',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.DATA_QUALITY_REPORT;
        SET @file=@csv_path+'DATA_QUALITY_REPORT.csv';
        SET @sql=N'BULK INSERT bronze.DATA_QUALITY_REPORT FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.DATA_QUALITY_REPORT;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.DATA_QUALITY_REPORT] ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.DATA_QUALITY_REPORT] FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- DELIVERIES ---------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.DELIVERIES',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.DELIVERIES;
        SET @file=@csv_path+'DELIVERIES.csv';
        SET @sql=N'BULK INSERT bronze.DELIVERIES FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.DELIVERIES;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.DELIVERIES]          ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.DELIVERIES]          FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- DELIVERY_PROVIDERS -------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.DELIVERY_PROVIDERS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.DELIVERY_PROVIDERS;
        SET @file=@csv_path+'DELIVERY_PROVIDERS.csv';
        SET @sql=N'BULK INSERT bronze.DELIVERY_PROVIDERS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.DELIVERY_PROVIDERS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.DELIVERY_PROVIDERS]  ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.DELIVERY_PROVIDERS]  FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- DEPARTMENTS --------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.DEPARTMENTS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.DEPARTMENTS;
        SET @file=@csv_path+'DEPARTMENTS.csv';
        SET @sql=N'BULK INSERT bronze.DEPARTMENTS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.DEPARTMENTS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.DEPARTMENTS]         ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.DEPARTMENTS]         FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- EMPLOYEES ----------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.EMPLOYEES',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.EMPLOYEES;
        SET @file=@csv_path+'EMPLOYEES.csv';
        SET @sql=N'BULK INSERT bronze.EMPLOYEES FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.EMPLOYEES;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.EMPLOYEES]           ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.EMPLOYEES]           FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- INVENTORY ----------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.INVENTORY',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.INVENTORY;
        SET @file=@csv_path+'INVENTORY.csv';
        SET @sql=N'BULK INSERT bronze.INVENTORY FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.INVENTORY;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.INVENTORY]           ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.INVENTORY]           FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- ONLINE_ORDER_ITEMS -------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.ONLINE_ORDER_ITEMS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.ONLINE_ORDER_ITEMS;
        SET @file=@csv_path+'ONLINE_ORDER_ITEMS.csv';
        SET @sql=N'BULK INSERT bronze.ONLINE_ORDER_ITEMS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.ONLINE_ORDER_ITEMS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.ONLINE_ORDER_ITEMS]  ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.ONLINE_ORDER_ITEMS]  FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- ONLINE_ORDERS ------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.ONLINE_ORDERS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.ONLINE_ORDERS;
        SET @file=@csv_path+'ONLINE_ORDERS.csv';
        SET @sql=N'BULK INSERT bronze.ONLINE_ORDERS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.ONLINE_ORDERS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.ONLINE_ORDERS]       ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.ONLINE_ORDERS]       FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- PAYMENTS -----------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.PAYMENTS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.PAYMENTS;
        SET @file=@csv_path+'PAYMENTS.csv';
        SET @sql=N'BULK INSERT bronze.PAYMENTS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.PAYMENTS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.PAYMENTS]            ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.PAYMENTS]            FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- POS_TRANSACTIONS ---------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.POS_TRANSACTIONS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.POS_TRANSACTIONS;
        SET @file=@csv_path+'POS_TRANSACTIONS.csv';
        SET @sql=N'BULK INSERT bronze.POS_TRANSACTIONS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.POS_TRANSACTIONS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.POS_TRANSACTIONS]    ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.POS_TRANSACTIONS]    FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- PRODUCTS -----------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.PRODUCTS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.PRODUCTS;
        SET @file=@csv_path+'PRODUCTS.csv';
        SET @sql=N'BULK INSERT bronze.PRODUCTS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.PRODUCTS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.PRODUCTS]            ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.PRODUCTS]            FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- PRODUCT_SUPPLIERS --------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.PRODUCT_SUPPLIERS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.PRODUCT_SUPPLIERS;
        SET @file=@csv_path+'PRODUCT_SUPPLIERS.csv';
        SET @sql=N'BULK INSERT bronze.PRODUCT_SUPPLIERS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.PRODUCT_SUPPLIERS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.PRODUCT_SUPPLIERS]   ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.PRODUCT_SUPPLIERS]   FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- PROMOTIONS ---------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.PROMOTIONS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.PROMOTIONS;
        SET @file=@csv_path+'PROMOTIONS.csv';
        SET @sql=N'BULK INSERT bronze.PROMOTIONS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.PROMOTIONS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.PROMOTIONS]          ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.PROMOTIONS]          FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- REGISTERS ----------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.REGISTERS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.REGISTERS;
        SET @file=@csv_path+'REGISTERS.csv';
        SET @sql=N'BULK INSERT bronze.REGISTERS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.REGISTERS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.REGISTERS]           ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.REGISTERS]           FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- STORES -------------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.STORES',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.STORES;
        SET @file=@csv_path+'STORES.csv';
        SET @sql=N'BULK INSERT bronze.STORES FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.STORES;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.STORES]              ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.STORES]              FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- SUPPLIERS ----------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.SUPPLIERS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.SUPPLIERS;
        SET @file=@csv_path+'SUPPLIERS.csv';
        SET @sql=N'BULK INSERT bronze.SUPPLIERS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.SUPPLIERS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.SUPPLIERS]           ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.SUPPLIERS]           FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- TRANSACTION_ITEMS --------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.TRANSACTION_ITEMS',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.TRANSACTION_ITEMS;
        SET @file=@csv_path+'TRANSACTION_ITEMS.csv';
        SET @sql=N'BULK INSERT bronze.TRANSACTION_ITEMS FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.TRANSACTION_ITEMS;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.TRANSACTION_ITEMS]   ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.TRANSACTION_ITEMS]   FAILED: '+ERROR_MESSAGE();
    END CATCH;

    -- WAREHOUSES ---------------------------------------------------
    INSERT INTO bronze.load_log(table_name,load_start,status) VALUES('bronze.WAREHOUSES',GETDATE(),'RUNNING');
    SET @log_id=SCOPE_IDENTITY();
    BEGIN TRY
        TRUNCATE TABLE bronze.WAREHOUSES;
        SET @file=@csv_path+'WAREHOUSES.csv';
        SET @sql=N'BULK INSERT bronze.WAREHOUSES FROM '''+@file+''' WITH (FIRSTROW=2,FIELDTERMINATOR='','',ROWTERMINATOR=''0x0a'',TABLOCK);';
        EXEC sp_executesql @sql;
        SELECT @rows=COUNT(*) FROM bronze.WAREHOUSES;
        UPDATE bronze.load_log SET rows_loaded=@rows,load_end=GETDATE(),status='SUCCESS' WHERE log_id=@log_id;
        PRINT '  [bronze.WAREHOUSES]          ' + CAST(@rows AS NVARCHAR) + ' rows loaded.';
    END TRY BEGIN CATCH
        UPDATE bronze.load_log SET load_end=GETDATE(),status='FAILED',error_message=ERROR_MESSAGE() WHERE log_id=@log_id;
        PRINT '  [bronze.WAREHOUSES]          FAILED: '+ERROR_MESSAGE();
    END CATCH;

    PRINT '=====================================================';
    PRINT ' bronze.load_bronze  END:   ' + CONVERT(NVARCHAR,GETDATE(),120);
    PRINT '=====================================================';

    -- Summary from log
    SELECT table_name, rows_loaded, load_start, load_end, status, error_message
    FROM   bronze.load_log
    WHERE  load_start >= CAST(CAST(GETDATE() AS DATE) AS DATETIME)
    ORDER  BY log_id;

END;
GO

PRINT '>> Procedure [bronze].[load_bronze] created.';
PRINT '>> TO LOAD:  EXEC bronze.load_bronze @csv_path = N''C:\your\path\Dataset1\'';';
GO
