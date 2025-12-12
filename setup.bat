@echo off
REM ============================================================================
REM Partnership Management System - Database Setup Script
REM Run this batch file on Windows to create and populate the database
REM ============================================================================

echo.
echo ========================================
echo Partnership Management Database Setup
echo ========================================
echo.

set MYSQL_PATH="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
set SQL_DIR=%~dp0
set DB_NAME=partnership_management

REM Check if MySQL executable exists
if not exist %MYSQL_PATH% (
    echo ERROR: MySQL not found at %MYSQL_PATH%
    echo Please update MYSQL_PATH in this script to match your MySQL installation
    echo.
    pause
    exit /b 1
)

REM Check if SQL files exist
if not exist "%SQL_DIR%schema.sql" (
    echo ERROR: schema.sql not found!
    echo Please make sure schema.sql is in the same folder as this script
    echo Current directory: %SQL_DIR%
    echo.
    pause
    exit /b 1
)

if not exist "%SQL_DIR%test-data.sql" (
    echo ERROR: test-data.sql not found!
    echo Please make sure test-data.sql is in the same folder as this script
    echo Current directory: %SQL_DIR%
    echo.
    pause
    exit /b 1
)

echo Files found:
echo   - schema.sql
echo   - test-data.sql
echo.

REM Step 0: Check if database exists and drop it
echo Step 0: Checking for existing database...
%MYSQL_PATH% -u root -p -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '%DB_NAME%';" 2>nul | find "%DB_NAME%" >nul

if %ERRORLEVEL% EQU 0 (
    echo.
    echo   *** WARNING ***
    echo   Found existing database: %DB_NAME%
    echo   This will DELETE all existing data!
    echo.
    set /P CONFIRM="   Do you want to continue? (Y/N): "

    if /I not "!CONFIRM!"=="Y" (
        echo.
        echo   Setup cancelled by user.
        echo.
        pause
        exit /b 0
    )

    echo.
    echo   Deleting old database...
    %MYSQL_PATH% -u root -p -e "DROP DATABASE %DB_NAME%;"

    if %ERRORLEVEL% NEQ 0 (
        echo   ERROR: Failed to delete existing database!
        pause
        exit /b 1
    )
    echo   Old database deleted successfully
    echo.
) else (
    echo   No existing database found (fresh installation)
    echo.
)

REM Step 1: Create database schema
echo Step 1: Creating database schema...
%MYSQL_PATH% -u root -p -e "source %SQL_DIR%schema.sql"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to create database schema!
    pause
    exit /b 1
)

echo   Database and tables created successfully
echo.

REM Step 2: Insert test data
echo Step 2: Inserting test data...
%MYSQL_PATH% -u root -p -e "source %SQL_DIR%test-data.sql"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to insert test data!
    pause
    exit /b 1
)

echo   Test data inserted successfully
echo.

REM Step 3: Verify data insertion
echo Step 3: Verifying data insertion...
echo.
%MYSQL_PATH% -u root -p -D %DB_NAME% -e "SELECT 'Partners' AS Entity, COUNT(*) AS Count FROM partners UNION ALL SELECT 'Organizations', COUNT(*) FROM organization UNION ALL SELECT 'Individuals', COUNT(*) FROM individual UNION ALL SELECT 'Organization Units', COUNT(*) FROM organization_unit UNION ALL SELECT 'Events', COUNT(*) FROM event UNION ALL SELECT 'Contributions', COUNT(*) FROM contribution UNION ALL SELECT 'Invoices', COUNT(*) FROM invoice UNION ALL SELECT 'Payments', COUNT(*) FROM payment UNION ALL SELECT 'Feedback', COUNT(*) FROM feedback;"

echo.
echo ========================================
echo SUCCESS! Database setup completed.
echo ========================================
echo.
echo You can now connect to the '%DB_NAME%' database
echo.
echo To connect:
echo   mysql -u root -p %DB_NAME%
echo.
echo For detailed usage instructions, see sql-guide.md
echo.
pause
