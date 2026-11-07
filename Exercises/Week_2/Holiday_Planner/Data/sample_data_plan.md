# Holiday Planner Scenario and Tuple Verification

## Purpose

This document tests the proposed HolidayPlanner schema with realistic sample scenarios before SQL implementation.

The goal is to determine whether the current relations can represent the required real-world situations without forcing unrelated information, storing lists inside attributes, duplicating facts, or losing important distinctions.

A failed scenario requires the relational design to be revised before mathematical verification begins.

---

# Scenario 1 - Single-Afternoon Pumpkin Picking

## Outing

Name: Fall Pumpkin Picking
Trip Type: Single Afternoon
Holiday: NULL
Start Date: 2026-10-10
End Date: 2026-10-10

Primary Location:

Sunny Acres Farm

## Participants

- Adult 1
- Adult 2
- Child 1

## Activities

2026-10-10

1. Pumpkin Picking
2. Farm Market

## Travel

Outbound:

Car
Home -> Sunny Acres Farm

Return:

Car
Sunny Acres Farm -> Home

## Accommodation

None.

## Packing

Personal items:

- phone
- wallet
- water bottle
- snacks

Activity-specific items:

- boots
- gloves

## Verification

PASS

The current schema supports:

- same-day outings
- multiple participants
- several ordered activities
- automobile travel
- no accommodation
- standard packing
- activity-specific packing

---

# Scenario 2 - Multi-Activity Halloween Day

## Outing

Name: Halloween Adventure Day
Trip Type: Multi-Activity Day
Holiday: Halloween
Start Date: 2026-10-31
End Date: 2026-10-31

## Activities

2026-10-31

1. Apple Picking
2. Corn Maze
3. Haunted House
4. Dinner

The activities occur at different locations.

## Travel

Multiple car travel legs are required between venues.

## Accommodation

None.

## Verification

PASS

OutingActivity supports:

- multiple activities on one date
- sequence numbers
- different locations
- different start times
- individual planned durations

TravelLeg supports multiple transportation segments.

---

# Scenario 3 - Weekend Driving Trip

## Outing

Name: Winter Mountain Weekend
Trip Type: Weekend
Start Date: 2027-01-15
End Date: 2027-01-17

## Travel

Car

Home -> Mountain Resort

Mountain Resort -> Home

## Accommodation

Mountain Lodge

Check In: 2027-01-15
Check Out: 2027-01-17

## Activities

Friday:
1. Dinner

Saturday:
1. Skiing
2. Hot Tub
3. Dinner

Sunday:
1. Snowshoeing
2. Lunch

## Packing

Personal Item:

- phone
- wallet
- medication
- charger

Suitcase:

- clothing
- toiletries
- sleepwear

Activity-specific:

- gloves
- ski goggles
- winter boots

## Verification

PASS

The current schema supports:

- a multi-day outing
- multiple activity days
- reusable lodging
- booking-specific accommodation data
- suitcase packing
- personal-item packing
- activity equipment

---

# Scenario 4 - Weekend Flying Trip

## Outing

Name: Boston Holiday Weekend
Trip Type: Weekend
Start Date: 2026-12-18
End Date: 2026-12-20

## Travel Legs

1. Car: Home -> Airport
2. Plane: Origin Airport -> Destination Airport
3. Other: Destination Airport -> Hotel
4. Other: Hotel -> Destination Airport
5. Plane: Destination Airport -> Origin Airport
6. Car: Airport -> Home

## Accommodation

Hotel

## Packing Observation

This scenario exposes a design limitation.

The current MemberTripPackingItem relation identifies reusable packing rules using:

{member_id, trip_type_id, item_id}

This means a person's standard Weekend packing list is identical whether the Weekend outing uses:

Car

or:

Plane

The assignment requires the model to distinguish driving and flying trips.

A reusable packing rule may therefore need to consider transportation mode in addition to trip duration/type.

## Verification

FAIL - DESIGN REVISION REQUIRED

---

# Scenario 5 - Week-Long Driving Vacation

## Outing

Name: Adirondack Summer Week
Trip Type: Week Long
Start Date: 2027-07-11
End Date: 2027-07-17

## Travel

Car

Several travel legs occur during the week.

## Accommodation

Cabin for first four nights.

Hotel for final two nights.

## Activities

Activities occur on multiple dates and include:

- hiking
- kayaking
- sightseeing
- swimming
- dining

## Verification

PASS

The schema supports:

- week-long duration
- multiple accommodations
- several activity days
- repeated transportation legs
- multiple activities
- suitcase and personal-item packing

---

# Scenario 6 - Week-Long Flying Holiday

## Outing

Name: Christmas City Vacation
Trip Type: Week Long
Holiday: Christmas
Start Date: 2027-12-20
End Date: 2027-12-27

## Travel

Combination of:

- Car
- Plane
- Train
- Other local transportation

## Accommodation

Two hotels.

## Activities

One or more activities occur on most days.

Some activities may repeat on different dates.

## Packing

Requires:

- standard week-long luggage
- personal carry items
- flight-specific items
- activity-specific equipment

## Verification

FAIL FOR SAME PACKING-MODE REASON AS SCENARIO 4

The itinerary, activity, accommodation, participant, and travel structures work.

The reusable packing model needs to distinguish transportation mode.

---

# Atomicity Verification

No proposed attribute requires a list of values.

Multiple:

- participants
- activities
- travel legs
- accommodations
- packing items

are represented through separate rows and relations rather than comma-separated or list-valued attributes.

Result:

PASS

---

# NULL Verification

Legitimate NULL cases include:

- FamilyMember.middle_name
- Outing.holiday_name
- Activity.default_duration_minutes
- TravelLeg.departure_datetime
- Accommodation.phone
- Accommodation.website
- OutingAccommodation.booking_reference

NULL is not used for required identifiers or required relationships.

Result:

PASS

---

# Derived-Value Verification

Values that can be derived reliably are intentionally not stored where unnecessary.

Examples:

Age is derived from birth_date.

Travel arrival time may be derived from departure time plus planned duration.

Total accommodation cost may be derived from number of nights multiplied by nightly rate.

Result:

PASS

---

# Relationship Verification

The following required structures are successfully represented:

FamilyMember M:N Outing

Outing M:N Activity occurrences

Outing 1:N TravelLeg

Outing M:N Accommodation

FamilyMember reusable packing rules

Activity-specific packing rules

Result:

PARTIAL PASS

The packing relationship requires additional transportation-mode context.

---

# Design Defect Found

## Problem

MemberTripPackingItem currently uses:

{member_id, trip_type_id, item_id}

This cannot distinguish:

Weekend + Car

from:

Weekend + Plane

or:

Week Long + Car

from:

Week Long + Plane

## Required Revision

Introduce a reusable TravelMode relation.

Proposed relation:

TravelMode(
    travel_mode_id,
    travel_mode_name,
    description
)

TravelLeg should reference TravelMode instead of storing travel_mode text directly.

MemberTripPackingItem should also include travel_mode_id.

Revised packing relationship:

FamilyMember
+
TripType
+
TravelMode
+
PackingItem

This permits standard reusable packing rules such as:

Member A + Weekend + Car + Cooler

Member A + Weekend + Plane + Travel Documents

Member A + Week Long + Plane + Carry-On Charger

---

# Scenario Verification Result

Let:

S1 = Single-Afternoon Scenario

S2 = Multi-Activity Day Scenario

S3 = Weekend Driving Scenario

S4 = Weekend Flying Scenario

S5 = Week-Long Driving Scenario

S6 = Week-Long Flying Scenario

Current results:

S1 = TRUE

S2 = TRUE

S3 = TRUE

S4 = FALSE

S5 = TRUE

S6 = FALSE

Overall scenario verification requires:

S = S1 ∧ S2 ∧ S3 ∧ S4 ∧ S5 ∧ S6

Therefore:

S = TRUE ∧ TRUE ∧ TRUE ∧ FALSE ∧ TRUE ∧ FALSE

S = FALSE

The current schema is NOT approved for mathematical verification or SQL implementation.

The TravelMode/packing design must be revised first.
---

# Design Revision 1 - Travel-Aware Packing

## Original Failure

The initial scenario test identified that MemberTripPackingItem could distinguish packing requirements by TripType but could not represent additional requirements created specifically by the transportation method.

Weekend + Car and Weekend + Plane therefore lacked a clean way to represent different travel-specific items.

The original proposed correction was to add TravelMode directly to MemberTripPackingItem.

That approach was rejected during further normalization review because it would require the same base TripType packing facts to be repeated for every transportation mode.

Example of undesirable duplication:

Member A + Weekend + Car + Toothbrush

Member A + Weekend + Plane + Toothbrush

Member A + Weekend + Train + Toothbrush

The fact that a toothbrush belongs in Member A's Weekend packing list is independent of transportation mode.

---

# Revised Solution

Two independent packing dimensions are maintained.

## MemberTripPackingItem

Represents items required because of trip type.

Examples:

Weekend:
- toothbrush
- clothing
- medication

Week Long:
- additional clothing
- toiletries
- sleepwear

## MemberTravelPackingItem

Represents additional items required because of transportation mode.

Examples:

Plane:
- travel documents
- carry-on charger

Car:
- road snacks
- cooler

## ActivityPackingItem

Represents requirements caused by selected activities.

Examples:

Skiing:
- gloves
- ski goggles

Hiking:
- hiking boots
- water bottle

---

# TravelMode Relation

Transportation mode is now represented through:

TravelMode(
    travel_mode_id,
    travel_mode_name,
    description
)

TravelLeg references TravelMode rather than storing transportation mode as unrestricted text.

This provides one controlled domain for transportation values and allows the same modes to be reused by packing rules.

---

# Post-Revision Scenario Verification

## Scenario 1 - Single-Afternoon Pumpkin Picking

Trip packing:
Single Afternoon rules

Travel packing:
Car rules

Activity packing:
Pumpkin Picking rules

Result:

PASS

---

## Scenario 2 - Multi-Activity Halloween Day

Trip packing:
Multi-Activity Day rules

Travel packing:
Car rules

Activity packing:
Apple Picking + Corn Maze + Haunted House + Dinner rules

Result:

PASS

---

## Scenario 3 - Weekend Driving Trip

Trip packing:
Weekend rules

Travel packing:
Car rules

Activity packing:
Skiing + Snowshoeing + other activity rules

Result:

PASS

---

## Scenario 4 - Weekend Flying Trip

Trip packing:
Weekend rules

Travel packing:
Plane rules

Activity packing:
Selected activity rules

Result:

PASS

The previous transportation-specific packing limitation has been removed.

---

## Scenario 5 - Week-Long Driving Vacation

Trip packing:
Week Long rules

Travel packing:
Car rules

Activity packing:
Selected activity rules

Result:

PASS

---

## Scenario 6 - Week-Long Flying Holiday

Trip packing:
Week Long rules

Travel packing:
Plane rules

Activity packing:
Selected activity rules

Result:

PASS

The previous transportation-specific packing limitation has been removed.

---

# Revised Scenario Mathematics

S1 = TRUE

S2 = TRUE

S3 = TRUE

S4 = TRUE

S5 = TRUE

S6 = TRUE

Therefore:

S = S1 ∧ S2 ∧ S3 ∧ S4 ∧ S5 ∧ S6

S = TRUE ∧ TRUE ∧ TRUE ∧ TRUE ∧ TRUE ∧ TRUE

S = TRUE

---

# Scenario Gate Result

Scenario Verification:

S = TRUE

The revised fifteen-relation design may now proceed to mathematical verification.

SQL implementation remains prohibited until the mathematical and anomaly verification stages also pass.
