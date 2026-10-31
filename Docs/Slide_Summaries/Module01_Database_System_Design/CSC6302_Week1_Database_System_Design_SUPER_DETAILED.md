# CSC 6302 - Database Principles

## Week 1 — Database System Design

**Instructor:** Wendy-Beth Minton  
**Source:** `Unit One_ Database System Design.pptx`  
**Source length:** 82 slides  
**Primary text referenced by deck:** *Database System Concepts*, 7th Edition, Silberschatz, Korth, and Sudarshan  
**Purpose:** Super-detailed study-chat conversion preserving slide order, course logistics, relational-model terminology, table/schema examples, ER diagrams, database architecture, DDL/DML/SQL syntax, transaction concepts, integrity constraints, assignments, and all significant visuals.

> **Source-fidelity rule:** This conversion follows the uploaded Week 1 deck. It preserves the instructor's wording, examples, policies, SQL examples, and course-specific claims. Study explanations are labeled separately and do not silently replace the source material.

---
# Slide-by-Slide Conversion

## Slide 1 — CSC6302 - Database Principles

### On-slide content

- Week 1 - Wendy-Beth Minton
- ‹#›


### Visual description

Minimal course-title slide with large blue CSC6302 / Database Principles text, Week 1 and instructor name Wendy-Beth Minton, plus Silberschatz/Korth/Sudarshan and *Database System Concepts – 7th Edition* attribution.


### Study interpretation

This establishes the Week 1 scope: database-system design, relational modeling, architecture, SQL, and integrity constraints.


---

## Slide 2 — Course Introduction

### On-slide content

- This course is entitled CSC6302 Database Principles
- In this course we will:
- Design relational database
  - Functional dependencies
  - Normal Forms
  - Normalizing Databases
- Learn the relational database language SQL
- Develop database applications using Java/Python
- Understand how data is stored within a relational database
- Leverage our knowledge of relational databases and their storage mechanisms to optimize how we write queries
- CSC 6302 - Week 1
- ‹#›


### Visual description

Text-only section-introduction slide headed Course Introduction.


---

## Slide 3 — Course Format

### On-slide content

- Weeks 1-8 of this course will have:
- Live Sessions
  - Every Tuesday from 6:30pm to 8:30pm
- Live Office Hours
  - Thursday 8:00pm to 9:00pm
  - By appointment
- Weeks 1-7 will have graded:
- Practice
- Online Quizzes
- Programing assignments
- Week 8 will have
- Graded final exam
- Communication:
- mintonw@merrimack.edu
- ‹#›


### Visual description

Text-only course-format slide listing weekly live sessions, office hours, graded work, and instructor contact information.


---

## Slide 4 — Course Format

### On-slide content

- Practice
  - Simple exercises
  - Design exercises
  - Will be tied to the programming assignment
  - Submitted via Canvas
- Quizzes
  - 10-15 questions
  - Autograded, and then adjusted up as needed
    - Multiple selection questions are auto graded poorly in Canvas
  - Open book, open notes
  - Submitted via Canvas
- Final exam
  - Questions from all eight units
  - 4 hours to complete after starting
  - Open book, open notes
  - Submitted via Canvas
- Attendance is optional, but strongly recommended!
- ‹#›
- Your WebCam is optional, but strongly recommended!


### Visual description

Text-only course-format slide describing practice, quizzes, the final exam, optional attendance, and optional webcam use.


---

## Slide 5 — Course Format

### On-slide content

- Practice and Programming Projects
  - All assignments may be done in Python or Java
    - Whichever you are comfortable with
    - README file for programming assignments is needed
      - Exact version of Python/Java you are using
      - Exact version of the OS you are using
      - Exact version of MySql you are using
  - All programming assignments must have a git repository
    - I must be added as a collaborator
    - A link to your repository must be submitted to canvas
      - Easier for me to find each person’s repository
      - Easier for you to see your grade on each assignment
  - Do not upload your code to Canvas
- I’m easy to find as a collaborator on github
  - mintonw@merrimack.edu
- Attendance is optional, but strongly recommended!
- ‹#›
- Your WebCam is optional, but strongly recommended!


### Visual description

Text-heavy programming-project policy slide covering Python/Java choice, README requirements, OS/MySQL versions, Git repository collaboration, and the instruction not to upload code directly to Canvas.


---

## Slide 6 — Evaluation

### On-slide content

- All task due dates are listed in Canvas.
  - Practice are Due Saturday night by 11:59 pm
  - Quiz is due Monday by 11:59 pm
  - Programming Assignments are due by Monday at 11:59 pm
- Late assignments receive a 5% penalty for each full day of delay.
  - If the deadlines are a struggle, given your personal circumstances, please reach out to me, and we can make adjustments as needed
- Final deadline on Sunday of the course's last week
- ‹#›

| Group | Weight |
| --- | --- |
| Practice | 10% |
| Projects | 60% |
| Quizzes | 10% |
| Final Exam | 20% |
| Total | 100% |


### Visual description

Evaluation slide with a four-row grading-weight table: Practice 10%, Projects 60%, Quizzes 10%, Final Exam 20%, totaling 100%.


### Study interpretation

Projects dominate the course grade at 60%, so the hands-on database work is the primary grading driver.


---

## Slide 7 — Evaluation

### On-slide content

- The final letter grade is computed according to this table:
- There are no grade D+, D, or D- in graduate courses.
- An average grade B is required to the Masters of Science in Computer Science.
- Final grades published after the course's end.

| A | A- | B+ | B | B- | C+ | C | C- | F |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 95 and up | 90 to 94.9 | 87 to 89.9 | 83 to 86.9 | 80 to 82.9 | 77 to 79.9 | 73 to 76.9 | 70 to 72.9 | 69.9 and low |

- ‹#›


### Visual description

Evaluation slide with a color-free letter-grade table ranging from A (95+) through F (69.9 and below), plus graduate-program grading notes.


---

## Slide 8 — Using AI, YES! However...

### On-slide content

- Documentation & Disclosure Requirements To maintain academic integrity, any use of Generative AI must be transparently documented. This is akin to citing your sources. The expectation of this course is that Generative AI use if limited to the following tasks:
- Explaining course concepts or errors
- Tutoring
- Understanding syntactic query elements
- Understanding python/java code elements
- Generating test data
- Ownership and Accountability While you may use AI to assist you, you must own your code. This entails the following:
- Technical Understanding: You must be able to explain, defend, and modify every line of code submitted.
- Functional Grading: If the submitted code does not run, it cannot be graded, regardless of whether AI was used to generate it.
- Human-Centric Design: Remember that documentation is for humans to understand the logic of the code; AI-generated documentation must still meet human standards for readability and specification.
- ‹#›


### Visual description

Text-only AI-use policy slide. It permits limited generative-AI support for concept/error explanations, tutoring, syntax/code understanding, and test-data generation, while emphasizing disclosure, code ownership, executability, and human-readable documentation.


### Study interpretation

AI is permitted as a learning assistant, but the student remains accountable for understanding, modifying, and running every submitted line.


---

## Slide 9 — Agenda

### On-slide content

- Discussion Topics:
- Databases and Database Applications
- The Relational Model
- Entity Relational Diagrams (ER Diagrams)
  - Database Table Design
- Database Systems
  - Database Architecture
  - Database Engine
- SQL - The Basics
  - Create Table
  - Insert
  - Update
  - Integrity Constraints
- ‹#›


### Visual description

Agenda slide listing the Week 1 database-system, relational-model, ER-diagram, architecture, engine, SQL, and integrity-constraint topics.


---

## Slide 10 — Recommended Reading

### On-slide content

- Chapter One: Introduction
- Chapter Two: Introduction to the Relational Model
  - 2.1-2.5
- Chapter Six: Database Design Using the E-R Model
  - 6.1-6.6
  - Note this chapter goes deeper into the E-R Model then necessary for this course
  - Please see the additional resources for the class on making E-R Models in MySQL Workbench
- Chapter Three: Introduction to SQL
  - 3.1-3.2
- 3.9
- Slides adapted for CSC6202: Database Principles from:


### Visual description

Recommended-reading slide listing textbook chapters/sections. A small image of the *Database System Concepts* textbook appears at lower-right, with attribution to Silberschatz, Korth, and Sudarshan.


---

## Slide 11 — Database Systems

### On-slide content

- CSC 6302 - Week 1
- "The entire information content of the database is represented in one and only one way—namely, as explicit values in column positions in rows in tables."
- — C.J. Date, An Introduction to Database Systems
- A database is a collection of interrelated data.
- A database system is a collection of interrelated data, and the programs needed to access that data.


### Visual description

Section-divider slide titled Database Systems with a C. J. Date quote about representing database information as explicit values in rows and columns.


---

## Slide 12 — Database Management System

### On-slide content

- DBMS contains information about a particular enterprise
  - Collection of interrelated data
  - Set of programs to access the data
  - An environment that is both convenient and efficient to use
- Database systems are used to manage collections of data that are:
  - Highly valuable
  - Relatively large
  - Accessed by multiple users and applications, often at the same time.
- A modern database system is a complex software system whose task is to manage a large, complex collection of data.
- Databases touch all aspects of our lives


### Visual description

Text-only DBMS definition slide describing interrelated data, access programs, multi-user access, scale, and convenience/efficiency.


---

## Slide 13 — Database Application Examples

### On-slide content

- Enterprise Information
  - Sales: customers, products, purchases
  - Accounting: payments, receipts, assets
  - Human Resources: Information about employees, salaries, payroll taxes.
- Manufacturing: management of production, inventory, orders, supply chain.
- Banking and finance
  - customer information, accounts, loans, and banking transactions.
  - Credit card transactions
  - Finance: sales and purchases of financial instruments (e.g., stocks and bonds; storing real-time market data
- Universities: registration, grades


### Visual description

Text-only list of enterprise, banking, finance, manufacturing, and university database applications.


---

## Slide 14 — Database Application Examples

### On-slide content

- Airlines: reservations, schedules
- Telecommunication: records of calls, texts, and data usage, generating monthly bills, maintaining balances on prepaid calling cards
- Web-based services
  - Online retailers: order tracking, customized recommendations
  - Online advertisements
- Document databases
- Navigation systems: For maintaining the locations of various places of interest along with the exact routes of roads, train systems, buses, etc.
- Medical Record Systems
- Social Media Sites
- Video Games (or any application) with customization options


### Visual description

Text-only continuation listing airline, telecom, online retail, advertising, document, navigation, medical-record, social-media, and game/application databases.


---

## Slide 15 — Purpose of Database Systems

### On-slide content

- In the early days, database applications were built directly on top of file systems, which leads to:
- Data redundancy and inconsistency: data is stored in multiple file formats resulting in duplication of information in different files
- Difficulty in accessing data
  - Need to write a new program to carry out each new task
- Data isolation
  - Multiple files and formats
- Integrity problems
  - Integrity constraints (e.g., account balance > 0) become “buried” in program code rather than being stated explicitly
  - Hard to add new constraints or change existing ones


### Visual description

Text-only slide listing file-system-era problems: redundancy, inconsistency, difficult access, isolation, and buried integrity constraints.


### Study interpretation

This slide motivates DBMSs by contrasting them with direct file-system programming, where redundancy, isolation, and buried constraints become maintenance problems.


---

## Slide 16 — Purpose of Database Systems

### On-slide content

- Atomicity of updates
  - Failures may leave database in an inconsistent state with partial updates carried out
  - Example: Transfer of funds from one account to another should either complete or not happen at all
- Concurrent access by multiple users
  - Concurrent access needed for performance
  - Uncontrolled concurrent accesses can lead to inconsistencies
    - Ex: Two people reading a balance (say 100) and updating it by withdrawing money (say 50 each) at the same time
- Security problems
  - Hard to provide user access to some, but not all, data
- Database systems offer solutions to all the above problems


### Visual description

Text-only continuation covering atomicity, concurrent-access anomalies, security problems, and the claim that DBMSs address these problems.


### Study interpretation

Atomicity, concurrency control, and security are introduced as additional reasons that a DBMS is more than file storage.


---

## Slide 17 — View of Data

### On-slide content

- A database system is a collection of interrelated data and a set of programs that allow users to access and modify these data.
- A major purpose of a database system is to provide users with an abstract view of the data.
  - Data models
    - A collection of conceptual tools for describing data, data relationships, data semantics, and consistency constraints.
  - Data abstraction
    - Hide the complexity of data structures to represent data in the database from users through several levels of data abstraction.


### Visual description

Text-only slide introducing data models and data abstraction as tools for describing and hiding data complexity.


---

## Slide 18 — The Relational Model

### On-slide content

- CSC 6302 - Week 1
- Ok, so now we know what a database is, conceptually, and what a database system is.
- Likely, we have used several database systems this week!
- But, how do we go about describe and defining database management system?
- "Information is data that has been given meaning by way of relational connection."
- — Russell L. Ackoff, From Data to Wisdom (1989)


### Visual description

Section-divider slide titled The Relational Model, with an Ackoff quote about information gaining meaning through relational connection.


---

## Slide 19 — Data Models

### On-slide content

- A collection of tools for describing
  - Data
  - Data relationships
  - Data semantics
  - Data constraints
- Entity-Relationship data model (mainly for database design)


### Visual description

Text-only slide defining data models as tools for describing data, relationships, semantics, constraints, and ER design.


---

## Slide 20 — University Database Example

### On-slide content

- In this course, we will be looking at a University database example, something we are all familiar with
- Data consists of information about:
  - Students
  - Instructors
  - Classes
- Application program examples:
  - Add new students, instructors, and courses
  - Register students for courses
  - Generate class rosters
  - Assign grades to students
  - Compute GPA and generate transcripts


### Visual description

Text-only university-database example listing students, instructors, classes, registration, rosters, grades, GPA, and transcripts.


---

## Slide 21 — Relational Model

### On-slide content

- All the data is stored in various tables.
- Example of tabular data in the relational model
- Columns
- Rows
- Ted CoddTuring Award 1981
- Tedd Codd


### Visual description

Relational-model slide with a sample instructor table labeled with arrows for columns and rows. A small portrait of E. F. 'Ted' Codd appears at lower-right with 'Turing Award 1981'.


### Study interpretation

The central relational idea is tabular representation: rows are tuples and columns are attributes.


---

## Slide 22 — A Simple Relational Database

### On-slide content

*No additional readable text beyond the slide title.*


### Visual description

Diagram slide showing two related relational tables: an instructor table and a department table, illustrating a simple relational database.


---

## Slide 23 — Relation Schema and Instance

### On-slide content

- The columns are attributes
  - Domain
    - The set of allowed values for each attribute
  - Attribute values are (normally) required to be atomic
    - indivisible
- ACID
  - Atomic
  - Consistency
    - The database is always in a consistent state
  - Isolation
    - Transactions don’t interfere with each other
  - Durability
    - Once you make changes, they are permanent
- ACID


### Visual description

Text-only schema/instance slide defining attributes, domains, atomic values, and ACID: Atomicity, Consistency, Isolation, Durability.


### Study interpretation

This slide combines relational terminology with ACID transaction properties. Do not confuse 'atomic attribute values' with the 'Atomicity' property of transactions.


---

## Slide 24 — Relation Schema and Instance

### On-slide content

- Relation schema
  - A Table name, and its attributes
  - Example
- instructor = (ID, name, dept_name, salary)
- Table Instance
  - The current values a relation
- Tuple
  - An element t of relation r
  - Represented by a row in a table


### Visual description

Text-only slide defining relation schema, table instance, and tuple, using instructor(ID, name, dept_name, salary) as the example.


---

## Slide 25 — Relations Are Unordered

### On-slide content

- Order of tuples is irrelevant (tuples may be stored in an arbitrary order)
- Example: instructor relation with unordered tuples


### Visual description

Relational table image showing the instructor relation with rows in a different order to emphasize that relations are unordered.


---

## Slide 26 — Relations Have a Schema

### On-slide content

- Relation schema -- is the logical structure of a relation
- Database schema -- is the logical structure of the database.
- Database instance -- is a snapshot of the data in the database at a given instant in time.
- Example:
  - schema: instructor (ID, name, dept_name, salary)
  - Instance:


### Visual description

Text plus instructor-table image demonstrating relation schema, database schema, and a database instance as a snapshot.


---

## Slide 27 — Instances and Schema

### On-slide content

- Similar to types and variables in programming languages
- Logical Schema – the overall logical structure of the database
  - Example: The database consists of information about a set of customers and accounts in a bank and the relationship between them
    - Analogous to type information of a variable in a program
- Physical schema – the overall physical structure of the database
- Instance – the actual content of the database at a particular point in time
  - Analogous to the value of a variable


### Visual description

Text-only slide comparing logical schema, physical schema, and instance to programming-language types and variable values.


---

## Slide 28 — Integrity Constraints (Or Keys)

### On-slide content

- Let K ⊆ R
- K is a superkey of R if values for K are sufficient to identify a unique tuple of each possible relation r(R)
  - Example: {ID} and {ID,name} are both superkeys of instructor.
- Superkey K is a candidate key if K is minimal
  - Every candidate key is a super key
  - What do we mean by minimal?
    - The columns included within the candidate key are sufficient to uniquely identify a row
  - Example: {ID} is a candidate key for Instructor
- One of the candidate keys is selected to be the primary key.
  - For now, the most convenient one to uniquely identify a row


### Visual description

Text-only key slide introducing superkeys, candidate keys, minimality, and primary-key selection using instructor ID.


### Study interpretation

Key hierarchy: superkey → minimal superkey (candidate key) → chosen candidate key (primary key).


---

## Slide 29 — Integrity Constraints (Or Keys)

### On-slide content

- Primary key
  - Each table must have a primary key defined
  - This is enforced by SQL
- Foreign key
  - Tables are not required to have one
  - Used when a column in one table references the primary key of a another table
    - Referencing relation
    - Referenced relation
  - Example: dept_name in instructor is a foreign key from instructor referencing department


### Visual description

Text-only key slide defining primary keys and foreign keys and distinguishing referencing vs referenced relations.


---

## Slide 30 — Identifying the Primary Key

### On-slide content

- Identify the Super Keys
  - There are 2(n)-1 unique super keys for every relation, where n is the number of columns in the relation
- Identify the Candidate Keys
  - Start with the list of super keys, and remove the ones that don’t make sense.
  - There should be more than one
- Primary Key
  - Select the candidate key that most efficiently uniquely identifies a row
  - There should only be one


### Visual description

Instructor-table image next to a three-step key-selection process: enumerate superkeys, identify candidate keys, then choose one primary key.


---

## Slide 31 — Identifying the Primary Key

### On-slide content

- Identify the 15 Super Keys
  - Id
  - name
  - dept_name
  - salary
  - Id, name
  - Id, dept_name
  - id, salary
  - name, dept_name
  - name, salary
  - dept_name, salary
  - id, name, dept_name
  - id, name, salary
  - id, dept_name, salary
  - name, dept_name, salary
  - id, name, dept_name, salary


### Visual description

Text-only enumeration of the 15 non-empty superkey combinations for a four-column instructor relation.


---

## Slide 32 — Identifying the Primary Key

### On-slide content

- Identify the Candidate Keys
  - Id
  - name, dept_name, salary
  - name, dept_name
  - name, salary
- Primary Key
  - Id


### Visual description

Instructor-table image beside a reduced candidate-key list, ending with ID selected as the primary key.


---

## Slide 33 — Entity Relational (ER) Diagram

### On-slide content

- CSC 6302 - Week 1
- Programming is not about typing, it's about thinking. - Rich Hickey
- Ok, so a database is organized into a collection of relations.
- And those relations are all interconnected.
- And those relations all have a way to uniquely identify a particular row within a relation.
- So, how do we effectively communicate this?


### Visual description

Section-divider slide titled Entity Relational (ER) Diagram with a Rich Hickey quote and a transition question about communicating interconnected relations.


---

## Slide 34 — Schema Diagram for University Database

### On-slide content

*No additional readable text beyond the slide title.*


### Visual description

Full university schema diagram. It contains entities/relations including student, instructor, department, course, section, classroom, time_slot, takes, teaches, advisor, and prereq. Arrows show foreign-key references among these relations; underlined attributes mark key fields.


### Study interpretation

This schema diagram is the core Week 1 relationship map and is worth studying as a concrete example of primary/foreign-key connections.


---

## Slide 35 — ER Diagram

### On-slide content

- Key Aspects
  - Entities
    - Real-world objects, people, or concepts
      - Our tables
      - Note that table design is very similar to object design
        - Each table should represent one thing, and all the data needed to represent that one thing
    - Represented by rectangles
    - Attributes
      - The columns in our tables
      - Represented by text within the entity
        - In some diagraming tools, they are placed within an oval
    - Primary Keys:
      - Unique identifiers that distinguish each instance of an entity
      - Represented by underlined text.


### Visual description

Text-only ER-diagram fundamentals slide: entities, attributes, primary keys, rectangles for entities, and underlined primary-key text.


---

## Slide 36 — ER Diagram

### On-slide content

- Key Aspects
  - Relationships:
    - How entities connect or act with each other
    - Represented by diamonds or connecting lines
      - When showing a foreign key relationship
        - Ensure the referencing relation includes an arrow head pointing to the referenced relation
  - Cardinality
    - The numerical rules or limits of a relationship
      - one-to-one
      - one-to-many
      - many-to-many


### Visual description

Text-only ER relationships/cardinality slide covering one-to-one, one-to-many, many-to-many, and arrowheads from referencing to referenced relations.


---

## Slide 37 — ER Diagram in MySQL Workbench

### On-slide content

- ER Diagrams are auto generated in MySQL Workbench
  - Reverse Engineer Tool
    - Ensure that you configure your MySQL Workbench relationships to “Connect to Columns”
      - This clearly shows foreign key relationships
        - Referencing table vs referenced table
- All databases presented to you in class will have an ER diagram
  - All databases you present to me will have an ER diagram
- Reference
- Generating ER Diagrams in MySQL Workbench


### Visual description

Text-only MySQL Workbench ER-diagram slide explaining reverse engineering, 'Connect to Columns', and the requirement that class databases and student submissions include ER diagrams.


---

## Slide 38 — Database Architecture

### On-slide content

- CSC 6302 - Week 1
- Now that we understand what a database system is, and how to describe how the data within a particular database is related, let’s back up.
- How do actually go about interacting with an existing database?


### Visual description

Section-divider slide titled Database Architecture introducing interaction with an existing database.


---

## Slide 39 — Levels of Abstraction

### On-slide content

- Physical level
  - Describes how a record is stored on disk.
- Logical level:
  - Describes data stored in database, and the relationships among the data.
  - The Database Schema resides at this level.
- View level:
  - Application programs hide details of data types.
  - Views can also hide information
    - Sensitive information
      - such as an employee’s salary
    - Unneeded information
      - Audience specific
        - The user of the application/website
        - Another programmer, working elsewhere in the product, who just views things as a black box


### Visual description

Text-only three-level abstraction slide defining physical, logical, and view levels and noting that views can hide sensitive or audience-irrelevant information.


### Study interpretation

The three levels of abstraction separate what users see, what the database logically contains, and how bytes are physically stored.


---

## Slide 40 — Application

### On-slide content

- Layers
- View
- Logical
- Physical


### Visual description

Large application-layers architecture diagram. At the top are users and tools in the View layer; the middle Logical layer contains application programs, DML queries/compiler/organizer, DDL interpreter, and query evaluation; the lower Physical layer contains storage-manager components and disk structures such as data, indices, data dictionary, and statistical data.


### Study interpretation

This picture ties the course together: user-facing tools sit above the logical query-processing layer, which in turn depends on the physical storage manager.


---

## Slide 41 — Encapsulation and Abstraction

### On-slide content

- Encapsulation
  - Each layer has their job to do
    - And everything they need to do it
- Abstraction
  - Each layer reveals only what it needs to the other layers
  - Each layer knows how to interact with the layer above/below
    - Does not know, or care, what is actually done
- Physical Data Independence
  - The ability to modify the physical schema without changing the logical schema
  - Applications depend on the logical schema
  - Interfaces between the various levels and components should be well defined so that changes in some parts do not seriously influence others.


### Visual description

Text-only slide connecting encapsulation and abstraction to physical data independence and well-defined interfaces between layers.


---

## Slide 42 — View Level

### On-slide content

- CSC 6302 - Week 1


### Visual description

Section-divider slide titled View Level.


---

## Slide 43 — View Level

### On-slide content

- View 1 could be an application
- View 2 to a web application
- View 3 a Mobile application


### Visual description

Three-tier abstraction diagram with multiple boxes labeled view 1, view 2, …, view n above logical level and physical level. Bullets map views to an application, web application, and mobile application.


---

## Slide 44 — View Level

### On-slide content

- Highest Level of Abstraction
  - Hides the most detail about how the system works
- Customizable views of the data
  - Security
  - Role-based permissions
  - Paywalls
- Who is focused on this level?
  - User interface designers
  - User interface programmers
    - Application programmers
    - Web programmers
    - Mobile programmers
  - Customers interact directly with this level
    - This is what you “see”
    - Customers may even seen multiple viewpoints


### Visual description

Text-only View Level slide describing it as the highest abstraction level, customizable, security/role/paywall aware, and the layer users directly see.


---

## Slide 45 — Logic Level

### On-slide content

- CSC 6302 - Week 1


### Visual description

Section-divider slide titled Logic Level.


---

## Slide 46 — What Do We Mean by Logical Level

### On-slide content

- What data is stored, and how that data relates
  - Database Design
  - Database
    - Tables
    - Attributes
    - Integrity Constraints
      - Primary Key
      - Foreign Key
- Actions taken against the data to perform tasks
  - Queries
    - Retrieve specific data from the database
  - Stored procedures
  - Functions
- This class is going to be VERY focused on this level


### Visual description

Text-only logical-level slide emphasizing database design, tables, attributes, keys/constraints, queries, stored procedures, and functions; it states the course is very focused on this level.


---

## Slide 47 — Data Definition Language (DDL)

### On-slide content

- We need a way to specific what data is being stored, how it's being stored, and how it will be retrieved
  - Let’s start with what/how is stored
- Data Definition Language
  - A specific notation for defining the database schema
    - Creating databases
    - Creating tables
    - Defining attributes and their domains
    - Defining integrity constraints
  - Example: create table instructor ( ID char(5), name varchar(20), dept_name varchar(20), salary numeric(8,2))
- DDL Language


### Visual description

DDL slide with the instructor relation CREATE TABLE example; it defines DDL as notation for creating databases/tables, attributes/domains, and constraints.


### Study interpretation

DDL defines structure; DML manipulates/query data. This distinction recurs throughout database courses.


---

## Slide 48 — Data Definition Language (DDL)

### On-slide content

- DDL compiler
  - Generates a set of table templates stored in a data dictionary
- Data dictionary
  - Contains metadata (i.e., data about data)
    - Database schema
    - Integrity constraints
      - Primary key (ID uniquely identifies instructors)
    - Authorization
      - Who can access what


### Visual description

Text-only DDL compiler/data-dictionary slide describing metadata, schema, integrity constraints, primary key, and authorization.


---

## Slide 49 — Data Manipulation Language (DML)

### On-slide content

- We need a way to describe how we are accessing and updating the data organized by the appropriate data model
  - Data Manipulation Language
    - Also known as query language
- Two types of DML
  - Procedural DML
    - Requires user to specify what data are needed and how to get those data.
  - Declarative DML
    - Requires User to specify what data are needed without specifying how to get those data.
- DML Language


### Visual description

DML slide defining procedural vs declarative DML and calling DML the query language for accessing/updating data.


---

## Slide 50 — Data Manipulation Language (DML)

### On-slide content

- Declarative DMLs are usually easier to learn and use than are procedural DMLs.
- Declarative DMLs are also referred to as non-procedural DMLs
- The portion of a DML that involves information retrieval is called a query language.


### Visual description

Text-only continuation explaining declarative/non-procedural DML and query-language terminology.


---

## Slide 51 — SQL Query Language

### On-slide content

- SQL query language is nonprocedural.
  - Query input
    - One or more tables
  - Query output
    - Single table
- SQL is NOT a Turing machine equivalent language
  - No network programming
  - No outputting to a display
  - No user interface
  - Generally embedded in some higher-level language
    - We will look at Python and Java later in the semester


### Visual description

Text-only SQL Query Language slide: SQL is nonprocedural, takes one or more tables as input, produces a table as output, is not Turing-machine equivalent, and is generally embedded in higher-level languages.


### Study interpretation

SQL is declarative/nonprocedural in the course framing: the user states what data is wanted, while the DBMS chooses how to execute the query.


---

## Slide 52 — Database Engine

### On-slide content

- MySql exists at the logical layer
  - Runs as a service on your computer
    - There are parts that interact with the view level:
      - You can access MySQL via the terminal/command prompt
  - Generally use another application, like MySQL Workbench, for a graphical tool
- A database system is partitioned into modules that deal with each of the responsibilities of the overall system.
- The functional components of a database system can be divided into
  - The storage manager,
  - The query processor component,
  - The transaction management component.


### Visual description

Text-only Database Engine slide locating MySQL at the logical layer and naming the storage manager, query processor, and transaction manager.


---

## Slide 53 — Storage Manager

### On-slide content

- Interface between the Logical Level and the Physical Level
- The storage manager is responsible to the following tasks:
  - Interaction with the OS file manager
    - OS file manager differs from OS to OS
  - Efficient storing, retrieving and updating of data
    - Data is physically stored on disk on your computer
    - Works with the OS
- The storage manager components include:
  - Authorization and integrity manager
  - Transaction manager
  - File manager
  - Buffer manager


### Visual description

Text-only Storage Manager slide listing OS interaction, efficient storage/retrieval/update, authorization/integrity manager, transaction manager, file manager, and buffer manager.


---

## Slide 54 — Storage Manager Continued

### On-slide content

- The storage manager implements several data structures as part of the physical system implementation:
  - Data files
    - Store the database itself
  - Data dictionary
    - Stores metadata about the structure of the database, in particular the schema of the database.
  - Indices
    - Can provide fast access to data items. A database index provides pointers to those data items that hold a particular value.
- We will get into more detail here later in the class


### Visual description

Text-only storage-manager continuation listing data files, data dictionary, and indices as physical implementation structures.


---

## Slide 55 — Query Processor

### On-slide content

- The query processor components include:
  - DDL interpreter
    - Interprets DDL statements
    - Records the definitions in the data dictionary.
  - DML compiler
    - Translates DML statements in a query language into an evaluation plan consisting of low-level instructions that the query evaluation engine understands.
    - Performs query optimization
      - Picks the lowest cost evaluation plan from among the various alternatives.
  - Query evaluation engine
    - Executes low-level instructions generated by the DML compiler.


### Visual description

Text-only Query Processor slide defining the DDL interpreter, DML compiler/optimizer, and query evaluation engine.


---

## Slide 56 — Query Processing

### On-slide content

- 1. Parsing and translation
- 2. Optimization
- 3. Evaluation


### Visual description

Query-processing flow diagram: query → parser/translator → relational-algebra expression → optimizer → execution plan → evaluation engine → query output. Data stores feed the evaluation engine, while statistics about data feed the optimizer. The slide labels the three phases: parsing/translation, optimization, evaluation.


### Study interpretation

Query optimization occurs after parsing/translation and before execution; statistics about stored data help the optimizer choose an evaluation plan.


---

## Slide 57 — Transaction Manager

### On-slide content

- What is a transaction?
  - A distinct unit of work
    - Database is in a consistent state before the work starts
    - Database is in a consistent state when the work ends
- Transaction management
  - Imagine you and your spouse share a bank account
    - You each check your balance and then spend money you know you have
      - But…what if when one of you spends the money, the other no longer can afford their purchase
      - The order of reads and writes matters!


### Visual description

Text-only transaction-management introduction using a shared bank account to explain that read/write ordering matters.


### Study interpretation

Transactions are distinct units of work whose correctness depends on both atomicity and isolation under concurrent access.


---

## Slide 58 — Transaction Manager

### On-slide content

- You check your balance, and have $500 dollars in your account
- Your spouse checks the balance, and there is $500 in the account
  - You make a $350 purchase
  - They make a $200 purchase
- You get hit with an overdraft fee
- You check your balance, and have $500 dollars in your account
  - You make a $350 purchase
- Your spouse checks the balance, and there is $150 in the account
  - They do not make their $200 purchase


### Visual description

Text-only paired bank-account scenarios comparing concurrent decisions from a $500 balance with a serialized sequence that prevents an overdraft.


---

## Slide 59 — ACID

### On-slide content

- Source: ACID


### Visual description

Four-panel ACID infographic: Atomicity ('every transaction is committed entirely'), Consistency ('data remains consistent after a transaction is completed'), Isolation ('transactions occur independently without interference'), Durability ('completed transactions are permanently recorded').


### Study interpretation

ACID is the transaction-safety framework introduced in Week 1 and should be memorized with the meaning of each letter.


---

## Slide 60 — Physical Level

### On-slide content

- CSC 6302 - Week 1


### Visual description

Section-divider slide titled Physical Level.


---

## Slide 61 — Physical Level

### On-slide content

- Deals with how data is actually stored
    - On your machine
    - In the cloud
    - On a server
    - On another machine
- Just like the View level, you should be able to swap out your storage system without impacting the logical layer or the view layer
  - Physical machine?
  - Virtual machine?
  - RAID array?
  - Remote machine?
  - Cloud storage?


### Visual description

Physical-level slide with a storage hierarchy diagram from cache → main memory → flash memory → magnetic disk → optical disk → magnetic tapes, alongside examples of local, cloud, server, virtual-machine, RAID, remote, and cloud storage.


### Study interpretation

The physical layer is replaceable without changing the logical/view layers when data independence is preserved.


---

## Slide 62 — Physical Level

### On-slide content

- The storage manager within a DBMS leverages how the data is stored to optimize queries and increase performance
  - Primary storage, like RAM is faster to access then secondary storage, like you harddrive
    - Or another machine’s hard drive
    - Or cloud storage
- We will dig deeper into this later in the course


### Visual description

Text-only continuation explaining that the storage manager uses physical storage characteristics for query optimization and that primary storage such as RAM is faster than secondary storage.


---

## Slide 63 — Basic SQL

### On-slide content

- CSC 6302 - Week 1
- “"Where is the information? Lost in data. Where is the data? Lost in the #@%! &database!"— Joe Celko, The Guru's Guide to SQL Server Stored Procedures”


### Visual description

Section-divider slide titled Basic SQL with a Joe Celko quote about information/data/databases.


---

## Slide 64 — Creating a Database in SQL

### On-slide content

- Goals
  - DESIGN THE DATABASE
  - Create the database
    - Use the built in tools in MySQL Workbench
    - Create a set of SQL statements, called a SQL script
  - Create the tables within the database
    - Again, we can use MySQL Workbench or a SQL script
  - Insert data into the tables
  - Query the database for particular data


### Visual description

Text-only workflow slide: design database → create database → create SQL script/tables → insert data → query data.


---

## Slide 65 — Domain Types in SQL

### On-slide content

- char(n). Fixed length character string, with user-specified length n.
- varchar(n). Variable length character strings, with user-specified maximum length n.
- int. Integer (a finite subset of the integers that is machine-dependent).
- smallint. Small integer (a machine-dependent subset of the integer domain type).
- numeric(p,d). Fixed point number, with user-specified precision of p digits, with d digits to the right of decimal point. (ex., numeric(3,1), allows 44.5 to be stores exactly, but not 444.5 or 0.32)
- real, double precision. Floating point and double-precision floating point numbers, with machine-dependent precision.
- float(n). Floating point number, with user-specified precision of at least n digits.


### Visual description

Text-only SQL domain-types slide defining char(n), varchar(n), int, smallint, numeric(p,d), real/double precision, and float(n).


---

## Slide 66 — Schema Definition

### On-slide content

- A schema definition provides a shorthand way of describing a table’s schema. The format of a schema definition is given below, with the underline used to identify the primary key:
- TableName(column1 column1Type, column2 column2Type)
- For the Department table:
- Department(dept_Name varchar(20), building varchar(15), budget numeric)


### Visual description

Text-only schema-definition slide showing the compact notation TableName(column type, …), with Department(dept_Name varchar(20), building varchar(15), budget numeric) as the example.


---

## Slide 67 — Create Table

### On-slide content

- An SQL relation is defined using the create table command:
- create table r
- (A1 D1, A2 D2, ..., An Dn, (integrity-constraint1), ..., (integrity-constraintk))
  - r is the name of the relation
  - each Ai is an attribute name in the schema of relation r
  - Di is the data type of values in the domain of attribute Ai
- Example:
- create table instructor ( ID char(5), name varchar(20), dept_name varchar(20), salary numeric(8,2))


### Visual description

Text-only CREATE TABLE syntax slide with the generic create-table grammar and the instructor(ID, name, dept_name, salary) example.


---

## Slide 68 — Create Table Note

### On-slide content

- Important Notes When Creating Tables
  - Check if the table exists
  - Each column needs an appropriate data type
  - A primary key uniquely identifies a row
    - Each table needs one
  - Constraints can be used to ensure the data being insert into the table is reasonable
- CREATE TABLE IF NOT EXISTS Department(
- dept_name varchar(20),
- building varchar(15),
- budget numeric(12,2) check (budget > 0),
- primary key (dept_name)
- );


### Visual description

Text-only Create Table Note slide showing CREATE TABLE IF NOT EXISTS Department(...), a positive-budget CHECK constraint, and a primary key on dept_name.


### Study interpretation

Good table creation combines correct data types, a primary key, and explicit integrity constraints.


---

## Slide 69 — Integrity Constraints in Create Table

### On-slide content

- Types of integrity constraints
  - primary key (A1, ..., An )
  - foreign key (Am, ..., An ) references r
  - not null
- SQL prevents any update to the database that violates an integrity constraint.
- Example:
- create table instructor ( ID char(5), name varchar(20) not null, dept_name varchar(20), salary numeric(8,2), primary key (ID), foreign key (dept_name) references department);


### Visual description

Text-only integrity-constraint CREATE TABLE example using NOT NULL, PRIMARY KEY(ID), and FOREIGN KEY(dept_name) REFERENCES department.


---

## Slide 70 — Schema Diagram for University Database

### On-slide content

*No additional readable text beyond the slide title.*


### Visual description

Repeat of the full University Database schema diagram used earlier, again showing student, instructor, department, course, section, classroom, time_slot, takes, teaches, advisor, and prereq relationships.


---

## Slide 71 — Updates to a Table

### On-slide content

- Insert
  - insert into instructor values ('10211', 'Smith', 'Biology', 66000);
- Delete
  - Remove all tuples from the student relation
    - delete from student
- Drop Table
  - drop table r
- Alter
  - alter table r add A D
    - where A is the name of the attribute to be added to relation r and D is the domain of A.
    - All exiting tuples in the relation are assigned null as the value for the new attribute.
  - alter table r drop A
    - where A is the name of an attribute of relation r
    - Dropping of attributes not supported by many databases.


### Visual description

Text-only update-operations slide showing INSERT, DELETE, DROP TABLE, ALTER TABLE ADD, and ALTER TABLE DROP syntax.


---

## Slide 72 — Important Inserting Note

### On-slide content

- Important Notes When Inserting Data
  - Every non-nullable column needs to be specified
  - Values must be listed in the same order as the columns
  - Values need to fall within the column’s domain
  - The table needs to exist
  - You need to tell the database engine what database is being used
- USING University;
- INSERT INTO Department (dept_name, building, budget) values ("Mathematics", "Palmisano", 10000);
- INSERT INTO Department (dept_name, building, budget) values ("Economics", "Sullivan", 20000);


### Visual description

Text-only insertion-notes slide emphasizing non-nullable columns, column order/domains, existing table/database context, and example INSERT INTO Department statements.


---

## Slide 73 — Integrity Constraints

### On-slide content

- CSC 6302 - Week 1
- Programming is not about typing, it's about thinking. - Rich Hickey


### Visual description

Section-divider slide titled Integrity Constraints with a Rich Hickey quote.


---

## Slide 74 — Referential Integrity

### On-slide content

- Ensures that a value that appears in one relation for a given set of attributes also appears for a certain set of attributes in another relation.
  - Example: If “Biology” is a department name appearing in one of the tuples in the instructor relation, then there exists a tuple in the department relation for “Biology”.
- Let A be a set of attributes. Let R and S be two relations that contain attributes A and where A is the primary key of S. A is said to be a foreign key of R if for any values of A appearing in R these values also appear in S.


### Visual description

Text-only Referential Integrity slide defining foreign keys formally and using Biology in instructor/department as the example.


### Study interpretation

Referential integrity is the formal rule behind foreign keys: referenced values must exist in the referenced relation.


---

## Slide 75 — Referential Integrity Continued

### On-slide content

- Foreign keys can be specified as part of the SQL create table statement
- foreign key (dept_name) references department
- By default, a foreign key references the primary-key attributes of the referenced table.
- SQL allows a list of attributes of the referenced relation to be specified explicitly.
- foreign key (dept_name) references department (dept_name)


### Visual description

Text-only continuation showing FOREIGN KEY(dept_name) REFERENCES department and explicit referenced-column syntax.


---

## Slide 76 — Cascading Actions and Referential Integrity

### On-slide content

- When a referential-integrity constraint is violated, the normal procedure is to reject the action that caused the violation.
- An alternative, in case of delete or update is to cascade
- create table course (
- (…
- dept_name varchar(20),
- foreign key (dept_name) references department
- on delete cascade
- on update cascade,
- . . .)
- Instead of cascade we can use :
  - set null,
  - set default


### Visual description

Text-only cascading-actions slide showing ON DELETE CASCADE / ON UPDATE CASCADE and alternatives SET NULL / SET DEFAULT.


### Study interpretation

Cascading actions define what the DBMS should do to dependent rows when referenced keys are updated/deleted.


---

## Slide 77 — The Check Clause

### On-slide content

- The check (P) clause specifies a predicate P that must be satisfied by every tuple in a relation.
- Example: ensure that semester is one of fall, winter, spring or summer
- create table section
- (course_id varchar (8),
- sec_id varchar (8),
- semester varchar (6),
- year numeric (4,0),
- building varchar (15),
- room_number varchar (7),
- time slot id varchar (4),
- primary key (course_id, sec_id, semester, year),
- check (semester in ('Fall', 'Winter', 'Spring', 'Summer')))


### Visual description

Text-only CHECK-clause slide with a section table example restricting semester to Fall, Winter, Spring, or Summer.


---

## Slide 78 — This Week's tasks

### On-slide content

- Practice Problem #1
- Programming project #1
- Quiz #1
- CSC 6302 - Week 1


### Visual description

Week 1 task-summary slide listing Practice Problem #1, Programming Project #1, and Quiz #1.


---

## Slide 79 — Practice Exercise 01

### On-slide content

- Install MySQL
- Install MySQL Workbench
- Optional
  - Install VS Code
  - Installing the Python extension for VS Code
- Design a Database
- The details and rubric will be provided in the practice assignment on Canvas
- This counts towards the Practice Exercise grade.


### Visual description

Text-only Practice Exercise 01 slide: install MySQL and MySQL Workbench, optionally VS Code/Python extension, then design a database; details/rubric are in Canvas.


---

## Slide 80 — Programming Assignment 01

### On-slide content

- This assignment counts towards the Coding Projects grade.
- In this assignment, you will be writing SQL statements to do the following:
- Create the database from the practice
- Create the tables from the practice
- Create an ER Diagram in MySQL Workbench
- Insert tuples into your tables
- Add a column to an existing table
- Remove a column from an existing table


### Visual description

Text-only Programming Assignment 01 slide: write SQL to create the practice database/tables, create an ER diagram in MySQL Workbench, insert tuples, add a column, and remove a column.


### Study interpretation

Programming Assignment 01 directly operationalizes the week: design → DDL → ER diagram → insert/update schema.


---

## Slide 81 — Quiz 01

### On-slide content

- This week's quiz will focus on:
- Databases and Database Applications
- The Relational Model
- Entity Relational Diagrams (ER Diagrams)
  - Database Table Design
- Database Systems
  - Database Architecture
  - Database Engine
- SQL - The Basics
  - Create Table
  - Insert
  - Update
  - Integrity Constraints
- Like all quizzes, the quiz will be taken in Canvas, and is open book/note.
- This counts towards the Quiz grade.


### Visual description

Text-only Quiz 01 slide listing Week 1 topics from database applications through integrity constraints and stating that the Canvas quiz is open book/open notes.


---

## Slide 82 — Check out recommended texts and videos!

### On-slide content

- Next Week - Basic SQL

| Assignment | Due Date |
| --- | --- |
| Practice | Saturday, 11:59 PM |
| Quiz | Monday, 11:59 PM |
| Programming Assignment | Monday, 11:59 PM |


### Visual description

Closing slide with a due-date table: Practice Saturday 11:59 PM; Quiz Monday 11:59 PM; Programming Assignment Monday 11:59 PM. It also says to check recommended texts/videos and previews Next Week – Basic SQL.


---


# Week 1 Master Study Summary

## 1. Course Scope

CSC6302 covers:
- relational database design
- functional dependencies
- normal forms / normalization
- SQL
- Java/Python database applications
- data storage
- query optimization

Week 1 establishes the vocabulary and architecture used by later units.

---

# 2. Course Logistics

## Weekly structure
Weeks 1–7:
- Practice
- Online quizzes
- Programming assignments

Week 8:
- Final exam

## Due dates
- Practice: Saturday 11:59 PM
- Quiz: Monday 11:59 PM
- Programming Assignment: Monday 11:59 PM

## Late penalty
**5% per full day**

## Grade weights
- Practice: 10%
- Projects: 60%
- Quizzes: 10%
- Final Exam: 20%

## AI policy
Permitted uses include:
- concept/error explanations
- tutoring
- syntax/query understanding
- Python/Java code-element understanding
- test-data generation

But:
- disclose AI use
- understand every line
- own the code
- code must run
- documentation must remain human-readable

---

# 3. Why Database Systems Exist

Direct file systems create problems such as:

```text
Redundancy
Inconsistency
Difficult access
Data isolation
Buried constraints
Partial updates
Concurrency anomalies
Security limitations
```

A DBMS centralizes solutions for:
- structured storage
- constraints
- concurrent users
- transactions
- security
- query processing

---

# 4. Relational Model

A relational database stores data in **relations/tables**.

## Core terms

### Attribute
A column.

### Domain
Allowed values for an attribute.

### Tuple
A row.

### Relation schema
Table name + attributes.

Example:

```text
instructor(ID, name, dept_name, salary)
```

### Relation instance
The current rows in the table.

### Database schema
Logical structure of the entire database.

### Database instance
Snapshot of all data at a point in time.

### Relations are unordered
Tuple order is not part of relational meaning.

---

# 5. Keys and Integrity

## Superkey
Any attribute set sufficient to uniquely identify a tuple.

## Candidate key
A **minimal superkey**.

## Primary key
One selected candidate key.

## Foreign key
Attribute(s) in one relation referencing the primary key of another relation.

## Referential integrity
A foreign-key value must correspond to an existing referenced key value.

### Key relationship

```text
Superkeys
   ↓ keep only minimal
Candidate Keys
   ↓ choose one
Primary Key
```

---

# 6. ER Diagrams

ER diagrams communicate:
- entities/tables
- attributes/columns
- primary keys
- relationships
- cardinality

## Relationship cardinalities
- one-to-one
- one-to-many
- many-to-many

## MySQL Workbench
The course expects:
- reverse-engineered ER diagrams
- relationships configured to **Connect to Columns**
- ER diagrams with all presented/submitted databases

---

# 7. University Database Model

The Week 1 schema uses relations such as:

- student
- instructor
- department
- course
- section
- classroom
- time_slot
- takes
- teaches
- advisor
- prereq

This example demonstrates:
- primary keys
- composite keys
- foreign keys
- many-to-many relationship tables
- reference direction

---

# 8. Levels of Abstraction

## View level
What users/applications see.

Examples:
- desktop app
- web app
- mobile app
- role-specific view

Can hide:
- sensitive data
- irrelevant data

## Logical level
What data exists and how it relates.

Focuses on:
- tables
- attributes
- constraints
- keys
- queries
- procedures/functions

This course is heavily focused on the logical level.

## Physical level
How the data is stored:
- local machine
- server
- VM
- RAID
- remote system
- cloud

## Physical data independence
Physical storage can change without forcing changes to the logical schema/application interface.

---

# 9. DDL vs DML

## DDL — Data Definition Language
Defines database structure.

Used to:
- create databases
- create tables
- define attributes/domains
- define keys/constraints

## DML — Data Manipulation Language
Accesses and modifies data.

### Procedural DML
Specify:
- what data
- how to get it

### Declarative DML
Specify:
- what data
- not how to get it

SQL is presented as declarative/nonprocedural.

---

# 10. Database Engine Components

## Storage Manager
Bridge between logical and physical layers.

Components:
- authorization/integrity manager
- transaction manager
- file manager
- buffer manager

Physical structures:
- data files
- data dictionary
- indices

## Query Processor
Components:
- DDL interpreter
- DML compiler
- optimizer
- query evaluation engine

### Query-processing stages
1. Parsing and translation
2. Optimization
3. Evaluation

## Transaction Manager
Controls units of work and concurrent access.

---

# 11. ACID

## Atomicity
Transaction completes entirely or not at all.

## Consistency
Transaction preserves database rules/valid state.

## Isolation
Concurrent transactions do not improperly interfere.

## Durability
Committed results persist.

### Memory aid

```text
A = All or nothing
C = Correct state
I = Independent execution
D = Durable results
```

---

# 12. Basic SQL

## Common domain types

```sql
char(n)
varchar(n)
int
smallint
numeric(p,d)
real
double precision
float(n)
```

## CREATE TABLE

```sql
CREATE TABLE instructor (
    ID        CHAR(5),
    name      VARCHAR(20),
    dept_name VARCHAR(20),
    salary    NUMERIC(8,2)
);
```

## Table with constraints

```sql
CREATE TABLE IF NOT EXISTS Department (
    dept_name VARCHAR(20),
    building  VARCHAR(15),
    budget    NUMERIC(12,2) CHECK (budget > 0),
    PRIMARY KEY (dept_name)
);
```

## Primary + Foreign Key example

```sql
CREATE TABLE instructor (
    ID        CHAR(5),
    name      VARCHAR(20) NOT NULL,
    dept_name VARCHAR(20),
    salary    NUMERIC(8,2),
    PRIMARY KEY (ID),
    FOREIGN KEY (dept_name) REFERENCES department
);
```

---

# 13. Updating Tables

## Insert

```sql
INSERT INTO instructor
VALUES ('10211', 'Smith', 'Biology', 66000);
```

## Delete all rows from a relation

```sql
DELETE FROM student;
```

## Drop a table

```sql
DROP TABLE r;
```

## Add an attribute

```sql
ALTER TABLE r ADD A D;
```

## Drop an attribute

```sql
ALTER TABLE r DROP A;
```

---

# 14. Insert Requirements

Before inserting data:
- table must exist
- correct database must be selected
- non-nullable columns require values
- values must match domains
- values must align with listed columns

Example from the slide:

```sql
INSERT INTO Department (dept_name, building, budget)
VALUES ("Mathematics", "Palmisano", 10000);
```

---

# 15. Referential Integrity

If:

```text
instructor.dept_name = "Biology"
```

then:

```text
department.dept_name = "Biology"
```

must exist.

SQL syntax:

```sql
FOREIGN KEY (dept_name)
REFERENCES department(dept_name)
```

---

# 16. Cascading Actions

Default behavior:
- reject updates/deletes that violate referential integrity

Alternative:

```sql
ON DELETE CASCADE
ON UPDATE CASCADE
```

Other actions named:
- SET NULL
- SET DEFAULT

---

# 17. CHECK Constraints

A CHECK clause defines a predicate that every row must satisfy.

Example:

```sql
CHECK (
    semester IN ('Fall', 'Winter', 'Spring', 'Summer')
)
```

---

# Week 1 Assignment Master Checklist

## Practice Exercise 01
- [ ] Install MySQL
- [ ] Install MySQL Workbench
- [ ] Optional: install VS Code
- [ ] Optional: Python extension
- [ ] Design a database
- [ ] Follow Canvas rubric
- [ ] Submit by Saturday 11:59 PM

## Programming Assignment 01
- [ ] Create database from practice design
- [ ] Create tables
- [ ] Create ER diagram in MySQL Workbench
- [ ] Insert tuples
- [ ] Add a column
- [ ] Remove a column
- [ ] Maintain Git repository
- [ ] Add instructor as collaborator
- [ ] Submit repository link to Canvas
- [ ] Do not upload code directly to Canvas
- [ ] Submit by Monday 11:59 PM

## Quiz 01
Study:
- [ ] Databases and database applications
- [ ] Relational model
- [ ] ER diagrams
- [ ] Table design
- [ ] Database systems
- [ ] Database architecture
- [ ] Database engine
- [ ] Basic SQL
- [ ] CREATE TABLE
- [ ] INSERT
- [ ] UPDATE / table updates
- [ ] Integrity constraints
- [ ] Open book/open notes
- [ ] Due Monday 11:59 PM

---

# High-Value Quiz Facts

1. A database is a collection of interrelated data.
2. A DBMS includes data plus programs to access/manage it.
3. DBMSs support large, valuable, multi-user datasets.
4. File systems can cause redundancy and inconsistency.
5. File systems make new data-access tasks harder.
6. DBMSs support explicit integrity constraints.
7. Atomicity prevents partial transaction completion.
8. Concurrency can create inconsistent results without control.
9. Data models describe data, relationships, semantics, and constraints.
10. The relational model stores data in tables.
11. Columns are attributes.
12. Rows are tuples.
13. A domain defines allowed attribute values.
14. Relation schema describes one relation's logical structure.
15. Database schema describes the database's logical structure.
16. Database instance is a snapshot of current data.
17. Tuple order is irrelevant in a relation.
18. A superkey uniquely identifies tuples.
19. A candidate key is a minimal superkey.
20. A primary key is a chosen candidate key.
21. Every candidate key is a superkey.
22. Every table should have a primary key in the course examples.
23. Foreign keys reference keys in another relation.
24. Referential integrity requires referenced values to exist.
25. ER diagrams show entities, attributes, and relationships.
26. Primary keys are represented as underlined attributes in the shown schema diagrams.
27. Relationships can be 1:1, 1:N, or M:N.
28. MySQL Workbench can reverse engineer ER diagrams.
29. The abstraction levels are view, logical, and physical.
30. View level hides implementation detail.
31. Logical level describes what data exists and how it relates.
32. Physical level describes how data is stored.
33. Physical data independence separates physical changes from logical/application changes.
34. DDL defines schemas/structures.
35. DML manipulates/accesses data.
36. SQL is presented as declarative/nonprocedural.
37. A SQL query takes table(s) as input and produces a table.
38. MySQL runs as a database-engine service.
39. The storage manager bridges logical and physical storage.
40. The query processor parses, optimizes, and evaluates queries.
41. Query optimization chooses a low-cost execution plan.
42. Statistics about data can guide optimization.
43. Transactions are distinct units of work.
44. ACID stands for Atomicity, Consistency, Isolation, Durability.
45. Atomicity means all-or-nothing.
46. Consistency preserves valid state.
47. Isolation limits transaction interference.
48. Durability preserves committed changes.
49. `char(n)` is fixed-length text.
50. `varchar(n)` is variable-length text.
51. `numeric(p,d)` defines fixed precision/scale.
52. CREATE TABLE defines a relation and its attributes.
53. PRIMARY KEY enforces uniqueness/identity.
54. NOT NULL prevents missing values.
55. FOREIGN KEY establishes a reference.
56. CHECK constrains acceptable values.
57. INSERT adds tuples.
58. DELETE removes tuples.
59. DROP TABLE removes a relation definition.
60. ALTER TABLE changes schema.
61. ON DELETE/UPDATE CASCADE propagates referenced-key changes.
62. Practice is 10% of the course grade.
63. Projects are 60%.
64. Quizzes are 10%.
65. Final exam is 20%.
66. Late work loses 5% per full day unless arrangements are made.
67. Week 1 Practice is due Saturday 11:59 PM.
68. Week 1 Quiz is due Monday 11:59 PM.
69. Week 1 Programming Assignment is due Monday 11:59 PM.
70. Next Week is Basic SQL.


---
# Complete Visual Inventory

- **Slide 1: CSC6302 - Database Principles** — Minimal course-title slide with large blue CSC6302 / Database Principles text, Week 1 and instructor name Wendy-Beth Minton, plus Silberschatz/Korth/Sudarshan and *Database System Concepts – 7th Edition* attribution.

- **Slide 2: Course Introduction** — Text-only section-introduction slide headed Course Introduction.

- **Slide 3: Course Format** — Text-only course-format slide listing weekly live sessions, office hours, graded work, and instructor contact information.

- **Slide 4: Course Format** — Text-only course-format slide describing practice, quizzes, the final exam, optional attendance, and optional webcam use.

- **Slide 5: Course Format** — Text-heavy programming-project policy slide covering Python/Java choice, README requirements, OS/MySQL versions, Git repository collaboration, and the instruction not to upload code directly to Canvas.

- **Slide 6: Evaluation** — Evaluation slide with a four-row grading-weight table: Practice 10%, Projects 60%, Quizzes 10%, Final Exam 20%, totaling 100%.

- **Slide 7: Evaluation** — Evaluation slide with a color-free letter-grade table ranging from A (95+) through F (69.9 and below), plus graduate-program grading notes.

- **Slide 8: Using AI, YES! However...** — Text-only AI-use policy slide. It permits limited generative-AI support for concept/error explanations, tutoring, syntax/code understanding, and test-data generation, while emphasizing disclosure, code ownership, executability, and human-readable documentation.

- **Slide 9: Agenda** — Agenda slide listing the Week 1 database-system, relational-model, ER-diagram, architecture, engine, SQL, and integrity-constraint topics.

- **Slide 10: Recommended Reading** — Recommended-reading slide listing textbook chapters/sections. A small image of the *Database System Concepts* textbook appears at lower-right, with attribution to Silberschatz, Korth, and Sudarshan.

- **Slide 11: Database Systems** — Section-divider slide titled Database Systems with a C. J. Date quote about representing database information as explicit values in rows and columns.

- **Slide 12: Database Management System** — Text-only DBMS definition slide describing interrelated data, access programs, multi-user access, scale, and convenience/efficiency.

- **Slide 13: Database Application Examples** — Text-only list of enterprise, banking, finance, manufacturing, and university database applications.

- **Slide 14: Database Application Examples** — Text-only continuation listing airline, telecom, online retail, advertising, document, navigation, medical-record, social-media, and game/application databases.

- **Slide 15: Purpose of Database Systems** — Text-only slide listing file-system-era problems: redundancy, inconsistency, difficult access, isolation, and buried integrity constraints.

- **Slide 16: Purpose of Database Systems** — Text-only continuation covering atomicity, concurrent-access anomalies, security problems, and the claim that DBMSs address these problems.

- **Slide 17: View of Data** — Text-only slide introducing data models and data abstraction as tools for describing and hiding data complexity.

- **Slide 18: The Relational Model** — Section-divider slide titled The Relational Model, with an Ackoff quote about information gaining meaning through relational connection.

- **Slide 19: Data Models** — Text-only slide defining data models as tools for describing data, relationships, semantics, constraints, and ER design.

- **Slide 20: University Database Example** — Text-only university-database example listing students, instructors, classes, registration, rosters, grades, GPA, and transcripts.

- **Slide 21: Relational Model** — Relational-model slide with a sample instructor table labeled with arrows for columns and rows. A small portrait of E. F. 'Ted' Codd appears at lower-right with 'Turing Award 1981'.

- **Slide 22: A Simple Relational Database** — Diagram slide showing two related relational tables: an instructor table and a department table, illustrating a simple relational database.

- **Slide 23: Relation Schema and Instance** — Text-only schema/instance slide defining attributes, domains, atomic values, and ACID: Atomicity, Consistency, Isolation, Durability.

- **Slide 24: Relation Schema and Instance** — Text-only slide defining relation schema, table instance, and tuple, using instructor(ID, name, dept_name, salary) as the example.

- **Slide 25: Relations Are Unordered** — Relational table image showing the instructor relation with rows in a different order to emphasize that relations are unordered.

- **Slide 26: Relations Have a Schema** — Text plus instructor-table image demonstrating relation schema, database schema, and a database instance as a snapshot.

- **Slide 27: Instances and Schema** — Text-only slide comparing logical schema, physical schema, and instance to programming-language types and variable values.

- **Slide 28: Integrity Constraints (Or Keys)** — Text-only key slide introducing superkeys, candidate keys, minimality, and primary-key selection using instructor ID.

- **Slide 29: Integrity Constraints (Or Keys)** — Text-only key slide defining primary keys and foreign keys and distinguishing referencing vs referenced relations.

- **Slide 30: Identifying the Primary Key** — Instructor-table image next to a three-step key-selection process: enumerate superkeys, identify candidate keys, then choose one primary key.

- **Slide 31: Identifying the Primary Key** — Text-only enumeration of the 15 non-empty superkey combinations for a four-column instructor relation.

- **Slide 32: Identifying the Primary Key** — Instructor-table image beside a reduced candidate-key list, ending with ID selected as the primary key.

- **Slide 33: Entity Relational (ER) Diagram** — Section-divider slide titled Entity Relational (ER) Diagram with a Rich Hickey quote and a transition question about communicating interconnected relations.

- **Slide 34: Schema Diagram for University Database** — Full university schema diagram. It contains entities/relations including student, instructor, department, course, section, classroom, time_slot, takes, teaches, advisor, and prereq. Arrows show foreign-key references among these relations; underlined attributes mark key fields.

- **Slide 35: ER Diagram** — Text-only ER-diagram fundamentals slide: entities, attributes, primary keys, rectangles for entities, and underlined primary-key text.

- **Slide 36: ER Diagram** — Text-only ER relationships/cardinality slide covering one-to-one, one-to-many, many-to-many, and arrowheads from referencing to referenced relations.

- **Slide 37: ER Diagram in MySQL Workbench** — Text-only MySQL Workbench ER-diagram slide explaining reverse engineering, 'Connect to Columns', and the requirement that class databases and student submissions include ER diagrams.

- **Slide 38: Database Architecture** — Section-divider slide titled Database Architecture introducing interaction with an existing database.

- **Slide 39: Levels of Abstraction** — Text-only three-level abstraction slide defining physical, logical, and view levels and noting that views can hide sensitive or audience-irrelevant information.

- **Slide 40: Application** — Large application-layers architecture diagram. At the top are users and tools in the View layer; the middle Logical layer contains application programs, DML queries/compiler/organizer, DDL interpreter, and query evaluation; the lower Physical layer contains storage-manager components and disk structures such as data, indices, data dictionary, and statistical data.

- **Slide 41: Encapsulation and Abstraction** — Text-only slide connecting encapsulation and abstraction to physical data independence and well-defined interfaces between layers.

- **Slide 42: View Level** — Section-divider slide titled View Level.

- **Slide 43: View Level** — Three-tier abstraction diagram with multiple boxes labeled view 1, view 2, …, view n above logical level and physical level. Bullets map views to an application, web application, and mobile application.

- **Slide 44: View Level** — Text-only View Level slide describing it as the highest abstraction level, customizable, security/role/paywall aware, and the layer users directly see.

- **Slide 45: Logic Level** — Section-divider slide titled Logic Level.

- **Slide 46: What Do We Mean by Logical Level** — Text-only logical-level slide emphasizing database design, tables, attributes, keys/constraints, queries, stored procedures, and functions; it states the course is very focused on this level.

- **Slide 47: Data Definition Language (DDL)** — DDL slide with the instructor relation CREATE TABLE example; it defines DDL as notation for creating databases/tables, attributes/domains, and constraints.

- **Slide 48: Data Definition Language (DDL)** — Text-only DDL compiler/data-dictionary slide describing metadata, schema, integrity constraints, primary key, and authorization.

- **Slide 49: Data Manipulation Language (DML)** — DML slide defining procedural vs declarative DML and calling DML the query language for accessing/updating data.

- **Slide 50: Data Manipulation Language (DML)** — Text-only continuation explaining declarative/non-procedural DML and query-language terminology.

- **Slide 51: SQL Query Language** — Text-only SQL Query Language slide: SQL is nonprocedural, takes one or more tables as input, produces a table as output, is not Turing-machine equivalent, and is generally embedded in higher-level languages.

- **Slide 52: Database Engine** — Text-only Database Engine slide locating MySQL at the logical layer and naming the storage manager, query processor, and transaction manager.

- **Slide 53: Storage Manager** — Text-only Storage Manager slide listing OS interaction, efficient storage/retrieval/update, authorization/integrity manager, transaction manager, file manager, and buffer manager.

- **Slide 54: Storage Manager Continued** — Text-only storage-manager continuation listing data files, data dictionary, and indices as physical implementation structures.

- **Slide 55: Query Processor** — Text-only Query Processor slide defining the DDL interpreter, DML compiler/optimizer, and query evaluation engine.

- **Slide 56: Query Processing** — Query-processing flow diagram: query → parser/translator → relational-algebra expression → optimizer → execution plan → evaluation engine → query output. Data stores feed the evaluation engine, while statistics about data feed the optimizer. The slide labels the three phases: parsing/translation, optimization, evaluation.

- **Slide 57: Transaction Manager** — Text-only transaction-management introduction using a shared bank account to explain that read/write ordering matters.

- **Slide 58: Transaction Manager** — Text-only paired bank-account scenarios comparing concurrent decisions from a $500 balance with a serialized sequence that prevents an overdraft.

- **Slide 59: ACID** — Four-panel ACID infographic: Atomicity ('every transaction is committed entirely'), Consistency ('data remains consistent after a transaction is completed'), Isolation ('transactions occur independently without interference'), Durability ('completed transactions are permanently recorded').

- **Slide 60: Physical Level** — Section-divider slide titled Physical Level.

- **Slide 61: Physical Level** — Physical-level slide with a storage hierarchy diagram from cache → main memory → flash memory → magnetic disk → optical disk → magnetic tapes, alongside examples of local, cloud, server, virtual-machine, RAID, remote, and cloud storage.

- **Slide 62: Physical Level** — Text-only continuation explaining that the storage manager uses physical storage characteristics for query optimization and that primary storage such as RAM is faster than secondary storage.

- **Slide 63: Basic SQL** — Section-divider slide titled Basic SQL with a Joe Celko quote about information/data/databases.

- **Slide 64: Creating a Database in SQL** — Text-only workflow slide: design database → create database → create SQL script/tables → insert data → query data.

- **Slide 65: Domain Types in SQL** — Text-only SQL domain-types slide defining char(n), varchar(n), int, smallint, numeric(p,d), real/double precision, and float(n).

- **Slide 66: Schema Definition** — Text-only schema-definition slide showing the compact notation TableName(column type, …), with Department(dept_Name varchar(20), building varchar(15), budget numeric) as the example.

- **Slide 67: Create Table** — Text-only CREATE TABLE syntax slide with the generic create-table grammar and the instructor(ID, name, dept_name, salary) example.

- **Slide 68: Create Table Note** — Text-only Create Table Note slide showing CREATE TABLE IF NOT EXISTS Department(...), a positive-budget CHECK constraint, and a primary key on dept_name.

- **Slide 69: Integrity Constraints in Create Table** — Text-only integrity-constraint CREATE TABLE example using NOT NULL, PRIMARY KEY(ID), and FOREIGN KEY(dept_name) REFERENCES department.

- **Slide 70: Schema Diagram for University Database** — Repeat of the full University Database schema diagram used earlier, again showing student, instructor, department, course, section, classroom, time_slot, takes, teaches, advisor, and prereq relationships.

- **Slide 71: Updates to a Table** — Text-only update-operations slide showing INSERT, DELETE, DROP TABLE, ALTER TABLE ADD, and ALTER TABLE DROP syntax.

- **Slide 72: Important Inserting Note** — Text-only insertion-notes slide emphasizing non-nullable columns, column order/domains, existing table/database context, and example INSERT INTO Department statements.

- **Slide 73: Integrity Constraints** — Section-divider slide titled Integrity Constraints with a Rich Hickey quote.

- **Slide 74: Referential Integrity** — Text-only Referential Integrity slide defining foreign keys formally and using Biology in instructor/department as the example.

- **Slide 75: Referential Integrity Continued** — Text-only continuation showing FOREIGN KEY(dept_name) REFERENCES department and explicit referenced-column syntax.

- **Slide 76: Cascading Actions and Referential Integrity** — Text-only cascading-actions slide showing ON DELETE CASCADE / ON UPDATE CASCADE and alternatives SET NULL / SET DEFAULT.

- **Slide 77: The Check Clause** — Text-only CHECK-clause slide with a section table example restricting semester to Fall, Winter, Spring, or Summer.

- **Slide 78: This Week's tasks** — Week 1 task-summary slide listing Practice Problem #1, Programming Project #1, and Quiz #1.

- **Slide 79: Practice Exercise 01** — Text-only Practice Exercise 01 slide: install MySQL and MySQL Workbench, optionally VS Code/Python extension, then design a database; details/rubric are in Canvas.

- **Slide 80: Programming Assignment 01** — Text-only Programming Assignment 01 slide: write SQL to create the practice database/tables, create an ER diagram in MySQL Workbench, insert tuples, add a column, and remove a column.

- **Slide 81: Quiz 01** — Text-only Quiz 01 slide listing Week 1 topics from database applications through integrity constraints and stating that the Canvas quiz is open book/open notes.

- **Slide 82: Check out recommended texts and videos!** — Closing slide with a due-date table: Practice Saturday 11:59 PM; Quiz Monday 11:59 PM; Programming Assignment Monday 11:59 PM. It also says to check recommended texts/videos and previews Next Week – Basic SQL.


---
# End of CSC 6302 Week 1 Super-Detailed Conversion

All **82 slides** are represented above in original order, including course policy, database-system motivation, relational tables, key-selection examples, ER/schema diagrams, abstraction-layer architecture, query-processing and ACID diagrams, SQL syntax, referential-integrity rules, and Week 1 graded tasks.
