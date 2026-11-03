CSC6302 EXERCISE 1
FAMILY SPOOKY VACATION DATABASE

SUBMISSION GUIDE

This package contains the required CSC6302 Exercise 1 work and a separate optional application extension.


FILE TO GRADE

Please open and grade:

CSC6302_e1_assignmentonly.pdf

This file contains only the required exercise material.

A second document is also included:

CSC6302_e1_optional version.pdf

The optional version contains the same required assignment followed by the Paranormal Expedition Mode extension.

Content appearing after the heading:

END OF REQUIRED EXERCISE

is included only as an additional demonstration and does not need to be graded.


============================================================
REQUIRED DATABASE FILES
============================================================

The database folder contains the MySQL files used for the required exercise.

database\schema.sql

Creates the FamilySpookyVacation database and core relations.


database\seed.sql

Adds the sample family, destinations, activities, and packing data.


database\queries.sql

Contains queries used to retrieve information from the completed structure.


database\tests.sql

Contains deliberate constraint tests used to verify keys, references, checks, and other integrity rules.


The required database can be recreated by running:

1. database\schema.sql
2. database\seed.sql

queries.sql and tests.sql are provided for demonstration and verification.


============================================================
EER DIAGRAMS
============================================================

The diagrams folder contains standalone copies of the database diagrams for easier viewing.

The required EER diagram represents the original Family Spooky Vacation Database.

The second diagram shows the larger optional Paranormal Expedition Mode extension and its connections to the core relations.


============================================================
OPTIONAL PARANORMAL EXPEDITION MODE
============================================================

Paranormal Expedition Mode is a separate application built on top of the required database.

It is included only as an optional demonstration and does not need to be graded as part of the required exercise.


============================================================
RUNTIME REQUIREMENTS
============================================================

The application was developed and tested with:

Operating System:
Windows 11

Java Development Kit:
Java 21

Database Server:
MySQL Server 8.0.46

JDBC Driver:
MySQL Connector/J 9.7.0

Database Administration:
MySQL Workbench

Code Editor:
Visual Studio Code

Browser:
Any modern web browser

Local Application Port:
8080


The Connector/J library is included in:

optional_game\lib\


MySQL Workbench is useful for loading and inspecting the database, but it is not required while the application is running.


The game requires:

Java 21
+
MySQL Server
+
MySQL Connector/J
+
Web Browser


============================================================
PREPARING THE GAME DATABASE
============================================================

The core FamilySpookyVacation database must be created before loading the optional game extension.

Run the following SQL files in this order:

1. database\schema.sql

2. database\seed.sql

3. optional_game\database\game_schema.sql

4. optional_game\database\game_seed.sql

5. optional_game\database\game_views.sql

6. optional_game\database\game_procedures.sql


The optional application uses the same FamilySpookyVacation schema as the required exercise.


============================================================
STARTING THE GAME
============================================================

Open PowerShell or another terminal in the root directory of the extracted submission package.


STEP 1 - CHECK JAVA

Run:

java -version

javac -version


Java 21 should be available.


STEP 2 - CREATE THE JAVA BIN DIRECTORY

PowerShell:

New-Item -ItemType Directory -Force ".\optional_game\java\bin"


STEP 3 - COMPILE THE JAVA SERVER

PowerShell:

javac --add-modules jdk.httpserver -cp ".\optional_game\lib\mysql-connector-j-9.7.0.jar" -d ".\optional_game\java\bin" ".\optional_game\java\src\GameServer.java"


STEP 4 - START THE APPLICATION

PowerShell:

java --add-modules jdk.httpserver -cp ".\optional_game\java\bin;.\optional_game\lib\mysql-connector-j-9.7.0.jar" GameServer


The application will request the password for the local MySQL root account.

After a successful connection, open the following address in a web browser:

http://localhost:8080/


============================================================
APPLICATION FLOW
============================================================

Browser Interface
        |
        v
Java HTTP Server
        |
        v
JDBC
        |
        v
MySQL Server
        |
        v
Stored Procedures, Views, and Relations


The browser interface does not connect directly to MySQL.

Java receives requests from the browser and communicates with the database through JDBC.


============================================================
STOPPING THE GAME
============================================================

Return to the terminal running GameServer and press:

Ctrl + C

This stops the local Java HTTP server.


============================================================
PACKAGE STRUCTURE
============================================================

CSC6302_Exercise1_KeownWhite_Source
|
|-- README.txt
|
|-- CSC6302_e1_assignmentonly.pdf
|
|-- CSC6302_e1_optional version.pdf
|
|-- database
|   |
|   |-- schema.sql
|   |-- seed.sql
|   |-- queries.sql
|   `-- tests.sql
|
|-- diagrams
|   |
|   |-- Required EER Diagram
|   `-- Optional Game EER Diagram
|
`-- optional_game
    |
    |-- database
    |   |
    |   |-- game_schema.sql
    |   |-- game_seed.sql
    |   |-- game_views.sql
    |   `-- game_procedures.sql
    |
    |-- java
    |   |
    |   `-- src
    |       |
    |       `-- GameServer.java
    |
    |-- lib
    |   |
    |   `-- mysql-connector-j-9.7.0.jar
    |
    `-- frontend
        |
        `-- index.html


============================================================
ADDITIONAL NOTES
============================================================

The optional application does not require:

Node.js
Docker
Tomcat
React
Maven
Gradle
A separate web server
A Java application framework


The required assignment can be reviewed directly from:

CSC6302_e1_assignmentonly.pdf


The optional version can be reviewed from:

CSC6302_e1_optional version.pdf


Only the material before the heading:

END OF REQUIRED EXERCISE

is part of the required graded work.