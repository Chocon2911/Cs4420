-- Partnership Management System Database Schema
-- MySQL DDL File

-- Drop database if exists and create new
DROP DATABASE IF EXISTS partnership_management;
CREATE DATABASE partnership_management;
USE partnership_management;

-- ============================================================================
-- CORE ENTITIES
-- ============================================================================

-- Partners table (main entity)
CREATE TABLE partners (
    ID VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type ENUM('organization', 'individual') NOT NULL,
    status ENUM('prospect', 'active', 'inactive') NOT NULL DEFAULT 'prospect',
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_partner_type (type),
    INDEX idx_partner_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Organization table (specialization of partners)
CREATE TABLE organization (
    ID VARCHAR(36) PRIMARY KEY,
    type ENUM('company', 'government agency', 'NGO') NOT NULL,
    FOREIGN KEY (ID) REFERENCES partners(ID) ON DELETE CASCADE,
    INDEX idx_org_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Individual table (specialization of partners)
CREATE TABLE individual (
    ID VARCHAR(36) PRIMARY KEY,
    type ENUM('lecturer', 'expert', 'alumni', 'sponsor') NOT NULL,
    FOREIGN KEY (ID) REFERENCES partners(ID) ON DELETE CASCADE,
    INDEX idx_ind_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Organization Unit table
CREATE TABLE organization_unit (
    ID VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    scope ENUM('school', 'faculty', 'lab', 'center') NOT NULL,
    organization_id VARCHAR(36),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organization(ID) ON DELETE SET NULL,
    INDEX idx_unit_scope (scope)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- AFFILIATION
-- ============================================================================

-- Affiliation table (connects partners with organizational units)
CREATE TABLE affiliation (
    ID VARCHAR(36) PRIMARY KEY,
    partner_id VARCHAR(36) NOT NULL,
    unit_id VARCHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    remark TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_id) REFERENCES partners(ID) ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES organization_unit(ID) ON DELETE CASCADE,
    INDEX idx_affiliation_partner (partner_id),
    INDEX idx_affiliation_unit (unit_id),
    INDEX idx_affiliation_dates (start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- CONTACTS
-- ============================================================================

-- Contact Point table
CREATE TABLE contact_point (
    ID VARCHAR(36) PRIMARY KEY,
    partner_id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    type ENUM('organization', 'individual') NOT NULL,
    position VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_id) REFERENCES partners(ID) ON DELETE CASCADE,
    INDEX idx_contact_point_partner (partner_id),
    INDEX idx_contact_point_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Contact table
CREATE TABLE contact (
    ID VARCHAR(36) PRIMARY KEY,
    contact_point_id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    is_primary BOOLEAN DEFAULT FALSE,
    contact_type ENUM('organization', 'individual') NOT NULL,
    organization_id VARCHAR(36),
    individual_id VARCHAR(36),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contact_point_id) REFERENCES contact_point(ID) ON DELETE CASCADE,
    FOREIGN KEY (organization_id) REFERENCES organization(ID) ON DELETE SET NULL,
    FOREIGN KEY (individual_id) REFERENCES individual(ID) ON DELETE SET NULL,
    INDEX idx_contact_point (contact_point_id),
    INDEX idx_contact_email (email),
    CHECK (
        (contact_type = 'organization' AND organization_id IS NOT NULL AND individual_id IS NULL) OR
        (contact_type = 'individual' AND individual_id IS NOT NULL AND organization_id IS NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- DOCUMENTS
-- ============================================================================

-- Documents table
CREATE TABLE documents (
    ID VARCHAR(36) PRIMARY KEY,
    partner_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    type ENUM('MoU', 'contract', 'letter', 'LoI') NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('draft', 'signed', 'expired', 'terminated') NOT NULL DEFAULT 'draft',
    link VARCHAR(512),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_id) REFERENCES partners(ID) ON DELETE CASCADE,
    INDEX idx_document_partner (partner_id),
    INDEX idx_document_type (type),
    INDEX idx_document_status (status),
    INDEX idx_document_dates (start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- EVENTS
-- ============================================================================

-- Event table
CREATE TABLE event (
    ID VARCHAR(36) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    type ENUM('seminar', 'workshop', 'competition', 'hackathon', 'guest lecture', 'research activity') NOT NULL,
    location VARCHAR(255),
    start_date DATE NOT NULL,
    end_date DATE,
    student_amount INT DEFAULT 0,
    staff_amount INT DEFAULT 0,
    scope_description TEXT,
    primary_partner_id VARCHAR(36) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (primary_partner_id) REFERENCES partners(ID) ON DELETE RESTRICT,
    INDEX idx_event_type (type),
    INDEX idx_event_dates (start_date, end_date),
    INDEX idx_event_primary_partner (primary_partner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Partner-Event junction table (many-to-many)
CREATE TABLE partner_event (
    partner_id VARCHAR(36),
    event_id VARCHAR(36),
    role VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (partner_id, event_id),
    FOREIGN KEY (partner_id) REFERENCES partners(ID) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES event(ID) ON DELETE CASCADE,
    INDEX idx_pe_partner (partner_id),
    INDEX idx_pe_event (event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- CONTRIBUTIONS
-- ============================================================================

-- Contribution table
CREATE TABLE contribution (
    ID VARCHAR(36) PRIMARY KEY,
    partner_id VARCHAR(36) NOT NULL,
    event_id VARCHAR(36) NOT NULL,
    type ENUM('cash', 'in kind') NOT NULL,
    description TEXT,
    monetary_value DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    created_date DATE NOT NULL,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_id) REFERENCES partners(ID) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES event(ID) ON DELETE CASCADE,
    INDEX idx_contribution_partner (partner_id),
    INDEX idx_contribution_event (event_id),
    INDEX idx_contribution_type (type),
    INDEX idx_contribution_date (created_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- INVOICES AND PAYMENTS
-- ============================================================================

-- Invoice table
CREATE TABLE invoice (
    ID VARCHAR(36) PRIMARY KEY,
    partner_id VARCHAR(36),
    event_id VARCHAR(36),
    unit_id VARCHAR(36),
    issue_date DATE NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    status ENUM('unpaid', 'paid', 'cancelled') NOT NULL DEFAULT 'unpaid',
    ref_num VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (partner_id) REFERENCES partners(ID) ON DELETE SET NULL,
    FOREIGN KEY (event_id) REFERENCES event(ID) ON DELETE SET NULL,
    FOREIGN KEY (unit_id) REFERENCES organization_unit(ID) ON DELETE SET NULL,
    INDEX idx_invoice_partner (partner_id),
    INDEX idx_invoice_event (event_id),
    INDEX idx_invoice_unit (unit_id),
    INDEX idx_invoice_status (status),
    INDEX idx_invoice_date (issue_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Payment table
CREATE TABLE payment (
    ID VARCHAR(36) PRIMARY KEY,
    invoice_id VARCHAR(36) NOT NULL,
    created_date DATE NOT NULL,
    method ENUM('cash', 'bank transfer', 'e-wallet') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    ref_payment VARCHAR(100),
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoice(ID) ON DELETE CASCADE,
    INDEX idx_payment_invoice (invoice_id),
    INDEX idx_payment_date (created_date),
    INDEX idx_payment_method (method)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- FEEDBACK
-- ============================================================================

-- Feedback table
CREATE TABLE feedback (
    ID VARCHAR(36) PRIMARY KEY,
    event_id VARCHAR(36) NOT NULL,
    unit_id VARCHAR(36),
    rater VARCHAR(255) NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    created_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES event(ID) ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES organization_unit(ID) ON DELETE SET NULL,
    INDEX idx_feedback_event (event_id),
    INDEX idx_feedback_unit (unit_id),
    INDEX idx_feedback_rating (rating),
    INDEX idx_feedback_date (created_date),
    CHECK (rating >= 1 AND rating <= 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- VIEWS FOR COMMON QUERIES
-- ============================================================================

-- View: Active partnerships
CREATE VIEW v_active_partners AS
SELECT
    p.ID,
    p.name,
    p.type,
    CASE
        WHEN p.type = 'organization' THEN o.type
        WHEN p.type = 'individual' THEN i.type
    END AS subtype,
    p.status,
    p.created_at
FROM partners p
LEFT JOIN organization o ON p.ID = o.ID
LEFT JOIN individual i ON p.ID = i.ID
WHERE p.status = 'active';

-- View: Event summary
CREATE VIEW v_event_summary AS
SELECT
    e.ID,
    e.title,
    e.type,
    e.start_date,
    e.end_date,
    e.student_amount,
    e.staff_amount,
    p.name AS primary_partner,
    COUNT(DISTINCT pe.partner_id) AS total_partners,
    COUNT(DISTINCT c.ID) AS total_contributions,
    COALESCE(SUM(c.monetary_value), 0) AS total_contribution_value,
    COUNT(DISTINCT f.ID) AS feedback_count,
    COALESCE(AVG(f.rating), 0) AS avg_rating
FROM event e
JOIN partners p ON e.primary_partner_id = p.ID
LEFT JOIN partner_event pe ON e.ID = pe.event_id
LEFT JOIN contribution c ON e.ID = c.event_id
LEFT JOIN feedback f ON e.ID = f.event_id
GROUP BY e.ID, e.title, e.type, e.start_date, e.end_date,
         e.student_amount, e.staff_amount, p.name;

-- View: Invoice status summary
CREATE VIEW v_invoice_summary AS
SELECT
    i.ID,
    i.ref_num,
    i.issue_date,
    i.amount,
    i.status,
    p.name AS partner_name,
    e.title AS event_title,
    COALESCE(SUM(pm.amount), 0) AS paid_amount,
    i.amount - COALESCE(SUM(pm.amount), 0) AS outstanding_amount
FROM invoice i
LEFT JOIN partners p ON i.partner_id = p.ID
LEFT JOIN event e ON i.event_id = e.ID
LEFT JOIN payment pm ON i.ID = pm.invoice_id
GROUP BY i.ID, i.ref_num, i.issue_date, i.amount, i.status, p.name, e.title;
