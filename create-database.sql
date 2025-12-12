-- Partnership Management System - Database DDL
-- MySQL Database Creation Script

-- Drop database if exists and create new one
DROP DATABASE IF EXISTS partnership_management;
CREATE DATABASE partnership_management;
USE partnership_management;

-- ==============================================
-- PARTNERS AND RELATED ENTITIES
-- ==============================================

-- Main Partners table (Superclass)
CREATE TABLE partners (
    ID CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type ENUM('organization', 'individual') NOT NULL,
    status ENUM('prospect', 'active', 'inactive') NOT NULL DEFAULT 'prospect',
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_partner_type (type),
    INDEX idx_partner_status (status)
);

-- Organization subclass
CREATE TABLE organization (
    ID CHAR(36) PRIMARY KEY,
    scope ENUM('company', 'government agency', 'NGO') NOT NULL,
    FOREIGN KEY (ID) REFERENCES partners(ID) ON DELETE CASCADE
);

-- Individual subclass
CREATE TABLE individual (
    ID CHAR(36) PRIMARY KEY,
    type ENUM('lecturer', 'expert', 'alumni', 'sponsor') NOT NULL,
    FOREIGN KEY (ID) REFERENCES partners(ID) ON DELETE CASCADE
);

-- ==============================================
-- ORGANIZATIONAL UNITS
-- ==============================================

CREATE TABLE organization_unit (
    ID CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    scope ENUM('school', 'faculty', 'lab', 'center') NOT NULL,
    organization_ID CHAR(36),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_ID) REFERENCES organization(ID) ON DELETE SET NULL,
    INDEX idx_unit_scope (scope)
);

-- ==============================================
-- AFFILIATION (Partners to Organization Units)
-- ==============================================

CREATE TABLE affiliation (
    ID CHAR(36) PRIMARY KEY,
    partner_ID CHAR(36) NOT NULL,
    unit_ID CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    remark TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_ID) REFERENCES partners(ID) ON DELETE CASCADE,
    FOREIGN KEY (unit_ID) REFERENCES organization_unit(ID) ON DELETE CASCADE,
    INDEX idx_affiliation_partner (partner_ID),
    INDEX idx_affiliation_unit (unit_ID)
);

-- ==============================================
-- CONTACT MANAGEMENT
-- ==============================================

-- Contact Points (associated with partners)
CREATE TABLE contact_point (
    ID CHAR(36) PRIMARY KEY,
    partner_ID CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    type ENUM('organization', 'individual') NOT NULL,
    position VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_ID) REFERENCES partners(ID) ON DELETE CASCADE,
    INDEX idx_contact_point_partner (partner_ID)
);

-- Contact details (multiple contacts per contact point)
CREATE TABLE contact (
    ID CHAR(36) PRIMARY KEY,
    contact_point_ID CHAR(36) NOT NULL,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contact_point_ID) REFERENCES contact_point(ID) ON DELETE CASCADE,
    INDEX idx_contact_point (contact_point_ID)
);

-- Contact Individual subclass
CREATE TABLE contact_individual (
    ID CHAR(36) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES contact(ID) ON DELETE CASCADE
);

-- Contact Organization subclass
CREATE TABLE contact_organization (
    ID CHAR(36) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES contact(ID) ON DELETE CASCADE
);

-- ==============================================
-- DOCUMENTS (Agreements, MoUs, Contracts)
-- ==============================================

CREATE TABLE documents (
    ID CHAR(36) PRIMARY KEY,
    partner_ID CHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    type ENUM('MoU', 'contract', 'letter', 'LoI') NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('draft', 'signed', 'expired', 'terminated') NOT NULL DEFAULT 'draft',
    link VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_ID) REFERENCES partners(ID) ON DELETE CASCADE,
    INDEX idx_document_partner (partner_ID),
    INDEX idx_document_status (status),
    INDEX idx_document_dates (start_date, end_date)
);

-- ==============================================
-- EVENTS (Collaboration Events)
-- ==============================================

CREATE TABLE event (
    ID CHAR(36) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    type ENUM('seminar', 'workshop', 'competition', 'hackathon', 'guest lecture', 'research activity') NOT NULL,
    location VARCHAR(255),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    student_amount INT DEFAULT 0,
    staff_amount INT DEFAULT 0,
    scope_description TEXT,
    primary_partner_ID CHAR(36),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (primary_partner_ID) REFERENCES partners(ID) ON DELETE SET NULL,
    INDEX idx_event_dates (start_date, end_date),
    INDEX idx_event_type (type),
    INDEX idx_event_primary_partner (primary_partner_ID)
);

-- Many-to-many relationship between partners and events
CREATE TABLE partner_events (
    partner_ID CHAR(36) NOT NULL,
    event_ID CHAR(36) NOT NULL,
    role VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (partner_ID, event_ID),
    FOREIGN KEY (partner_ID) REFERENCES partners(ID) ON DELETE CASCADE,
    FOREIGN KEY (event_ID) REFERENCES event(ID) ON DELETE CASCADE
);

-- ==============================================
-- CONTRIBUTIONS
-- ==============================================

CREATE TABLE contribution (
    ID CHAR(36) PRIMARY KEY,
    partner_ID CHAR(36) NOT NULL,
    event_ID CHAR(36) NOT NULL,
    type ENUM('cash', 'in kind') NOT NULL,
    description TEXT,
    monetary_value INT DEFAULT 0,
    created_date DATE NOT NULL,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_ID) REFERENCES partners(ID) ON DELETE CASCADE,
    FOREIGN KEY (event_ID) REFERENCES event(ID) ON DELETE CASCADE,
    INDEX idx_contribution_partner (partner_ID),
    INDEX idx_contribution_event (event_ID),
    INDEX idx_contribution_type (type)
);

-- ==============================================
-- INVOICES AND PAYMENTS
-- ==============================================

-- Invoices
CREATE TABLE invoice (
    ID CHAR(36) PRIMARY KEY,
    partner_ID CHAR(36),
    event_ID CHAR(36),
    organization_unit_ID CHAR(36),
    issue_date DATE NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    status ENUM('unpaid', 'paid', 'cancelled') NOT NULL DEFAULT 'unpaid',
    ref_num VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_ID) REFERENCES partners(ID) ON DELETE SET NULL,
    FOREIGN KEY (event_ID) REFERENCES event(ID) ON DELETE SET NULL,
    FOREIGN KEY (organization_unit_ID) REFERENCES organization_unit(ID) ON DELETE SET NULL,
    INDEX idx_invoice_partner (partner_ID),
    INDEX idx_invoice_event (event_ID),
    INDEX idx_invoice_unit (organization_unit_ID),
    INDEX idx_invoice_status (status)
);

-- Payments (multiple payments per invoice for installments)
CREATE TABLE payment (
    ID CHAR(36) PRIMARY KEY,
    invoice_ID CHAR(36) NOT NULL,
    created_date DATE NOT NULL,
    method ENUM('cash', 'bank transfer', 'e-wallet') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    ref_payment VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_ID) REFERENCES invoice(ID) ON DELETE CASCADE,
    INDEX idx_payment_invoice (invoice_ID),
    INDEX idx_payment_date (created_date)
);

-- ==============================================
-- FEEDBACK
-- ==============================================

CREATE TABLE feedback (
    ID CHAR(36) PRIMARY KEY,
    event_ID CHAR(36),
    organization_unit_ID CHAR(36),
    rater VARCHAR(255) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_ID) REFERENCES event(ID) ON DELETE CASCADE,
    FOREIGN KEY (organization_unit_ID) REFERENCES organization_unit(ID) ON DELETE CASCADE,
    INDEX idx_feedback_event (event_ID),
    INDEX idx_feedback_unit (organization_unit_ID),
    INDEX idx_feedback_rating (rating)
);

-- ==============================================
-- VIEWS FOR COMMON QUERIES
-- ==============================================

-- View: Active partnerships with contact information
CREATE VIEW active_partnerships AS
SELECT
    p.ID,
    p.name,
    p.type,
    p.status,
    cp.name AS contact_name,
    cp.email AS contact_email,
    cp.phone AS contact_phone
FROM partners p
LEFT JOIN contact_point cp ON p.ID = cp.partner_ID
WHERE p.status = 'active';

-- View: Event summary with partner information
CREATE VIEW event_summary AS
SELECT
    e.ID,
    e.title,
    e.type,
    e.start_date,
    e.end_date,
    p.name AS primary_partner,
    e.student_amount,
    e.staff_amount,
    COUNT(DISTINCT pe.partner_ID) AS total_partners
FROM event e
LEFT JOIN partners p ON e.primary_partner_ID = p.ID
LEFT JOIN partner_events pe ON e.ID = pe.event_ID
GROUP BY e.ID, e.title, e.type, e.start_date, e.end_date, p.name, e.student_amount, e.staff_amount;

-- View: Invoice payment status
CREATE VIEW invoice_payment_summary AS
SELECT
    i.ID AS invoice_id,
    i.ref_num,
    i.amount AS invoice_amount,
    i.status,
    COALESCE(SUM(pay.amount), 0) AS paid_amount,
    i.amount - COALESCE(SUM(pay.amount), 0) AS remaining_amount
FROM invoice i
LEFT JOIN payment pay ON i.ID = pay.invoice_ID
GROUP BY i.ID, i.ref_num, i.amount, i.status;

-- ==============================================
-- INDEXES FOR PERFORMANCE
-- ==============================================

-- Additional composite indexes for common query patterns
CREATE INDEX idx_event_date_type ON event(start_date, type);
CREATE INDEX idx_contribution_event_partner ON contribution(event_ID, partner_ID);
CREATE INDEX idx_invoice_status_date ON invoice(status, issue_date);
CREATE INDEX idx_feedback_rating_date ON feedback(rating, created_date);

-- ==============================================
-- STORED PROCEDURES
-- ==============================================

-- Procedure to calculate total contributions for a partner
DELIMITER //
CREATE PROCEDURE get_partner_contribution_total(IN p_partner_id CHAR(36))
BEGIN
    SELECT
        p.name AS partner_name,
        COUNT(c.ID) AS total_contributions,
        SUM(c.monetary_value) AS total_value,
        SUM(CASE WHEN c.type = 'cash' THEN c.monetary_value ELSE 0 END) AS cash_total,
        SUM(CASE WHEN c.type = 'in kind' THEN c.monetary_value ELSE 0 END) AS in_kind_total
    FROM partners p
    LEFT JOIN contribution c ON p.ID = c.partner_ID
    WHERE p.ID = p_partner_id
    GROUP BY p.ID, p.name;
END //
DELIMITER ;

-- Procedure to get event statistics
DELIMITER //
CREATE PROCEDURE get_event_statistics(IN p_event_id CHAR(36))
BEGIN
    SELECT
        e.title,
        e.type,
        e.start_date,
        e.end_date,
        e.student_amount,
        e.staff_amount,
        COUNT(DISTINCT pe.partner_ID) AS partner_count,
        COUNT(DISTINCT c.ID) AS contribution_count,
        SUM(c.monetary_value) AS total_contribution_value,
        COUNT(DISTINCT f.ID) AS feedback_count,
        AVG(f.rating) AS average_rating
    FROM event e
    LEFT JOIN partner_events pe ON e.ID = pe.event_ID
    LEFT JOIN contribution c ON e.ID = c.event_ID
    LEFT JOIN feedback f ON e.ID = f.event_ID
    WHERE e.ID = p_event_id
    GROUP BY e.ID, e.title, e.type, e.start_date, e.end_date, e.student_amount, e.staff_amount;
END //
DELIMITER ;

-- ==============================================
-- TRIGGERS
-- ==============================================

-- Trigger to auto-update invoice status when fully paid
DELIMITER //
CREATE TRIGGER update_invoice_status_after_payment
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    DECLARE total_paid DECIMAL(15,2);
    DECLARE invoice_amt DECIMAL(15,2);

    SELECT COALESCE(SUM(amount), 0) INTO total_paid
    FROM payment
    WHERE invoice_ID = NEW.invoice_ID;

    SELECT amount INTO invoice_amt
    FROM invoice
    WHERE ID = NEW.invoice_ID;

    IF total_paid >= invoice_amt THEN
        UPDATE invoice
        SET status = 'paid'
        WHERE ID = NEW.invoice_ID;
    END IF;
END //
DELIMITER ;

-- ==============================================
-- DATABASE READY
-- ==============================================
SELECT 'Partnership Management Database Created Successfully!' AS Status;
