# Partnership Management System - Complete SQL Guide

## Table of Contents
1. [Getting Started](#getting-started)
2. [Basic Database Operations](#basic-database-operations)
3. [Querying Data](#querying-data)
4. [Inserting Data](#inserting-data)
5. [Updating Data](#updating-data)
6. [Deleting Data](#deleting-data)
7. [Using Views](#using-views)
8. [Using Stored Procedures](#using-stored-procedures)
9. [Advanced Queries](#advanced-queries)
10. [Reporting Queries](#reporting-queries)
11. [Database Maintenance](#database-maintenance)

---

## Getting Started

### Connecting to MySQL

**Option 1: MySQL Command Line**
```bash
# Windows Command Prompt
cd "C:\Program Files\MySQL\MySQL Server 8.0\bin"
mysql.exe -u root -p

# Enter your password when prompted
# Then select the database:
USE partnership_management;
```

**Option 2: MySQL Workbench**
1. Open MySQL Workbench
2. Click on your local connection
3. Enter password
4. Select `partnership_management` from the schema list

### Verify Database Setup
```sql
-- Check if database exists
SHOW DATABASES;

-- Use the database
USE partnership_management;

-- List all tables
SHOW TABLES;

-- Get table structure
DESCRIBE partners;
DESCRIBE event;
DESCRIBE invoice;
```

---

## Basic Database Operations

### Viewing Database Structure

```sql
-- Show all tables
SHOW TABLES;

-- Show table structure
SHOW COLUMNS FROM partners;
DESCRIBE event;

-- Show table creation statement
SHOW CREATE TABLE invoice;

-- Show all indexes on a table
SHOW INDEX FROM event;

-- Show all foreign keys
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'partnership_management'
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

### Quick Data Overview

```sql
-- Count records in each table
SELECT 'Partners' AS Table_Name, COUNT(*) AS Record_Count FROM partners
UNION ALL
SELECT 'Events', COUNT(*) FROM event
UNION ALL
SELECT 'Contributions', COUNT(*) FROM contribution
UNION ALL
SELECT 'Invoices', COUNT(*) FROM invoice
UNION ALL
SELECT 'Payments', COUNT(*) FROM payment
UNION ALL
SELECT 'Feedback', COUNT(*) FROM feedback;
```

---

## Querying Data

### Simple SELECT Queries

```sql
-- View all partners
SELECT * FROM partners;

-- View only active partners
SELECT * FROM partners WHERE status = 'active';

-- View all organizations
SELECT p.ID, p.name, o.scope, p.status
FROM partners p
JOIN organization o ON p.ID = o.ID;

-- View all individuals
SELECT p.ID, p.name, i.type, p.status
FROM partners p
JOIN individual i ON p.ID = i.ID;

-- View all events
SELECT * FROM event ORDER BY start_date DESC;

-- View upcoming events
SELECT * FROM event
WHERE start_date >= CURDATE()
ORDER BY start_date;

-- View events by type
SELECT type, COUNT(*) as count
FROM event
GROUP BY type;
```

### JOIN Queries

```sql
-- Partners with their contact points
SELECT
    p.name AS partner_name,
    p.type,
    cp.name AS contact_name,
    cp.email,
    cp.phone
FROM partners p
LEFT JOIN contact_point cp ON p.ID = cp.partner_ID;

-- Events with primary partners
SELECT
    e.title,
    e.type,
    e.start_date,
    p.name AS primary_partner
FROM event e
LEFT JOIN partners p ON e.primary_partner_ID = p.ID;

-- All partners participating in an event
SELECT
    e.title AS event_title,
    p.name AS partner_name,
    pe.role
FROM event e
JOIN partner_events pe ON e.ID = pe.event_ID
JOIN partners p ON pe.partner_ID = p.ID
ORDER BY e.title;

-- Contributions with partner and event details
SELECT
    c.ID,
    p.name AS partner_name,
    e.title AS event_title,
    c.type,
    c.monetary_value,
    c.created_date
FROM contribution c
JOIN partners p ON c.partner_ID = p.ID
JOIN event e ON c.event_ID = e.ID
ORDER BY c.monetary_value DESC;

-- Invoices with payment status
SELECT
    i.ref_num,
    p.name AS partner_name,
    e.title AS event_title,
    i.amount,
    i.status,
    i.issue_date
FROM invoice i
LEFT JOIN partners p ON i.partner_ID = p.ID
LEFT JOIN event e ON i.event_ID = e.ID
ORDER BY i.issue_date DESC;

-- Affiliations between partners and units
SELECT
    p.name AS partner_name,
    ou.name AS unit_name,
    ou.scope,
    a.start_date,
    a.remark
FROM affiliation a
JOIN partners p ON a.partner_ID = p.ID
JOIN organization_unit ou ON a.unit_ID = ou.ID;
```

### Filtering and Searching

```sql
-- Search partners by name
SELECT * FROM partners
WHERE name LIKE '%FPT%';

-- Find events in a date range
SELECT * FROM event
WHERE start_date BETWEEN '2023-01-01' AND '2023-12-31';

-- Find high-value contributions (over 50 million VND)
SELECT
    p.name,
    e.title,
    c.monetary_value,
    c.type
FROM contribution c
JOIN partners p ON c.partner_ID = p.ID
JOIN event e ON c.event_ID = e.ID
WHERE c.monetary_value > 50000000;

-- Find unpaid invoices
SELECT
    i.ref_num,
    p.name AS partner_name,
    i.amount,
    i.issue_date
FROM invoice i
LEFT JOIN partners p ON i.partner_ID = p.ID
WHERE i.status = 'unpaid';

-- Find events with high student participation (>100)
SELECT title, student_amount, staff_amount, start_date
FROM event
WHERE student_amount > 100
ORDER BY student_amount DESC;

-- Find feedback with low ratings
SELECT
    f.rater,
    f.rating,
    f.comment,
    e.title AS event_title
FROM feedback f
LEFT JOIN event e ON f.event_ID = e.ID
WHERE f.rating <= 2;
```

### Aggregation Queries

```sql
-- Total contributions by partner
SELECT
    p.name,
    COUNT(c.ID) AS contribution_count,
    SUM(c.monetary_value) AS total_value
FROM partners p
LEFT JOIN contribution c ON p.ID = c.partner_ID
GROUP BY p.ID, p.name
ORDER BY total_value DESC;

-- Average event rating
SELECT
    e.title,
    AVG(f.rating) AS avg_rating,
    COUNT(f.ID) AS feedback_count
FROM event e
LEFT JOIN feedback f ON e.ID = f.event_ID
GROUP BY e.ID, e.title
HAVING feedback_count > 0
ORDER BY avg_rating DESC;

-- Total invoice amount by status
SELECT
    status,
    COUNT(*) AS invoice_count,
    SUM(amount) AS total_amount
FROM invoice
GROUP BY status;

-- Events per partner
SELECT
    p.name,
    COUNT(DISTINCT pe.event_ID) AS events_participated
FROM partners p
LEFT JOIN partner_events pe ON p.ID = pe.partner_ID
GROUP BY p.ID, p.name
ORDER BY events_participated DESC;

-- Monthly event summary
SELECT
    YEAR(start_date) AS year,
    MONTH(start_date) AS month,
    COUNT(*) AS event_count,
    SUM(student_amount) AS total_students
FROM event
GROUP BY YEAR(start_date), MONTH(start_date)
ORDER BY year, month;
```

---

## Inserting Data

### Adding New Partners

```sql
-- Add a new organization partner
INSERT INTO partners (ID, name, type, status, note)
VALUES ('ORG-006', 'Samsung Vietnam', 'organization', 'prospect', 'Technology partnership opportunity');

INSERT INTO organization (ID, scope)
VALUES ('ORG-006', 'company');

-- Add a new individual partner
INSERT INTO partners (ID, name, type, status, note)
VALUES ('IND-006', 'Dr. Hoang Van Kien', 'individual', 'active', 'Blockchain expert');

INSERT INTO individual (ID, type)
VALUES ('IND-006', 'expert');
```

### Adding Contact Information

```sql
-- Add contact point for a partner
INSERT INTO contact_point (ID, partner_ID, name, email, phone, type, position)
VALUES ('CP-011', 'ORG-006', 'University Partnership Team', 'edu@samsung.com.vn', '+84-24-1234-5678', 'organization', 'Manager');

-- Add contact details
INSERT INTO contact (ID, contact_point_ID, name, email, phone, is_primary)
VALUES ('CNT-006', 'CP-011', 'Ms. Kim Ji-won', 'jiwon.kim@samsung.com', '+84-901-111-222', TRUE);

INSERT INTO contact_organization (ID) VALUES ('CNT-006');
```

### Creating New Events

```sql
-- Add a new event
INSERT INTO event (ID, title, type, location, start_date, end_date, student_amount, staff_amount, scope_description, primary_partner_ID)
VALUES ('EVT-011', 'Blockchain Technology Workshop', 'workshop', 'Tech Lab', '2024-01-15', '2024-01-17', 60, 6, 'Introduction to blockchain and cryptocurrency', 'IND-006');

-- Link partners to the event
INSERT INTO partner_events (partner_ID, event_ID, role)
VALUES
    ('IND-006', 'EVT-011', 'Primary Organizer'),
    ('ORG-006', 'EVT-011', 'Equipment Sponsor');
```

### Recording Contributions

```sql
-- Add a new contribution
INSERT INTO contribution (ID, partner_ID, event_ID, type, description, monetary_value, created_date, note)
VALUES ('CTB-011', 'ORG-006', 'EVT-011', 'in kind', 'Provided blockchain development kits', 60000000, '2024-01-10', 'Equipment valued at 60M VND');
```

### Creating Invoices and Payments

```sql
-- Add a new invoice
INSERT INTO invoice (ID, partner_ID, event_ID, organization_unit_ID, issue_date, amount, status, ref_num)
VALUES ('INV-011', 'ORG-006', 'EVT-011', 'UNIT-002', '2024-01-05', 25000000.00, 'unpaid', 'INV-2024-001');

-- Record a payment
INSERT INTO payment (ID, invoice_ID, created_date, method, amount, ref_payment)
VALUES ('PAY-010', 'INV-011', '2024-01-20', 'bank transfer', 25000000.00, 'TXN-SAMSUNG-20240120-001');
```

### Adding Feedback

```sql
-- Add event feedback
INSERT INTO feedback (ID, event_ID, organization_unit_ID, rater, rating, comment, created_date)
VALUES ('FBK-016', 'EVT-011', NULL, 'Student Nguyen Van B', 5, 'Excellent hands-on workshop on blockchain technology!', '2024-01-18');

-- Add organizational unit feedback
INSERT INTO feedback (ID, event_ID, organization_unit_ID, rater, rating, comment, created_date)
VALUES ('FBK-017', NULL, 'UNIT-002', 'External Reviewer', 4, 'Good facilities and collaborative environment', '2024-01-20');
```

---

## Updating Data

### Updating Partner Information

```sql
-- Update partner status
UPDATE partners
SET status = 'active'
WHERE ID = 'ORG-005';

-- Update partner note
UPDATE partners
SET note = 'Long-term strategic partner in AI research'
WHERE ID = 'ORG-001';

-- Change organization scope
UPDATE organization
SET scope = 'NGO'
WHERE ID = 'ORG-003';
```

### Updating Events

```sql
-- Update event dates
UPDATE event
SET start_date = '2024-02-01', end_date = '2024-02-03'
WHERE ID = 'EVT-011';

-- Update participation numbers
UPDATE event
SET student_amount = 180, staff_amount = 16
WHERE ID = 'EVT-001';

-- Change event location
UPDATE event
SET location = 'New Conference Center'
WHERE ID = 'EVT-007';
```

### Updating Invoice Status

```sql
-- Mark invoice as paid (normally done automatically by trigger)
UPDATE invoice
SET status = 'paid'
WHERE ID = 'INV-008';

-- Cancel an invoice
UPDATE invoice
SET status = 'cancelled'
WHERE ID = 'INV-010';
```

### Updating Documents

```sql
-- Update document status
UPDATE documents
SET status = 'signed'
WHERE ID = 'DOC-006';

-- Extend document end date
UPDATE documents
SET end_date = '2027-12-31'
WHERE ID = 'DOC-002';
```

---

## Deleting Data

### Safe Deletion with Foreign Keys

```sql
-- Delete a feedback record
DELETE FROM feedback WHERE ID = 'FBK-016';

-- Delete a payment (invoice will remain)
DELETE FROM payment WHERE ID = 'PAY-010';

-- Delete a partner-event relationship
DELETE FROM partner_events
WHERE partner_ID = 'ORG-006' AND event_ID = 'EVT-011';

-- Delete a contribution
DELETE FROM contribution WHERE ID = 'CTB-011';

-- Delete an entire event (will cascade to related records)
DELETE FROM event WHERE ID = 'EVT-011';

-- Delete a partner (will cascade to all related records)
-- WARNING: This will delete contact points, documents, contributions, etc.
DELETE FROM partners WHERE ID = 'ORG-006';
```

### Bulk Deletions

```sql
-- Delete all feedback older than 2 years
DELETE FROM feedback
WHERE created_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- Delete all cancelled invoices
DELETE FROM invoice WHERE status = 'cancelled';

-- Delete inactive partners with no events
DELETE FROM partners
WHERE status = 'inactive'
AND ID NOT IN (SELECT DISTINCT partner_ID FROM partner_events);
```

---

## Using Views

The database includes pre-built views for common queries:

### Active Partnerships View

```sql
-- View all active partnerships with contact info
SELECT * FROM active_partnerships;

-- Filter active partnerships by type
SELECT * FROM active_partnerships
WHERE type = 'organization';
```

### Event Summary View

```sql
-- View event summary with partner counts
SELECT * FROM event_summary;

-- Find events with most partners
SELECT * FROM event_summary
ORDER BY total_partners DESC;

-- Events by type
SELECT type, COUNT(*) as count
FROM event_summary
GROUP BY type;
```

### Invoice Payment Summary View

```sql
-- View all invoice payment statuses
SELECT * FROM invoice_payment_summary;

-- Find unpaid invoices with amounts
SELECT * FROM invoice_payment_summary
WHERE status = 'unpaid';

-- Find partially paid invoices
SELECT * FROM invoice_payment_summary
WHERE remaining_amount > 0 AND paid_amount > 0;
```

---

## Using Stored Procedures

### Get Partner Contribution Total

```sql
-- View total contributions for a specific partner
CALL get_partner_contribution_total('ORG-001');

-- Example for all major partners
CALL get_partner_contribution_total('ORG-001');
CALL get_partner_contribution_total('ORG-004');
CALL get_partner_contribution_total('IND-002');
```

### Get Event Statistics

```sql
-- Get comprehensive statistics for an event
CALL get_event_statistics('EVT-003');

-- Check statistics for multiple events
CALL get_event_statistics('EVT-001');
CALL get_event_statistics('EVT-006');
CALL get_event_statistics('EVT-010');
```

---

## Advanced Queries

### Complex JOIN Queries

```sql
-- Complete event report with all details
SELECT
    e.title,
    e.type,
    e.start_date,
    e.end_date,
    p.name AS primary_partner,
    e.student_amount,
    e.staff_amount,
    COUNT(DISTINCT pe.partner_ID) AS total_partners,
    COUNT(DISTINCT c.ID) AS contributions,
    SUM(c.monetary_value) AS total_contribution_value,
    AVG(f.rating) AS avg_rating
FROM event e
LEFT JOIN partners p ON e.primary_partner_ID = p.ID
LEFT JOIN partner_events pe ON e.ID = pe.event_ID
LEFT JOIN contribution c ON e.ID = c.event_ID
LEFT JOIN feedback f ON e.ID = f.event_ID
GROUP BY e.ID, e.title, e.type, e.start_date, e.end_date, p.name, e.student_amount, e.staff_amount;

-- Partner engagement report
SELECT
    p.ID,
    p.name,
    p.type,
    p.status,
    COUNT(DISTINCT pe.event_ID) AS events_count,
    COUNT(DISTINCT c.ID) AS contributions_count,
    SUM(c.monetary_value) AS total_contributed,
    COUNT(DISTINCT d.ID) AS documents_count,
    COUNT(DISTINCT a.ID) AS affiliations_count
FROM partners p
LEFT JOIN partner_events pe ON p.ID = pe.partner_ID
LEFT JOIN contribution c ON p.ID = c.partner_ID
LEFT JOIN documents d ON p.ID = d.partner_ID
LEFT JOIN affiliation a ON p.ID = a.partner_ID
GROUP BY p.ID, p.name, p.type, p.status
ORDER BY total_contributed DESC;

-- Organizational unit performance
SELECT
    ou.name AS unit_name,
    ou.scope,
    COUNT(DISTINCT a.partner_ID) AS affiliated_partners,
    COUNT(DISTINCT i.ID) AS invoices_count,
    SUM(i.amount) AS total_invoiced,
    AVG(f.rating) AS avg_feedback_rating
FROM organization_unit ou
LEFT JOIN affiliation a ON ou.ID = a.unit_ID
LEFT JOIN invoice i ON ou.ID = i.organization_unit_ID
LEFT JOIN feedback f ON ou.ID = f.organization_unit_ID
GROUP BY ou.ID, ou.name, ou.scope;
```

### Subqueries

```sql
-- Find partners who contributed more than average
SELECT p.name, SUM(c.monetary_value) AS total
FROM partners p
JOIN contribution c ON p.ID = c.partner_ID
GROUP BY p.ID, p.name
HAVING SUM(c.monetary_value) > (
    SELECT AVG(total_contrib) FROM (
        SELECT SUM(monetary_value) AS total_contrib
        FROM contribution
        GROUP BY partner_ID
    ) AS avg_table
);

-- Events with above-average participation
SELECT title, student_amount
FROM event
WHERE student_amount > (SELECT AVG(student_amount) FROM event);

-- Partners with no contributions yet
SELECT p.name, p.type, p.status
FROM partners p
WHERE p.ID NOT IN (SELECT DISTINCT partner_ID FROM contribution);

-- Find most active month for events
SELECT YEAR(start_date) AS year, MONTH(start_date) AS month, COUNT(*) AS event_count
FROM event
GROUP BY YEAR(start_date), MONTH(start_date)
ORDER BY event_count DESC
LIMIT 1;
```

### Window Functions (MySQL 8.0+)

```sql
-- Rank partners by total contributions
SELECT
    p.name,
    SUM(c.monetary_value) AS total_contribution,
    RANK() OVER (ORDER BY SUM(c.monetary_value) DESC) AS contribution_rank
FROM partners p
JOIN contribution c ON p.ID = c.partner_ID
GROUP BY p.ID, p.name;

-- Running total of contributions over time
SELECT
    created_date,
    monetary_value,
    SUM(monetary_value) OVER (ORDER BY created_date) AS running_total
FROM contribution
ORDER BY created_date;

-- Event participation trends
SELECT
    start_date,
    title,
    student_amount,
    AVG(student_amount) OVER (ORDER BY start_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_students
FROM event
ORDER BY start_date;
```

---

## Reporting Queries

### Financial Reports

```sql
-- Overall financial summary
SELECT
    SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) AS total_paid,
    SUM(CASE WHEN status = 'unpaid' THEN amount ELSE 0 END) AS total_unpaid,
    SUM(amount) AS total_invoiced,
    COUNT(*) AS total_invoices
FROM invoice;

-- Payment method analysis
SELECT
    method,
    COUNT(*) AS payment_count,
    SUM(amount) AS total_amount
FROM payment
GROUP BY method;

-- Monthly revenue report
SELECT
    YEAR(p.created_date) AS year,
    MONTH(p.created_date) AS month,
    SUM(p.amount) AS monthly_revenue,
    COUNT(DISTINCT p.invoice_ID) AS invoices_paid
FROM payment p
GROUP BY YEAR(p.created_date), MONTH(p.created_date)
ORDER BY year DESC, month DESC;
```

### Partnership Reports

```sql
-- Partner status distribution
SELECT
    status,
    type,
    COUNT(*) AS count
FROM partners
GROUP BY status, type;

-- Active partnerships by category
SELECT
    CASE
        WHEN p.type = 'organization' THEN o.scope
        WHEN p.type = 'individual' THEN i.type
    END AS category,
    COUNT(*) AS count
FROM partners p
LEFT JOIN organization o ON p.ID = o.ID
LEFT JOIN individual i ON p.ID = i.ID
WHERE p.status = 'active'
GROUP BY category;

-- Document status overview
SELECT
    type,
    status,
    COUNT(*) AS count
FROM documents
GROUP BY type, status;
```

### Event Reports

```sql
-- Event type analysis
SELECT
    type,
    COUNT(*) AS event_count,
    SUM(student_amount) AS total_students,
    AVG(student_amount) AS avg_students,
    SUM(staff_amount) AS total_staff
FROM event
GROUP BY type
ORDER BY event_count DESC;

-- Yearly event summary
SELECT
    YEAR(start_date) AS year,
    COUNT(*) AS events,
    SUM(student_amount) AS total_students,
    SUM(staff_amount) AS total_staff,
    AVG(student_amount) AS avg_students_per_event
FROM event
GROUP BY YEAR(start_date);

-- Top-rated events
SELECT
    e.title,
    e.type,
    AVG(f.rating) AS avg_rating,
    COUNT(f.ID) AS feedback_count
FROM event e
JOIN feedback f ON e.ID = f.event_ID
GROUP BY e.ID, e.title, e.type
HAVING feedback_count >= 2
ORDER BY avg_rating DESC, feedback_count DESC;
```

### Contribution Analysis

```sql
-- Contribution type breakdown
SELECT
    type,
    COUNT(*) AS contribution_count,
    SUM(monetary_value) AS total_value,
    AVG(monetary_value) AS avg_value
FROM contribution
GROUP BY type;

-- Top contributors
SELECT
    p.name,
    p.type,
    COUNT(c.ID) AS contributions,
    SUM(c.monetary_value) AS total_value
FROM partners p
JOIN contribution c ON p.ID = c.partner_ID
GROUP BY p.ID, p.name, p.type
ORDER BY total_value DESC
LIMIT 10;

-- Contribution trends by quarter
SELECT
    YEAR(created_date) AS year,
    QUARTER(created_date) AS quarter,
    COUNT(*) AS contributions,
    SUM(monetary_value) AS total_value
FROM contribution
GROUP BY YEAR(created_date), QUARTER(created_date)
ORDER BY year DESC, quarter DESC;
```

---

## Database Maintenance

### Backup and Restore

```sql
-- Create a backup (run in command line, not MySQL)
-- Windows Command Prompt:
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe" -u root -p partnership_management > backup_2024-01-01.sql

-- Restore from backup:
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p partnership_management < backup_2024-01-01.sql
```

### Data Validation

```sql
-- Check for orphaned records (shouldn't happen due to FK constraints)
-- Partners without type records
SELECT p.* FROM partners p
LEFT JOIN organization o ON p.ID = o.ID
LEFT JOIN individual i ON p.ID = i.ID
WHERE o.ID IS NULL AND i.ID IS NULL;

-- Events without primary partners
SELECT * FROM event WHERE primary_partner_ID IS NULL;

-- Invoices with payment total not matching invoice amount
SELECT
    i.ID,
    i.amount AS invoice_amount,
    COALESCE(SUM(p.amount), 0) AS paid_amount,
    i.status
FROM invoice i
LEFT JOIN payment p ON i.ID = p.invoice_ID
GROUP BY i.ID, i.amount, i.status
HAVING i.status = 'paid' AND invoice_amount != paid_amount;
```

### Performance Optimization

```sql
-- Analyze table statistics
ANALYZE TABLE partners, event, invoice, contribution;

-- Check table optimization
CHECK TABLE partners;

-- Optimize tables
OPTIMIZE TABLE partners, event, invoice;

-- View slow queries (if slow query log is enabled)
SELECT * FROM mysql.slow_log ORDER BY query_time DESC LIMIT 10;
```

### Data Cleanup

```sql
-- Remove old draft documents (older than 1 year)
DELETE FROM documents
WHERE status = 'draft'
AND created_at < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Archive old events (you might want to create an archive table first)
-- Create archive table
CREATE TABLE event_archive LIKE event;

-- Move old events to archive
INSERT INTO event_archive SELECT * FROM event WHERE end_date < '2022-01-01';
DELETE FROM event WHERE end_date < '2022-01-01';
```

---

## Tips and Best Practices

### Query Performance Tips

1. **Use EXPLAIN to analyze queries:**
```sql
EXPLAIN SELECT * FROM event WHERE start_date > '2023-01-01';
```

2. **Use indexes wisely:**
```sql
-- Check existing indexes
SHOW INDEX FROM event;

-- Create custom index if needed
CREATE INDEX idx_custom ON event(type, start_date);
```

3. **Limit large result sets:**
```sql
SELECT * FROM event ORDER BY start_date DESC LIMIT 10;
```

### Transaction Management

```sql
-- Start a transaction
START TRANSACTION;

-- Make changes
UPDATE partners SET status = 'inactive' WHERE ID = 'IND-005';
DELETE FROM contribution WHERE partner_ID = 'IND-005';

-- If everything looks good, commit
COMMIT;

-- If something went wrong, rollback
-- ROLLBACK;
```

### Common Mistakes to Avoid

1. **Don't forget WHERE clause in UPDATE/DELETE:**
```sql
-- BAD: Updates ALL records
UPDATE partners SET status = 'inactive';

-- GOOD: Updates specific record
UPDATE partners SET status = 'inactive' WHERE ID = 'IND-005';
```

2. **Use transactions for multiple related changes:**
```sql
START TRANSACTION;
INSERT INTO invoice (...) VALUES (...);
INSERT INTO payment (...) VALUES (...);
COMMIT;
```

3. **Check for NULL values in JOINs:**
```sql
-- May not show all partners if they don't have events
SELECT p.name, COUNT(pe.event_ID)
FROM partners p
JOIN partner_events pe ON p.ID = pe.partner_ID
GROUP BY p.name;

-- Better: Shows all partners even without events
SELECT p.name, COUNT(pe.event_ID)
FROM partners p
LEFT JOIN partner_events pe ON p.ID = pe.partner_ID
GROUP BY p.name;
```

---

## Quick Reference Cheat Sheet

### Most Common Queries

```sql
-- List all active partners
SELECT * FROM partners WHERE status = 'active';

-- Recent events
SELECT * FROM event ORDER BY start_date DESC LIMIT 5;

-- Unpaid invoices
SELECT * FROM invoice WHERE status = 'unpaid';

-- Top contributors
SELECT p.name, SUM(c.monetary_value) AS total
FROM partners p
JOIN contribution c ON p.ID = c.partner_ID
GROUP BY p.ID, p.name
ORDER BY total DESC
LIMIT 5;

-- Event with most participants
SELECT title, student_amount + staff_amount AS total_participants
FROM event
ORDER BY total_participants DESC
LIMIT 1;
```

### Useful Keyboard Shortcuts (MySQL Workbench)

- **Ctrl + Enter**: Execute current statement
- **Ctrl + Shift + Enter**: Execute all statements
- **Ctrl + /**: Comment/uncomment line
- **Ctrl + B**: Beautify/format query
- **Ctrl + Space**: Auto-complete
- **F5**: Refresh

---

## Conclusion

This guide covers the essential operations for working with the Partnership Management System database. For more advanced MySQL features, refer to the official MySQL documentation at https://dev.mysql.com/doc/

Remember to:
- Always backup before major changes
- Use transactions for related operations
- Test queries on a copy before running on production
- Keep your password secure
- Regularly review and optimize slow queries
