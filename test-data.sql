-- Partnership Management System Test Data
-- MySQL Data Insertion File

USE partnership_management;

-- Disable foreign key checks temporarily for clean insertion
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- PARTNERS (10 partners: 6 organizations + 4 individuals)
-- ============================================================================

-- Organizations (6)
INSERT INTO partners (ID, name, type, status, note) VALUES
('ORG-001', 'Tech Innovations Vietnam Co., Ltd.', 'organization', 'active', 'Leading technology company specializing in AI and software development'),
('ORG-002', 'Vietnam Ministry of Education', 'organization', 'active', 'Government agency for education oversight'),
('ORG-003', 'Green Future Foundation', 'organization', 'active', 'NGO focused on environmental sustainability'),
('ORG-004', 'FPT Software', 'organization', 'active', 'Major IT corporation in Vietnam'),
('ORG-005', 'Asia Development Bank', 'organization', 'prospect', 'International financial institution'),
('ORG-006', 'Samsung Vietnam Electronics', 'organization', 'active', 'Electronics manufacturing and R&D');

INSERT INTO organization (ID, type) VALUES
('ORG-001', 'company'),
('ORG-002', 'government agency'),
('ORG-003', 'NGO'),
('ORG-004', 'company'),
('ORG-005', 'government agency'),
('ORG-006', 'company');

-- Individuals (4)
INSERT INTO partners (ID, name, type, status, note) VALUES
('IND-001', 'Dr. Nguyen Van Minh', 'individual', 'active', 'AI and Machine Learning expert'),
('IND-002', 'Prof. Tran Thi Lan', 'individual', 'active', 'Software Engineering professor at MIT'),
('IND-003', 'Mr. Le Hoang Nam', 'individual', 'active', 'Alumni, CEO of startup company'),
('IND-004', 'Dr. Pham Duc Hieu', 'individual', 'inactive', 'Former research collaborator');

INSERT INTO individual (ID, type) VALUES
('IND-001', 'expert'),
('IND-002', 'lecturer'),
('IND-003', 'alumni'),
('IND-004', 'expert');

-- ============================================================================
-- ORGANIZATION UNITS (5 units)
-- ============================================================================

INSERT INTO organization_unit (ID, name, scope, organization_id) VALUES
('UNIT-001', 'School of Information and Communication Technology', 'school', NULL),
('UNIT-002', 'Faculty of Computer Science', 'faculty', NULL),
('UNIT-003', 'AI Research Lab', 'lab', NULL),
('UNIT-004', 'Innovation and Entrepreneurship Center', 'center', NULL),
('UNIT-005', 'Data Science Lab', 'lab', NULL);

-- ============================================================================
-- AFFILIATIONS (Connect partners with organizational units)
-- ============================================================================

INSERT INTO affiliation (ID, partner_id, unit_id, start_date, end_date, remark) VALUES
('AFF-001', 'ORG-001', 'UNIT-003', '2023-01-15', NULL, 'Research collaboration on AI projects'),
('AFF-002', 'ORG-004', 'UNIT-002', '2022-06-01', NULL, 'Industry partnership for student training'),
('AFF-003', 'IND-001', 'UNIT-003', '2023-03-01', NULL, 'Visiting researcher'),
('AFF-004', 'ORG-003', 'UNIT-004', '2023-05-10', '2024-05-10', 'Environmental innovation projects'),
('AFF-005', 'IND-002', 'UNIT-002', '2024-01-01', NULL, 'Guest lecturer program'),
('AFF-006', 'ORG-006', 'UNIT-005', '2023-09-01', NULL, 'Data science research partnership'),
('AFF-007', 'IND-003', 'UNIT-004', '2024-02-15', NULL, 'Startup mentorship program');

-- ============================================================================
-- CONTACT POINTS (Contact information for partners)
-- ============================================================================

INSERT INTO contact_point (ID, partner_id, name, email, phone, type, position) VALUES
('CP-001', 'ORG-001', 'Business Development Dept', 'bd@techinnovations.vn', '+84-24-1234-5678', 'organization', 'Department'),
('CP-002', 'ORG-002', 'Partnership Office', 'partnership@moet.gov.vn', '+84-24-3869-1234', 'organization', 'Office'),
('CP-003', 'ORG-003', 'Program Director', 'director@greenfuture.org', '+84-28-9876-5432', 'organization', 'Director'),
('CP-004', 'ORG-004', 'Academic Relations', 'academic@fpt.com.vn', '+84-24-7308-0808', 'organization', 'Department'),
('CP-005', 'IND-001', 'Personal Contact', 'nguyenvanminh@email.com', '+84-90-123-4567', 'individual', NULL),
('CP-006', 'IND-002', 'MIT Office', 'ttlan@mit.edu', '+1-617-253-1000', 'individual', 'Professor'),
('CP-007', 'ORG-006', 'R&D Center', 'rnd.center@samsung.com', '+84-24-3972-1234', 'organization', 'R&D Department'),
('CP-008', 'IND-003', 'Office Contact', 'lhn.ceo@startup.vn', '+84-98-765-4321', 'individual', 'CEO');

INSERT INTO contact (ID, contact_point_id, name, email, phone, is_primary, contact_type, organization_id, individual_id) VALUES
('CON-001', 'CP-001', 'Ms. Nguyen Thu Ha', 'ha.nguyen@techinnovations.vn', '+84-90-111-2222', TRUE, 'organization', 'ORG-001', NULL),
('CON-002', 'CP-002', 'Mr. Tran Van Dong', 'dong.tran@moet.gov.vn', '+84-91-333-4444', TRUE, 'organization', 'ORG-002', NULL),
('CON-003', 'CP-003', 'Dr. Le Thi Mai', 'mai.le@greenfuture.org', '+84-92-555-6666', TRUE, 'organization', 'ORG-003', NULL),
('CON-004', 'CP-004', 'Mr. Pham Quang Huy', 'huy.pham@fpt.com.vn', '+84-93-777-8888', TRUE, 'organization', 'ORG-004', NULL),
('CON-005', 'CP-005', 'Dr. Nguyen Van Minh', 'nguyenvanminh@email.com', '+84-90-123-4567', TRUE, 'individual', NULL, 'IND-001'),
('CON-006', 'CP-006', 'Prof. Tran Thi Lan', 'ttlan@mit.edu', '+1-617-253-1000', TRUE, 'individual', NULL, 'IND-002'),
('CON-007', 'CP-007', 'Dr. Kim Min-jun', 'minjun.kim@samsung.com', '+84-94-999-0000', TRUE, 'organization', 'ORG-006', NULL),
('CON-008', 'CP-008', 'Mr. Le Hoang Nam', 'lhn.ceo@startup.vn', '+84-98-765-4321', TRUE, 'individual', NULL, 'IND-003');

-- ============================================================================
-- DOCUMENTS (Partnership agreements)
-- ============================================================================

INSERT INTO documents (ID, partner_id, title, type, start_date, end_date, status, link) VALUES
('DOC-001', 'ORG-001', 'AI Research Collaboration Agreement', 'MoU', '2023-01-15', '2026-01-15', 'signed', '/docs/mou-org001-2023.pdf'),
('DOC-002', 'ORG-004', 'Student Internship Program Contract', 'contract', '2022-06-01', '2025-06-01', 'signed', '/docs/contract-org004-2022.pdf'),
('DOC-003', 'ORG-003', 'Environmental Innovation MoU', 'MoU', '2023-05-10', '2024-05-10', 'expired', '/docs/mou-org003-2023.pdf'),
('DOC-004', 'IND-002', 'Guest Lecture Letter of Intent', 'LoI', '2024-01-01', '2024-12-31', 'signed', '/docs/loi-ind002-2024.pdf'),
('DOC-005', 'ORG-006', 'Data Science Research Partnership', 'MoU', '2023-09-01', '2026-09-01', 'signed', '/docs/mou-org006-2023.pdf'),
('DOC-006', 'ORG-002', 'Education Policy Collaboration', 'letter', '2024-03-01', NULL, 'signed', '/docs/letter-org002-2024.pdf'),
('DOC-007', 'IND-001', 'Visiting Researcher Agreement', 'contract', '2023-03-01', '2024-03-01', 'signed', '/docs/contract-ind001-2023.pdf'),
('DOC-008', 'ORG-005', 'Development Bank Partnership Draft', 'MoU', NULL, NULL, 'draft', '/docs/draft-org005-2024.pdf');

-- ============================================================================
-- EVENTS (10 collaboration events)
-- ============================================================================

INSERT INTO event (ID, title, type, location, start_date, end_date, student_amount, staff_amount, scope_description, primary_partner_id) VALUES
('EVT-001', 'AI in Healthcare Workshop 2024', 'workshop', 'Conference Hall A, Building C1', '2024-03-15', '2024-03-15', 120, 15, 'Workshop on applying AI in healthcare diagnostics', 'ORG-001'),
('EVT-002', 'National Programming Competition', 'competition', 'Sports Center', '2024-04-20', '2024-04-22', 250, 25, 'Annual programming competition for university students', 'ORG-004'),
('EVT-003', 'Blockchain Technology Seminar', 'seminar', 'Auditorium', '2024-02-10', '2024-02-10', 80, 10, 'Introduction to blockchain and cryptocurrency', 'ORG-001'),
('EVT-004', 'Green Tech Hackathon 2024', 'hackathon', 'Innovation Center', '2024-05-10', '2024-05-12', 150, 20, 'Hackathon focused on environmental solutions', 'ORG-003'),
('EVT-005', 'Software Engineering Best Practices', 'guest lecture', 'Lecture Hall B3', '2024-01-25', '2024-01-25', 200, 8, 'Guest lecture series on modern software development', 'IND-002'),
('EVT-006', 'Industry-Academia Research Symposium', 'research activity', 'Research Building', '2024-06-05', '2024-06-06', 100, 30, 'Joint research presentation and collaboration', 'ORG-006'),
('EVT-007', 'Startup Pitch Competition', 'competition', 'Innovation Center', '2024-07-15', '2024-07-15', 80, 12, 'Students pitch startup ideas to investors', 'IND-003'),
('EVT-008', 'Machine Learning Workshop Series', 'workshop', 'Computer Lab 5', '2024-08-01', '2024-08-15', 60, 5, 'Hands-on ML workshop spanning 3 weeks', 'IND-001'),
('EVT-009', 'Data Science Career Fair', 'seminar', 'University Main Hall', '2024-09-20', '2024-09-20', 300, 20, 'Career opportunities in data science and analytics', 'ORG-006'),
('EVT-010', 'Educational Technology Conference', 'seminar', 'International Conference Center', '2024-10-10', '2024-10-12', 180, 35, 'Conference on innovations in educational technology', 'ORG-002');

-- ============================================================================
-- PARTNER-EVENT RELATIONSHIPS (Many-to-many)
-- ============================================================================

INSERT INTO partner_event (partner_id, event_id, role) VALUES
-- Event 1 (AI Workshop)
('ORG-001', 'EVT-001', 'Primary Organizer'),
('IND-001', 'EVT-001', 'Speaker'),
-- Event 2 (Programming Competition)
('ORG-004', 'EVT-002', 'Primary Organizer'),
('ORG-001', 'EVT-002', 'Sponsor'),
('IND-003', 'EVT-002', 'Judge'),
-- Event 3 (Blockchain Seminar)
('ORG-001', 'EVT-003', 'Primary Organizer'),
-- Event 4 (Green Tech Hackathon)
('ORG-003', 'EVT-004', 'Primary Organizer'),
('ORG-001', 'EVT-004', 'Technical Partner'),
('ORG-006', 'EVT-004', 'Sponsor'),
-- Event 5 (Guest Lecture)
('IND-002', 'EVT-005', 'Primary Speaker'),
-- Event 6 (Research Symposium)
('ORG-006', 'EVT-006', 'Primary Organizer'),
('IND-001', 'EVT-006', 'Researcher'),
('ORG-001', 'EVT-006', 'Co-organizer'),
-- Event 7 (Startup Competition)
('IND-003', 'EVT-007', 'Primary Organizer'),
('ORG-004', 'EVT-007', 'Sponsor'),
-- Event 8 (ML Workshop)
('IND-001', 'EVT-008', 'Primary Instructor'),
('ORG-001', 'EVT-008', 'Technical Support'),
-- Event 9 (Career Fair)
('ORG-006', 'EVT-009', 'Primary Organizer'),
('ORG-004', 'EVT-009', 'Participating Company'),
('ORG-001', 'EVT-009', 'Participating Company'),
-- Event 10 (EdTech Conference)
('ORG-002', 'EVT-010', 'Primary Organizer'),
('IND-002', 'EVT-010', 'Keynote Speaker'),
('ORG-004', 'EVT-010', 'Technology Partner');

-- ============================================================================
-- CONTRIBUTIONS (10 contributions)
-- ============================================================================

INSERT INTO contribution (ID, partner_id, event_id, type, description, monetary_value, created_date, note) VALUES
('CONT-001', 'ORG-001', 'EVT-001', 'cash', 'Sponsorship for workshop materials and venue', 50000000.00, '2024-03-01', 'VND 50,000,000'),
('CONT-002', 'ORG-004', 'EVT-002', 'cash', 'Prize money for competition winners', 100000000.00, '2024-04-10', 'VND 100,000,000'),
('CONT-003', 'ORG-001', 'EVT-002', 'in kind', 'Technical equipment and software licenses', 30000000.00, '2024-04-10', 'Valued at VND 30,000,000'),
('CONT-004', 'ORG-003', 'EVT-004', 'cash', 'Hackathon funding and prizes', 75000000.00, '2024-05-01', 'VND 75,000,000'),
('CONT-005', 'ORG-006', 'EVT-004', 'in kind', 'Technology and development resources', 40000000.00, '2024-05-01', 'Valued at VND 40,000,000'),
('CONT-006', 'IND-002', 'EVT-005', 'in kind', 'Guest lecture sessions (pro bono)', 15000000.00, '2024-01-20', 'Professional service valued at VND 15,000,000'),
('CONT-007', 'ORG-006', 'EVT-006', 'cash', 'Research symposium sponsorship', 80000000.00, '2024-05-25', 'VND 80,000,000'),
('CONT-008', 'ORG-004', 'EVT-007', 'cash', 'Startup competition prize fund', 60000000.00, '2024-07-05', 'VND 60,000,000'),
('CONT-009', 'ORG-001', 'EVT-008', 'in kind', 'ML training resources and cloud credits', 25000000.00, '2024-07-25', 'Valued at VND 25,000,000'),
('CONT-010', 'ORG-004', 'EVT-010', 'in kind', 'Technology platform and support', 35000000.00, '2024-10-01', 'Valued at VND 35,000,000');

-- ============================================================================
-- INVOICES (10 invoices with related payments)
-- ============================================================================

INSERT INTO invoice (ID, partner_id, event_id, unit_id, issue_date, amount, status, ref_num, description) VALUES
('INV-001', 'ORG-001', 'EVT-001', 'UNIT-003', '2024-03-20', 15000000.00, 'paid', 'INV202403001', 'Venue rental and equipment for AI workshop'),
('INV-002', 'ORG-004', 'EVT-002', 'UNIT-002', '2024-04-25', 25000000.00, 'paid', 'INV202404002', 'Competition organization and logistics'),
('INV-003', 'ORG-003', 'EVT-004', 'UNIT-004', '2024-05-15', 20000000.00, 'paid', 'INV202405003', 'Hackathon venue and catering services'),
('INV-004', 'ORG-006', 'EVT-006', 'UNIT-005', '2024-06-10', 30000000.00, 'paid', 'INV202406004', 'Research symposium organization'),
('INV-005', NULL, 'EVT-007', 'UNIT-004', '2024-07-20', 18000000.00, 'paid', 'INV202407005', 'Startup competition expenses'),
('INV-006', 'ORG-001', 'EVT-008', 'UNIT-003', '2024-08-20', 12000000.00, 'unpaid', 'INV202408006', 'ML workshop materials and instructor fees'),
('INV-007', 'ORG-006', 'EVT-009', 'UNIT-002', '2024-09-25', 35000000.00, 'paid', 'INV202409007', 'Career fair booth and organization'),
('INV-008', 'ORG-002', 'EVT-010', 'UNIT-001', '2024-10-15', 40000000.00, 'unpaid', 'INV202410008', 'Conference venue and accommodation'),
('INV-009', NULL, NULL, 'UNIT-003', '2024-11-01', 8000000.00, 'paid', 'INV202411009', 'Lab equipment maintenance'),
('INV-010', 'ORG-004', NULL, 'UNIT-002', '2024-11-10', 22000000.00, 'unpaid', 'INV202411010', 'Annual partnership administrative fees');

-- ============================================================================
-- PAYMENTS (Multiple payments for invoices, including partial payments)
-- ============================================================================

INSERT INTO payment (ID, invoice_id, created_date, method, amount, ref_payment, note) VALUES
-- Full payments
('PAY-001', 'INV-001', '2024-03-25', 'bank transfer', 15000000.00, 'BT20240325001', 'Full payment received'),
('PAY-002', 'INV-002', '2024-04-30', 'bank transfer', 25000000.00, 'BT20240430002', 'Full payment received'),
('PAY-003', 'INV-003', '2024-05-20', 'bank transfer', 20000000.00, 'BT20240520003', 'Full payment received'),

-- Partial payments for INV-004
('PAY-004', 'INV-004', '2024-06-15', 'bank transfer', 15000000.00, 'BT20240615004', 'Partial payment 1 of 2'),
('PAY-005', 'INV-004', '2024-06-30', 'bank transfer', 15000000.00, 'BT20240630005', 'Partial payment 2 of 2 - Full payment complete'),

-- Full payment
('PAY-006', 'INV-005', '2024-07-25', 'cash', 18000000.00, 'CSH20240725006', 'Cash payment received'),

-- Partial payments for INV-007
('PAY-007', 'INV-007', '2024-09-30', 'e-wallet', 20000000.00, 'EW20240930007', 'Partial payment via e-wallet'),
('PAY-008', 'INV-007', '2024-10-05', 'bank transfer', 15000000.00, 'BT20241005008', 'Final payment'),

-- Full payment
('PAY-009', 'INV-009', '2024-11-05', 'bank transfer', 8000000.00, 'BT20241105009', 'Full payment received'),

-- Multiple payments in different methods
('PAY-010', 'INV-002', '2024-05-05', 'e-wallet', 5000000.00, 'EW20240505010', 'Additional service fee payment'),
('PAY-011', 'INV-003', '2024-05-25', 'cash', 2000000.00, 'CSH20240525011', 'Late fee payment'),
('PAY-012', 'INV-005', '2024-08-01', 'bank transfer', 3000000.00, 'BT20240801012', 'Additional expenses payment');

-- ============================================================================
-- FEEDBACK (Multiple feedback records for different events)
-- ============================================================================

INSERT INTO feedback (ID, event_id, unit_id, rater, rating, comment, created_date) VALUES
-- Event 1 (AI Workshop)
('FBK-001', 'EVT-001', 'UNIT-003', 'Student Nguyen Van A', 5, 'Excellent workshop! Very practical and informative.', '2024-03-16'),
('FBK-002', 'EVT-001', 'UNIT-003', 'Student Tran Thi B', 4, 'Good content but could use more hands-on exercises.', '2024-03-16'),
('FBK-003', 'EVT-001', 'UNIT-003', 'Lecturer Pham Van C', 5, 'Well-organized event with high-quality speakers.', '2024-03-17'),

-- Event 2 (Programming Competition)
('FBK-004', 'EVT-002', 'UNIT-002', 'Participant Le Minh D', 5, 'Challenging problems and great organization!', '2024-04-23'),
('FBK-005', 'EVT-002', 'UNIT-002', 'Participant Hoang Thi E', 4, 'Very competitive, learned a lot.', '2024-04-23'),
('FBK-006', 'EVT-002', 'UNIT-002', 'Judge Nguyen Duc F', 5, 'High quality of participants and problems.', '2024-04-24'),

-- Event 3 (Blockchain Seminar)
('FBK-007', 'EVT-003', 'UNIT-002', 'Student Vu Van G', 4, 'Good introduction to blockchain technology.', '2024-02-11'),
('FBK-008', 'EVT-003', 'UNIT-002', 'Student Do Thi H', 3, 'Interesting but too theoretical.', '2024-02-11'),

-- Event 4 (Green Tech Hackathon)
('FBK-009', 'EVT-004', 'UNIT-004', 'Team Green Innovators', 5, 'Amazing experience! Great mentorship and resources.', '2024-05-13'),
('FBK-010', 'EVT-004', 'UNIT-004', 'Team EcoTech', 5, 'Excellent event, well-organized and inspiring.', '2024-05-13'),
('FBK-011', 'EVT-004', 'UNIT-004', 'Mentor Tran Van I', 4, 'Good projects, students were very creative.', '2024-05-14'),

-- Event 5 (Guest Lecture)
('FBK-012', 'EVT-005', 'UNIT-002', 'Student Nguyen Thi K', 5, 'Prof. Lan shared invaluable insights!', '2024-01-26'),
('FBK-013', 'EVT-005', 'UNIT-002', 'Student Le Van L', 5, 'Best guest lecture of the year!', '2024-01-26'),
('FBK-014', 'EVT-005', 'UNIT-002', 'Student Pham Thi M', 4, 'Very informative and engaging.', '2024-01-27'),

-- Event 6 (Research Symposium)
('FBK-015', 'EVT-006', 'UNIT-005', 'Researcher Hoang Van N', 5, 'Great platform for industry-academia collaboration.', '2024-06-07'),
('FBK-016', 'EVT-006', 'UNIT-005', 'PhD Student Nguyen Thi O', 4, 'Learned about cutting-edge research.', '2024-06-07'),

-- Event 7 (Startup Competition)
('FBK-017', 'EVT-007', 'UNIT-004', 'Team InnoStart', 5, 'Fantastic opportunity to pitch our ideas!', '2024-07-16'),
('FBK-018', 'EVT-007', 'UNIT-004', 'Investor Panel', 4, 'Promising startups with innovative ideas.', '2024-07-16'),

-- Event 8 (ML Workshop)
('FBK-019', 'EVT-008', 'UNIT-003', 'Student Tran Van P', 5, 'Hands-on approach was very effective!', '2024-08-16'),
('FBK-020', 'EVT-008', 'UNIT-003', 'Student Le Thi Q', 5, 'Dr. Minh is an excellent instructor.', '2024-08-16'),

-- Event 9 (Career Fair)
('FBK-021', 'EVT-009', 'UNIT-002', 'Student Nguyen Van R', 4, 'Many great opportunities presented.', '2024-09-21'),
('FBK-022', 'EVT-009', 'UNIT-002', 'Student Pham Thi S', 5, 'Met many potential employers!', '2024-09-21'),

-- Event 10 (EdTech Conference)
('FBK-023', 'EVT-010', 'UNIT-001', 'Attendee Hoang Van T', 5, 'Inspiring talks about the future of education.', '2024-10-13'),
('FBK-024', 'EVT-010', 'UNIT-001', 'Attendee Le Thi U', 4, 'Well-organized conference with great networking.', '2024-10-13'),
('FBK-025', 'EVT-010', 'UNIT-001', 'Speaker Panel', 5, 'High-quality presentations and discussions.', '2024-10-14');

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Verify data insertion
SELECT 'Partners' AS Entity, COUNT(*) AS Count FROM partners
UNION ALL
SELECT 'Organizations', COUNT(*) FROM organization
UNION ALL
SELECT 'Individuals', COUNT(*) FROM individual
UNION ALL
SELECT 'Organization Units', COUNT(*) FROM organization_unit
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

-- Display summary statistics
SELECT
    'Data Insertion Summary' AS Info,
    (SELECT COUNT(*) FROM partners) AS Total_Partners,
    (SELECT COUNT(*) FROM organization) AS Organizations,
    (SELECT COUNT(*) FROM individual) AS Individuals,
    (SELECT COUNT(*) FROM organization_unit) AS Units,
    (SELECT COUNT(*) FROM event) AS Events,
    (SELECT COUNT(*) FROM contribution) AS Contributions,
    (SELECT COUNT(*) FROM invoice) AS Invoices,
    (SELECT COUNT(*) FROM payment) AS Payments,
    (SELECT COUNT(*) FROM feedback) AS Feedback_Records;
