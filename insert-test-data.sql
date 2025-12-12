-- Partnership Management System - Test Data
-- MySQL Data Insertion Script

USE partnership_management;

-- ==============================================
-- PARTNERS (10 partners: 5 organizations + 5 individuals)
-- ==============================================

-- Organizations (5)
INSERT INTO partners (ID, name, type, status, note) VALUES
('ORG-001', 'VinGroup Corporation', 'organization', 'active', 'Leading Vietnamese conglomerate interested in AI and technology collaboration'),
('ORG-002', 'Ministry of Education and Training', 'organization', 'active', 'Government partner for educational initiatives'),
('ORG-003', 'Vietnam Red Cross Society', 'organization', 'active', 'NGO partner for community service projects'),
('ORG-004', 'FPT Software', 'organization', 'active', 'Technology company providing internship opportunities'),
('ORG-005', 'Intel Vietnam', 'organization', 'prospect', 'Potential partner for hardware research collaboration');

INSERT INTO organization (ID, scope) VALUES
('ORG-001', 'company'),
('ORG-002', 'government agency'),
('ORG-003', 'NGO'),
('ORG-004', 'company'),
('ORG-005', 'company');

-- Individuals (5)
INSERT INTO partners (ID, name, type, status, note) VALUES
('IND-001', 'Dr. Nguyen Van Minh', 'individual', 'active', 'AI expert and frequent guest lecturer'),
('IND-002', 'Prof. Tran Thi Lan', 'individual', 'active', 'Distinguished alumna, tech entrepreneur'),
('IND-003', 'Mr. Le Hoang Nam', 'individual', 'active', 'Industry expert in cybersecurity'),
('IND-004', 'Dr. Pham Thu Huong', 'individual', 'active', 'Research collaboration in machine learning'),
('IND-005', 'Mr. Vo Minh Duc', 'individual', 'inactive', 'Former sponsor, relationship ended');

INSERT INTO individual (ID, type) VALUES
('IND-001', 'expert'),
('IND-002', 'alumni'),
('IND-003', 'expert'),
('IND-004', 'lecturer'),
('IND-005', 'sponsor');

-- ==============================================
-- ORGANIZATIONAL UNITS (5 units)
-- ==============================================

INSERT INTO organization_unit (ID, name, scope, organization_ID) VALUES
('UNIT-001', 'School of Information and Communication Technology', 'school', 'ORG-001'),
('UNIT-002', 'Faculty of Computer Science', 'faculty', NULL),
('UNIT-003', 'AI Research Lab', 'lab', NULL),
('UNIT-004', 'Software Engineering Department', 'faculty', NULL),
('UNIT-005', 'Innovation and Technology Transfer Center', 'center', 'ORG-004');

-- ==============================================
-- AFFILIATIONS (Linking partners to units)
-- ==============================================

INSERT INTO affiliation (ID, partner_ID, unit_ID, start_date, remark) VALUES
('AFF-001', 'ORG-001', 'UNIT-001', '2023-01-15', 'Strategic partnership for AI education'),
('AFF-002', 'ORG-004', 'UNIT-004', '2022-06-01', 'Internship and training program'),
('AFF-003', 'IND-001', 'UNIT-003', '2023-03-10', 'Research collaboration'),
('AFF-004', 'IND-004', 'UNIT-002', '2022-09-01', 'Guest lecturer program'),
('AFF-005', 'ORG-002', 'UNIT-002', '2023-02-20', 'Educational policy collaboration'),
('AFF-006', 'IND-002', 'UNIT-005', '2023-05-15', 'Entrepreneurship mentorship'),
('AFF-007', 'ORG-003', 'UNIT-002', '2022-11-01', 'Community service partnership');

-- ==============================================
-- CONTACT POINTS AND CONTACTS
-- ==============================================

-- Contact Points for Organizations
INSERT INTO contact_point (ID, partner_ID, name, email, phone, type, position) VALUES
('CP-001', 'ORG-001', 'Partnership Department', 'partnership@vingroup.vn', '+84-24-3974-9999', 'organization', 'Department Head'),
('CP-002', 'ORG-002', 'International Cooperation Office', 'intl@moet.gov.vn', '+84-24-3869-4242', 'organization', 'Director'),
('CP-003', 'ORG-003', 'Community Relations', 'community@redcross.org.vn', '+84-24-3942-3937', 'organization', 'Manager'),
('CP-004', 'ORG-004', 'University Relations Team', 'university@fpt.com.vn', '+84-24-7300-8866', 'organization', 'Team Lead'),
('CP-005', 'ORG-005', 'Academic Programs', 'academic@intel.com.vn', '+84-28-3824-8530', 'organization', 'Coordinator');

-- Contact Points for Individuals
INSERT INTO contact_point (ID, partner_ID, name, email, phone, type, position) VALUES
('CP-006', 'IND-001', 'Dr. Nguyen Van Minh', 'nv.minh@gmail.com', '+84-912-345-678', 'individual', 'Expert'),
('CP-007', 'IND-002', 'Prof. Tran Thi Lan', 'tt.lan@techcorp.vn', '+84-903-456-789', 'individual', 'CEO'),
('CP-008', 'IND-003', 'Mr. Le Hoang Nam', 'lh.nam@cybersec.vn', '+84-918-765-432', 'individual', 'Consultant'),
('CP-009', 'IND-004', 'Dr. Pham Thu Huong', 'pt.huong@university.edu.vn', '+84-909-876-543', 'individual', 'Associate Professor'),
('CP-010', 'IND-005', 'Mr. Vo Minh Duc', 'vm.duc@email.com', '+84-901-234-567', 'individual', 'Former Sponsor');

-- Contact details
INSERT INTO contact (ID, contact_point_ID, name, email, phone, is_primary) VALUES
('CNT-001', 'CP-001', 'Ms. Nguyen Thu Ha', 'nth.ha@vingroup.vn', '+84-912-111-222', TRUE),
('CNT-002', 'CP-001', 'Mr. Tran Quoc Anh', 'tq.anh@vingroup.vn', '+84-913-222-333', FALSE),
('CNT-003', 'CP-002', 'Dr. Le Van Thanh', 'lv.thanh@moet.gov.vn', '+84-914-333-444', TRUE),
('CNT-004', 'CP-004', 'Ms. Hoang Minh Chau', 'hm.chau@fpt.com.vn', '+84-915-444-555', TRUE),
('CNT-005', 'CP-006', 'Dr. Nguyen Van Minh', 'nv.minh@gmail.com', '+84-912-345-678', TRUE);

-- Contact subtypes
INSERT INTO contact_organization (ID) VALUES ('CNT-001'), ('CNT-002'), ('CNT-003'), ('CNT-004');
INSERT INTO contact_individual (ID) VALUES ('CNT-005');

-- ==============================================
-- DOCUMENTS (Legal agreements)
-- ==============================================

INSERT INTO documents (ID, partner_ID, title, type, start_date, end_date, status, link) VALUES
('DOC-001', 'ORG-001', 'AI Education Collaboration MoU', 'MoU', '2023-01-15', '2026-01-14', 'signed', '/docs/vingroup-mou-2023.pdf'),
('DOC-002', 'ORG-004', 'Internship Program Agreement', 'contract', '2022-06-01', '2025-05-31', 'signed', '/docs/fpt-internship-contract.pdf'),
('DOC-003', 'ORG-002', 'Educational Partnership Letter', 'letter', '2023-02-20', '2024-02-19', 'signed', '/docs/moet-partnership-letter.pdf'),
('DOC-004', 'IND-001', 'Guest Lecture Letter of Intent', 'LoI', '2023-03-10', '2024-03-09', 'signed', '/docs/minh-lecture-loi.pdf'),
('DOC-005', 'ORG-003', 'Community Service MoU', 'MoU', '2022-11-01', '2024-10-31', 'signed', '/docs/redcross-mou.pdf'),
('DOC-006', 'ORG-005', 'Research Collaboration Draft', 'MoU', '2024-01-01', '2027-12-31', 'draft', '/docs/intel-draft-mou.pdf'),
('DOC-007', 'IND-002', 'Mentorship Agreement', 'contract', '2023-05-15', '2024-05-14', 'signed', '/docs/lan-mentorship.pdf');

-- ==============================================
-- EVENTS (10 collaboration events)
-- ==============================================

INSERT INTO event (ID, title, type, location, start_date, end_date, student_amount, staff_amount, scope_description, primary_partner_ID) VALUES
('EVT-001', 'AI in Industry Seminar 2023', 'seminar', 'Main Auditorium', '2023-03-15', '2023-03-15', 150, 12, 'Introduction to AI applications in Vietnamese industries', 'ORG-001'),
('EVT-002', 'Cybersecurity Workshop', 'workshop', 'Computer Lab A', '2023-04-20', '2023-04-22', 80, 8, 'Hands-on cybersecurity training for students', 'IND-003'),
('EVT-003', 'Smart City Hackathon 2023', 'hackathon', 'Innovation Hub', '2023-05-10', '2023-05-12', 120, 15, '48-hour hackathon for smart city solutions', 'ORG-004'),
('EVT-004', 'Machine Learning Guest Lecture Series', 'guest lecture', 'Lecture Hall B', '2023-06-05', '2023-06-30', 200, 5, 'Four-week lecture series on ML fundamentals', 'IND-001'),
('EVT-005', 'Community Tech Education Program', 'workshop', 'Community Center', '2023-07-15', '2023-07-20', 50, 10, 'Teaching basic technology skills to underserved communities', 'ORG-003'),
('EVT-006', 'Startup Pitch Competition', 'competition', 'Business School', '2023-08-25', '2023-08-26', 100, 8, 'Student startup ideas competition with industry judges', 'IND-002'),
('EVT-007', 'IoT Research Symposium', 'research activity', 'Research Center', '2023-09-18', '2023-09-20', 60, 20, 'Academic research presentations on IoT technologies', 'ORG-001'),
('EVT-008', 'Women in Tech Conference', 'seminar', 'Conference Hall', '2023-10-10', '2023-10-10', 180, 15, 'Empowering women in technology careers', 'IND-004'),
('EVT-009', 'Industry 4.0 Innovation Workshop', 'workshop', 'Engineering Building', '2023-11-05', '2023-11-07', 90, 12, 'Exploring Industry 4.0 technologies and applications', 'ORG-004'),
('EVT-010', 'Data Science Career Fair', 'seminar', 'Sports Complex', '2023-12-01', '2023-12-01', 250, 10, 'Connecting students with data science career opportunities', 'ORG-001');

-- ==============================================
-- PARTNER-EVENT RELATIONSHIPS (Many-to-Many)
-- ==============================================

INSERT INTO partner_events (partner_ID, event_ID, role) VALUES
('ORG-001', 'EVT-001', 'Primary Organizer'),
('IND-001', 'EVT-001', 'Keynote Speaker'),
('ORG-004', 'EVT-001', 'Co-sponsor'),
('IND-003', 'EVT-002', 'Primary Organizer'),
('ORG-004', 'EVT-002', 'Equipment Sponsor'),
('ORG-004', 'EVT-003', 'Primary Organizer'),
('ORG-001', 'EVT-003', 'Prize Sponsor'),
('IND-002', 'EVT-003', 'Judge'),
('IND-001', 'EVT-004', 'Primary Organizer'),
('IND-004', 'EVT-004', 'Co-lecturer'),
('ORG-003', 'EVT-005', 'Primary Organizer'),
('IND-002', 'EVT-006', 'Primary Organizer'),
('ORG-001', 'EVT-006', 'Prize Sponsor'),
('ORG-001', 'EVT-007', 'Primary Organizer'),
('IND-001', 'EVT-007', 'Research Presenter'),
('IND-004', 'EVT-008', 'Primary Organizer'),
('IND-002', 'EVT-008', 'Panelist'),
('ORG-004', 'EVT-009', 'Primary Organizer'),
('ORG-001', 'EVT-010', 'Primary Organizer'),
('ORG-004', 'EVT-010', 'Exhibitor');

-- ==============================================
-- CONTRIBUTIONS (10 contributions)
-- ==============================================

INSERT INTO contribution (ID, partner_ID, event_ID, type, description, monetary_value, created_date, note) VALUES
('CTB-001', 'ORG-001', 'EVT-001', 'cash', 'Sponsorship for venue and refreshments', 50000000, '2023-02-15', 'VND 50 million donation'),
('CTB-002', 'ORG-004', 'EVT-002', 'in kind', 'Provided 40 laptops for workshop', 120000000, '2023-04-10', 'Equipment loan valued at VND 120 million'),
('CTB-003', 'ORG-001', 'EVT-003', 'cash', 'Prize money for winners', 100000000, '2023-05-01', 'VND 100 million in prizes'),
('CTB-004', 'IND-002', 'EVT-003', 'cash', 'Additional prize sponsorship', 20000000, '2023-05-05', 'VND 20 million from alumna'),
('CTB-005', 'ORG-003', 'EVT-005', 'in kind', 'Volunteer trainers and materials', 15000000, '2023-07-01', 'Valued at VND 15 million'),
('CTB-006', 'ORG-001', 'EVT-006', 'cash', 'Startup competition prize fund', 75000000, '2023-08-15', 'VND 75 million prize pool'),
('CTB-007', 'ORG-001', 'EVT-007', 'cash', 'Research symposium funding', 40000000, '2023-09-01', 'VND 40 million for event costs'),
('CTB-008', 'IND-001', 'EVT-007', 'in kind', 'Expert time and presentation materials', 10000000, '2023-09-10', 'Valued at VND 10 million'),
('CTB-009', 'ORG-004', 'EVT-009', 'in kind', 'Industrial equipment demonstrations', 80000000, '2023-10-25', 'Equipment valued at VND 80 million'),
('CTB-010', 'ORG-001', 'EVT-010', 'cash', 'Career fair organization support', 30000000, '2023-11-15', 'VND 30 million for logistics');

-- ==============================================
-- INVOICES (10 invoices)
-- ==============================================

INSERT INTO invoice (ID, partner_ID, event_ID, organization_unit_ID, issue_date, amount, status, ref_num) VALUES
('INV-001', 'ORG-001', 'EVT-001', 'UNIT-001', '2023-02-01', 50000000.00, 'paid', 'INV-2023-001'),
('INV-002', 'ORG-004', 'EVT-002', 'UNIT-004', '2023-04-01', 25000000.00, 'paid', 'INV-2023-002'),
('INV-003', 'ORG-001', 'EVT-003', 'UNIT-005', '2023-04-25', 100000000.00, 'paid', 'INV-2023-003'),
('INV-004', 'IND-002', 'EVT-006', 'UNIT-005', '2023-08-10', 20000000.00, 'paid', 'INV-2023-004'),
('INV-005', NULL, NULL, 'UNIT-002', '2023-06-15', 15000000.00, 'paid', 'INV-2023-005'),
('INV-006', 'ORG-001', 'EVT-007', 'UNIT-003', '2023-08-20', 40000000.00, 'paid', 'INV-2023-006'),
('INV-007', 'ORG-004', 'EVT-009', 'UNIT-004', '2023-10-20', 35000000.00, 'paid', 'INV-2023-007'),
('INV-008', 'ORG-001', 'EVT-010', 'UNIT-002', '2023-11-10', 30000000.00, 'unpaid', 'INV-2023-008'),
('INV-009', NULL, NULL, 'UNIT-003', '2023-11-25', 20000000.00, 'unpaid', 'INV-2023-009'),
('INV-010', 'ORG-002', NULL, 'UNIT-002', '2023-12-01', 45000000.00, 'cancelled', 'INV-2023-010');

-- ==============================================
-- PAYMENTS (Related to invoices)
-- ==============================================

INSERT INTO payment (ID, invoice_ID, created_date, method, amount, ref_payment) VALUES
('PAY-001', 'INV-001', '2023-02-15', 'bank transfer', 50000000.00, 'TXN-VIN-20230215-001'),
('PAY-002', 'INV-002', '2023-04-10', 'bank transfer', 25000000.00, 'TXN-FPT-20230410-001'),
('PAY-003', 'INV-003', '2023-05-05', 'bank transfer', 50000000.00, 'TXN-VIN-20230505-001'),
('PAY-004', 'INV-003', '2023-05-20', 'bank transfer', 50000000.00, 'TXN-VIN-20230520-001'),
('PAY-005', 'INV-004', '2023-08-25', 'cash', 20000000.00, 'CASH-20230825-001'),
('PAY-006', 'INV-005', '2023-06-30', 'bank transfer', 15000000.00, 'TXN-GEN-20230630-001'),
('PAY-007', 'INV-006', '2023-09-10', 'bank transfer', 40000000.00, 'TXN-VIN-20230910-001'),
('PAY-008', 'INV-007', '2023-11-01', 'bank transfer', 20000000.00, 'TXN-FPT-20231101-001'),
('PAY-009', 'INV-007', '2023-11-15', 'bank transfer', 15000000.00, 'TXN-FPT-20231115-001');

-- ==============================================
-- FEEDBACK (Multiple feedback records)
-- ==============================================

INSERT INTO feedback (ID, event_ID, organization_unit_ID, rater, rating, comment, created_date) VALUES
('FBK-001', 'EVT-001', NULL, 'Student Nguyen Van A', 5, 'Excellent seminar! Very informative about AI applications in industry.', '2023-03-16'),
('FBK-002', 'EVT-001', NULL, 'Faculty Member Dr. Tran', 4, 'Well-organized event with good industry insights.', '2023-03-17'),
('FBK-003', 'EVT-002', NULL, 'Student Le Thi B', 5, 'Hands-on workshop was extremely valuable for learning cybersecurity.', '2023-04-23'),
('FBK-004', 'EVT-003', NULL, 'Participant Team Alpha', 5, 'Amazing hackathon experience! Great organization and challenging problems.', '2023-05-13'),
('FBK-005', 'EVT-003', NULL, 'Participant Team Beta', 4, 'Good event but could use more mentorship during the hackathon.', '2023-05-13'),
('FBK-006', 'EVT-004', NULL, 'Student Pham Van C', 5, 'Dr. Minh is an excellent lecturer. Learned so much about ML!', '2023-07-01'),
('FBK-007', 'EVT-005', NULL, 'Community Member', 5, 'Thank you for bringing technology education to our community!', '2023-07-21'),
('FBK-008', 'EVT-006', NULL, 'Startup Founder', 4, 'Great platform to pitch our ideas. Judges provided valuable feedback.', '2023-08-27'),
('FBK-009', 'EVT-007', NULL, 'Research Attendee', 5, 'High-quality research presentations. Excellent networking opportunity.', '2023-09-21'),
('FBK-010', 'EVT-008', NULL, 'Female Student', 5, 'Very inspiring conference! Motivated me to pursue a tech career.', '2023-10-11'),
('FBK-011', 'EVT-009', NULL, 'Engineering Student', 4, 'Good introduction to Industry 4.0 technologies.', '2023-11-08'),
('FBK-012', 'EVT-010', NULL, 'CS Graduate', 5, 'Found my dream job at this career fair! Thank you for organizing.', '2023-12-02'),
('FBK-013', NULL, 'UNIT-001', 'Industry Partner', 5, 'Excellent collaboration with the School of ICT.', '2023-12-10'),
('FBK-014', NULL, 'UNIT-002', 'Research Collaborator', 4, 'Good research facilities and supportive faculty.', '2023-12-11'),
('FBK-015', NULL, 'UNIT-003', 'Visiting Scholar', 5, 'AI Research Lab has cutting-edge equipment and brilliant researchers.', '2023-12-12');

-- ==============================================
-- DATA VERIFICATION QUERIES
-- ==============================================

-- Count summary
SELECT 'Partners' AS Entity, COUNT(*) AS Count FROM partners
UNION ALL
SELECT 'Organizations', COUNT(*) FROM organization
UNION ALL
SELECT 'Individuals', COUNT(*) FROM individual
UNION ALL
SELECT 'Organizational Units', COUNT(*) FROM organization_unit
UNION ALL
SELECT 'Affiliations', COUNT(*) FROM affiliation
UNION ALL
SELECT 'Contact Points', COUNT(*) FROM contact_point
UNION ALL
SELECT 'Contacts', COUNT(*) FROM contact
UNION ALL
SELECT 'Documents', COUNT(*) FROM documents
UNION ALL
SELECT 'Events', COUNT(*) FROM event
UNION ALL
SELECT 'Partner-Event Relations', COUNT(*) FROM partner_events
UNION ALL
SELECT 'Contributions', COUNT(*) FROM contribution
UNION ALL
SELECT 'Invoices', COUNT(*) FROM invoice
UNION ALL
SELECT 'Payments', COUNT(*) FROM payment
UNION ALL
SELECT 'Feedback', COUNT(*) FROM feedback;

-- ==============================================
-- SAMPLE QUERIES FOR VERIFICATION
-- ==============================================

-- Show all active partnerships
SELECT * FROM active_partnerships;

-- Show event summary
SELECT * FROM event_summary;

-- Show invoice payment status
SELECT * FROM invoice_payment_summary;

-- Test stored procedure: Get partner contribution total
CALL get_partner_contribution_total('ORG-001');

-- Test stored procedure: Get event statistics
CALL get_event_statistics('EVT-003');

SELECT 'Test data inserted successfully!' AS Status;
