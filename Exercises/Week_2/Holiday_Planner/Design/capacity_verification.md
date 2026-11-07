# Holiday Planner Capacity and Growth Verification

## Purpose

This document estimates how the HolidayPlanner schema would grow if it were used beyond the classroom sample.

The objective is to identify high-growth relations before performance problems occur.

---

# Baseline Assumptions

Assume:

- 6 family outings per year
- 4 family members
- average 4 activities per outing
- average 4 travel legs per outing
- average 1 accommodation record per overnight outing
- approximately 4 overnight outings per year
- packing definitions are mostly reusable and grow slowly

---

# Estimated Annual Row Growth

## Outing

6 outings/year

Growth:

6 rows/year

---

## OutingParticipant

6 outings × 4 family members

24 rows/year

---

## OutingActivity

6 outings × 4 activities

24 rows/year

---

## TravelLeg

6 outings × 4 travel legs

24 rows/year

---

## OutingAccommodation

Approximately 4 overnight outings/year

Estimated:

4 to 6 rows/year

---

# Slowly Growing Reference Tables

The following tables should grow much more slowly:

- FamilyMember
- TripType
- Location
- Activity
- TravelMode
- Accommodation
- PackingItem
- MemberTripPackingItem
- MemberTravelPackingItem
- ActivityPackingItem

These relations primarily store reusable definitions rather than trip history.

---

# Ten-Year Projection

Using the baseline assumptions:

Outing:

6 × 10 = 60 rows

OutingParticipant:

24 × 10 = 240 rows

OutingActivity:

24 × 10 = 240 rows

TravelLeg:

24 × 10 = 240 rows

OutingAccommodation:

approximately 40 to 60 rows

Even after ten years of normal family use, the database remains small.

---

# Large-Scale Thought Experiment

If the same schema supported 100,000 households instead of one family, the high-growth tables would become:

1. OutingParticipant
2. OutingActivity
3. TravelLeg
4. Outing
5. OutingAccommodation

These relations would require the closest monitoring for:

- index size
- query latency
- storage growth
- archival policy
- partitioning considerations
- historical-data retention

---

# Index Implications

The current schema already provides indexes through:

- primary keys
- unique constraints
- foreign-key support indexes

At family scale, additional indexing is unnecessary.

At large scale, indexes should be chosen from measured query patterns rather than added indiscriminately.

Possible future search indexes may include:

- Outing(start_date)
- Outing(outing_name)
- OutingActivity(activity_date)
- TravelLeg(departure_datetime)

These are not added during the current assignment because the sample workload does not justify them yet.

---

# Capacity Result

Family-scale capacity risk:

LOW

High-growth relations identified:

- OutingParticipant
- OutingActivity
- TravelLeg
- Outing
- OutingAccommodation

Current schema remains appropriate for the Module 2 workload.

Capacity Verification:

G = TRUE