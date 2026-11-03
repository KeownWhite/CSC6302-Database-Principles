# Paranormal Expedition Database Design

## Database

Database Name: `ParanormalExpedition`

Purpose: Store and organize information about paranormal investigations, including locations, expeditions, investigators, equipment assignments, and evidence collected during each investigation.

The initial design contains seven relations.

---

# 1. Location

Represents a physical site where one or more paranormal expeditions may occur.

| Attribute | Data Type | Constraints | Purpose |
|---|---|---|---|
| location_id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier for each location |
| location_name | VARCHAR(100) | NOT NULL | Name of the location |
| address | VARCHAR(150) | NULL | Street address when available |
| city | VARCHAR(75) | NOT NULL | City containing the location |
| state | CHAR(2) | NOT NULL | Two-letter state abbreviation |
| location_type | VARCHAR(50) | NOT NULL | Type of site |
| risk_level | VARCHAR(20) | NOT NULL, DEFAULT 'Moderate' | Investigation risk classification |
| notes | TEXT | NULL | Additional information |

### Constraints

- `location_id` uniquely identifies each location.
- `risk_level` should be limited to:
  - Low
  - Moderate
  - High
  - Extreme

---

# 2. Investigator

Represents a person participating in paranormal investigations.

| Attribute | Data Type | Constraints | Purpose |
|---|---|---|---|
| investigator_id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique investigator identifier |
| first_name | VARCHAR(50) | NOT NULL | Investigator first name |
| last_name | VARCHAR(50) | NOT NULL | Investigator last name |
| email | VARCHAR(120) | NOT NULL, UNIQUE | Contact email |
| specialty | VARCHAR(75) | NOT NULL | Primary investigation specialty |
| experience_years | INT | NOT NULL, DEFAULT 0 | Years of relevant experience |
| active_status | BOOLEAN | NOT NULL, DEFAULT TRUE | Indicates whether the investigator is active |

### Constraints

- `email` must be unique.
- `experience_years` cannot be negative.

---

# 3. Equipment

Represents equipment available for paranormal investigations.

| Attribute | Data Type | Constraints | Purpose |
|---|---|---|---|
| equipment_id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique equipment identifier |
| equipment_name | VARCHAR(100) | NOT NULL | Name of the device |
| equipment_type | VARCHAR(75) | NOT NULL | Equipment category |
| manufacturer | VARCHAR(100) | NULL | Device manufacturer |
| serial_number | VARCHAR(100) | NULL, UNIQUE | Manufacturer serial number |
| operational_status | VARCHAR(20) | NOT NULL, DEFAULT 'Available' | Current equipment state |
| legacy_code | VARCHAR(30) | NULL | Temporary legacy tracking field |

### Constraints

Suggested operational states:

- Available
- Assigned
- Maintenance
- Retired

### Assignment Design Note

`legacy_code` is intentionally included in the original schema so the required `DROP COLUMN` operation can later be demonstrated without removing useful production data.

---

# 4. Expedition

Represents a paranormal investigation conducted at a location.

| Attribute | Data Type | Constraints | Purpose |
|---|---|---|---|
| expedition_id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique expedition identifier |
| expedition_name | VARCHAR(120) | NOT NULL | Expedition name |
| location_id | INT | NOT NULL, FOREIGN KEY | Location being investigated |
| start_date | DATE | NOT NULL | Scheduled or actual start date |
| end_date | DATE | NULL | Completion date |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'Planned' | Current expedition state |
| objective | VARCHAR(255) | NOT NULL | Main investigation objective |

### Foreign Key

`location_id` references:

`Location(location_id)`

### Nullability

`end_date` may be NULL because an expedition can exist before it has been completed.

### Constraints

Suggested statuses:

- Planned
- Active
- Completed
- Cancelled

If `end_date` contains a value, it should not occur before `start_date`.

---

# 5. ExpeditionInvestigator

Junction relation connecting investigators with expeditions.

This relation resolves the many-to-many relationship between `Expedition` and `Investigator`.

| Attribute | Data Type | Constraints | Purpose |
|---|---|---|---|
| expedition_id | INT | PRIMARY KEY, FOREIGN KEY | Expedition assignment |
| investigator_id | INT | PRIMARY KEY, FOREIGN KEY | Assigned investigator |
| team_role | VARCHAR(75) | NOT NULL | Investigator role for this expedition |
| hours_assigned | DECIMAL(5,2) | NOT NULL, DEFAULT 0 | Assigned investigation hours |

### Composite Primary Key

`{expedition_id, investigator_id}`

### Foreign Keys

`expedition_id` references:

`Expedition(expedition_id)`

`investigator_id` references:

`Investigator(investigator_id)`

### Constraints

`hours_assigned` cannot be negative.

---

# 6. ExpeditionEquipment

Junction relation connecting equipment with expeditions.

This relation resolves the many-to-many relationship between `Expedition` and `Equipment`.

| Attribute | Data Type | Constraints | Purpose |
|---|---|---|---|
| expedition_id | INT | PRIMARY KEY, FOREIGN KEY | Expedition using the equipment |
| equipment_id | INT | PRIMARY KEY, FOREIGN KEY | Equipment assigned |
| checkout_time | DATETIME | NOT NULL | Time equipment was issued |
| return_time | DATETIME | NULL | Time equipment was returned |
| condition_out | VARCHAR(50) | NOT NULL, DEFAULT 'Good' | Condition when issued |
| condition_in | VARCHAR(50) | NULL | Condition when returned |

### Composite Primary Key

`{expedition_id, equipment_id}`

### Foreign Keys

`expedition_id` references:

`Expedition(expedition_id)`

`equipment_id` references:

`Equipment(equipment_id)`

### Nullability

`return_time` and `condition_in` may remain NULL while equipment is still checked out.

---

# 7. Evidence

Represents evidence or observations recorded during an expedition.

| Attribute | Data Type | Constraints | Purpose |
|---|---|---|---|
| evidence_id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique evidence identifier |
| expedition_id | INT | NOT NULL, FOREIGN KEY | Expedition where evidence was collected |
| investigator_id | INT | NOT NULL, FOREIGN KEY | Investigator recording the evidence |
| equipment_id | INT | NULL, FOREIGN KEY | Equipment used to collect evidence |
| evidence_type | VARCHAR(50) | NOT NULL | Type of evidence |
| captured_at | DATETIME | NOT NULL | Date and time of collection |
| file_reference | VARCHAR(255) | NULL | Path or reference to associated media |
| credibility_score | TINYINT | NOT NULL, DEFAULT 5 | Evidence credibility rating |
| notes | TEXT | NULL | Additional observations |

### Foreign Keys

`expedition_id` references:

`Expedition(expedition_id)`

`investigator_id` references:

`Investigator(investigator_id)`

`equipment_id` references:

`Equipment(equipment_id)`

### Nullability

`equipment_id` may be NULL because evidence can be based on a direct human observation rather than a device.

`file_reference` may be NULL when no media file exists.

### Constraints

`credibility_score` must satisfy:

`1 <= credibility_score <= 10`

---

# Relationship Summary

Location 1:N Expedition

Expedition M:N Investigator

Resolved through:

ExpeditionInvestigator

Expedition M:N Equipment

Resolved through:

ExpeditionEquipment

Expedition 1:N Evidence

Investigator 1:N Evidence

Equipment 1:N Evidence, with the equipment relationship optional from the Evidence side.

---

# Planned ALTER TABLE Operations

## Required ADD COLUMN Operation

After the initial Evidence table has been created and populated, add:

`review_status VARCHAR(20) NOT NULL DEFAULT 'Pending'`

This demonstrates adding a non-nullable attribute with a default value.

## Required DROP COLUMN Operation

Remove:

`Equipment.legacy_code`

This demonstrates the required column-removal operation while preserving the useful equipment attributes.

---

# Minimum Data Requirement

Seven tables are included.

The assignment requires at least twenty tuples in each table.

Minimum required tuples:

7 x 20 = 140 tuples

The final database may contain more than 140 records, but no table should contain fewer than twenty.

---

# Initial Design Status

- Database identified
- Seven relations defined
- Primary keys identified
- Composite keys identified
- Foreign keys identified
- Nullable attributes considered
- Default values planned
- CHECK constraints planned
- One-to-many relationships identified
- Many-to-many relationships resolved
- ADD COLUMN operation planned
- DROP COLUMN operation planned
- Ready for relationship validation
