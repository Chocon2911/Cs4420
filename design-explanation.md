# Partnership Management System - Design Explanation

## 1. Introduction

This document explains the design decisions made for the Partnership Management System database, which is intended to track and manage partnerships between an educational institution and external entities (individuals and organizations). The system manages collaboration events, contributions, financial transactions, and feedback.

## 2. Entity Design Decisions

### 2.1 Partners Entity (Generalization/Specialization)

**Design Decision**: We implemented a generalization-specialization hierarchy where `partners` is the superclass, and `organization` and `individual` are subclasses.

**Rationale**:
- Both organizations and individuals share common attributes (ID, name, type, status, note)
- Each subtype has unique attributes: organizations have a scope (company/government/NGO), while individuals have a type (lecturer/expert/alumni/sponsor)
- This design follows the ISA (Is-A) relationship principle and avoids NULL values in a single table
- The `type` attribute in partners distinguishes between the two subtypes for quick queries

**Implementation**: Using total participation (each partner must be either an organization or individual) with disjoint constraints (cannot be both).

### 2.2 Contact Management

**Design Decision**: Created a two-level contact structure with `contact_point` and `contact` entities, along with specialization for `contact_individual` and `contact_organization`.

**Rationale**:
- Partners may have multiple contact points (e.g., different departments or representatives)
- Each contact point can have multiple contact methods (email, phone with different purposes)
- The `is_primary` flag indicates the preferred contact method
- Separating contact_individual and contact_organization allows for different attributes if needed in the future
- This design provides flexibility for managing complex organizational structures

### 2.3 Affiliation Entity

**Design Decision**: Created a separate `affiliation` entity to link partners with `organization_unit`.

**Rationale**:
- Represents a many-to-many relationship between partners and organizational units
- Tracks temporal information (start_date) indicating when the affiliation began
- Allows for additional attributes like remarks to document the nature of the affiliation
- Supports scenarios where one partner affiliates with multiple units and vice versa

### 2.4 Documents Entity

**Design Decision**: Separate entity for legal documents (MoU, contracts, LoI).

**Rationale**:
- Documents are critical business objects requiring their own lifecycle management
- Attributes like status (draft/signed/expired/terminated) track the document's state
- Start and end dates enable automatic expiration tracking
- Link attribute stores file location or URL
- One partner can have multiple documents over time

### 2.5 Events and Contributions

**Design Decision**: Separate `event` and `contribution` entities with a one-to-many relationship from events to contributions.

**Rationale**:
- Events represent collaboration activities with partners
- Contributions can be cash or in-kind and are tied to specific events
- Multiple partners can participate in one event (many-to-many relationship)
- One event can have multiple contributions from different partners
- Each event has a primary partner (main organizer) through a one-to-one relationship
- Tracks participation metrics (student_amount, staff_amount) for impact assessment

### 2.6 Invoice and Payment

**Design Decision**: Separate entities for `invoice` and `payment` with one-to-many relationship.

**Rationale**:
- Invoices can be paid in multiple installments, requiring separate payment tracking
- Payment methods (cash/bank transfer/e-wallet) are tracked at the payment level
- Invoice status (unpaid/paid/cancelled) provides quick financial overview
- Reference numbers enable external system integration
- Supports both partner invoices and organizational unit invoices

### 2.7 Feedback Entity

**Design Decision**: Feedback entity linked to both events and organizational units.

**Rationale**:
- Captures stakeholder satisfaction with numerical ratings (1-5 scale)
- Can be associated with specific events for activity-level feedback
- Can be associated with organizational units for unit-level feedback
- Comments field allows qualitative feedback
- Temporal tracking (created_date) enables trend analysis

## 3. Relationship Cardinalities

### 3.1 Partner Relationships

- **Partners ↔ Organization/Individual**: (1:1) - Total participation, each partner is exactly one type
- **Partners ↔ Contact Points**: (1:N) - One partner can have multiple contact points
- **Partners ↔ Affiliation**: (N:1) - Many partners can share one affiliation record (though typically one-to-one with organizational units through affiliation)
- **Partners ↔ Documents**: (1:N) - One partner can have multiple documents
- **Partners ↔ Events**: (N:M) - Partners can participate in multiple events, events can have multiple partners
- **Partners ↔ Contributions**: (1:N) - One partner can make multiple contributions
- **Partners ↔ Invoices**: (1:N) - One partner can have multiple invoices

### 3.2 Event Relationships

- **Event ↔ Primary Partner**: (N:1) - Each event has one primary partner
- **Event ↔ Contributions**: (1:N) - One event can receive multiple contributions
- **Event ↔ Invoices**: (1:N) - One event can generate multiple invoices
- **Event ↔ Feedback**: (1:N) - One event can receive multiple feedback records

### 3.3 Organizational Unit Relationships

- **Organization Unit ↔ Affiliation**: (N:1) - Multiple affiliations can point to one unit
- **Organization Unit ↔ Organization**: (N:1) - Multiple units belong to one organization (hierarchical structure)
- **Organization Unit ↔ Invoices**: (1:N) - One unit can have multiple invoices
- **Organization Unit ↔ Feedback**: (1:N) - One unit can receive multiple feedback records

### 3.4 Financial Relationships

- **Invoice ↔ Payments**: (1:N) - One invoice can have multiple payments (installments)

### 3.5 Contact Relationships

- **Contact Point ↔ Contacts**: (1:N) - One contact point can have multiple contact methods
- **Contact ↔ Contact Organization/Individual**: (1:1) - Each contact is exactly one type

## 4. Key Attribute Decisions

### 4.1 Use of Enumerations

Extensive use of ENUM types for controlled vocabularies:
- **Partner status**: Tracks relationship lifecycle (prospect/active/inactive)
- **Document status**: Manages document lifecycle (draft/signed/expired/terminated)
- **Event types**: Categorizes collaboration activities
- **Payment methods**: Standardizes payment tracking
- **Contribution types**: Distinguishes cash vs. in-kind contributions

**Rationale**: Ensures data integrity, simplifies queries, and provides clear business semantics.

### 4.2 Temporal Attributes

All major entities include date tracking:
- **created_date**: Audit trail for when records were created
- **start_date/end_date**: Valid time period for documents and events
- **issue_date**: Financial record keeping for invoices

**Rationale**: Enables temporal queries, audit trails, and automated expiration management.

### 4.3 Monetary Values

Used appropriate data types for financial data:
- **amount** (double): For invoice and payment amounts
- **monetary_value** (int): For contribution valuations

**Rationale**: Balance between precision and storage efficiency. Integer for contributions as they're estimates; double for actual financial transactions.

## 5. Design Patterns and Best Practices

### 5.1 Normalization

The design follows Third Normal Form (3NF):
- No repeating groups
- All non-key attributes depend on the entire primary key
- No transitive dependencies

### 5.2 Referential Integrity

All relationships enforce referential integrity through foreign keys, ensuring:
- No orphaned records
- Cascade operations where appropriate
- Data consistency across related entities

### 5.3 Extensibility

The design allows for future extensions:
- New partner types can be added through the generalization hierarchy
- New event types can be added to the enumeration
- Additional attributes can be added to entities without major restructuring
- The contact point system can accommodate new contact methods

## 6. Conclusion

This database design balances normalization principles with practical business requirements. The use of generalization/specialization hierarchies, separate entities for different business concepts, and careful cardinality definitions creates a robust foundation for a partnership management system. The design supports complex queries for reporting, maintains data integrity, and provides flexibility for future enhancements.
