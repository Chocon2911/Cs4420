#!/bin/bash
# ============================================================================
# Partnership Management System - Database Setup Script (WSL)
# ============================================================================
# This script will:
# 1. Drop the existing database (if it exists)
# 2. Create a new database
# 3. Create all tables (schema.sql)
# 4. Insert test data (test-data.sql)
# ============================================================================

# Configuration
MYSQL_USER="root"
MYSQL_PASSWORD="chocon2911"
DB_NAME="partnership_management"
SCHEMA_FILE="schema.sql"
DATA_FILE="test-data.sql"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "============================================================================"
echo -e "${BLUE}Partnership Management System - Database Setup${NC}"
echo "============================================================================"
echo ""

# Check if MySQL is accessible (Windows MySQL from WSL)
echo -e "${YELLOW}[1/5] Checking MySQL connection...${NC}"
mysql.exe -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Cannot connect to MySQL!${NC}"
    echo "Please check:"
    echo "  - MySQL service is running on Windows"
    echo "  - Username is correct: $MYSQL_USER"
    echo "  - Password is correct: $MYSQL_PASSWORD"
    echo "  - MySQL is accessible from WSL (mysql.exe in PATH)"
    exit 1
fi
echo -e "${GREEN}✓ MySQL connection successful!${NC}"
echo ""

# Check if required files exist
echo -e "${YELLOW}[2/5] Checking required files...${NC}"
if [ ! -f "$SCHEMA_FILE" ]; then
    echo -e "${RED}ERROR: $SCHEMA_FILE not found!${NC}"
    echo "Please make sure $SCHEMA_FILE is in the current directory."
    exit 1
fi
echo "  ✓ $SCHEMA_FILE found"

if [ ! -f "$DATA_FILE" ]; then
    echo -e "${RED}ERROR: $DATA_FILE not found!${NC}"
    echo "Please make sure $DATA_FILE is in the current directory."
    exit 1
fi
echo "  ✓ $DATA_FILE found"
echo -e "${GREEN}✓ All required files found!${NC}"
echo ""

# Drop existing database if it exists
echo -e "${YELLOW}[3/5] Dropping existing database (if exists)...${NC}"
mysql.exe -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to drop existing database!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Old database dropped successfully (if it existed)${NC}"
echo ""

# Create database and schema
echo -e "${YELLOW}[4/5] Creating database and tables...${NC}"
mysql.exe -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" < "$SCHEMA_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to create database schema!${NC}"
    echo "Check $SCHEMA_FILE for errors."
    exit 1
fi
echo -e "${GREEN}✓ Database and tables created successfully!${NC}"
echo ""

# Insert test data
echo -e "${YELLOW}[5/5] Inserting test data...${NC}"
mysql.exe -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" < "$DATA_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to insert test data!${NC}"
    echo "Check $DATA_FILE for errors."
    exit 1
fi
echo -e "${GREEN}✓ Test data inserted successfully!${NC}"
echo ""

# Display summary
echo "============================================================================"
echo -e "${GREEN}DATABASE SETUP COMPLETED SUCCESSFULLY!${NC}"
echo "============================================================================"
echo ""
echo "Database Name: $DB_NAME"
echo ""

# Count records in each table
echo "Verifying data insertion..."
echo ""

mysql.exe -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -D "$DB_NAME" -e "
SELECT 'Partners' AS Entity, COUNT(*) AS Count FROM partners
UNION ALL SELECT 'Organizations', COUNT(*) FROM organization
UNION ALL SELECT 'Individuals', COUNT(*) FROM individual
UNION ALL SELECT 'Organization Units', COUNT(*) FROM organization_unit
UNION ALL SELECT 'Affiliations', COUNT(*) FROM affiliation
UNION ALL SELECT 'Contact Points', COUNT(*) FROM contact_point
UNION ALL SELECT 'Contacts', COUNT(*) FROM contact
UNION ALL SELECT 'Documents', COUNT(*) FROM documents
UNION ALL SELECT 'Events', COUNT(*) FROM event
UNION ALL SELECT 'Partner-Event Links', COUNT(*) FROM partner_event
UNION ALL SELECT 'Contributions', COUNT(*) FROM contribution
UNION ALL SELECT 'Invoices', COUNT(*) FROM invoice
UNION ALL SELECT 'Payments', COUNT(*) FROM payment
UNION ALL SELECT 'Feedback', COUNT(*) FROM feedback;
" 2>&1

echo ""
echo "============================================================================"
echo "Next Steps:"
echo "============================================================================"
echo "1. Connect to the database:"
echo "   mysql.exe -u $MYSQL_USER -p$MYSQL_PASSWORD $DB_NAME"
echo ""
echo "2. Run sample queries (see sql-guide.md)"
echo ""
echo "3. Explore the data:"
echo "   USE $DB_NAME;"
echo "   SHOW TABLES;"
echo "   SELECT * FROM partners;"
echo ""
echo "For detailed instructions, refer to sql-guide.md"
echo "============================================================================"
echo ""
