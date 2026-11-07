# Module 2 Holiday Planner Extension Plan

## Starting Point

Module 2 expands the Module 1 family spooky vacation design into a generic holiday-planning database.

The existing Module 1 database remains unchanged as the original reference implementation.

The new database will be named:

HolidayPlanner

## Design Goal

The HolidayPlanner database must support:

- single-afternoon outings
- multi-activity day trips
- weekend trips
- week-long trips
- automobile travel
- airplane travel
- family demographic data
- outing participants
- reusable personal-item packing lists
- reusable suitcase packing lists
- activity-specific packing requirements
- outing locations
- ordered activities
- travel duration and price
- accommodation information

## Proposed Relations

### FamilyMember

Stores demographic information about each person in the family.

### TripType

Defines reusable trip categories such as:

- Single Afternoon
- Multi-Activity Day
- Weekend
- Week Long

### Location

Stores destinations that may be used by multiple outings.

### Outing

Represents one planned family trip or outing.

Each outing references one TripType and one Location.

Holiday-specific information is stored here because an outing may or may not be associated with a holiday.

### OutingParticipant

Resolves the many-to-many relationship between FamilyMember and Outing.

A family member may attend many outings, while one outing may contain several family members.

### Activity

Stores reusable activities such as hiking, apple picking, skiing, dining, or visiting a haunted attraction.

### OutingActivity

Associates activities with outings.

The relation also stores scheduling information so activities can occur in sequence and on different days.

Planned scheduling attributes include:

- activity date
- sequence number
- start time
- duration

This allows both a single afternoon activity and a multi-day itinerary to use the same relational structure.

### TravelMode

Stores reusable transportation modes.

Initial values include:

- Car
- Plane
- Train
- Bus
- Other

### Travel

Stores individual transportation legs for an outing.

Each travel leg references a TravelMode and records information such as:

- origin
- destination
- duration
- price

### Accommodation

Stores reusable lodging-property information such as hotels, cabins, resorts, and rental properties.

### OutingAccommodation

Associates an outing with an accommodation and stores booking-specific information such as check-in date, check-out date, nightly rate, and booking reference.

Short day trips do not require an OutingAccommodation record.

### PackingItem

Stores reusable item definitions.

Examples include:

- backpack
- phone charger
- clothing
- toothbrush
- gloves
- boots
- sunscreen
- water bottle

### MemberTripPackingItem

Defines the standard items a specific family member normally carries for a particular TripType.

This supports the requirement that each person generally brings the same items on a given type of trip.

The relation will also identify whether an item belongs in:

- Personal Item
- Suitcase

### MemberTravelPackingItem

Defines additional packing items associated with a family member and a transportation mode.

This relation supplements rather than replaces MemberTripPackingItem.

For example:

- Plane -> travel documents
- Plane -> carry-on charger
- Car -> road snacks
- Car -> vehicle emergency supplies

This separation prevents ordinary Weekend or Week Long packing rules from being repeated once for every transportation mode.

### ActivityPackingItem

Defines items required or recommended for a particular activity.

This allows the planner to automatically determine activity-specific equipment and supplies.

## Relationship Summary

FamilyMember M:N Outing
resolved through OutingParticipant

Outing N:1 TripType

Outing N:1 Location

Outing M:N Activity
resolved through OutingActivity

TravelMode 1:N Travel

Outing 1:N Travel

Outing M:N Accommodation
resolved through OutingAccommodation

FamilyMember M:N PackingItem for a TripType
resolved through MemberTripPackingItem

FamilyMember M:N PackingItem for a TravelMode
resolved through MemberTravelPackingItem

Activity M:N PackingItem
resolved through ActivityPackingItem

## Design Principles Taken From Course Examples

The design follows the same general relational pattern used in the professor's example databases:

1. Distinct concepts are represented by separate relations.
2. Many-to-many relationships are resolved through junction relations.
3. Foreign keys maintain referential integrity.
4. Foreign-key referential actions will be selected according to relationship lifecycle, data-history requirements, and MySQL constraint compatibility.
5. Surrogate numeric identifiers may be used where they provide a stable identifier.
6. Composite primary keys will be used for appropriate junction relations.
7. Nullable attributes will be used only when the value may legitimately not exist.
8. Sample tuples will be used to confirm that the design can represent each required outing type.

## Next Design Step

Define every attribute, domain, primary key, foreign key, nullability rule, and constraint for the fifteen proposed relations before writing SQL.