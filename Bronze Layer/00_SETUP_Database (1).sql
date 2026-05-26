-- =============================================================================
-- STEP 0 | DATABASE & SCHEMA SETUP
-- Run this FIRST before anything else.
-- Creates the DataWarehouse database, and bronze + silver schemas.
-- =============================================================================

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    CREATE DATABASE DataWarehouse;
    PRINT 'Database [DataWarehouse] created.';
END
ELSE
    PRINT 'Database [DataWarehouse] already exists.';
GO

USE DataWarehouse;
GO

-- Create bronze schema
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
    PRINT 'Schema [bronze] created.';
END
ELSE
    PRINT 'Schema [bronze] already exists.';
GO

-- Create silver schema
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT 'Schema [silver] created.';
END
ELSE
    PRINT 'Schema [silver] already exists.';
GO

PRINT '>> Setup complete. Run the Bronze scripts next.';
GO
