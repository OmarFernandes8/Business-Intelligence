-- =============================================================================
-- EXECUTE ALL LAYERS
-- Run this AFTER all 4 scripts have been executed.
-- Update @csv_path to your actual folder before running.
-- =============================================================================

USE DataWarehouse;
GO

-- -------------------------------------------------------
-- STEP 1: Load Bronze (update path below!)
-- -------------------------------------------------------
EXEC bronze.load_bronze @csv_path = N'C:\Dataset1\';
-- ^^^ CHANGE THIS to your actual path, e.g.:
-- N'C:\Users\omar2\Desktop\Dataset1\'
-- N'C:\DataWarehouse\Dataset1\'

GO

-- -------------------------------------------------------
-- STEP 2: Load Silver (no path needed, reads from bronze)
-- -------------------------------------------------------
EXEC silver.load_silver;
GO

-- -------------------------------------------------------
-- STEP 3: Run the PD1 Submission Audit Script
-- Open PD1-SubmissionScript.sql and execute it.
-- Screenshot BOTH the Results tab and Messages tab.
-- -------------------------------------------------------
