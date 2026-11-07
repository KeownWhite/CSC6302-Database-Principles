# Holiday Planner Mathematical Verification

## Purpose

This document verifies the fifteen-relation HolidayPlanner design before SQL implementation.

The verification checks:

- functional dependencies
- attribute closure
- candidate-key minimality
- superkey counts
- alternate candidate keys
- composite-key minimality
- normalization
- insertion, update, and deletion anomaly risk
- foreign-key domain compatibility
- cross-relation integrity rules

The purpose is to prove the relational model before relying on MySQL execution as evidence of correctness.

---

# Verification Rules

For relation R and proposed candidate key K:

K⁺ = R

A candidate key must also be minimal:

∀ A ∈ K, (K - {A})⁺ ≠ R

For a relation containing n attributes and one candidate key containing k attributes:

N = 2^(n-k)

where N is the number of superkeys containing K.

For multiple candidate keys, inclusion-exclusion is used to avoid counting overlapping superkeys more than once.

For Boyce-Codd Normal Form:

∀ non-trivial X → Y, X must be a superkey.

---

# Summary

| Relation | n | Candidate Key Size(s) | Distinct Superkeys | BCNF |
|---|---:|---|---:|---|
| FamilyMember | 6 | 1 | 32 | PASS |
| TripType | 5 | 1, 1 | 24 | PASS |
| Location | 8 | 1 | 128 | PASS |
| Outing | 8 | 1 | 128 | PASS |
| OutingParticipant | 3 | 2 | 2 | PASS |
| Activity | 6 | 1, 1 | 48 | PASS |
| OutingActivity | 8 | 3 | 32 | PASS |
| TravelMode | 3 | 1, 1 | 6 | PASS |
| TravelLeg | 9 | 1, 2 | 320 | PASS |
| Accommodation | 6 | 1, 2 | 40 | PASS |
| OutingAccommodation | 6 | 3 | 8 | PASS |
| PackingItem | 4 | 1, 1 | 12 | PASS |
| MemberTripPackingItem | 5 | 3 | 4 | PASS |
| MemberTravelPackingItem | 5 | 3 | 4 | PASS |
| ActivityPackingItem | 4 | 2 | 4 | PASS |

The numerical sum across the independent relations is 792 superkeys.

This total is informational only. Superkeys belong to their individual relations and are not combined into one database-wide key space.

---

# 1. FamilyMember

R = {
member_id,
first_name,
middle_name,
last_name,
birth_date,
relationship_to_household
}

Principal functional dependency:

member_id →
first_name,
middle_name,
last_name,
birth_date,
relationship_to_household

Closure:

{member_id}⁺ = R

Minimality:

∅⁺ ≠ R

Therefore:

Candidate Key = {member_id}

Primary Key = {member_id}

Superkey calculation:

n = 6
k = 1

N = 2^(6-1)
N = 2^5
N = 32

No person's name or birth date is assumed unique.

BCNF:

PASS

---

# 2. TripType

R = {
trip_type_id,
trip_type_name,
min_days,
max_days,
description
}

Functional dependencies:

trip_type_id →
trip_type_name,
min_days,
max_days,
description

trip_type_name →
trip_type_id,
min_days,
max_days,
description

Closures:

{trip_type_id}⁺ = R

{trip_type_name}⁺ = R

Therefore:

K1 = {trip_type_id}

K2 = {trip_type_name}

Primary Key = {trip_type_id}

The numeric identifier is selected because descriptive labels may be edited without changing the identity of the type.

Superkey calculation:

|S(K1)| = 2^(5-1) = 16

|S(K2)| = 2^(5-1) = 16

The overlap must contain both candidate-key attributes:

|S(K1) ∩ S(K2)| = 2^(5-2) = 8

Therefore:

|S(K1) ∪ S(K2)| = 16 + 16 - 8

Distinct Superkeys = 24

BCNF:

PASS

---

# 3. Location

R = {
location_id,
location_name,
address_line1,
city,
state_province,
postal_code,
country,
location_type
}

Functional dependency:

location_id →
location_name,
address_line1,
city,
state_province,
postal_code,
country,
location_type

Closure:

{location_id}⁺ = R

Candidate Key = {location_id}

Primary Key = {location_id}

Descriptive location fields are not assumed globally unique.

n = 8
k = 1

N = 2^(8-1)
N = 128

BCNF:

PASS

---

# 4. Outing

R = {
outing_id,
outing_name,
trip_type_id,
primary_location_id,
holiday_name,
start_date,
end_date,
description
}

Functional dependency:

outing_id →
outing_name,
trip_type_id,
primary_location_id,
holiday_name,
start_date,
end_date,
description

Closure:

{outing_id}⁺ = R

Candidate Key = {outing_id}

Primary Key = {outing_id}

n = 8
k = 1

N = 2^7
N = 128

BCNF:

PASS

---

# 5. OutingParticipant

R = {
outing_id,
member_id,
attendance_status
}

Functional dependency:

{outing_id, member_id} → attendance_status

Closure:

{outing_id, member_id}⁺ = R

Minimality:

{outing_id}⁺ ≠ R

{member_id}⁺ ≠ R

Therefore:

Candidate Key = {outing_id, member_id}

Primary Key = {outing_id, member_id}

n = 3
k = 2

N = 2^(3-2)
N = 2

The two superkeys are characterized as:

{outing_id, member_id}

{outing_id, member_id, attendance_status}

BCNF:

PASS

---

# 6. Activity

R = {
activity_id,
activity_name,
activity_category,
default_duration_minutes,
min_participants,
description
}

Functional dependencies:

activity_id →
activity_name,
activity_category,
default_duration_minutes,
min_participants,
description

activity_name →
activity_id,
activity_category,
default_duration_minutes,
min_participants,
description

Therefore:

K1 = {activity_id}

K2 = {activity_name}

Primary Key = {activity_id}

Superkeys:

|S(K1)| = 2^5 = 32

|S(K2)| = 2^5 = 32

Overlap:

2^(6-2) = 16

Distinct Superkeys:

32 + 32 - 16 = 48

BCNF:

PASS

---

# 7. OutingActivity

R = {
outing_id,
activity_date,
sequence_number,
activity_id,
location_id,
start_time,
planned_duration_minutes,
notes
}

Functional dependency:

{outing_id, activity_date, sequence_number} →
activity_id,
location_id,
start_time,
planned_duration_minutes,
notes

Closure:

{outing_id, activity_date, sequence_number}⁺ = R

Minimality:

{outing_id, activity_date}⁺ ≠ R

{outing_id, sequence_number}⁺ ≠ R

{activity_date, sequence_number}⁺ ≠ R

Business assumption:

sequence_number restarts for each activity date within an outing.

Therefore all three key attributes are required.

Candidate Key:

{outing_id, activity_date, sequence_number}

Primary Key:

{outing_id, activity_date, sequence_number}

n = 8
k = 3

N = 2^(8-3)
N = 32

BCNF:

PASS

---

# 8. TravelMode

R = {
travel_mode_id,
travel_mode_name,
description
}

Functional dependencies:

travel_mode_id → travel_mode_name, description

travel_mode_name → travel_mode_id, description

Candidate keys:

K1 = {travel_mode_id}

K2 = {travel_mode_name}

Primary Key:

{travel_mode_id}

Superkeys:

|S(K1)| = 2^2 = 4

|S(K2)| = 2^2 = 4

Overlap:

2^(3-2) = 2

Distinct Superkeys:

4 + 4 - 2 = 6

BCNF:

PASS

---

# 9. TravelLeg

R = {
travel_leg_id,
outing_id,
sequence_number,
travel_mode_id,
from_location_id,
to_location_id,
departure_datetime,
planned_duration_minutes,
estimated_cost
}

Functional dependencies:

travel_leg_id →
outing_id,
sequence_number,
travel_mode_id,
from_location_id,
to_location_id,
departure_datetime,
planned_duration_minutes,
estimated_cost

{outing_id, sequence_number} →
travel_leg_id,
travel_mode_id,
from_location_id,
to_location_id,
departure_datetime,
planned_duration_minutes,
estimated_cost

Candidate keys:

K1 = {travel_leg_id}

K2 = {outing_id, sequence_number}

Primary Key:

{travel_leg_id}

Alternate key:

{outing_id, sequence_number}

Minimality of K2:

{outing_id}⁺ ≠ R

{sequence_number}⁺ ≠ R

Superkey calculation:

|S(K1)| = 2^(9-1) = 256

|S(K2)| = 2^(9-2) = 128

Their intersection must contain:

{travel_leg_id, outing_id, sequence_number}

Union-key size = 3

Overlap:

2^(9-3) = 64

Therefore:

Distinct Superkeys = 256 + 128 - 64

Distinct Superkeys = 320

BCNF:

PASS

---

# 10. Accommodation

R = {
accommodation_id,
accommodation_name,
location_id,
accommodation_type,
phone,
website
}

Functional dependencies:

accommodation_id →
accommodation_name,
location_id,
accommodation_type,
phone,
website

{accommodation_name, location_id} →
accommodation_id,
accommodation_type,
phone,
website

Candidate keys:

K1 = {accommodation_id}

K2 = {accommodation_name, location_id}

Primary Key:

{accommodation_id}

Minimality of K2:

{accommodation_name}⁺ ≠ R

{location_id}⁺ ≠ R

Superkeys:

|S(K1)| = 2^(6-1) = 32

|S(K2)| = 2^(6-2) = 16

Intersection requires:

{accommodation_id, accommodation_name, location_id}

Overlap:

2^(6-3) = 8

Distinct Superkeys:

32 + 16 - 8 = 40

BCNF:

PASS

---

# 11. OutingAccommodation

R = {
outing_id,
accommodation_id,
check_in_date,
check_out_date,
nightly_rate,
booking_reference
}

Functional dependency:

{outing_id, accommodation_id, check_in_date} →
check_out_date,
nightly_rate,
booking_reference

Closure:

{outing_id, accommodation_id, check_in_date}⁺ = R

Minimality:

{outing_id, accommodation_id}⁺ ≠ R

{outing_id, check_in_date}⁺ ≠ R

{accommodation_id, check_in_date}⁺ ≠ R

Therefore:

Candidate Key:

{outing_id, accommodation_id, check_in_date}

Primary Key:

{outing_id, accommodation_id, check_in_date}

n = 6
k = 3

N = 2^(6-3)
N = 8

BCNF:

PASS

---

# 12. PackingItem

R = {
item_id,
item_name,
item_category,
description
}

Functional dependencies:

item_id →
item_name,
item_category,
description

item_name →
item_id,
item_category,
description

Candidate keys:

K1 = {item_id}

K2 = {item_name}

Primary Key:

{item_id}

Superkeys:

|S(K1)| = 2^3 = 8

|S(K2)| = 2^3 = 8

Overlap:

2^(4-2) = 4

Distinct Superkeys:

8 + 8 - 4 = 12

BCNF:

PASS

---

# 13. MemberTripPackingItem

R = {
member_id,
trip_type_id,
item_id,
bag_type,
quantity
}

Functional dependency:

{member_id, trip_type_id, item_id} →
bag_type,
quantity

Closure:

{member_id, trip_type_id, item_id}⁺ = R

Minimality:

{member_id, trip_type_id}⁺ ≠ R

{member_id, item_id}⁺ ≠ R

{trip_type_id, item_id}⁺ ≠ R

Candidate Key:

{member_id, trip_type_id, item_id}

Primary Key:

{member_id, trip_type_id, item_id}

n = 5
k = 3

N = 2^(5-3)
N = 4

BCNF:

PASS

---

# 14. MemberTravelPackingItem

R = {
member_id,
travel_mode_id,
item_id,
bag_type,
quantity
}

Functional dependency:

{member_id, travel_mode_id, item_id} →
bag_type,
quantity

Closure:

{member_id, travel_mode_id, item_id}⁺ = R

Minimality:

{member_id, travel_mode_id}⁺ ≠ R

{member_id, item_id}⁺ ≠ R

{travel_mode_id, item_id}⁺ ≠ R

Candidate Key:

{member_id, travel_mode_id, item_id}

Primary Key:

{member_id, travel_mode_id, item_id}

n = 5
k = 3

N = 2^(5-3)
N = 4

BCNF:

PASS

---

# 15. ActivityPackingItem

R = {
activity_id,
item_id,
quantity,
requirement_level
}

Functional dependency:

{activity_id, item_id} →
quantity,
requirement_level

Closure:

{activity_id, item_id}⁺ = R

Minimality:

{activity_id}⁺ ≠ R

{item_id}⁺ ≠ R

Candidate Key:

{activity_id, item_id}

Primary Key:

{activity_id, item_id}

n = 4
k = 2

N = 2^(4-2)
N = 4

BCNF:

PASS

---

# Normalization Verification

## First Normal Form

Every relation contains atomic attributes.

No field contains:

- lists of participants
- lists of activities
- lists of travel legs
- lists of accommodations
- lists of packing items

1NF:

PASS

---

## Second Normal Form

Relations with single-attribute keys satisfy 2NF automatically.

For each composite-key relation, all non-key attributes depend on the entire candidate key.

Checked relations:

- OutingParticipant
- OutingActivity
- OutingAccommodation
- MemberTripPackingItem
- MemberTravelPackingItem
- ActivityPackingItem

No non-key attribute depends on only part of a composite candidate key under the stated business rules.

2NF:

PASS

---

## Third Normal Form

Descriptive facts about separate entities are stored in their own relations.

Examples:

TripType descriptions are not repeated in Outing.

Location details are not repeated in TravelLeg.

Accommodation details are not repeated in OutingAccommodation.

PackingItem descriptions are not repeated in packing junction relations.

TravelMode descriptions are not repeated in TravelLeg or transportation packing rules.

No identified non-key attribute determines another non-key attribute within the same relation.

3NF:

PASS

---

# Boyce-Codd Normal Form

For every identified non-trivial functional dependency:

X → Y

the determinant X is a candidate key or superkey of its relation.

Therefore:

FamilyMember ∈ BCNF

TripType ∈ BCNF

Location ∈ BCNF

Outing ∈ BCNF

OutingParticipant ∈ BCNF

Activity ∈ BCNF

OutingActivity ∈ BCNF

TravelMode ∈ BCNF

TravelLeg ∈ BCNF

Accommodation ∈ BCNF

OutingAccommodation ∈ BCNF

PackingItem ∈ BCNF

MemberTripPackingItem ∈ BCNF

MemberTravelPackingItem ∈ BCNF

ActivityPackingItem ∈ BCNF

Since:

BCNF ⇒ 3NF ⇒ 2NF ⇒ 1NF

the complete design satisfies the lower normal forms under the stated business assumptions.

---

# Anomaly Audit

## Insertion Anomalies

Separate entity relations allow:

- a FamilyMember to exist without an Outing
- an Activity to exist before being scheduled
- a Location to exist before an outing uses it
- an Accommodation to exist without a reservation
- a PackingItem to exist before a packing rule uses it
- a TravelMode to exist before a TravelLeg uses it

Result:

PASS

---

## Update Anomalies

Reusable facts are stored once.

Examples:

Changing a hotel phone number requires one Accommodation update.

Changing a packing-item description requires one PackingItem update.

Changing a transportation-mode description requires one TravelMode update.

Changing an Activity name requires one Activity update.

Result:

PASS

---

## Deletion Anomalies

Removing an association does not inherently remove its independent entity.

Examples:

Deleting an OutingActivity association does not require deleting Activity.

Deleting an OutingAccommodation association does not require deleting Accommodation.

Deleting a packing rule does not require deleting PackingItem.

Foreign-key deletion behavior must be selected carefully during SQL implementation so cascading actions match the intended lifecycle.

Result:

PASS AT DESIGN LEVEL

Implementation behavior remains to be tested.

---

# Foreign-Key Domain Audit

The SQL implementation must use identical compatible domains on each reference pair.

Required pairs include:

Outing.trip_type_id
→ TripType.trip_type_id

Outing.primary_location_id
→ Location.location_id

OutingParticipant.outing_id
→ Outing.outing_id

OutingParticipant.member_id
→ FamilyMember.member_id

OutingActivity.outing_id
→ Outing.outing_id

OutingActivity.activity_id
→ Activity.activity_id

OutingActivity.location_id
→ Location.location_id

TravelLeg.outing_id
→ Outing.outing_id

TravelLeg.travel_mode_id
→ TravelMode.travel_mode_id

TravelLeg.from_location_id
→ Location.location_id

TravelLeg.to_location_id
→ Location.location_id

Accommodation.location_id
→ Location.location_id

OutingAccommodation.outing_id
→ Outing.outing_id

OutingAccommodation.accommodation_id
→ Accommodation.accommodation_id

MemberTripPackingItem.member_id
→ FamilyMember.member_id

MemberTripPackingItem.trip_type_id
→ TripType.trip_type_id

MemberTripPackingItem.item_id
→ PackingItem.item_id

MemberTravelPackingItem.member_id
→ FamilyMember.member_id

MemberTravelPackingItem.travel_mode_id
→ TravelMode.travel_mode_id

MemberTravelPackingItem.item_id
→ PackingItem.item_id

ActivityPackingItem.activity_id
→ Activity.activity_id

ActivityPackingItem.item_id
→ PackingItem.item_id

Result:

PASS AT DESIGN LEVEL

Exact SQL domain matching remains an implementation requirement.

---

# Cross-Relation Integrity Rules

Normalization alone cannot enforce every business rule.

The implementation verification plan must test the following rules separately.

## Outing Duration

The number of days represented by:

Outing.start_date
through
Outing.end_date

should be compatible with the referenced TripType min_days and max_days.

Status:

REQUIRES IMPLEMENTATION VERIFICATION

---

## Scheduled Activity Date

OutingActivity.activity_date should fall between the parent Outing start_date and end_date.

Status:

REQUIRES IMPLEMENTATION VERIFICATION

---

## Accommodation Dates

OutingAccommodation check-in and check-out dates should be compatible with the parent Outing dates.

Status:

REQUIRES IMPLEMENTATION VERIFICATION

---

## Travel Timing

TravelLeg departure times should be reasonable relative to the associated Outing.

Status:

REQUIRES IMPLEMENTATION VERIFICATION

---

## Activity Participant Minimum

The confirmed participant count for an Outing should satisfy Activity.min_participants when that activity is scheduled.

Status:

REQUIRES QUERY OR APPLICATION-LEVEL VERIFICATION

---

# Pre-Implementation Verification Gate

Let:

M = Mathematical Verification

S = Scenario Verification

N = Normalization and Anomaly Verification

D = Constraint Design Verification

Current results:

M = TRUE

S = TRUE

N = TRUE

D = TRUE

Therefore:

P = M ∧ S ∧ N ∧ D

P = TRUE ∧ TRUE ∧ TRUE ∧ TRUE

P = TRUE

---

# Conclusion

The fifteen-relation HolidayPlanner schema passes the pre-implementation relational verification gate under the documented business assumptions.

The schema is approved to proceed to SQL implementation.

This approval does not mean implementation verification is complete.

After SQL creation, the database must still undergo:

- executable constraint testing
- referential-integrity testing
- duplicate-key testing
- NULL testing
- cascade testing
- reconciliation queries
- query-plan inspection
- transaction reasoning
- capacity review
- backup and restore testing

Mathematical correctness and implementation correctness remain separate verification layers.