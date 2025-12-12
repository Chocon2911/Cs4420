# Partnership Management System - SQL Guide

## Table of Contents
1. [Setup and Installation](#setup-and-installation)
2. [Running the Project](#running-the-project)
3. [Basic MySQL Commands](#basic-mysql-commands)
4. [Database Interaction Guide](#database-interaction-guide)
5. [Sample Queries and Testing](#sample-queries-and-testing)
6. [Troubleshooting](#troubleshooting)

---

## 1. Setup and Installation

### Prerequisites
- MySQL Server installed on Windows
- MySQL username: `root`
- MySQL password (set during MySQL installation)

### Quick Setup
Simply run the setup batch file from Windows Command Prompt:
```cmd
cd "C:\Users\Admin\OneDrive - Hanoi University of Science and Technology\New folder\year 4-1\CS4420\Group"

setup.bat
```

This will automatically:
- Check for existing database
- Warn you before deleting (if database exists)
- Create new database
- Create all tables
- Insert test data
- Verify installation

---

## 2. Running the Project

### Method 1: Using setup.bat (Recommended)
```cmd
setup.bat
```
Enter your MySQL password when prompted (you'll be asked multiple times).

### Method 2: Manual Setup from Command Prompt
```cmd
mysql -u root -p < schema.sql
mysql -u root -p < test-data.sql
```
Enter your MySQL password when prompted.

### Method 3: Interactive Setup
```cmd
mysql -u root -p
```
Enter your MySQL password when prompted

Then run these commands in MySQL prompt:
```sql
SOURCE schema.sql;
SOURCE test-data.sql;
```

---

## 3. Basic MySQL Commands

### Connecting to MySQL

#### Connect to MySQL:
```cmd
mysql -u root -p
```
Enter your MySQL password when prompted.

#### Connect directly to the partnership database:
```cmd
mysql -u root -p partnership_management
```
Enter your MySQL password when prompted.

### Essential MySQL Commands
```sql
-- Show all databases
SHOW DATABASES;

-- Use the partnership database
USE partnership_management;

-- Show all tables in current database
SHOW TABLES;

-- Show table structure
DESCRIBE partners;
DESCRIBE event;

-- Show table creation SQL
SHOW CREATE TABLE partners;

-- Exit MySQL
EXIT;
-- or
QUIT;
-- or press Ctrl+C
```

---

## 4. Database Interaction Guide

### 4.1 Viewing Data

#### List all partners
```sql
USE partnership_management;

-- All partners
SELECT * FROM partners;

-- Active partners only
SELECT * FROM partners WHERE status = 'active';

-- Organizations only
SELECT p.*, o.type AS org_type
FROM partners p
JOIN organization o ON p.ID = o.ID
WHERE p.type = 'organization';

-- Individuals only
SELECT p.*, i.type AS ind_type
FROM partners p
JOIN individual i ON p.ID = i.ID
WHERE p.type = 'individual';
```

#### List all events
```sql
-- All events
SELECT * FROM event;

-- Events with primary partner names
SELECT e.*, p.name AS primary_partner
FROM event e
JOIN partners p ON e.primary_partner_id = p.ID
ORDER BY e.start_date DESC;

-- Upcoming events
SELECT * FROM event
WHERE start_date >= CURDATE()
ORDER BY start_date;

-- Events by type
SELECT type, COUNT(*) AS count
FROM event
GROUP BY type;
```

#### View organizational units
```sql
-- All units
SELECT * FROM organization_unit;

-- Units by scope
SELECT scope, COUNT(*) AS count
FROM organization_unit
GROUP BY scope;
```

#### View contributions
```sql
-- All contributions
SELECT * FROM contribution;

-- Contributions with partner and event info
SELECT
    c.*,
    p.name AS partner_name,
    e.title AS event_title
FROM contribution c
JOIN partners p ON c.partner_id = p.ID
JOIN event e ON c.event_id = e.ID
ORDER BY c.created_date DESC;

-- Total contributions by partner
SELECT
    p.name,
    COUNT(c.ID) AS contribution_count,
    SUM(c.monetary_value) AS total_value
FROM partners p
JOIN contribution c ON p.ID = c.partner_id
GROUP BY p.ID, p.name
ORDER BY total_value DESC;

-- Cash vs In-kind contributions
SELECT
    type,
    COUNT(*) AS count,
    SUM(monetary_value) AS total_value
FROM contribution
GROUP BY type;
```

#### View invoices and payments
```sql
-- All invoices
SELECT * FROM invoice;

-- Invoices with payment status
SELECT
    i.ID,
    i.ref_num,
    i.issue_date,
    i.amount,
    i.status,
    p.name AS partner_name,
    COALESCE(SUM(pm.amount), 0) AS paid_amount,
    i.amount - COALESCE(SUM(pm.amount), 0) AS outstanding
FROM invoice i
LEFT JOIN partners p ON i.partner_id = p.ID
LEFT JOIN payment pm ON i.ID = pm.invoice_id
GROUP BY i.ID, i.ref_num, i.issue_date, i.amount, i.status, p.name;

-- Unpaid invoices
SELECT * FROM invoice WHERE status = 'unpaid';

-- All payments
SELECT * FROM payment;

-- Payments by method
SELECT method, COUNT(*) AS count, SUM(amount) AS total
FROM payment
GROUP BY method;
```

#### View feedback
```sql
-- All feedback
SELECT * FROM feedback;

-- Feedback with event details
SELECT
    f.*,
    e.title AS event_title,
    e.type AS event_type
FROM feedback f
JOIN event e ON f.event_id = e.ID
ORDER BY f.created_date DESC;

-- Average rating by event
SELECT
    e.title,
    COUNT(f.ID) AS feedback_count,
    AVG(f.rating) AS avg_rating,
    MIN(f.rating) AS min_rating,
    MAX(f.rating) AS max_rating
FROM event e
LEFT JOIN feedback f ON e.ID = f.event_id
GROUP BY e.ID, e.title
ORDER BY avg_rating DESC;

-- Feedback by rating
SELECT rating, COUNT(*) AS count
FROM feedback
GROUP BY rating
ORDER BY rating DESC;
```

### 4.2 Using Views

The database includes pre-built views for common queries:

```sql
-- View active partners with detailed info
SELECT * FROM v_active_partners;

-- View event summary with metrics
SELECT * FROM v_event_summary;

-- View invoice summary with payment details
SELECT * FROM v_invoice_summary;

-- Find events with highest participation
SELECT * FROM v_event_summary
ORDER BY student_amount DESC
LIMIT 5;

-- Find events with best ratings
SELECT * FROM v_event_summary
ORDER BY avg_rating DESC
LIMIT 5;

-- Check outstanding invoices
SELECT * FROM v_invoice_summary
WHERE outstanding_amount > 0;
```

### 4.3 Inserting New Data

#### Add a new partner (Organization)
```sql
-- Step 1: Add to partners table
INSERT INTO partners (ID, name, type, status, note)
VALUES ('ORG-007', 'New Tech Company', 'organization', 'prospect', 'Potential partner for AI research');

-- Step 2: Add organization details
INSERT INTO organization (ID, type)
VALUES ('ORG-007', 'company');
```

#### Add a new partner (Individual)
```sql
-- Step 1: Add to partners table
INSERT INTO partners (ID, name, type, status, note)
VALUES ('IND-005', 'Dr. John Smith', 'individual', 'active', 'International researcher');

-- Step 2: Add individual details
INSERT INTO individual (ID, type)
VALUES ('IND-005', 'expert');
```

#### Add a new event
```sql
INSERT INTO event (ID, title, type, location, start_date, end_date,
                   student_amount, staff_amount, scope_description, primary_partner_id)
VALUES ('EVT-011', 'Web Development Bootcamp', 'workshop', 'Lab Building',
        '2024-12-01', '2024-12-05', 50, 5,
        'Intensive web development training', 'ORG-001');
```

#### Add a contribution
```sql
INSERT INTO contribution (ID, partner_id, event_id, type, description,
                         monetary_value, created_date, note)
VALUES ('CONT-011', 'ORG-001', 'EVT-011', 'cash',
        'Bootcamp sponsorship', 20000000.00, CURDATE(),
        'VND 20,000,000');
```

#### Add an invoice
```sql
INSERT INTO invoice (ID, partner_id, event_id, unit_id, issue_date,
                    amount, status, ref_num, description)
VALUES ('INV-011', 'ORG-001', 'EVT-011', 'UNIT-002', CURDATE(),
        15000000.00, 'unpaid', 'INV202412011',
        'Bootcamp venue and materials');
```

#### Add a payment
```sql
INSERT INTO payment (ID, invoice_id, created_date, method, amount, ref_payment)
VALUES ('PAY-013', 'INV-011', CURDATE(), 'bank transfer',
        15000000.00, 'BT20241201013');
```

### 4.4 Updating Data

```sql
-- Update partner status
UPDATE partners
SET status = 'active'
WHERE ID = 'ORG-005';

-- Update event details
UPDATE event
SET student_amount = 150, staff_amount = 18
WHERE ID = 'EVT-001';

-- Update invoice status
UPDATE invoice
SET status = 'paid'
WHERE ID = 'INV-006';

-- Update document status to expired
UPDATE documents
SET status = 'expired'
WHERE end_date < CURDATE() AND status = 'signed';
```

### 4.5 Deleting Data

```sql
-- Delete a feedback entry
DELETE FROM feedback WHERE ID = 'FBK-001';

-- Delete a payment
DELETE FROM payment WHERE ID = 'PAY-001';

-- Delete an invoice (will cascade delete payments)
DELETE FROM invoice WHERE ID = 'INV-011';

-- Delete a partner (will cascade delete related records)
DELETE FROM partners WHERE ID = 'ORG-007';
```

---

## 5. Sample Queries and Testing

### 5.1 Analytical Queries

#### Partner Engagement Analysis
```sql
-- Partners with most events
SELECT
    p.name,
    COUNT(DISTINCT pe.event_id) AS event_count,
    SUM(c.monetary_value) AS total_contributions
FROM partners p
LEFT JOIN partner_event pe ON p.ID = pe.partner_id
LEFT JOIN contribution c ON p.ID = c.partner_id
GROUP BY p.ID, p.name
ORDER BY event_count DESC;
```

#### Financial Summary
```sql
-- Total revenue vs total contributions
SELECT
    'Invoices' AS category,
    SUM(amount) AS total_amount
FROM invoice
UNION ALL
SELECT
    'Payments' AS category,
    SUM(amount)
FROM payment
UNION ALL
SELECT
    'Contributions' AS category,
    SUM(monetary_value)
FROM contribution;
```

#### Event Performance
```sql
-- Events with participation and feedback
SELECT
    e.title,
    e.type,
    e.start_date,
    e.student_amount + e.staff_amount AS total_participants,
    COUNT(DISTINCT f.ID) AS feedback_count,
    AVG(f.rating) AS avg_rating,
    SUM(c.monetary_value) AS total_contributions
FROM event e
LEFT JOIN feedback f ON e.ID = f.event_id
LEFT JOIN contribution c ON e.ID = c.event_id
GROUP BY e.ID, e.title, e.type, e.start_date, e.student_amount, e.staff_amount
ORDER BY avg_rating DESC;
```

#### Partnership Timeline
```sql
-- Active affiliations with duration
SELECT
    p.name AS partner_name,
    ou.name AS unit_name,
    a.start_date,
    a.end_date,
    DATEDIFF(COALESCE(a.end_date, CURDATE()), a.start_date) AS days_active
FROM affiliation a
JOIN partners p ON a.partner_id = p.ID
JOIN organization_unit ou ON a.unit_id = ou.ID
ORDER BY days_active DESC;
```

### 5.2 Data Validation Queries

```sql
-- Check for partners without type specification
SELECT p.*
FROM partners p
LEFT JOIN organization o ON p.ID = o.ID
LEFT JOIN individual i ON p.ID = i.ID
WHERE p.type = 'organization' AND o.ID IS NULL
   OR p.type = 'individual' AND i.ID IS NULL;

-- Check for invoices with overpayment
SELECT
    i.ID,
    i.amount,
    SUM(p.amount) AS total_paid
FROM invoice i
JOIN payment p ON i.ID = p.invoice_id
GROUP BY i.ID, i.amount
HAVING SUM(p.amount) > i.amount;

-- Check for events without feedback
SELECT e.*
FROM event e
LEFT JOIN feedback f ON e.ID = f.event_id
WHERE f.ID IS NULL AND e.end_date < CURDATE();

-- Check for expired documents still marked as signed
SELECT *
FROM documents
WHERE status = 'signed'
  AND end_date < CURDATE();
```

### 5.3 Testing Specific Features

#### Test Cascade Deletion
```sql
-- Count related records before deletion
SELECT
    'Partner' AS entity,
    COUNT(*) AS count
FROM partners WHERE ID = 'ORG-001'
UNION ALL
SELECT 'Contact Points', COUNT(*) FROM contact_point WHERE partner_id = 'ORG-001'
UNION ALL
SELECT 'Documents', COUNT(*) FROM documents WHERE partner_id = 'ORG-001'
UNION ALL
SELECT 'Contributions', COUNT(*) FROM contribution WHERE partner_id = 'ORG-001';

-- Delete partner (test cascade)
-- DELETE FROM partners WHERE ID = 'ORG-001';

-- Verify cascade deletion worked
-- (Re-run the count query above - should show 0 for all)
```

#### Test Partial Payments
```sql
-- Create test invoice
INSERT INTO invoice (ID, partner_id, event_id, unit_id, issue_date, amount, status, ref_num)
VALUES ('INV-TEST', 'ORG-001', 'EVT-001', 'UNIT-001', CURDATE(), 30000000, 'unpaid', 'TEST001');

-- Add partial payment 1
INSERT INTO payment (ID, invoice_id, created_date, method, amount, ref_payment)
VALUES ('PAY-TEST1', 'INV-TEST', CURDATE(), 'bank transfer', 10000000, 'TEST-BT-001');

-- Add partial payment 2
INSERT INTO payment (ID, invoice_id, created_date, method, amount, ref_payment)
VALUES ('PAY-TEST2', 'INV-TEST', CURDATE(), 'bank transfer', 20000000, 'TEST-BT-002');

-- Check payment status
SELECT
    i.ID,
    i.amount AS invoice_amount,
    SUM(p.amount) AS total_paid,
    i.amount - SUM(p.amount) AS outstanding
FROM invoice i
LEFT JOIN payment p ON i.ID = p.invoice_id
WHERE i.ID = 'INV-TEST'
GROUP BY i.ID, i.amount;

-- Cleanup
-- DELETE FROM invoice WHERE ID = 'INV-TEST';
```

---

## 6. Troubleshooting

### Common Issues and Solutions

#### Issue: Cannot connect to MySQL
```cmd
REM Solution 1: Check if MySQL service is running
REM Press Win+R, type: services.msc
REM Look for MySQL80 or MySQL service and start it

REM Solution 2: Test connection
mysql -u root -p
REM Enter your MySQL password when prompted

REM Solution 3: Check if MySQL is in PATH
where mysql
```

#### Issue: "Access denied for user 'root'"
```cmd
REM Verify password is correct
mysql -u root -p
REM Enter your MySQL password when prompted

REM If password is wrong, you may need to reset it
```

#### Issue: "Database already exists" error
```sql
-- Drop the database first
DROP DATABASE IF EXISTS partnership_management;

-- Then create it
CREATE DATABASE partnership_management;
```

#### Issue: Foreign key constraint errors
```sql
-- Check foreign key constraints
SELECT * FROM information_schema.TABLE_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'partnership_management'
  AND CONSTRAINT_TYPE = 'FOREIGN KEY';

-- Temporarily disable foreign key checks (use carefully!)
SET FOREIGN_KEY_CHECKS = 0;
-- ... your operations ...
SET FOREIGN_KEY_CHECKS = 1;
```

#### Issue: Character encoding problems
```sql
-- Check database charset
SHOW CREATE DATABASE partnership_management;

-- Set proper charset for client
SET NAMES utf8mb4;
```

### Useful Diagnostic Queries

```sql
-- Check database size
SELECT
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
FROM information_schema.TABLES
WHERE table_schema = 'partnership_management'
ORDER BY (data_length + index_length) DESC;

-- Check row counts for all tables
SELECT
    table_name,
    table_rows
FROM information_schema.TABLES
WHERE table_schema = 'partnership_management'
ORDER BY table_rows DESC;

-- Check for missing indexes
SHOW INDEXES FROM partners;
SHOW INDEXES FROM event;

-- View recent queries (requires log enabled)
-- SHOW FULL PROCESSLIST;
```

### Getting Help

```sql
-- MySQL help
HELP;

-- Help for specific command
HELP SELECT;
HELP INSERT;
HELP UPDATE;

-- Show MySQL version
SELECT VERSION();

-- Show current user
SELECT USER();

-- Show current database
SELECT DATABASE();
```

---

## Quick Reference Card

### Essential Commands
```cmd
REM Connect to MySQL
mysql -u root -p partnership_management
REM Enter your MySQL password when prompted

REM Run SQL file
mysql -u root -p < filename.sql
REM Enter your MySQL password when prompted

REM Backup database
mysqldump -u root -p partnership_management > backup.sql
REM Enter your MySQL password when prompted

REM Restore database
mysql -u root -p partnership_management < backup.sql
REM Enter your MySQL password when prompted
```

### Common SQL Patterns
```sql
-- Select with join
SELECT a.*, b.* FROM table_a a JOIN table_b b ON a.id = b.a_id;

-- Count with group
SELECT category, COUNT(*) FROM table GROUP BY category;

-- Update with condition
UPDATE table SET field = 'value' WHERE condition;

-- Delete with condition
DELETE FROM table WHERE condition;

-- Insert with select
INSERT INTO table SELECT * FROM other_table WHERE condition;
```

---

## Next Steps

1. **Explore the data**: Use the SELECT queries to familiarize yourself with the data
2. **Test modifications**: Try INSERT, UPDATE, DELETE operations
3. **Create reports**: Use JOIN and GROUP BY to generate insights
4. **Build new queries**: Practice writing complex queries for your specific needs
5. **Backup regularly**: Use mysqldump to backup your database

For more information, refer to:
- MySQL Documentation: https://dev.mysql.com/doc/
- SQL Tutorial: https://www.w3schools.com/sql/
