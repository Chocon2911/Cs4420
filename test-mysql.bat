@echo off
REM ============================================================================
REM MySQL Connection Test Script
REM This script helps you find the correct MySQL username
REM ============================================================================

echo.
echo ============================================================================
echo MySQL Connection Diagnostic Tool
echo ============================================================================
echo.

SET MYSQL_PASSWORD=chocon2911

echo This script will test MySQL connection with different usernames.
echo Password being used: %MYSQL_PASSWORD%
echo.

REM Check if MySQL is in PATH
echo Testing if MySQL is installed and in PATH...
where mysql >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: MySQL command not found!
    echo.
    echo MySQL might not be in your system PATH.
    echo.
    echo Common MySQL installation paths:
    echo   C:\Program Files\MySQL\MySQL Server 8.0\bin
    echo   C:\Program Files\MySQL\MySQL Server 5.7\bin
    echo   C:\xampp\mysql\bin
    echo.
    echo To add MySQL to PATH:
    echo   1. Search for "Environment Variables" in Windows
    echo   2. Click "Environment Variables" button
    echo   3. Under "System variables", find "Path"
    echo   4. Click "Edit" and add your MySQL bin folder path
    echo   5. Restart Command Prompt
    echo.
    pause
    exit /b 1
)
echo SUCCESS: MySQL command found!
mysql --version
echo.

REM Check MySQL service
echo Checking if MySQL service is running...
sc query MySQL80 | find "RUNNING" >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo SUCCESS: MySQL80 service is running
) ELSE (
    sc query MySQL | find "RUNNING" >nul 2>&1
    IF %ERRORLEVEL% EQU 0 (
        echo SUCCESS: MySQL service is running
    ) ELSE (
        echo WARNING: Could not detect MySQL service status
        echo Please check Windows Services manually
        echo.
    )
)
echo.

REM Test common usernames
echo Testing common MySQL usernames...
echo.

SET TEST_USERS=root Admin %USERNAME%

FOR %%U IN (%TEST_USERS%) DO (
    echo Testing username: %%U
    mysql -u %%U -p%MYSQL_PASSWORD% -e "SELECT 'Connection successful!' AS Status;" 2>nul
    IF !ERRORLEVEL! EQU 0 (
        echo SUCCESS: Connected with username: %%U
        echo.
        echo Your MySQL credentials:
        echo   Username: %%U
        echo   Password: %MYSQL_PASSWORD%
        echo.
        echo You can now run setup.bat and enter: %%U
        echo.
        pause
        exit /b 0
    ) ELSE (
        echo FAILED: Could not connect with username: %%U
    )
    echo.
)

REM If all tests failed
echo ============================================================================
echo All automatic tests failed!
echo ============================================================================
echo.
echo Please try connecting manually:
echo.
echo 1. Open Command Prompt
echo 2. Type: mysql -u YOUR_USERNAME -p
echo 3. Enter password when prompted: %MYSQL_PASSWORD%
echo.
echo If you don't remember your username, try:
echo   - root
echo   - %USERNAME%
echo   - Admin
echo.
echo If you don't remember your password, you may need to reset it:
echo https://dev.mysql.com/doc/refman/8.0/en/resetting-permissions.html
echo.
pause
