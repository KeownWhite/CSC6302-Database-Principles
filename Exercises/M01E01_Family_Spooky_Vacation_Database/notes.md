# CSC6302 Database Principles

- Module: 01
- Exercise: 01
- Title: Family Spooky Vacation Database

# Working Notes

## 1. Graded Core Concept

The required database models a family vacation to spooky destinations.

The graded design must remain understandable without the optional game extension.

Core concepts:

- family members
- spooky vacation destinations
- activities available at destinations
- costumes
- comfort items
- safety items
- packing requirements

The professor allows flexibility in how the spooky vacation database is organized, so the final design may extend the examples while remaining within the vacation theme.

---

# 2. Core Business Rules

1. Every family member must be uniquely identifiable.

2. A family member may be interested in more than one vacation destination.

3. Multiple family members may choose the same destination.

4. Every destination must be uniquely identifiable.

5. A destination may offer multiple activities.

6. The same general activity may be available at more than one destination.

7. Every packing item must belong to a defined category.

Possible categories include:

- Costume
- Safety
- Comfort
- Food
- Equipment

8. A family member may require multiple packing items.

9. The same packing item may be required by multiple family members.

10. Quantity belongs to the assignment of an item to a family member, not to the definition of the item itself.

11. Facts should be stored once whenever practical.

12. The design should avoid unnecessary duplicate data.

---

# 3. Integrity Rules

The database should enforce appropriate constraints where possible.

## Entity Integrity

- Every primary key must uniquely identify a row.
- Primary-key values must not be NULL.

## Referential Integrity

- Foreign-key values must reference valid rows in the parent relation.

## Domain Integrity

Use appropriate data types and CHECK constraints where useful.

Examples:

- quantity must be greater than zero
- ranking values must be positive
- numeric ratings must remain within their defined range
- category values must come from an allowed set

## Required Constraint Types

Consider:

- PRIMARY KEY
- FOREIGN KEY
- NOT NULL
- UNIQUE
- CHECK
- DEFAULT

Only use a constraint when it represents a real business rule.

---

# 4. Key Analysis Rules

For every relation:

1. Identify all possible attribute combinations required by the course.
2. Determine which combinations uniquely identify rows.
3. Identify candidate keys.
4. Verify candidate-key minimality.
5. Select one primary key.
6. Explain why that primary key is the most reasonable choice.

Formal candidate-key verification:

K+ = R

A candidate key K must determine every attribute in relation R.

It must also be minimal:

For every proper subset S of K:

S+ != R

---

# 5. Functional Dependencies

Functional dependencies will be written before finalizing the schema.

General form:

X -> Y

Meaning:

A value of X determines exactly one value of Y.

Functional dependencies will be used to justify:

- relation structure
- candidate keys
- decomposition
- normalization

---

# 6. Normalization Goal

Target:

1NF -> 2NF -> 3NF

BCNF will also be checked as an optional advanced verification.

## 1NF

- atomic values
- no repeating groups

## 2NF

- must satisfy 1NF
- no non-key attribute may depend on only part of a composite candidate key

## 3NF

- must satisfy 2NF
- eliminate inappropriate transitive dependencies

## BCNF

For every nontrivial functional dependency:

X -> Y

X should be a superkey.

---

# 7. Design Verification

The final graded section may include a short mathematical verification section.

Possible checks:

- functional dependencies
- attribute closure
- candidate-key minimality
- superkey enumeration
- normalization
- constraint validation

Advanced analysis must support the required assignment rather than replace it.

---

# 8. Optional Interactive Extension

## Paranormal Expedition Mode

The completed vacation database may support an optional hidden game extension.

This extension is not part of the required grading criteria.

The core database must remain independently complete.

The game will reinterpret existing vacation data rather than duplicate it.

Examples:

FAMILY_MEMBER -> player
VACATION_SITE -> expedition location
ACTIVITY -> investigation
PACKING_ITEM -> player loadout

The original family member name and identity remain unchanged.

---

# 9. Game Concept

During the spooky family vacation, one family member begins a fictional infection mystery.

Players use database information to identify the infected person.

The pathogen and transmission rules are fictional game mechanics.

The game may use:

- movements
- contact events
- symptom clues
- observations
- scores
- investigation activities

Points may be awarded for identifying clues early.

The optional extension should demonstrate database concepts such as:

- constraints
- relationships
- derived values
- queries
- state transitions
- data validation

---

# 10. CSC6033 Integration

CSC6033 concepts may be used only when they naturally support the database application.

Possible uses:

- finite-state machines for game states
- recursion for tracing relationships
- matrices for contact relationships
- dot products for weighted clue scoring
- enums for state categories
- classes for application entities
- graph traversal for deduction
- cycle detection for invalid states

These concepts belong primarily in the optional extension, not the required assignment response.

---

# 11. Design Principle

Every relation must exist for a reason.

A relation should be justified by one or more of:

- business rule
- functional dependency
- relationship cardinality
- removal of redundancy
- normalization requirement

No table should exist only to make the design appear more complex.

# 12. Locked Business Rules - Version 1

## Vacation Structure

BR-01: The system stores one or more family members.

BR-02: Each family member has a unique internal identifier.

BR-03: The system stores one or more spooky vacation destinations.

BR-04: Each destination has a unique internal identifier.

BR-05: A family member may be interested in multiple destinations.

BR-06: A destination may be selected by multiple family members.

## Activities

BR-07: A destination may offer multiple activities.

BR-08: The same activity type may be available at multiple destinations.

BR-09: An activity must be associated with at least one valid destination before it can be scheduled for the vacation.

## Packing

BR-10: The system stores reusable definitions of packing items.

BR-11: Packing items may belong to categories such as Costume, Safety, Comfort, Food, or Equipment.

BR-12: A family member may require multiple packing items.

BR-13: The same packing item may be assigned to multiple family members.

BR-14: The quantity of an item is specific to the family member's packing assignment.

BR-15: A packing quantity must be greater than zero.

## Data Integrity

BR-16: Every relation must have a primary key.

BR-17: Required descriptive values may not be NULL.

BR-18: Foreign-key values must reference existing parent rows.

BR-19: Values governed by a defined range or allowed set should be protected with CHECK constraints where appropriate.

BR-20: Data that can be derived through relationships should not be unnecessarily duplicated.

## Design Rule

BR-21: Many-to-many relationships must be resolved through associative relations.

BR-22: Every relation must represent one logical subject or relationship.

BR-23: Every relation must be justified by a business rule, functional dependency, cardinality requirement, or normalization decision.

BR-24: The graded vacation database must remain complete and understandable without the optional game extension.

## Optional Extension Boundary

BR-25: Paranormal Expedition Mode may reference the graded vacation relations but must not alter their meaning.

BR-26: A family member may become a game player through their existing identity rather than through duplicated personal information.

BR-27: Optional game-state data must remain logically separate from required vacation data.


# 13. Relationship Map

The business rules imply three core many-to-many relationships.

## R1. Family Members and Destinations

A family member may want to visit multiple destinations.

A destination may be selected by multiple family members.

Cardinality:

FAMILY_MEMBER M:N VACATION_SITE

This relationship will require an associative relation later.

Possible relationship data:

- preference rank
- selected status
- notes

---

## R2. Destinations and Activities

A vacation site may offer multiple activities.

The same type of activity may be offered at multiple destinations.

Cardinality:

VACATION_SITE M:N ACTIVITY

This relationship will require an associative relation later.

Possible relationship data:

- availability
- duration
- difficulty
- scheduled time

---

## R3. Family Members and Packing Items

A family member may need multiple packing items.

The same packing item may be needed by multiple family members.

Cardinality:

FAMILY_MEMBER M:N PACKING_ITEM

This relationship will require an associative relation later.

Possible relationship data:

- quantity
- packed status
- priority

---

# 14. Initial Conceptual Model

FAMILY_MEMBER
      |
      | M:N
      |
VACATION_SITE
      |
      | M:N
      |
   ACTIVITY

FAMILY_MEMBER
      |
      | M:N
      |
PACKING_ITEM

The associative relations required by these many-to-many relationships will be identified after functional dependencies are defined.

No associative relation should be created until its key and purpose can be justified.


# 15. Candidate Attributes

The following attributes are proposed for analysis. They are not yet the final SQL schema.

## FAMILY_MEMBER

- MemberID
- MemberName

Possible dependency:

MemberID -> MemberName

Assumption:
MemberName is not guaranteed to be unique.

---

## VACATION_SITE

- SiteID
- SiteName
- Location
- SpookinessLevel

Possible dependency:

SiteID -> SiteName, Location, SpookinessLevel

Possible constraint:

1 <= SpookinessLevel <= 5

SiteName alone is not assumed to be unique.

---

## ACTIVITY

- ActivityID
- ActivityName
- ActivityCategory

Possible dependency:

ActivityID -> ActivityName, ActivityCategory

ActivityName alone is not assumed to be unique.

---

## PACKING_ITEM

- ItemID
- ItemName
- ItemCategory

Possible dependency:

ItemID -> ItemName, ItemCategory

Possible ItemCategory values:

- Costume
- Safety
- Comfort
- Food
- Equipment

---

# 16. Relationship Attributes

## FAMILY_MEMBER to VACATION_SITE

Relationship attributes:

- MemberID
- SiteID
- PreferenceRank

Functional dependency:

{MemberID, SiteID} -> PreferenceRank

The pair identifies one family member's preference for one destination.

Possible constraint:

PreferenceRank > 0

---

## VACATION_SITE to ACTIVITY

Relationship attributes:

- SiteID
- ActivityID

Candidate dependency:

{SiteID, ActivityID} -> all attributes of the relationship

This relationship may not require additional descriptive attributes.

---

## FAMILY_MEMBER to PACKING_ITEM

Relationship attributes:

- MemberID
- ItemID
- Quantity
- PackedStatus

Functional dependency:

{MemberID, ItemID} -> Quantity, PackedStatus

Possible constraints:

Quantity > 0

PackedStatus IN ('YES', 'NO')

---

# 17. Initial Functional Dependency Set

Let F be the current set of functional dependencies.

F = {

MemberID -> MemberName,

SiteID -> SiteName, Location, SpookinessLevel,

ActivityID -> ActivityName, ActivityCategory,

ItemID -> ItemName, ItemCategory,

{MemberID, SiteID} -> PreferenceRank,

{MemberID, ItemID} -> Quantity, PackedStatus

}

The VACATION_SITE to ACTIVITY association currently contains only its identifying attributes, so it has no meaningful nontrivial dependency beyond its composite key determining the row itself.

---

# 18. Important Design Assumptions

A1. Surrogate identification values are unique.

A2. Names are descriptive and are not automatically assumed to be unique.

A3. One family member may rank the same destination only once.

A4. One activity may be associated with the same destination only once.

A5. One packing item may be assigned to the same family member only once.

A6. Quantity belongs to the member-item relationship.

A7. PreferenceRank belongs to the member-site relationship.

A8. PackedStatus belongs to the member-item relationship.

These assumptions will be tested against candidate keys and normalization before the schema is finalized.


# 19. Attribute Closure and Candidate-Key Verification

The following section uses functional dependencies to test whether proposed keys determine every attribute in their relation.

A set K is a superkey when:

K+ = R

A superkey is a candidate key when it is minimal:

For every proper subset S of K:

S+ != R

---

## FAMILY_MEMBER

Proposed relation:

FAMILY_MEMBER(MemberID, MemberName)

Functional dependency:

MemberID -> MemberName

Start with:

{MemberID}+ = {MemberID}

Apply:

MemberID -> MemberName

Therefore:

{MemberID}+ = {MemberID, MemberName}

Since this equals the complete relation:

{MemberID}+ = FAMILY_MEMBER

Therefore:

{MemberID} is a superkey.

Because MemberID contains only one attribute, it has no smaller nonempty subset capable of identifying the complete relation.

Therefore:

Candidate Key = {MemberID}

Primary-key candidate:

MemberID

Formal superkeys:

- {MemberID}
- {MemberID, MemberName}

---

## VACATION_SITE

Proposed relation:

VACATION_SITE(
    SiteID,
    SiteName,
    Location,
    SpookinessLevel
)

Functional dependency:

SiteID -> SiteName, Location, SpookinessLevel

Start:

{SiteID}+ = {SiteID}

Apply the dependency:

{SiteID}+ =
{
    SiteID,
    SiteName,
    Location,
    SpookinessLevel
}

Therefore:

{SiteID}+ = VACATION_SITE

Thus:

Candidate Key = {SiteID}

Formal superkeys are every attribute set containing SiteID.

Number of formal superkeys:

n = 4
k = 1

N = 2^(n-k)

N = 2^(4-1)

N = 8

Formal superkeys:

1. {SiteID}
2. {SiteID, SiteName}
3. {SiteID, Location}
4. {SiteID, SpookinessLevel}
5. {SiteID, SiteName, Location}
6. {SiteID, SiteName, SpookinessLevel}
7. {SiteID, Location, SpookinessLevel}
8. {SiteID, SiteName, Location, SpookinessLevel}

---

## ACTIVITY

Proposed relation:

ACTIVITY(
    ActivityID,
    ActivityName,
    ActivityCategory
)

Functional dependency:

ActivityID -> ActivityName, ActivityCategory

Closure:

{ActivityID}+ =
{
    ActivityID,
    ActivityName,
    ActivityCategory
}

Therefore:

Candidate Key = {ActivityID}

Number of formal superkeys:

n = 3
k = 1

N = 2^(3-1)

N = 4

Formal superkeys:

1. {ActivityID}
2. {ActivityID, ActivityName}
3. {ActivityID, ActivityCategory}
4. {ActivityID, ActivityName, ActivityCategory}

---

## PACKING_ITEM

Proposed relation:

PACKING_ITEM(
    ItemID,
    ItemName,
    ItemCategory
)

Functional dependency:

ItemID -> ItemName, ItemCategory

Closure:

{ItemID}+ =
{
    ItemID,
    ItemName,
    ItemCategory
}

Therefore:

Candidate Key = {ItemID}

Number of formal superkeys:

n = 3
k = 1

N = 2^(3-1)

N = 4

Formal superkeys:

1. {ItemID}
2. {ItemID, ItemName}
3. {ItemID, ItemCategory}
4. {ItemID, ItemName, ItemCategory}

---

## FAMILY_SITE

Proposed relation:

FAMILY_SITE(
    MemberID,
    SiteID,
    PreferenceRank
)

Functional dependency:

{MemberID, SiteID} -> PreferenceRank

Start:

{MemberID, SiteID}+ =
{
    MemberID,
    SiteID
}

Apply:

{MemberID, SiteID} -> PreferenceRank

Therefore:

{MemberID, SiteID}+ =
{
    MemberID,
    SiteID,
    PreferenceRank
}

So:

{MemberID, SiteID}

is a superkey.

Minimality test:

{MemberID}+ != FAMILY_SITE

{SiteID}+ != FAMILY_SITE

Therefore neither proper subset determines the complete relation.

Thus:

Candidate Key = {MemberID, SiteID}

Formal superkeys:

1. {MemberID, SiteID}
2. {MemberID, SiteID, PreferenceRank}

---

## SITE_ACTIVITY

Proposed relation:

SITE_ACTIVITY(
    SiteID,
    ActivityID
)

There are no non-key descriptive attributes.

The combination:

{SiteID, ActivityID}

uniquely identifies one activity assignment at one vacation site.

Closure:

{SiteID, ActivityID}+ =
{
    SiteID,
    ActivityID
}

Therefore:

Candidate Key = {SiteID, ActivityID}

Neither SiteID nor ActivityID alone identifies the relationship.

Formal superkeys:

1. {SiteID, ActivityID}

---

## MEMBER_ITEM

Proposed relation:

MEMBER_ITEM(
    MemberID,
    ItemID,
    Quantity,
    PackedStatus
)

Functional dependency:

{MemberID, ItemID} -> Quantity, PackedStatus

Closure:

{MemberID, ItemID}+ =
{
    MemberID,
    ItemID,
    Quantity,
    PackedStatus
}

Therefore:

{MemberID, ItemID}

is a superkey.

Minimality:

{MemberID}+ != MEMBER_ITEM

{ItemID}+ != MEMBER_ITEM

Therefore:

Candidate Key = {MemberID, ItemID}

Number of formal superkeys:

n = 4
k = 2

N = 2^(4-2)

N = 4

Formal superkeys:

1. {MemberID, ItemID}
2. {MemberID, ItemID, Quantity}
3. {MemberID, ItemID, PackedStatus}
4. {MemberID, ItemID, Quantity, PackedStatus}

---

# 20. Current Candidate-Key Summary

FAMILY_MEMBER
Candidate Key:
{MemberID}

VACATION_SITE
Candidate Key:
{SiteID}

ACTIVITY
Candidate Key:
{ActivityID}

PACKING_ITEM
Candidate Key:
{ItemID}

FAMILY_SITE
Candidate Key:
{MemberID, SiteID}

SITE_ACTIVITY
Candidate Key:
{SiteID, ActivityID}

MEMBER_ITEM
Candidate Key:
{MemberID, ItemID}

These keys remain provisional until normalization and relationship analysis are complete.


# 21. Normalization Verification

The proposed relations are tested progressively against First Normal Form, Second Normal Form, Third Normal Form, and Boyce-Codd Normal Form.

The purpose is to verify that the design minimizes redundancy while preserving the required relationships.

---

## FAMILY_MEMBER

Relation:

FAMILY_MEMBER(
    MemberID,
    MemberName
)

Functional dependency:

MemberID -> MemberName

### First Normal Form

All attributes contain atomic values.

There are no repeating groups.

Result:

FAMILY_MEMBER satisfies 1NF.

### Second Normal Form

The candidate key contains one attribute:

{MemberID}

Because the candidate key is not composite, partial dependency cannot occur.

Result:

FAMILY_MEMBER satisfies 2NF.

### Third Normal Form

The only nontrivial dependency is:

MemberID -> MemberName

The determinant MemberID is a candidate key.

There are no transitive dependencies.

Result:

FAMILY_MEMBER satisfies 3NF.

### BCNF

For every nontrivial functional dependency, the determinant is a superkey.

Result:

FAMILY_MEMBER satisfies BCNF.

---

## VACATION_SITE

Relation:

VACATION_SITE(
    SiteID,
    SiteName,
    Location,
    SpookinessLevel
)

Functional dependency:

SiteID -> SiteName, Location, SpookinessLevel

### First Normal Form

Each attribute is atomic.

No repeating destination properties are stored in one field.

Result:

VACATION_SITE satisfies 1NF.

### Second Normal Form

The candidate key is:

{SiteID}

Because it contains one attribute, no partial dependency exists.

Result:

VACATION_SITE satisfies 2NF.

### Third Normal Form

SiteName, Location, and SpookinessLevel depend directly on SiteID.

No non-key attribute is assumed to determine another non-key attribute.

Result:

VACATION_SITE satisfies 3NF.

### BCNF

SiteID is the determinant of every nontrivial dependency and is a candidate key.

Result:

VACATION_SITE satisfies BCNF.

---

## ACTIVITY

Relation:

ACTIVITY(
    ActivityID,
    ActivityName,
    ActivityCategory
)

Functional dependency:

ActivityID -> ActivityName, ActivityCategory

### First Normal Form

All values are atomic.

Result:

ACTIVITY satisfies 1NF.

### Second Normal Form

The candidate key is a single attribute:

{ActivityID}

No partial dependency is possible.

Result:

ACTIVITY satisfies 2NF.

### Third Normal Form

ActivityName and ActivityCategory depend directly on ActivityID.

No transitive dependency is currently assumed.

Result:

ACTIVITY satisfies 3NF.

### BCNF

The determinant ActivityID is a candidate key.

Result:

ACTIVITY satisfies BCNF.

---

## PACKING_ITEM

Relation:

PACKING_ITEM(
    ItemID,
    ItemName,
    ItemCategory
)

Functional dependency:

ItemID -> ItemName, ItemCategory

### First Normal Form

All item values are atomic.

Result:

PACKING_ITEM satisfies 1NF.

### Second Normal Form

The candidate key is:

{ItemID}

No partial dependency exists.

Result:

PACKING_ITEM satisfies 2NF.

### Third Normal Form

ItemName and ItemCategory depend directly on ItemID.

ItemCategory does not determine ItemName under the current business rules.

Result:

PACKING_ITEM satisfies 3NF.

### BCNF

ItemID is the determinant and is a candidate key.

Result:

PACKING_ITEM satisfies BCNF.

---

## FAMILY_SITE

Relation:

FAMILY_SITE(
    MemberID,
    SiteID,
    PreferenceRank
)

Functional dependency:

{MemberID, SiteID} -> PreferenceRank

Candidate key:

{MemberID, SiteID}

### First Normal Form

All attributes contain atomic values.

Each row represents one family member and one destination.

Result:

FAMILY_SITE satisfies 1NF.

### Second Normal Form

The candidate key is composite:

{MemberID, SiteID}

PreferenceRank depends on the complete combination.

Neither:

MemberID -> PreferenceRank

nor:

SiteID -> PreferenceRank

is assumed to hold.

Therefore there is no partial dependency.

Result:

FAMILY_SITE satisfies 2NF.

### Third Normal Form

There is no non-key attribute determining another non-key attribute.

Result:

FAMILY_SITE satisfies 3NF.

### BCNF

The determinant:

{MemberID, SiteID}

is a candidate key.

Result:

FAMILY_SITE satisfies BCNF.

---

## SITE_ACTIVITY

Relation:

SITE_ACTIVITY(
    SiteID,
    ActivityID
)

Candidate key:

{SiteID, ActivityID}

### First Normal Form

Both values are atomic.

Each row represents exactly one site-activity association.

Result:

SITE_ACTIVITY satisfies 1NF.

### Second Normal Form

There are no non-key attributes.

Therefore no partial dependency can exist.

Result:

SITE_ACTIVITY satisfies 2NF.

### Third Normal Form

There are no non-key attributes or transitive dependencies.

Result:

SITE_ACTIVITY satisfies 3NF.

### BCNF

There are no nontrivial functional dependencies whose determinant is not a superkey.

Result:

SITE_ACTIVITY satisfies BCNF.

---

## MEMBER_ITEM

Relation:

MEMBER_ITEM(
    MemberID,
    ItemID,
    Quantity,
    PackedStatus
)

Functional dependency:

{MemberID, ItemID} -> Quantity, PackedStatus

Candidate key:

{MemberID, ItemID}

### First Normal Form

Each attribute contains one atomic value.

Result:

MEMBER_ITEM satisfies 1NF.

### Second Normal Form

Quantity and PackedStatus depend on the complete composite key.

Neither:

MemberID -> Quantity, PackedStatus

nor:

ItemID -> Quantity, PackedStatus

is assumed to hold.

Therefore no partial dependency exists.

Result:

MEMBER_ITEM satisfies 2NF.

### Third Normal Form

Quantity does not determine PackedStatus.

PackedStatus does not determine Quantity.

No transitive dependency exists under the current business rules.

Result:

MEMBER_ITEM satisfies 3NF.

### BCNF

The determinant:

{MemberID, ItemID}

is a candidate key.

Result:

MEMBER_ITEM satisfies BCNF.

---

# 22. Normalization Summary

Under the current business rules:

FAMILY_MEMBER  -> BCNF
VACATION_SITE  -> BCNF
ACTIVITY       -> BCNF
PACKING_ITEM   -> BCNF
FAMILY_SITE    -> BCNF
SITE_ACTIVITY  -> BCNF
MEMBER_ITEM    -> BCNF

Therefore every proposed relation currently satisfies:

1NF -> 2NF -> 3NF -> BCNF

This conclusion remains valid only while the functional dependencies and business assumptions remain unchanged.

---

# 23. Open Design Decision - Preference Ranking

The meaning of PreferenceRank must be finalized before FAMILY_SITE is locked.

Current assumption:

{MemberID, SiteID} -> PreferenceRank

Possible stronger rule:

One family member may assign each numerical rank only once.

If that stronger rule is adopted:

{MemberID, PreferenceRank} -> SiteID

would also hold.

This would create another candidate key:

{MemberID, PreferenceRank}

That change would affect:

- candidate-key enumeration
- superkey enumeration
- UNIQUE constraints
- closure calculations

Do not finalize FAMILY_SITE until this rule is decided.


# 24. Preference Ranking Decision - Locked

The stronger preference-ranking rule is adopted.

Business rule:

A family member may rank multiple destinations, but the same family member may not assign the same numerical preference rank to more than one destination.

Therefore:

{MemberID, SiteID} -> PreferenceRank

and:

{MemberID, PreferenceRank} -> SiteID

Candidate keys:

K1 = {MemberID, SiteID}

K2 = {MemberID, PreferenceRank}

Primary-key choice:

{MemberID, SiteID}

Reason:

MemberID and SiteID naturally identify the relationship between one family member and one vacation site.

PreferenceRank is meaningful application data and may change if the family member changes their ranking. Therefore, it is better enforced as an alternate candidate key through a UNIQUE constraint rather than being used as the primary key.

Required constraint:

UNIQUE(MemberID, PreferenceRank)

---

# 25. FAMILY_SITE Revised Key Analysis

Relation:

FAMILY_SITE(
    MemberID,
    SiteID,
    PreferenceRank
)

Candidate keys:

1. {MemberID, SiteID}
2. {MemberID, PreferenceRank}

Primary key:

{MemberID, SiteID}

Alternate candidate key:

{MemberID, PreferenceRank}

Formal superkeys:

1. {MemberID, SiteID}
2. {MemberID, PreferenceRank}
3. {MemberID, SiteID, PreferenceRank}

The complete three-attribute relation is also a superkey because it contains both candidate keys.

---

# 26. Locked Relation Set - Version 1

The graded vacation database will use seven relations.

## 1. FAMILY_MEMBER

Attributes:

- MemberID
- MemberName

Purpose:

Stores each family member once.

Candidate key:

{MemberID}

---

## 2. VACATION_SITE

Attributes:

- SiteID
- SiteName
- Location
- SpookinessLevel

Purpose:

Stores spooky vacation destinations.

Candidate key:

{SiteID}

Constraint:

1 <= SpookinessLevel <= 5

---

## 3. ACTIVITY

Attributes:

- ActivityID
- ActivityName
- ActivityCategory

Purpose:

Stores reusable activity definitions.

Candidate key:

{ActivityID}

---

## 4. PACKING_ITEM

Attributes:

- ItemID
- ItemName
- ItemCategory

Purpose:

Stores reusable packing-item definitions.

Candidate key:

{ItemID}

Allowed categories may include:

- Costume
- Safety
- Comfort
- Food
- Equipment

---

## 5. FAMILY_SITE

Attributes:

- MemberID
- SiteID
- PreferenceRank

Purpose:

Resolves the many-to-many relationship between family members and vacation sites.

Candidate keys:

- {MemberID, SiteID}
- {MemberID, PreferenceRank}

Primary key:

{MemberID, SiteID}

Constraints:

PreferenceRank > 0

UNIQUE(MemberID, PreferenceRank)

---

## 6. SITE_ACTIVITY

Attributes:

- SiteID
- ActivityID

Purpose:

Resolves the many-to-many relationship between destinations and activities.

Candidate key:

{SiteID, ActivityID}

Primary key:

{SiteID, ActivityID}

---

## 7. MEMBER_ITEM

Attributes:

- MemberID
- ItemID
- Quantity
- PackedStatus

Purpose:

Resolves the many-to-many relationship between family members and packing items.

Candidate key:

{MemberID, ItemID}

Primary key:

{MemberID, ItemID}

Constraints:

Quantity > 0

PackedStatus is Boolean.

---

# 27. Locked Cardinality Model

FAMILY_MEMBER
    M
    |
    |
    N
VACATION_SITE

Resolved by:

FAMILY_SITE


VACATION_SITE
    M
    |
    |
    N
ACTIVITY

Resolved by:

SITE_ACTIVITY


FAMILY_MEMBER
    M
    |
    |
    N
PACKING_ITEM

Resolved by:

MEMBER_ITEM

---

# 28. Design Status

The following are now locked:

- business rules
- relationship cardinalities
- functional dependencies
- candidate keys
- primary-key strategy
- normalization target
- core relation set

The next stage is physical schema design:

- MySQL data types
- PRIMARY KEY constraints
- FOREIGN KEY constraints
- NOT NULL constraints
- UNIQUE constraints
- CHECK constraints
- DEFAULT values where justified


# 29. Physical Schema Decisions

The logical model is now translated into MySQL-compatible data types and integrity constraints.

## FAMILY_MEMBER

MemberID:
INT UNSIGNED
PRIMARY KEY
AUTO_INCREMENT

MemberName:
VARCHAR(80)
NOT NULL

Reasoning:
MemberID is a generated numeric identifier. MemberName is descriptive and is not assumed to be unique.

---

## VACATION_SITE

SiteID:
INT UNSIGNED
PRIMARY KEY
AUTO_INCREMENT

SiteName:
VARCHAR(100)
NOT NULL

Location:
VARCHAR(100)
NOT NULL

SpookinessLevel:
TINYINT UNSIGNED
NOT NULL

Constraint:

CHECK (SpookinessLevel BETWEEN 1 AND 5)

---

## ACTIVITY

ActivityID:
INT UNSIGNED
PRIMARY KEY
AUTO_INCREMENT

ActivityName:
VARCHAR(100)
NOT NULL

ActivityCategory:
VARCHAR(40)
NOT NULL

---

## PACKING_ITEM

ItemID:
INT UNSIGNED
PRIMARY KEY
AUTO_INCREMENT

ItemName:
VARCHAR(100)
NOT NULL

ItemCategory:
VARCHAR(20)
NOT NULL

Constraint:

CHECK (
    ItemCategory IN (
        'Costume',
        'Safety',
        'Comfort',
        'Food',
        'Equipment'
    )
)

---

## FAMILY_SITE

MemberID:
INT UNSIGNED
NOT NULL

SiteID:
INT UNSIGNED
NOT NULL

PreferenceRank:
TINYINT UNSIGNED
NOT NULL

Primary Key:

{MemberID, SiteID}

Alternate Candidate Key:

{MemberID, PreferenceRank}

Constraints:

CHECK (PreferenceRank > 0)

UNIQUE (MemberID, PreferenceRank)

Foreign Keys:

MemberID -> FAMILY_MEMBER(MemberID)

SiteID -> VACATION_SITE(SiteID)

---

## SITE_ACTIVITY

SiteID:
INT UNSIGNED
NOT NULL

ActivityID:
INT UNSIGNED
NOT NULL

Primary Key:

{SiteID, ActivityID}

Foreign Keys:

SiteID -> VACATION_SITE(SiteID)

ActivityID -> ACTIVITY(ActivityID)

---

## MEMBER_ITEM

MemberID:
INT UNSIGNED
NOT NULL

ItemID:
INT UNSIGNED
NOT NULL

Quantity:
TINYINT UNSIGNED
NOT NULL

PackedStatus:
BOOLEAN
NOT NULL
DEFAULT FALSE

Primary Key:

{MemberID, ItemID}

Constraints:

CHECK (Quantity > 0)

Foreign Keys:

MemberID -> FAMILY_MEMBER(MemberID)

ItemID -> PACKING_ITEM(ItemID)

---

# 30. Constraint Strategy

PRIMARY KEY:
Enforces row identity.

FOREIGN KEY:
Enforces valid relationships between parent and child relations.

NOT NULL:
Used when the attribute must have a value.

UNIQUE:
Used for alternate candidate keys.

CHECK:
Used to enforce domain/business rules.

DEFAULT:
Used only when a reasonable default exists.

AUTO_INCREMENT:
Used for generated surrogate identifiers in the physical MySQL implementation.


# 31. Constraint Verification Results

The physical MySQL implementation was tested against valid and invalid operations.

## Test Results

### Test 1 - PRIMARY KEY

Attempt:
Insert a second FAMILY_MEMBER using MemberID 1.

Result:
Rejected.

MySQL Error:
Duplicate entry for family_member.PRIMARY.

Conclusion:
Primary-key uniqueness is enforced.

---

### Test 2 - NOT NULL

Attempt:
Insert a FAMILY_MEMBER with MemberName = NULL.

Result:
Rejected.

MySQL Error:
Column 'MemberName' cannot be null.

Conclusion:
Required descriptive data is protected.

---

### Test 3 - CHECK: SpookinessLevel

Attempt:
Insert SpookinessLevel = 9.

Allowed domain:

1 <= SpookinessLevel <= 5

Result:
Rejected by chk_spookiness_level.

Conclusion:
The destination rating domain is enforced.

---

### Test 4 - FOREIGN KEY

Attempt:
Insert FAMILY_SITE using MemberID 999.

Result:
Rejected by fk_family_site_member.

Conclusion:
A destination preference cannot reference a nonexistent family member.

---

### Test 5 - UNIQUE Alternate Candidate Key

Attempt:
Assign Alex Carter another destination with PreferenceRank = 1.

Result:
Rejected by uq_family_preference_rank.

Conclusion:

The alternate candidate key:

{MemberID, PreferenceRank}

is physically enforced using a UNIQUE constraint.

---

### Test 6 - CHECK: PreferenceRank

Attempt:
Insert PreferenceRank = 0.

Result:
Rejected by chk_preference_rank.

Conclusion:

PreferenceRank must satisfy:

PreferenceRank > 0

---

### Test 7 - CHECK: ItemCategory

Attempt:
Insert ItemCategory = 'Magic'.

Result:
Rejected by chk_item_category.

Conclusion:
Packing-item categories are restricted to the defined domain.

---

### Test 8 - CHECK: Quantity

Attempt:
Assign Quantity = 0.

Result:
Rejected by chk_member_item_quantity.

Conclusion:

Quantity must satisfy:

Quantity > 0

---

### Test 9 - DEFAULT

Attempt:
Insert a MEMBER_ITEM row without specifying PackedStatus.

Result:
Accepted.

Returned value:

PackedStatus = 0

Conclusion:
MySQL applied the DEFAULT FALSE rule successfully.

The temporary test row was deleted after verification.

---

### Test 10 - Referential Integrity on DELETE

Attempt:
Delete VACATION_SITE SiteID 1 while dependent FAMILY_SITE rows exist.

Result:
Rejected by fk_family_site_site.

Conclusion:
The parent destination cannot be deleted while child rows reference it.

---

# 32. Integrity Verification Summary

The implemented schema successfully enforced:

- PRIMARY KEY
- FOREIGN KEY
- NOT NULL
- UNIQUE
- CHECK
- DEFAULT
- referential integrity

All intentional invalid operations were rejected.

The valid DEFAULT-value test succeeded.

Therefore, the physical MySQL implementation behaves consistently with the logical business rules.

