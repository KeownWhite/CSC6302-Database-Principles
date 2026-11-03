# Paranormal Expedition Relationship Design

## Purpose

This document defines the relationships between the seven relations in the `ParanormalExpedition` database.

---

# 1. Location to Expedition

Relationship:

`Location 1:N Expedition`

Meaning:

One location may be associated with many expeditions.

Each expedition must be associated with one location.

Foreign key:

`Expedition.location_id`

references:

`Location.location_id`

Participation:

- Location side: optional
- Expedition side: required

A location may exist before any expedition has been scheduled there.

An expedition cannot exist without a valid location.

---

# 2. Expedition to Investigator

Logical relationship:

`Expedition M:N Investigator`

Meaning:

One expedition may include many investigators.

One investigator may participate in many expeditions.

This many-to-many relationship is resolved through:

`ExpeditionInvestigator`

Resulting relationships:

`Expedition 1:N ExpeditionInvestigator`

`Investigator 1:N ExpeditionInvestigator`

Foreign keys:

`ExpeditionInvestigator.expedition_id`

references:

`Expedition.expedition_id`

`ExpeditionInvestigator.investigator_id`

references:

`Investigator.investigator_id`

Composite primary key:

`{expedition_id, investigator_id}`

This prevents the same investigator from being assigned to the same expedition more than once.

---

# 3. Expedition to Equipment

Logical relationship:

`Expedition M:N Equipment`

Meaning:

One expedition may use many pieces of equipment.

One piece of equipment may be used across many expeditions over time.

This many-to-many relationship is resolved through:

`ExpeditionEquipment`

Resulting relationships:

`Expedition 1:N ExpeditionEquipment`

`Equipment 1:N ExpeditionEquipment`

Foreign keys:

`ExpeditionEquipment.expedition_id`

references:

`Expedition.expedition_id`

`ExpeditionEquipment.equipment_id`

references:

`Equipment.equipment_id`

Composite primary key:

`{expedition_id, equipment_id}`

This prevents the same equipment item from being assigned twice to the same expedition.

---

# 4. Expedition to Evidence

Relationship:

`Expedition 1:N Evidence`

Meaning:

One expedition may produce many evidence records.

Each evidence record must belong to one expedition.

Foreign key:

`Evidence.expedition_id`

references:

`Expedition.expedition_id`

Participation:

- Expedition side: optional
- Evidence side: required

An expedition may exist without evidence.

An evidence record cannot exist without an expedition.

---

# 5. Investigator to Evidence

Relationship:

`Investigator 1:N Evidence`

Meaning:

One investigator may record many evidence items.

Each evidence record must identify the investigator who recorded it.

Foreign key:

`Evidence.investigator_id`

references:

`Investigator.investigator_id`

Participation:

- Investigator side: optional
- Evidence side: required

An investigator may exist without recording evidence.

Each evidence record must identify an investigator.

---

# 6. Equipment to Evidence

Relationship:

`Equipment 1:N Evidence`

Meaning:

One equipment item may be associated with many evidence records over time.

An evidence record may optionally reference one equipment item.

Foreign key:

`Evidence.equipment_id`

references:

`Equipment.equipment_id`

Participation:

- Equipment side: optional
- Evidence side: optional

The equipment reference is optional because some evidence may be based on direct observation rather than a device.

---

# Relationship Summary

| Parent Relation | Child Relation | Cardinality | Foreign Key |
|---|---|---|---|
| Location | Expedition | 1:N | Expedition.location_id |
| Expedition | ExpeditionInvestigator | 1:N | ExpeditionInvestigator.expedition_id |
| Investigator | ExpeditionInvestigator | 1:N | ExpeditionInvestigator.investigator_id |
| Expedition | ExpeditionEquipment | 1:N | ExpeditionEquipment.expedition_id |
| Equipment | ExpeditionEquipment | 1:N | ExpeditionEquipment.equipment_id |
| Expedition | Evidence | 1:N | Evidence.expedition_id |
| Investigator | Evidence | 1:N | Evidence.investigator_id |
| Equipment | Evidence | 1:N | Evidence.equipment_id |

---

# Many-to-Many Resolution

Two many-to-many relationships exist in the logical design.

## Expedition and Investigator

Original relationship:

`Expedition M:N Investigator`

Resolved as:

`Expedition 1:N ExpeditionInvestigator N:1 Investigator`

---

## Expedition and Equipment

Original relationship:

`Expedition M:N Equipment`

Resolved as:

`Expedition 1:N ExpeditionEquipment N:1 Equipment`

---

# Foreign Key Dependency Order

Tables should be created in the following order:

1. Location
2. Investigator
3. Equipment
4. Expedition
5. ExpeditionInvestigator
6. ExpeditionEquipment
7. Evidence

This order ensures that referenced parent relations exist before foreign key constraints are created.

---

# ER Diagram Target

The final MySQL Workbench ER diagram should visually show:

`Location -> Expedition`

`Expedition -> ExpeditionInvestigator <- Investigator`

`Expedition -> ExpeditionEquipment <- Equipment`

`Expedition -> Evidence`

`Investigator -> Evidence`

`Equipment -> Evidence`

The junction relations should clearly display their composite primary keys and foreign key connections.

---

# Relationship Design Status

- One-to-many relationships defined
- Many-to-many relationships identified
- Junction relations defined
- Foreign keys mapped
- Composite primary keys confirmed
- Optional participation identified
- Required participation identified
- Table creation dependency order established
- Ready for SQL implementation
