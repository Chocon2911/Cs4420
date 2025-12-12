@echo off
REM Partnership Management System - Database Setup Script
REM Run this batch file on Windows to create and populate the database

echo ========================================
echo Partnership Management Database Setup
echo ========================================
echo.

set MYSQL_PATH="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
set SQL_DIR=%~dp0

echo Step 1: Creating database schema...
%MYSQL_PATH% -u root -p -e "source %SQL_DIR%create-database.sql"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create database schema!
    pause
    exit /b 1
)

echo.
echo Step 2: Inserting test data...
%MYSQL_PATH% -u root -p -e "source %SQL_DIR%insert-test-data.sql"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to insert test data!
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Database setup completed.
echo ========================================
echo.
echo You can now connect to the 'partnership_management' database
echo.
pause
