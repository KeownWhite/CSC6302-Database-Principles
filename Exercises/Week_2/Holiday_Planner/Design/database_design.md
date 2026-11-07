# Holiday Planner Master Database Design

## Database

Database Name: `HolidayPlanner`

## Purpose

The HolidayPlanner database expands the original family spooky-vacation concept into a generic family travel-planning system.

The schema must support:

- single-afternoon outings
- multi-activity day trips
- weekend trips
- week-long trips
- driving
- flying
- reusable family packing rules
- personal-item packing
- suitcase packing
- activity-specific equipment
- multiple activities in sequence
- multiple activity days
- accommodations
- travel cost and duration
- family demographic information

No SQL implementation should begin until this design passes mathematical, scenario, anomaly, and integrity verification.

---

# Design Assumptions

1. Numeric identifiers are stable internal identifiers.

2. Person names are not assumed to be unique.

3. Location names are not assumed to be unique.

4. A family member may participate in many outings.

5. An outing may contain many family members.

6. An outing may contain multiple activities.

7. The same activity may occur more than once during one outing.

8. Activities may occur at locations different from an outing's primary destination.

9. An outing may contain multiple travel legs.

10. An overnight outing may use one or more accommodations.

11. A lodging property may be reused across multiple outings.

12. A person's standard packing list may differ by trip type.

13. Activity-specific equipment is separate from a person's standard trip packing list.

14. Derived facts should not be stored when they can be reliably calculated from existing values unless the assignment explicitly requires the stored value.

---

# 1. FamilyMember

Represents one person within the family.

## Schema

FamilyMember(
    member_id INT UNSIGNED,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    relationship_to_household VARCHAR(40)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| member_id | INT UNSIGNED | No | PK, AUTO_INCREMENT | Stable identifier |
| first_name | VARCHAR(50) | No | | First name |
| middle_name | VARCHAR(50) | Yes | | Middle name when applicable |
| last_name | VARCHAR(50) | No | | Last name |
| birth_date | DATE | No | | Demographic age information without storing changing age |
| relationship_to_household | VARCHAR(40) | No | | Family/household relationship |

## Key Assumption

Names and birth dates are not assumed to uniquely identify a person.

Primary key candidate:

{member_id}

---

# 2. TripType

Defines reusable categories of outings.

Examples:

- Single Afternoon
- Multi-Activity Day
- Weekend
- Week Long

## Schema

TripType(
    trip_type_id SMALLINT UNSIGNED,
    trip_type_name VARCHAR(50),
    min_days TINYINT UNSIGNED,
    max_days TINYINT UNSIGNED,
    description VARCHAR(255)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| trip_type_id | SMALLINT UNSIGNED | No | PK, AUTO_INCREMENT | Stable identifier |
| trip_type_name | VARCHAR(50) | No | UNIQUE | Human-readable type |
| min_days | TINYINT UNSIGNED | No | CHECK >= 1 | Minimum expected duration |
| max_days | TINYINT UNSIGNED | No | CHECK >= min_days | Maximum expected duration |
| description | VARCHAR(255) | Yes | | Explanation |

Candidate keys:

{trip_type_id}

{trip_type_name}

---

# 3. Location

Represents a physical place used by outings, activities, travel legs, or accommodations.

## Schema

Location(
    location_id INT UNSIGNED,
    location_name VARCHAR(120),
    address_line1 VARCHAR(150),
    city VARCHAR(80),
    state_province VARCHAR(80),
    postal_code VARCHAR(20),
    country VARCHAR(80),
    location_type VARCHAR(40)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| location_id | INT UNSIGNED | No | PK, AUTO_INCREMENT | Stable identifier |
| location_name | VARCHAR(120) | No | | Place name |
| address_line1 | VARCHAR(150) | Yes | | Street address when applicable |
| city | VARCHAR(80) | No | | City |
| state_province | VARCHAR(80) | No | | State/province |
| postal_code | VARCHAR(20) | Yes | | Postal code |
| country | VARCHAR(80) | No | DEFAULT 'United States' | Country |
| location_type | VARCHAR(40) | No | | Home, venue, airport, hotel, park, etc. |

Primary key candidate:

{location_id}

No descriptive attribute combination is assumed globally unique.

---

# 4. Outing

Represents one planned family outing or holiday trip.

## Schema

Outing(
    outing_id INT UNSIGNED,
    outing_name VARCHAR(120),
    trip_type_id SMALLINT UNSIGNED,
    primary_location_id INT UNSIGNED,
    holiday_name VARCHAR(80),
    start_date DATE,
    end_date DATE,
    description VARCHAR(255)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| outing_id | INT UNSIGNED | No | PK, AUTO_INCREMENT | Stable identifier |
| outing_name | VARCHAR(120) | No | | Trip name |
| trip_type_id | SMALLINT UNSIGNED | No | FK | Outing category |
| primary_location_id | INT UNSIGNED | No | FK | Primary destination |
| holiday_name | VARCHAR(80) | Yes | | Holiday when applicable |
| start_date | DATE | No | | Beginning date |
| end_date | DATE | No | CHECK end_date >= start_date | Ending date |
| description | VARCHAR(255) | Yes | | Planning notes |

Foreign keys:

trip_type_id → TripType(trip_type_id)

primary_location_id → Location(location_id)

Primary key candidate:

{outing_id}

`holiday_name` being NULL means the outing is not tied to a specific holiday, avoiding a redundant holiday-specific Boolean field.

---

# 5. OutingParticipant

Resolves the many-to-many relationship between Outing and FamilyMember.

## Schema

OutingParticipant(
    outing_id INT UNSIGNED,
    member_id INT UNSIGNED,
    attendance_status VARCHAR(20)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| outing_id | INT UNSIGNED | No | PK, FK | Outing |
| member_id | INT UNSIGNED | No | PK, FK | Participant |
| attendance_status | VARCHAR(20) | No | DEFAULT 'Confirmed' | Participation status |

Composite primary key:

{outing_id, member_id}

Foreign keys:

outing_id → Outing(outing_id)

member_id → FamilyMember(member_id)

Planned attendance values:

- Invited
- Confirmed
- Declined

---

# 6. Activity

Represents a reusable activity definition.

## Schema

Activity(
    activity_id INT UNSIGNED,
    activity_name VARCHAR(100),
    activity_category VARCHAR(50),
    default_duration_minutes SMALLINT UNSIGNED,
    min_participants TINYINT UNSIGNED,
    description VARCHAR(255)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| activity_id | INT UNSIGNED | No | PK, AUTO_INCREMENT | Stable identifier |
| activity_name | VARCHAR(100) | No | UNIQUE | Activity name |
| activity_category | VARCHAR(50) | No | | Category |
| default_duration_minutes | SMALLINT UNSIGNED | Yes | CHECK > 0 when present | Typical duration |
| min_participants | TINYINT UNSIGNED | No | DEFAULT 1, CHECK > 0 | Minimum people |
| description | VARCHAR(255) | Yes | | Description |

Candidate keys:

{activity_id}

{activity_name}

---

# 7. OutingActivity

Represents one scheduled activity occurrence within an outing.

The same Activity may appear multiple times during one Outing.

## Schema

OutingActivity(
    outing_id INT UNSIGNED,
    activity_date DATE,
    sequence_number SMALLINT UNSIGNED,
    activity_id INT UNSIGNED,
    location_id INT UNSIGNED,
    start_time TIME,
    planned_duration_minutes SMALLINT UNSIGNED,
    notes VARCHAR(255)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| outing_id | INT UNSIGNED | No | PK, FK | Parent outing |
| activity_date | DATE | No | PK | Scheduled date |
| sequence_number | SMALLINT UNSIGNED | No | PK, CHECK > 0 | Order for that day |
| activity_id | INT UNSIGNED | No | FK | Activity |
| location_id | INT UNSIGNED | No | FK | Activity venue |
| start_time | TIME | Yes | | Exact start when known |
| planned_duration_minutes | SMALLINT UNSIGNED | No | CHECK > 0 | Planned duration |
| notes | VARCHAR(255) | Yes | | Schedule notes |

Composite primary key:

{outing_id, activity_date, sequence_number}

Foreign keys:

outing_id → Outing(outing_id)

activity_id → Activity(activity_id)

location_id → Location(location_id)

Business rule:

activity_date should fall between the parent outing's start_date and end_date.

That rule requires cross-table verification because a simple row-level CHECK cannot compare values from another table.

---

# 8. TravelMode

Represents a reusable transportation method.

## Schema

TravelMode(
    travel_mode_id SMALLINT UNSIGNED,
    travel_mode_name VARCHAR(30),
    description VARCHAR(255)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| travel_mode_id | SMALLINT UNSIGNED | No | PK, AUTO_INCREMENT | Stable identifier |
| travel_mode_name | VARCHAR(30) | No | UNIQUE | Transportation mode |
| description | VARCHAR(255) | Yes | | Explanation |

Candidate keys:

{travel_mode_id}

{travel_mode_name}

Initial values include:

- Car
- Plane
- Train
- Bus
- Other

---
# 9. TravelLeg

Represents one transportation segment of an outing.

An outing may contain multiple legs.

## Schema

TravelLeg(
    travel_leg_id INT UNSIGNED,
    outing_id INT UNSIGNED,
    sequence_number SMALLINT UNSIGNED,
    travel_mode_id SMALLINT UNSIGNED,
    from_location_id INT UNSIGNED,
    to_location_id INT UNSIGNED,
    departure_datetime DATETIME,
    planned_duration_minutes INT UNSIGNED,
    estimated_cost DECIMAL(10,2)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| travel_leg_id | INT UNSIGNED | No | PK, AUTO_INCREMENT | Stable identifier |
| outing_id | INT UNSIGNED | No | FK | Parent outing |
| sequence_number | SMALLINT UNSIGNED | No | UNIQUE with outing_id | Travel order |
| travel_mode_id | SMALLINT UNSIGNED | No | FK | Transportation method |
| from_location_id | INT UNSIGNED | No | FK | Departure |
| to_location_id | INT UNSIGNED | No | FK | Arrival |
| departure_datetime | DATETIME | Yes | | Planned departure |
| planned_duration_minutes | INT UNSIGNED | No | CHECK > 0 | Travel duration |
| estimated_cost | DECIMAL(10,2) | No | CHECK >= 0 | Estimated total leg cost |

Primary key:

{travel_leg_id}

Alternate candidate key:

{outing_id, sequence_number}

Foreign keys:

outing_id → Outing(outing_id)

travel_mode_id → TravelMode(travel_mode_id)

from_location_id → Location(location_id)

to_location_id → Location(location_id)

Supported travel modes initially include:

- Car
- Plane
- Train
- Bus
- Other

Constraint:

from_location_id ≠ to_location_id

Arrival time is not stored because it can be calculated from departure time and planned duration when departure time exists.

---

# 10. Accommodation

Represents a reusable lodging property.

## Schema

Accommodation(
    accommodation_id INT UNSIGNED,
    accommodation_name VARCHAR(120),
    location_id INT UNSIGNED,
    accommodation_type VARCHAR(40),
    phone VARCHAR(25),
    website VARCHAR(255)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| accommodation_id | INT UNSIGNED | No | PK, AUTO_INCREMENT | Stable identifier |
| accommodation_name | VARCHAR(120) | No | UNIQUE with location_id | Property name |
| location_id | INT UNSIGNED | No | FK, UNIQUE with accommodation_name | Property location |
| accommodation_type | VARCHAR(40) | No | | Hotel, cabin, resort, rental, etc. |
| phone | VARCHAR(25) | Yes | | Contact number |
| website | VARCHAR(255) | Yes | | Website |

Candidate keys:

{accommodation_id}

{accommodation_name, location_id}

Foreign key:

location_id → Location(location_id)

---

# 11. OutingAccommodation

Associates an outing with lodging and stores booking-specific facts.

## Schema

OutingAccommodation(
    outing_id INT UNSIGNED,
    accommodation_id INT UNSIGNED,
    check_in_date DATE,
    check_out_date DATE,
    nightly_rate DECIMAL(10,2),
    booking_reference VARCHAR(80)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| outing_id | INT UNSIGNED | No | PK, FK | Outing |
| accommodation_id | INT UNSIGNED | No | PK, FK | Lodging property |
| check_in_date | DATE | No | PK | Stay beginning |
| check_out_date | DATE | No | CHECK > check_in_date | Stay ending |
| nightly_rate | DECIMAL(10,2) | No | CHECK >= 0 | Planned nightly rate |
| booking_reference | VARCHAR(80) | Yes | | External reservation identifier |

Composite primary key:

{outing_id, accommodation_id, check_in_date}

Foreign keys:

outing_id → Outing(outing_id)

accommodation_id → Accommodation(accommodation_id)

No total lodging cost is stored because it is derivable from the number of nights and nightly rate.

---

# 12. PackingItem

Represents a reusable item that may appear in packing rules.

## Schema

PackingItem(
    item_id INT UNSIGNED,
    item_name VARCHAR(100),
    item_category VARCHAR(50),
    description VARCHAR(255)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| item_id | INT UNSIGNED | No | PK, AUTO_INCREMENT | Stable identifier |
| item_name | VARCHAR(100) | No | UNIQUE | Item name |
| item_category | VARCHAR(50) | No | | Clothing, electronics, safety, etc. |
| description | VARCHAR(255) | Yes | | Description |

Candidate keys:

{item_id}

{item_name}

---

# 13. MemberTripPackingItem

Defines a person's standard packing requirement for a TripType.

## Schema

MemberTripPackingItem(
    member_id INT UNSIGNED,
    trip_type_id SMALLINT UNSIGNED,
    item_id INT UNSIGNED,
    bag_type VARCHAR(20),
    quantity SMALLINT UNSIGNED
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| member_id | INT UNSIGNED | No | PK, FK | Family member |
| trip_type_id | SMALLINT UNSIGNED | No | PK, FK | Trip category |
| item_id | INT UNSIGNED | No | PK, FK | Packing item |
| bag_type | VARCHAR(20) | No | CHECK | Storage location |
| quantity | SMALLINT UNSIGNED | No | DEFAULT 1, CHECK > 0 | Standard quantity |

Composite primary key:

{member_id, trip_type_id, item_id}

Foreign keys:

member_id → FamilyMember(member_id)

trip_type_id → TripType(trip_type_id)

item_id → PackingItem(item_id)

Valid bag types:

- Personal Item
- Suitcase

---

# 14. MemberTravelPackingItem

Defines transportation-specific packing requirements for a family member.

## Schema

MemberTravelPackingItem(
    member_id INT UNSIGNED,
    travel_mode_id SMALLINT UNSIGNED,
    item_id INT UNSIGNED,
    bag_type VARCHAR(20),
    quantity SMALLINT UNSIGNED
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| member_id | INT UNSIGNED | No | PK, FK | Family member |
| travel_mode_id | SMALLINT UNSIGNED | No | PK, FK | Transportation mode |
| item_id | INT UNSIGNED | No | PK, FK | Packing item |
| bag_type | VARCHAR(20) | No | CHECK | Storage location |
| quantity | SMALLINT UNSIGNED | No | DEFAULT 1, CHECK > 0 | Standard quantity |

Composite primary key:

{member_id, travel_mode_id, item_id}

Foreign keys:

member_id → FamilyMember(member_id)

travel_mode_id → TravelMode(travel_mode_id)

item_id → PackingItem(item_id)

Valid bag types:

- Personal Item
- Suitcase

This relation stores only transportation-specific additions.

Examples:

Plane:
- travel documents
- carry-on charger

Car:
- road snacks
- cooler
- vehicle emergency supplies

This prevents ordinary TripType packing facts from being repeated once for every transportation mode.

---
# 15. ActivityPackingItem

Defines equipment or supplies associated with an Activity.

## Schema

ActivityPackingItem(
    activity_id INT UNSIGNED,
    item_id INT UNSIGNED,
    quantity SMALLINT UNSIGNED,
    requirement_level VARCHAR(20)
)

| Attribute | Domain / Type | Null | Key / Constraint | Purpose |
|---|---|---|---|---|
| activity_id | INT UNSIGNED | No | PK, FK | Activity |
| item_id | INT UNSIGNED | No | PK, FK | Required/recommended item |
| quantity | SMALLINT UNSIGNED | No | DEFAULT 1, CHECK > 0 | Quantity |
| requirement_level | VARCHAR(20) | No | DEFAULT 'Required', CHECK | Requirement strength |

Composite primary key:

{activity_id, item_id}

Foreign keys:

activity_id → Activity(activity_id)

item_id → PackingItem(item_id)

Valid requirement levels:

- Required
- Recommended

---

# Relationship Summary

FamilyMember M:N Outing
through OutingParticipant

TripType 1:N Outing

Location 1:N Outing

Outing M:N Activity occurrences
through OutingActivity

Activity 1:N OutingActivity

Location 1:N OutingActivity

TravelMode 1:N TravelLeg

Outing 1:N TravelLeg

Location 1:N TravelLeg as departure location

Location 1:N TravelLeg as arrival location

Accommodation M:N Outing
through OutingAccommodation

Location 1:N Accommodation

FamilyMember M:N PackingItem for each TripType
through MemberTripPackingItem

Activity M:N PackingItem
through ActivityPackingItem

---

# Pre-Mathematical Design Status

- 15 relations defined
- attributes frozen for initial verification
- conceptual domains identified
- SQL types proposed
- nullable attributes identified
- candidate keys proposed
- primary keys proposed
- foreign-key paths proposed
- derived values deliberately avoided where possible
- multiple travel legs supported
- repeated activities supported
- multiple activity days supported
- multiple accommodations supported
- reusable packing rules supported

The design is NOT yet approved for SQL implementation.

Next step:

Sample tuple and scenario verification, followed by full mathematical verification.