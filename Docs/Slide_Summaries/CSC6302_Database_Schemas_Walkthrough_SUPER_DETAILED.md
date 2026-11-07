# CSC 6302 — Database Principles
## Database Schemas: Step-by-Step Schema Design Walkthrough

**Source:** `Database Schemas-2.pdf`  
**Source length:** **4 pages**  
**Purpose:** Super-detailed study conversion preserving the complete walkthrough in source order while reorganizing it into a reusable schema-design workflow for the CSC6302 study chat.

> **Source-fidelity note:** This handout is an introductory design walkthrough. It explicitly says that separate handouts will contain the final ER diagrams and SQL database-creation scripts for the three examples. This conversion therefore does **not** invent completed ERDs, normalized schemas, key choices, data types, or SQL that are not present in the source.

---

# What This Handout Is Teaching

The document walks through the **thinking process that happens before SQL**.

Its basic sequence is:

```text
Choose a topic
      ↓
Identify relations
      ↓
Give relations unique names
      ↓
Identify attributes
      ↓
Add sample tuples
      ↓
Check whether the design can represent real data
      ↓
Define domains
      ↓
Check atomicity and NULL possibilities
      ↓
Write relation schemas
      ↓
Find superkeys
      ↓
Find candidate keys
      ↓
Choose primary keys
      ↓
Identify foreign-key constraints
      ↓
Build ER diagram / SQL in later handouts
```

The major lesson is that schema design is **iterative**. As soon as sample data reveals that the current relations cannot represent the real-world problem correctly, the design must change.

---

# Page 1 — Let's Create a Schema Walkthrough

## Purpose of the walkthrough

The handout says the class will follow the creation of **three different database schemas**.

Each example will eventually be:

1. designed,
2. described by an ER Diagram,
3. implemented as a SQL database.

The source also says that separate handouts will later provide:

- final ER diagrams,
- SQL database-creation scripts.

The databases will later be used to write SQL queries.

---

# Choose a Topic

The first design step is to choose:

> a topic with a lot of data and relationships that can be discussed.

Three example topics are introduced:

### 1. DnD Character Creation

### 2. Meal Planning

### 3. Family Schedule Planning

## Study interpretation

The topic should be rich enough to contain:

- multiple distinct things,
- attributes describing those things,
- relationships among them,
- rules or restrictions worth representing.

A trivial topic with only one table and no meaningful relationships would not teach much about relational design.

---

# What Relations Are Needed?

The source says:

> A relation is like an object, it should be a distinct thing that can be described.

This is the first major modeling decision.

Instead of immediately writing columns, first ask:

> **What distinct things exist in this problem domain?**

---

## DnD Character Creation Example

Possible relations:

- **Class**
- **Spell**
- **Weapon**

These are treated as separate objects because each represents a distinct concept with its own descriptive properties.

---

## Meal Planning Example

Possible relations:

- **Ingredient**
- **Recipe**

---

## Family Schedule Example

Possible relations:

- **Family Member**
- **Chore**
- **Location**

---

# Do All Relations Have a Unique Name?

The handout says this seems obvious, but relation names should be:

- unique,
- clear,
- descriptive of their exact purpose.

If names are ambiguous or duplicated:

- the schema becomes confusing,
- MySQL ultimately requires unique table names anyway.

## Design principle

A relation name should make its meaning obvious without needing additional explanation.

### Better
`FamilyMember`

### Worse
`Data1`

The first communicates the entity's purpose; the second does not.

---

# Page 1 Study Checklist

Before moving on:

- [ ] Is the topic rich enough to have multiple related data objects?
- [ ] Have the major real-world objects been identified?
- [ ] Is each object distinct enough to deserve a relation?
- [ ] Does every relation have a unique, descriptive name?
- [ ] Are relation names understandable without looking at the data?

---

# Page 2 — What Attributes Does Each Relation Need?

The handout emphasizes that brainstorming attributes is an important design step.

It also gives an important warning:

> As attributes are brainstormed, it may become clear that the design needs **more relations or fewer relations**.

That means attributes are not merely details added after the design is finished.

They can reveal flaws in the relation structure itself.

---

# Attribute Naming

Within a relation:

- attribute names should be distinct,
- names should clearly describe the value being stored.

However, the source notes that:

> different relations may have attributes with the same name.

For example:

```text
Spell.Name
Weapon.Name
Ingredient.Name
Recipe.Name
```

There is no problem with different tables each having a `Name` attribute, because the table context tells us what the name describes.

---

# DnD Character Creation Attributes

## Class

1. Name
2. Alignment
3. Type

## Spell

1. Name
2. Cost
3. Effect
4. Duration
5. Effective Distance

## Weapon

1. Name
2. Cost
3. Deals X Damage
4. Weight
5. How is it wielded?

---

# Meal Planning Attributes

## Ingredient

1. Name
2. Size
3. Type

## Recipe

1. Name
2. Serving Size
3. List of Ingredients
4. Cook Time
5. Difficulty Rating

---

# Family Planning / Family Schedule Attributes

## Family Member

1. First Name
2. Middle Name
3. Last Name
4. Birthday

## Chore

1. Name
2. Difficulty
3. Duration
4. Tools Needed
5. Frequency

The Chore list begins at the end of page 2 and continues onto page 3 in the source.

---

# Why Attribute Brainstorming Matters

The attribute list forces questions such as:

- Is the value really one thing?
- Should it be stored directly?
- Is the attribute actually describing another entity?
- Could one row need multiple values?
- Is the attribute name precise enough?
- Does it imply a relationship that is missing?

This becomes especially important on the next page when the design is tested using tuples.

---

# Page 2 Study Checklist

For every relation:

- [ ] What properties describe this entity?
- [ ] Does every attribute have a clear purpose?
- [ ] Are attribute names unique within the relation?
- [ ] Are any attributes suspiciously list-like?
- [ ] Does an attribute suggest another missing relation?
- [ ] Do any attributes need units or more precise meaning?
- [ ] Are two attributes with the same name actually representing the same kind of domain?

---

# Page 3 — Let's Add Some Tuples

The handout says:

> Adding data to your relations is a great way to ensure you are actually storing the data you intend to store.

This is a major schema-design technique.

A model that looks reasonable in abstract form may fail as soon as realistic rows are inserted.

---

# DnD Character Creation — Tuple Testing

The source raises two questions.

## Spell Duration

A spell's duration should be a:

**unit of Time**

Therefore the attribute/domain should reflect that semantic meaning.

The handout says this should influence how the attribute is typed later.

## Cost

A spell costs:

**mana**

A weapon costs:

**coin**

The handout asks:

> Should both attributes simply be named `Cost`?

It also asks:

> Should they have the same type?

## Study interpretation

The point is not that the source provides a final answer.

The point is that **similar labels do not guarantee the same meaning**.

A good domain model must distinguish semantic differences.

---

# Recipe Schema — The "List of Ingredients" Problem

The original Recipe relation included:

- Name
- Serving Size
- **List of Ingredients**
- Cook Time
- Difficulty Rating

Then the sample-data test reveals a problem.

The handout states:

> each attribute in a relation stores a distinct value.

Therefore:

> **We cannot store a list of ingredients in one attribute.**

The source calls this:

> a tricky fix

and says it will be revisited in a future example.

The immediate conclusion is:

> the current relation cannot represent the required data and **additional relations are needed**.

## Critical relational-design lesson

This is an early introduction to the idea of **atomic attributes** and the modeling of multi-valued relationships.

Conceptually, the problem looks like:

```text
Recipe
  ├─ Name
  ├─ ServingSize
  └─ Ingredients = [ingredient1, ingredient2, ingredient3]   ← problem
```

The handout does **not** provide the final corrected design here.

Therefore this conversion does not invent a junction table or completed normalized schema.

It only preserves the conclusion:

**more relations are required.**

---

# Family Schedule — Can the Model Represent Restrictions?

The handout asks:

> Do we have enough relations to know if a family member can complete a chore?

Examples:

- A child cannot drive.
- A parent cannot attend soccer practice.

Then it asks:

> How can we add more relations to better capture these restrictions?

Again, the handout is deliberately forcing the designer to notice that:

- entities alone may be insufficient,
- relationships and constraints matter,
- realistic tuples expose missing model structure.

---

# Schema Design Through Example Data

The broader pattern is:

```text
Propose a relation
      ↓
Add realistic tuples
      ↓
Ask whether the row structure can express reality
      ↓
If not:
    modify attributes
    and/or
    add/remove relations
```

This is why database design is iterative rather than one-pass.

---

# What Are the Domains of Each Attribute?

After the class is reasonably confident that the needed relations exist, the handout moves to:

**domains**

A domain describes the set/type/meaning of values that an attribute is allowed to hold.

The source deliberately says to think about the **data itself first**, before forcing it into a programming/database type.

The sequence is:

```text
What does the value mean?
        ↓
What values are valid?
        ↓
Only then choose an implementation type
```

---

# Domain Questions

The handout asks:

### 1. Are the domains atomic?

Could any domain contain more than one value?

If so, the attribute or relation design may need revision.

### 2. Do existing attributes/domains need to be changed to make them atomic?

The Recipe/ingredient-list problem is the obvious example.

### 3. Can any attributes be NULL?

The handout distinguishes two different ideas:

- the value is **unknown**
- the value **does not exist / is not applicable**

Then asks:

> How would we handle these two unique cases?

The source does not give the final SQL solution here.

The design goal is to recognize that NULL semantics must be considered intentionally.

---

# Page 3 Study Checklist

- [ ] Insert sample tuples before declaring the design finished.
- [ ] Does every attribute hold one atomic value?
- [ ] Are units/semantics clear?
- [ ] Do similarly named attributes actually share the same domain?
- [ ] Does any field contain a list?
- [ ] Does realistic data reveal missing relations?
- [ ] Can the model represent real-world restrictions?
- [ ] What is the conceptual domain of each attribute?
- [ ] Can each attribute be NULL?
- [ ] If NULL is possible, does it mean unknown or not applicable?

---

# Page 4 — Relation Schemas, Keys, and Foreign Keys

The final page transitions from:

**conceptual entities/attributes**

to:

**formal relation schemas and constraints**.

---

# What Are the Relation Schemas?

The source gives the general notation:

```text
RelationName(
    Attribute1Name Attribute1Domain,
    Attribute2Name Attribute2Domain,
    ...
)
```

A relation schema therefore records:

- relation name,
- attribute names,
- attribute domains.

---

# What Are the Superkeys?

The handout asks:

> What values of the tuple are needed to uniquely identify the tuple?

A **superkey** is an attribute set sufficient to uniquely identify a tuple.

The handout also reminds the student to consider:

> redundant superkeys

because key design may later change as requirements or data become clearer.

## Study example

If `StudentID` uniquely identifies a Student:

```text
{StudentID}
```

is a superkey.

So are larger combinations that still include a unique identifier, for example:

```text
{StudentID, LastName}
```

But the larger combination may be redundant.

> This example is a study illustration; it is not one of the handout's three completed schemas.

---

# What Are the Candidate Keys?

The handout defines candidate keys as:

> the **minimal superkeys**

Meaning:

- they still uniquely identify a tuple,
- no unnecessary attribute can be removed while preserving uniqueness.

There may be:

**more than one candidate key**

for a relation.

---

# What Is the Primary Key?

The handout says the primary key should be:

> the candidate key we think is going to best suit our needs

The source also emphasizes that the chosen key:

> could change as we design and develop.

This is why the process begins broadly with superkeys and then narrows down.

---

# Key-Selection Workflow

```text
Find attribute combinations that uniquely identify rows
                  ↓
               Superkeys
                  ↓
Remove redundant attributes
                  ↓
            Candidate Keys
                  ↓
Choose the best candidate for the design
                  ↓
             Primary Key
```

---

# Underline Primary Keys in Relation Schema Definitions

The handout instructs:

> Let's underline our primary keys in our relation schema definitions.

This matches the relational-schema notation used in class where key attributes are visually distinguished.

---

# What Are the Foreign-Key Constraints?

The final design step in this handout is identifying:

**referential relationships between relations**

The source says that in the referencing table the designer looks at attributes/keys and draws an arrow toward the attribute being referenced.

The important rule is:

> referential integrity constraints must be understood and applied.

---

# Referencing vs Referenced Relations

Conceptually:

```text
Referencing relation
      Foreign Key
          |
          v
Referenced relation
      Key value
```

The source notes that a primary key does not necessarily have to be used in every theoretical referencing situation, but:

> most languages are going to require this

The main course idea is that foreign keys connect relations while preserving valid references.

---

# Complete Schema-Design Workflow From the Handout

## Phase 1 — Define the domain problem

- [ ] Choose a topic with meaningful data and relationships.

## Phase 2 — Identify relations

- [ ] What distinct things exist?
- [ ] Does each deserve its own relation?
- [ ] Does every relation have a unique name?

## Phase 3 — Identify attributes

- [ ] What properties describe each relation?
- [ ] Are names clear?
- [ ] Does an attribute expose a missing relation?

## Phase 4 — Test with tuples

- [ ] Add realistic sample data.
- [ ] Can every real-world value be represented?
- [ ] Are there list-valued fields?
- [ ] Are restrictions/relationships representable?

## Phase 5 — Define domains

- [ ] What does each value mean?
- [ ] What values are valid?
- [ ] Are the values atomic?
- [ ] Can the attribute be NULL?
- [ ] What would NULL mean?

## Phase 6 — Formalize relation schemas

```text
RelationName(Attribute Domain, ...)
```

## Phase 7 — Determine keys

- [ ] Enumerate superkeys.
- [ ] Identify candidate keys.
- [ ] Choose a primary key.
- [ ] Underline the primary key in schema notation.

## Phase 8 — Determine foreign-key constraints

- [ ] Which relations reference others?
- [ ] Which attributes form the references?
- [ ] Does each foreign key preserve referential integrity?

## Phase 9 — Later handouts

According to the source, subsequent materials will provide:

- final ER diagrams,
- SQL creation scripts.

---

# Three Example Domains From the Handout

# 1. DnD Character Creation

## Initial relations

### Class
- Name
- Alignment
- Type

### Spell
- Name
- Cost
- Effect
- Duration
- Effective Distance

### Weapon
- Name
- Cost
- Deals X Damage
- Weight
- How is it wielded?

## Design questions exposed by tuple testing

- Should Spell.Duration have a Time domain?
- Spell.Cost means mana.
- Weapon.Cost means coin.
- Should those two attributes share a name?
- Should they share a type/domain?

---

# 2. Meal Planning

## Initial relations

### Ingredient
- Name
- Size
- Type

### Recipe
- Name
- Serving Size
- List of Ingredients
- Cook Time
- Difficulty Rating

## Major design problem

`List of Ingredients` is not atomic.

The handout concludes:

> additional relations are required

but intentionally leaves the final corrected design for a later example/handout.

---

# 3. Family Schedule Planning

## Initial relations

### Family Member
- First Name
- Middle Name
- Last Name
- Birthday

### Chore
- Name
- Difficulty
- Duration
- Tools Needed
- Frequency

### Location
Listed as an initial relation on page 1, but this handout does not provide its attribute list.

## Design questions exposed by tuple testing

How can the database know whether a particular family member can perform a particular activity/chore?

Examples:
- child cannot drive
- parent cannot attend soccer practice

The handout asks students to consider:

**additional relations** to capture these restrictions.

---

# High-Value CSC6302 Study Facts

1. Schema design begins before SQL.
2. A topic should contain meaningful data and relationships.
3. A relation should represent a distinct describable thing.
4. Relation names should be unique and descriptive.
5. Attribute brainstorming may reveal that more or fewer relations are needed.
6. Attribute names must be distinct within a relation.
7. Different relations may use the same attribute name.
8. Sample tuples are a design-validation tool.
9. Realistic data can expose flaws in an abstract schema.
10. A domain should be considered conceptually before selecting a database data type.
11. Attributes should be atomic.
12. A list inside one attribute is a warning sign for relational design.
13. The Recipe `List of Ingredients` attribute cannot correctly store multiple distinct ingredient values under the handout's relational rules.
14. The handout therefore concludes that additional relations are needed for the Recipe example.
15. A schema must be able to represent real-world restrictions and relationships.
16. NULL should be considered explicitly during design.
17. The handout distinguishes an unknown value from a value that simply does not exist/apply.
18. A relation schema contains relation name, attribute names, and domains.
19. A superkey uniquely identifies a tuple.
20. Superkeys may contain redundant attributes.
21. A candidate key is a minimal superkey.
22. A relation may have multiple candidate keys.
23. The primary key is selected from the candidate keys.
24. Primary-key choice may change as requirements/design evolve.
25. Primary keys should be underlined in the course's relation-schema notation.
26. Foreign keys create references between relations.
27. Referential integrity must be understood and enforced.
28. The source's schema-design process is iterative.
29. DnD, Meal Planning, and Family Schedule are the three example domains.
30. This four-page handout does **not** contain the final ER diagrams or SQL creation scripts; those are described as separate handouts.

---

# Source-Fidelity Warnings

## 1. No final schemas are supplied

The handout asks the student to determine:

- domains,
- superkeys,
- candidate keys,
- primary keys,
- foreign keys.

It does **not** give the completed answers.

Therefore a study summary should not pretend that final keys or schemas were provided.

---

## 2. No ER diagrams are embedded in these four pages

The introductory paragraph says the schemas will be:

- described by ER diagrams,
- implemented as SQL databases,

and that separate handouts will provide the final ERDs/scripts.

This document itself is the **walkthrough**, not the final solution set.

---

## 3. `Location` is listed but not developed

The Family Schedule example initially lists:

- Family Member
- Chore
- Location

but later attribute brainstorming in this handout only develops Family Member and Chore.

The source does not provide Location attributes here.

---

# Complete Visual Inventory

## Page 1
- Header: `CSC6302: Database Principles`
- Large heading: `Let's Create a Schema Walkthrough`
- Introductory paragraph describing three schemas, ER diagrams, SQL databases, and later handouts
- Section: `Choose a Topic`
- Section: `What Relations are Needed?`
- Section: `Do all Relations have a unique name?`
- Text-only black-and-white handout layout
- No diagram, table, or image

## Page 2
- Header: `CSC6302: Database Principles`
- Large heading: `What Attributes Does Each Relation Need?`
- Nested bullet lists for:
  - DnD Character Creation
  - Meal Planning
  - Family Planning
- Family Member and Chore attribute lists begin
- Text-only page
- No ER diagram or image

## Page 3
- Continuation of Chore attributes:
  - Difficulty
  - Duration
  - Tools Needed
  - Frequency
- Large heading: `Let's add some tuples`
- DnD tuple/domain questions
- Recipe list-of-ingredients atomicity problem
- Family scheduling/restriction questions
- Large heading: `What are the domains of each attribute?`
- Atomicity and NULL questions
- Text-only page

## Page 4
- Heading: `What are the relation schemas for our relations`
- General relation-schema notation
- Questions about:
  - superkeys
  - redundant superkeys
  - candidate keys
  - primary keys
- Instruction to underline primary keys
- Heading: `What are the foreign key constraints for our relations?`
- Referential-integrity discussion
- Text-only page

---

# One-Page Memory Version

```text
CSC6302 SCHEMA DESIGN

1. Pick a topic with meaningful relationships.
2. Identify distinct entities → relations.
3. Give each relation a unique, descriptive name.
4. Brainstorm attributes.
5. Add sample tuples.
6. Let sample data expose bad modeling.
7. Define conceptual domains before SQL types.
8. Make attributes atomic.
9. Decide NULL possibilities/meaning.
10. Write relation schemas.
11. Find all superkeys.
12. Reduce to candidate keys.
13. Pick primary key.
14. Identify foreign keys.
15. Enforce referential integrity.
16. Draw ERD / create SQL later.

KEY IDEA:
Schema design is iterative.

WARNING SIGNS:
- list stored in one attribute
- vague relation name
- unclear domain/unit
- same label with different semantics
- inability to represent restrictions
- no unique key
- foreign reference without valid target
```

---

# End of CSC6302 Database Schemas Super-Detailed Conversion

All **4 source pages** are represented above in source order. The conversion preserves the DnD Character Creation, Meal Planning, and Family Schedule examples; the relation/attribute/tuple/domain workflow; atomicity and NULL questions; superkey/candidate-key/primary-key process; foreign-key constraints; and the source's explicit statement that final ER diagrams and SQL scripts are supplied separately.
