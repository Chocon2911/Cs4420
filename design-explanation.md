# Partnership Management System - Database Design Explanation

## 1. Overview

This partnership management system is designed to track and manage relationships between a university and its external partners (both organizations and individuals), including collaboration events, financial transactions, contributions, and feedback.

## 2. Entity Design Decisions

### 2.1 Partners (Main Entity)
**Attributes:**
- `ID` (UID, PK): Unique identifier for each partner
- `name` (string): Partner's name
- `type` (enum): Distinguishes between 'organization' and 'individual'
- `status` (enum): Tracks partnership lifecycle ('prospect', 'active', 'inactive')
- `note` (string): Additional remarks

**Design Rationale:** Partners serves as the central entity using a generalization/specialization pattern. This allows common attributes to be stored once while enabling specific attributes for organizations and individuals in separate tables.

### 2.2 Organization and Individual (Specialization)
**Organization attributes:**
- `ID` (UID, PK, FK to Partners)
- `type` (enum): 'company', 'government agency', 'NGO'

**Individual attributes:**
- `ID` (UID, PK, FK to Partners)
- `type` (enum): 'lecturer', 'expert', 'alumni', 'sponsor'

**Design Rationale:** Implemented using inheritance (ISA relationship). Each organization/individual must be a partner, preventing orphaned records. This supports polymorphic queries while maintaining type-specific data integrity.

### 2.3 Affiliation
**Attributes:**
- `ID` (UID, PK): Unique identifier
- `start_date` (date): When the affiliation began
- `remark` (string): Additional notes
- Foreign keys to Partners and Organization_unit

**Design Rationale:** Models many-to-one relationship between partners and organizational units. A partner can be affiliated with one organizational unit at a time, but a unit can have multiple affiliated partners. This tracks formal associations within the university structure.

### 2.4 Organization_unit
**Attributes:**
- `ID` (UID, PK): Unique identifier
- `scope` (enum): 'school', 'faculty', 'lab', 'center'

**Design Rationale:** Represents internal university organizational structure. Connected to organization partners through a one-to-one relationship (org_info) for organizations that are specifically linked to a unit. Also tracks which unit manages events, invoices, and feedback.

### 2.5 Contact_point and Contact
**Contact_point attributes:**
- `ID`, `name`, `email`, `phone` (PK attributes)
- `type` (enum): 'organization' or 'individual'
- `position` (enum): Role/position of contact

**Contact attributes:**
- `ID`, `name`, `email`, `phone`
- `is_primary` (bool): Indicates primary contact

**Design Rationale:** Two-level contact structure where contact_point serves as a grouping mechanism (one partner can have multiple contact points), and each contact point can have multiple individual contacts. This supports complex organizational structures where different departments have different contact persons.

### 2.6 Documents
**Attributes:**
- `ID` (UID, PK)
- `title` (string): Document name
- `type` (enum): 'MoU', 'contract', 'letter', 'LoI'
- `start_date`, `end_date` (date): Validity period
- `status` (enum): 'draft', 'signed', 'expired', 'terminated'
- `link` (string): File storage location

**Design Rationale:** Tracks formal agreements with partners. Status tracking enables automated notifications for expiring agreements. The link attribute supports document management systems integration.

### 2.7 Event
**Attributes:**
- `title` (string): Event name
- `type` (enum): 'seminar', 'workshop', 'competition', 'hackathon', 'guest lecture', 'research activity'
- `location`, `start_date`, `end_date`
- `student_amount`, `staff_amount` (int): Participation metrics
- `scope_description` (string): Event scope details

**Design Rationale:** Central to collaboration tracking. Many-to-many relationship with partners allows multiple partners per event and vice versa. One partner is designated as the primary partner (event_primary_partner relationship). Participation metrics enable impact assessment.

### 2.8 Contribution
**Attributes:**
- `ID` (UID, PK)
- `type` (enum): 'cash' or 'in kind'
- `description` (string): Details of contribution
- `monetary_value` (int): Valuation
- `created_date` (date)
- `note` (string)

**Design Rationale:** Tracks both monetary and non-monetary contributions. Every contribution is linked to a specific event and partner. Monetary valuation of in-kind contributions enables comprehensive reporting.

### 2.9 Invoice and Payment
**Invoice attributes:**
- `ID`, `issue_date`, `amount`
- `status` (enum): 'unpaid', 'paid', 'cancelled'
- `ref_num` (int): Reference number

**Payment attributes:**
- `ID`, `created_date`
- `method` (enum): 'cash', 'bank transfer', 'e-wallet'
- `amount`, `ref_payment` (string)

**Design Rationale:** Separate entities to handle partial payments (one invoice can have multiple payments). Invoices can be linked to partners, events, or organizational units, providing flexible billing scenarios. Status tracking enables accounts receivable management.

### 2.10 Feedback
**Attributes:**
- `ID`, `rater` (string)
- `rating` (int): 1-5 scale
- `comment` (string)
- `created_date` (date)

**Design Rationale:** Collects qualitative and quantitative feedback for events. Linked to both events and organizational units to track performance by unit and event type.

## 3. Relationship Cardinality Decisions

### One-to-One Relationships:
- **Partners to Organization/Individual**: Each partner is either an organization OR an individual (disjoint specialization)
- **Organization_unit to Organization**: Each organizational unit may have one associated organization partner
- **Event to Partners (primary)**: Each event has one primary partner

### One-to-Many Relationships:
- **Partners to Contact_points**: One partner can have multiple contact points
- **Partners to Documents**: One partner can have multiple agreements
- **Partners to Contributions/Invoices**: One partner can make multiple contributions and receive multiple invoices
- **Event to Invoices/Feedback**: Events can have multiple invoices and feedback records
- **Invoice to Payments**: One invoice can have multiple payments (partial payments)

### Many-to-Many Relationships:
- **Partners to Events**: Partners can participate in multiple events, events can have multiple partners
- **Partners to Affiliation to Organization_units**: Through affiliation entity

## 4. Data Integrity Considerations

1. **Referential Integrity**: All foreign keys enforce referential integrity with CASCADE or SET NULL options based on business rules
2. **Enumerated Types**: Used extensively to constrain values and prevent invalid data entry
3. **Status Tracking**: Multiple entities include status fields enabling lifecycle management
4. **Temporal Data**: Date fields track when records were created and validity periods
5. **Primary Keys**: All entities have UID primary keys ensuring uniqueness

## 5. Extensibility

The design supports future extensions such as:
- Additional partner types by extending the type enumeration
- New event categories
- Additional payment methods
- Expansion of organizational unit hierarchy
- Integration with external systems via link/reference fields
