# Optional Extension: Paranormal Expedition Mode

This extension is not part of the required grading criteria.

It reuses the completed Family Spooky Vacation Database to demonstrate how the same normalized data can support an interactive application.

The graded core remains independently complete.

---

# 1. Extension Architecture

Let:

DC = graded core vacation database

DG = optional hidden game layer

Complete system:

D = DC U DG

Dependency direction:

DG -> DC

The game may reference the core database.

The core database must not depend on game data.

---

# 2. Identity Rule

Family members become players through their existing MemberID.

No player name is duplicated.

Example:

GAME_PLAYER.MemberID
    ->
FAMILY_MEMBER.MemberID

The player's displayed name is retrieved from FAMILY_MEMBER.

Therefore:

MemberName is stored only once.

---

# 3. Game Premise

The family begins a spooky vacation.

When Paranormal Expedition Mode is activated, the same family members become game players.

One player secretly begins with a fictional infection.

The objective is to identify the original infected player before the game reaches its terminal state.

The infection model is fictional and exists only as application/game state.

---

# 4. Session Rules

GR-01:
Every game has one unique SessionID.

GR-02:
A session has a current turn.

GR-03:
A session has one game status.

Possible statuses:

- READY
- ACTIVE
- WON
- LOST
- ENDED

GR-04:
Only ACTIVE sessions may advance turns.

GR-05:
Each participating family member may appear only once in a given game session.

---

# 5. Player Rules

GR-06:
Every game player must reference an existing FAMILY_MEMBER.

GR-07:
A family member may participate in multiple game sessions.

GR-08:
A player starts with a score of zero.

GR-09:
A player's score may increase or decrease through recorded game events.

GR-10:
PlayerStatus must come from a defined set.

Possible values:

- ACTIVE
- SUSPECTED
- CLEARED
- REMOVED

---

# 6. Infection Rules

GR-11:
Exactly one player begins each game as Patient Zero.

Formally:

Sum(PatientZero) = 1 per SessionID

GR-12:
Patient Zero has no infection source.

GR-13:
A later infected player must reference another player from the same session as the source.

GR-14:
A player cannot infect themselves.

GR-15:
The infection source must have become infected earlier than the recipient.

GR-16:
The hidden infection truth must not be exposed directly through the normal player-facing interface.

---

# 7. Contact Rules

GR-17:
A contact event involves two different players.

GR-18:
Both players must belong to the same game session.

GR-19:
A contact event occurs at a valid VACATION_SITE.

GR-20:
Every contact event belongs to one turn.

GR-21:
A player cannot have a contact event with themselves.

Formal rule:

PlayerA != PlayerB

---

# 8. Symptom Rules

GR-22:
Symptoms are fictional game clues.

GR-23:
A symptom event belongs to one player and one session.

GR-24:
A symptom has an appearance turn.

GR-25:
A symptom may be discovered on the same turn or a later turn.

Therefore:

DiscoveredTurn >= AppearanceTurn

GR-26:
Earlier discovery can produce more points.

---

# 9. Scoring Rules

For symptom s:

DetectionDelay = DiscoveredTurn - AppearanceTurn

Possible scoring model:

Points(s) = max(0, MaxPoints - k * DetectionDelay)

Where:

MaxPoints = maximum clue score

k = delay penalty per turn

Points are recorded as events rather than stored only as one final total.

Player total:

TotalScore(p) = sum(ScoreEvent.Points)

This allows the score history to remain auditable.

---

# 10. Deduction Rules

Let P be the set of possible suspects.

Initial candidate set:

C0 = P

Each valid clue may eliminate impossible candidates:

C(n+1) = Cn - En

where:

En = candidates eliminated by clue n

If:

|Cn| = 1

then the remaining player is uniquely determined.

Possible game result:

DEDUCIBLE

If:

|Cn| > 1

then the current evidence is insufficient.

Possible game result:

AMBIGUOUS

---

# 11. State-Machine Concept

Possible player infection states:

HEALTHY
EXPOSED
LATENT
SYMPTOMATIC
CRITICAL
REMOVED

State transitions must follow defined game rules.

Example:

HEALTHY -> EXPOSED
EXPOSED -> LATENT
LATENT -> SYMPTOMATIC

Illegal transitions should be rejected by application logic or validation tests.

---

# 12. CSC6033 Integration

Possible use of previous course concepts:

## Finite-State Machines

Control legal infection/game transitions.

## Recursion

Trace an infection source backward toward Patient Zero.

## Graphs

Represent contact or infection relationships.

## Matrices

Represent player-to-player contacts.

## Dot Products

Calculate weighted suspicion scores from discovered clues.

## Enums

Represent controlled state categories in Java.

## Classes

Represent sessions, players, events, and game-state objects.

## Cycle Detection

Reject impossible infection graphs.

---

# 13. Database Design Rule

The hidden game layer must not duplicate:

- family names
- vacation-site names
- activity names
- packing-item names

Instead, it references the existing core identifiers:

- MemberID
- SiteID
- ActivityID
- ItemID

---

# 14. First Proposed Game Relations

Do not implement yet.

Candidate relations:

GAME_SESSION

GAME_PLAYER

CONTACT_EVENT

SYMPTOM_EVENT

SCORE_EVENT

INFECTION_STATE

These remain provisional until functional dependencies and candidate keys are proven.


# 15. GAME_SESSION Relation

Proposed relation:

GAME_SESSION(
    SessionID,
    StartedAt,
    CurrentTurn,
    GameStatus
)

## Functional Dependency

SessionID -> StartedAt, CurrentTurn, GameStatus

## Candidate Key

{SessionID}

Closure:

{SessionID}+ =
{
    SessionID,
    StartedAt,
    CurrentTurn,
    GameStatus
}

Therefore:

{SessionID}+ = GAME_SESSION

So:

Candidate Key = {SessionID}

Primary Key:

SessionID

## Constraints

SessionID:
INT UNSIGNED
PRIMARY KEY
AUTO_INCREMENT

StartedAt:
DATETIME
NOT NULL
DEFAULT CURRENT_TIMESTAMP

CurrentTurn:
INT UNSIGNED
NOT NULL
DEFAULT 0

GameStatus:
VARCHAR(10)
NOT NULL
DEFAULT 'READY'

CHECK (
    GameStatus IN (
        'READY',
        'ACTIVE',
        'WON',
        'LOST',
        'ENDED'
    )
)

CHECK (CurrentTurn >= 0)

## Formal Superkeys

n = 4
k = 1

Number of superkeys:

2^(4-1) = 8

Superkeys:

1. {SessionID}
2. {SessionID, StartedAt}
3. {SessionID, CurrentTurn}
4. {SessionID, GameStatus}
5. {SessionID, StartedAt, CurrentTurn}
6. {SessionID, StartedAt, GameStatus}
7. {SessionID, CurrentTurn, GameStatus}
8. {SessionID, StartedAt, CurrentTurn, GameStatus}

## Normalization

SessionID determines every non-key attribute.

No partial dependency exists.

No transitive dependency is assumed.

Therefore:

GAME_SESSION satisfies BCNF.

---

# 16. GAME_PLAYER Relation

Proposed relation:

GAME_PLAYER(
    SessionID,
    MemberID,
    Score,
    PlayerStatus
)

Purpose:

Connect an existing family member to a particular game session without duplicating their name or other core information.

## Functional Dependency

{SessionID, MemberID} -> Score, PlayerStatus

## Candidate Key

{SessionID, MemberID}

Closure:

{SessionID, MemberID}+ =
{
    SessionID,
    MemberID,
    Score,
    PlayerStatus
}

Therefore:

Candidate Key = {SessionID, MemberID}

Primary Key:

{SessionID, MemberID}

## Minimality

{SessionID}+ != GAME_PLAYER

{MemberID}+ != GAME_PLAYER

Therefore the composite key is minimal.

## Constraints

SessionID:
INT UNSIGNED
NOT NULL

MemberID:
INT UNSIGNED
NOT NULL

Score:
INT
NOT NULL
DEFAULT 0

PlayerStatus:
VARCHAR(10)
NOT NULL
DEFAULT 'ACTIVE'

PRIMARY KEY (
    SessionID,
    MemberID
)

FOREIGN KEY (SessionID)
REFERENCES GAME_SESSION(SessionID)

FOREIGN KEY (MemberID)
REFERENCES FAMILY_MEMBER(MemberID)

CHECK (
    PlayerStatus IN (
        'ACTIVE',
        'SUSPECTED',
        'CLEARED',
        'REMOVED'
    )
)

## Formal Superkeys

n = 4
k = 2

Number of superkeys:

2^(4-2) = 4

Superkeys:

1. {SessionID, MemberID}
2. {SessionID, MemberID, Score}
3. {SessionID, MemberID, PlayerStatus}
4. {SessionID, MemberID, Score, PlayerStatus}

## Normalization

Score and PlayerStatus depend on the full composite key.

Neither:

SessionID -> Score, PlayerStatus

nor:

MemberID -> Score, PlayerStatus

holds globally.

Therefore:

GAME_PLAYER satisfies 2NF.

No transitive dependency exists under the current rules.

The determinant of the nontrivial dependency is a candidate key.

Therefore:

GAME_PLAYER satisfies BCNF.

---

# 17. Core-to-Game Relationship

The game does not duplicate MemberName.

Instead:

GAME_PLAYER.MemberID
    ->
FAMILY_MEMBER.MemberID

Therefore:

FAMILY_MEMBER
    1
    |
    |
    N
GAME_PLAYER

and:

GAME_SESSION
    1
    |
    |
    N
GAME_PLAYER

GAME_PLAYER is an associative relation between:

GAME_SESSION
and
FAMILY_MEMBER

This allows one family member to participate in many game sessions while appearing only once in the core vacation database.


# 18. INFECTION_STATE Relation

Purpose:

INFECTION_STATE stores the hidden game truth for each player.

This relation is not intended to be directly exposed through the normal player-facing interface.

Proposed relation:

INFECTION_STATE(
    SessionID,
    MemberID,
    InfectionStatus,
    InfectionTurn,
    InfectedByMemberID,
    PatientZero
)

---

# 19. Functional Dependencies

Primary dependency:

{SessionID, MemberID}
    ->
InfectionStatus,
InfectionTurn,
InfectedByMemberID,
PatientZero

A player's infection state is specific to one game session.

The same family member may have completely different infection states in different sessions.

---

# 20. Candidate Key

Candidate key:

{SessionID, MemberID}

Closure:

{SessionID, MemberID}+ =
{
    SessionID,
    MemberID,
    InfectionStatus,
    InfectionTurn,
    InfectedByMemberID,
    PatientZero
}

Therefore:

{SessionID, MemberID}+ = INFECTION_STATE

So:

Candidate Key = {SessionID, MemberID}

Primary Key:

{SessionID, MemberID}

---

# 21. Minimality

SessionID alone cannot identify one player's infection state.

MemberID alone cannot identify one infection state because the same family member may participate in multiple sessions.

Therefore:

{SessionID}+ != INFECTION_STATE

{MemberID}+ != INFECTION_STATE

The composite key is minimal.

---

# 22. Proposed Data Types

SessionID:

INT UNSIGNED
NOT NULL

MemberID:

INT UNSIGNED
NOT NULL

InfectionStatus:

VARCHAR(15)
NOT NULL
DEFAULT 'HEALTHY'

InfectionTurn:

INT UNSIGNED
NULL

InfectedByMemberID:

INT UNSIGNED
NULL

PatientZero:

BOOLEAN
NOT NULL
DEFAULT FALSE

---

# 23. Infection-State Domain

Allowed InfectionStatus values:

- HEALTHY
- EXPOSED
- LATENT
- SYMPTOMATIC
- CRITICAL
- REMOVED

Possible CHECK constraint:

CHECK (
    InfectionStatus IN (
        'HEALTHY',
        'EXPOSED',
        'LATENT',
        'SYMPTOMATIC',
        'CRITICAL',
        'REMOVED'
    )
)

---

# 24. Referential Integrity

The player whose state is being stored must exist in GAME_PLAYER.

Composite foreign key:

FOREIGN KEY (
    SessionID,
    MemberID
)
REFERENCES GAME_PLAYER(
    SessionID,
    MemberID
)

The infection source must also be a player in the same session.

Conceptually:

{
    SessionID,
    InfectedByMemberID
}
    ->
GAME_PLAYER(
    SessionID,
    MemberID
)

This prevents one game session from claiming that a player was infected by somebody who does not participate in that session.

---

# 25. Self-Infection Rule

A player cannot infect themselves.

When InfectedByMemberID is present:

MemberID != InfectedByMemberID

Possible CHECK:

CHECK (
    InfectedByMemberID IS NULL
    OR MemberID <> InfectedByMemberID
)

---

# 26. Patient Zero Rule

Patient Zero has no infection source.

Therefore:

PatientZero = TRUE
    ->
InfectedByMemberID IS NULL

Patient Zero begins infected at the initial game state.

For the game model:

PatientZero = TRUE
    ->
InfectionTurn = 0

Possible row-level CHECK:

CHECK (
    PatientZero = FALSE
    OR (
        InfectedByMemberID IS NULL
        AND InfectionTurn = 0
    )
)

---

# 27. Exactly One Patient Zero

Game rule:

Exactly one player must be Patient Zero in every session.

Formally:

For every session s:

SUM(PatientZero WHERE SessionID = s) = 1

This is a multi-row rule.

A normal row-level CHECK constraint cannot guarantee this requirement because the rule depends on other rows within the same session.

Therefore, this rule will be enforced when the game session is initialized through:

- stored procedure logic, or
- Java application logic

and verified with database tests.

This distinction is intentional.

---

# 28. Infection Chronology Rule

If player B was infected by player A:

InfectionTurn(A) < InfectionTurn(B)

Formally:

InfectedBy(B, A)
    ->
Turn(A) < Turn(B)

This rule compares multiple rows.

Therefore it cannot be fully enforced by a simple CHECK constraint on one tuple.

It will be verified by:

- game-engine validation
- SQL validation queries
- optional trigger/procedure logic

---

# 29. Formal Superkeys

Relation:

INFECTION_STATE(
    SessionID,
    MemberID,
    InfectionStatus,
    InfectionTurn,
    InfectedByMemberID,
    PatientZero
)

Total attributes:

n = 6

Candidate-key attributes:

k = 2

Assuming this is the only candidate key:

Number of formal superkeys:

2^(n-k)

= 2^(6-2)

= 2^4

= 16

Every formal superkey must contain:

{SessionID, MemberID}

The complete enumeration will be generated later if this relation is included in the optional documentation.

---

# 30. Normalization

Primary dependency:

{SessionID, MemberID}
    ->
InfectionStatus,
InfectionTurn,
InfectedByMemberID,
PatientZero

All non-key attributes depend on the complete composite candidate key.

No partial dependency exists.

No non-key attribute is assumed to determine another non-key attribute.

Therefore:

INFECTION_STATE satisfies 1NF.

INFECTION_STATE satisfies 2NF.

INFECTION_STATE satisfies 3NF.

Under the current functional dependencies:

INFECTION_STATE satisfies BCNF.

---

# 31. Hidden-Truth Boundary

INFECTION_STATE belongs to the game engine.

Normal players should not directly query:

- PatientZero
- InfectedByMemberID
- undiscovered infection state

Instead, players interact with evidence generated from the hidden truth.

Visible evidence will be stored separately in relations such as:

CONTACT_EVENT

SYMPTOM_EVENT

SCORE_EVENT

This creates two conceptual layers:

HIDDEN TRUTH
      |
      v
OBSERVABLE EVIDENCE
      |
      v
PLAYER DEDUCTION


# 32. CONTACT_EVENT Relation

Purpose:

CONTACT_EVENT records interactions between two game players at a vacation site during a specific turn.

These records form the observable contact graph used by the deduction system.

Proposed relation:

CONTACT_EVENT(
    ContactEventID,
    SessionID,
    TurnNumber,
    PlayerAID,
    PlayerBID,
    SiteID
)

---

# 33. Contact Identity

Each recorded contact receives a generated identifier:

ContactEventID

Primary functional dependency:

ContactEventID
    ->
SessionID,
TurnNumber,
PlayerAID,
PlayerBID,
SiteID

Therefore:

{ContactEventID}

is a candidate key.

A second natural identifier is also defined by the game rules:

{
    SessionID,
    TurnNumber,
    PlayerAID,
    PlayerBID,
    SiteID
}

The game assumes the same pair of players can have only one recorded contact event at the same site during the same turn.

Therefore:

{
    SessionID,
    TurnNumber,
    PlayerAID,
    PlayerBID,
    SiteID
}
    ->
ContactEventID

This gives CONTACT_EVENT two candidate keys.

Candidate Key 1:

{ContactEventID}

Candidate Key 2:

{
    SessionID,
    TurnNumber,
    PlayerAID,
    PlayerBID,
    SiteID
}

Primary Key:

{ContactEventID}

Alternate Candidate Key:

{
    SessionID,
    TurnNumber,
    PlayerAID,
    PlayerBID,
    SiteID
}

The generated identifier is selected as the primary key because it remains small, stable, and convenient for other game relations to reference.

---

# 34. Proposed Data Types

ContactEventID:

BIGINT UNSIGNED
AUTO_INCREMENT
PRIMARY KEY

SessionID:

INT UNSIGNED
NOT NULL

TurnNumber:

INT UNSIGNED
NOT NULL

PlayerAID:

INT UNSIGNED
NOT NULL

PlayerBID:

INT UNSIGNED
NOT NULL

SiteID:

INT UNSIGNED
NOT NULL

---

# 35. Player Referential Integrity

Both participants must exist as players in the same session.

Foreign key 1:

FOREIGN KEY (
    SessionID,
    PlayerAID
)
REFERENCES GAME_PLAYER(
    SessionID,
    MemberID
)

Foreign key 2:

FOREIGN KEY (
    SessionID,
    PlayerBID
)
REFERENCES GAME_PLAYER(
    SessionID,
    MemberID
)

Using SessionID in both foreign keys prevents a contact from referencing a player from another game session.

---

# 36. Vacation-Site Integration

Every contact occurs at a valid vacation destination.

Foreign key:

FOREIGN KEY (SiteID)
REFERENCES VACATION_SITE(SiteID)

This directly reuses the graded core database.

No duplicate site name or location is stored in CONTACT_EVENT.

---

# 37. No Self-Contact

A player cannot have a contact event with themselves.

Required rule:

PlayerAID != PlayerBID

A stronger canonical-order rule will be used:

PlayerAID < PlayerBID

Possible CHECK:

CHECK (
    PlayerAID < PlayerBID
)

This accomplishes two goals:

1. prevents self-contact;
2. prevents reversed duplicates.

For example:

(1, 3)

is allowed.

(3, 1)

is not stored as a separate representation of the same contact.

---

# 38. Alternate Candidate-Key Constraint

The natural candidate key is enforced with:

UNIQUE (
    SessionID,
    TurnNumber,
    PlayerAID,
    PlayerBID,
    SiteID
)

This prevents duplicate recording of the same contact event.

---

# 39. Turn Validation

A contact cannot occur before the game begins.

Therefore:

TurnNumber > 0

Possible CHECK:

CHECK (TurnNumber > 0)

A stronger rule is:

TurnNumber <= GAME_SESSION.CurrentTurn

This rule requires comparison with another relation.

Therefore it cannot be fully enforced using an ordinary row-level CHECK.

It will be enforced through:

- game procedure logic;
- Java game-engine validation;
- SQL validation queries.

---

# 40. Functional Dependency Set

For CONTACT_EVENT:

ContactEventID
    ->
SessionID,
TurnNumber,
PlayerAID,
PlayerBID,
SiteID

and:

{
    SessionID,
    TurnNumber,
    PlayerAID,
    PlayerBID,
    SiteID
}
    ->
ContactEventID

Both determinants are candidate keys.

---

# 41. Normalization

All descriptive attributes depend on a candidate key.

There are no partial dependencies.

There are no assumed transitive dependencies.

Every determinant of a nontrivial functional dependency is a candidate key.

Therefore:

CONTACT_EVENT satisfies BCNF.

---

# 42. Graph Interpretation

For one game session, define:

G = (V, E)

where:

V = game players

and:

E = recorded CONTACT_EVENT relationships

Each MemberID becomes a vertex.

Each contact becomes an undirected edge.

Example:

Alex ---- Maya
  |
  |
Noah ---- Jordan

The database remains relational.

The graph is derived from relational rows for analysis.

---

# 43. Contact Matrix

For n players, a contact adjacency matrix A may be derived.

A[i,j] = 1

if players i and j have a recorded contact.

Otherwise:

A[i,j] = 0

Because contact is undirected:

A[i,j] = A[j,i]

The diagonal must remain zero:

A[i,i] = 0

The CHECK rule:

PlayerAID < PlayerBID

helps guarantee that each undirected edge is stored only once even though the derived matrix is symmetric.

---

# 44. CSC6033 Connection

CONTACT_EVENT supplies the relational data needed for:

- graph traversal;
- adjacency matrices;
- recursive path tracing;
- cycle detection;
- infection-chain analysis.

The CSC6033 algorithms operate on data retrieved from the database rather than replacing the relational model.


# 45. Game Duration - Locked

Maximum turns:

12

Each game session begins at:

CurrentTurn = 0

The active investigation runs from:

Turn 1 through Turn 12

The session may end before Turn 12 if a win or loss condition is reached.

Constraint concept:

0 <= CurrentTurn <= 12

Possible SQL CHECK:

CHECK (
    CurrentTurn BETWEEN 0 AND 12
)

---

# 46. Win Condition

The primary objective is to correctly identify Patient Zero.

A player or team submits an accusation:

AccusedMemberID

The game is won when:

AccusedMemberID = PatientZeroMemberID

Then:

GameStatus = 'WON'

The game may end immediately after a correct accusation.

---

# 47. Loss Conditions

The game is lost if any defined terminal condition occurs before Patient Zero is correctly identified.

## Loss Condition 1 - Turn Limit

If:

CurrentTurn = 12

and no correct accusation has been made:

GameStatus = 'LOST'

---

## Loss Condition 2 - Infection Threshold

Let:

I = number of infected players

P = total number of participating players

InfectionRatio = I / P

If:

InfectionRatio >= 0.75

then:

GameStatus = 'LOST'

For example:

With 4 players:

3 infected / 4 players = 0.75

Therefore the game is lost when 3 of 4 players are infected.

---

## Loss Condition 3 - Incorrect Accusations

The game may permit a limited number of incorrect accusations.

Proposed limit:

MaximumWrongAccusations = 2

If:

WrongAccusationCount > 2

then:

GameStatus = 'LOST'

This rule remains provisional until accusation mechanics are finalized.

---

# 48. Early Victory

The game does not require all 12 turns to be played.

If Patient Zero is correctly identified early:

GameStatus = 'WON'

and the session ends immediately.

Therefore:

ActualGameLength <= 12 turns

---

# 49. Deduction State

The database may internally determine whether the evidence is sufficient to uniquely identify Patient Zero.

Let:

Cn = current candidate set

If:

|Cn| = 1

then:

DeductionState = 'DEDUCIBLE'

If:

|Cn| > 1

then:

DeductionState = 'AMBIGUOUS'

The game does not automatically reveal the remaining candidate.

Players must recognize the evidence and submit an accusation.

---

# 50. Score and Victory Are Separate

Winning the game and earning a high score are separate goals.

A player may correctly identify Patient Zero but still finish with a low score.

Possible total:

TotalScore =
    SymptomPoints
    + EvidencePoints
    + DeductionPoints
    - WrongAccusationPenalties

Possible final rankings:

S = exceptional early identification
A = strong investigation
B = successful but late
C = correct with several mistakes
LOSS = Patient Zero not identified before a terminal condition

The exact score thresholds will be finalized after SCORE_EVENT is designed.


# 51. SYMPTOM_EVENT Relation

Purpose:

SYMPTOM_EVENT records fictional symptom clues that appear for game players during a session.

These events are visible evidence.

They do not expose the hidden infection truth directly.

Proposed relation:

SYMPTOM_EVENT(
    SymptomEventID,
    SessionID,
    MemberID,
    SymptomCode,
    AppearanceTurn,
    DiscoveredTurn,
    Severity
)

---

# 52. Functional Dependencies

Primary dependency:

SymptomEventID
    ->
SessionID,
MemberID,
SymptomCode,
AppearanceTurn,
DiscoveredTurn,
Severity

Therefore:

{SymptomEventID}

is a candidate key.

A second possible natural identifier is:

{
    SessionID,
    MemberID,
    SymptomCode,
    AppearanceTurn
}

Assumption:

The same symptom cannot first appear more than once for the same player on the same turn.

Therefore:

{
    SessionID,
    MemberID,
    SymptomCode,
    AppearanceTurn
}
    ->
SymptomEventID

Candidate keys:

K1 = {SymptomEventID}

K2 = {
    SessionID,
    MemberID,
    SymptomCode,
    AppearanceTurn
}

Primary Key:

{SymptomEventID}

Alternate Candidate Key:

{
    SessionID,
    MemberID,
    SymptomCode,
    AppearanceTurn
}

---

# 53. Proposed Data Types

SymptomEventID:

BIGINT UNSIGNED
AUTO_INCREMENT
PRIMARY KEY

SessionID:

INT UNSIGNED
NOT NULL

MemberID:

INT UNSIGNED
NOT NULL

SymptomCode:

VARCHAR(30)
NOT NULL

AppearanceTurn:

TINYINT UNSIGNED
NOT NULL

DiscoveredTurn:

TINYINT UNSIGNED
NULL

Severity:

TINYINT UNSIGNED
NOT NULL

---

# 54. Player Referential Integrity

Every symptom event must belong to a player participating in the same game session.

Composite foreign key:

FOREIGN KEY (
    SessionID,
    MemberID
)
REFERENCES GAME_PLAYER(
    SessionID,
    MemberID
)

---

# 55. Turn Constraints

The game lasts 12 turns.

Therefore:

1 <= AppearanceTurn <= 12

Possible CHECK:

CHECK (
    AppearanceTurn BETWEEN 1 AND 12
)

If the symptom has been discovered:

DiscoveredTurn >= AppearanceTurn

and:

DiscoveredTurn <= 12

Possible CHECK:

CHECK (
    DiscoveredTurn IS NULL
    OR (
        DiscoveredTurn >= AppearanceTurn
        AND DiscoveredTurn <= 12
    )
)

A NULL DiscoveredTurn means the clue has not yet been noticed.

---

# 56. Severity Domain

Severity is a fictional game rating.

Range:

1 <= Severity <= 5

Possible CHECK:

CHECK (
    Severity BETWEEN 1 AND 5
)

Severity does not represent a real medical scale.

It exists only as a game variable.

---

# 57. Symptom Codes

Possible fictional symptom codes may include:

- STATIC_VISION
- COLD_FLASH
- AUDIO_DISTORTION
- MEMORY_SKIP
- SHADOW_FLICKER

These are intentionally fictional clues.

They are not intended to model real disease symptoms.

---

# 58. Duplicate Prevention

The alternate candidate key should be enforced as:

UNIQUE (
    SessionID,
    MemberID,
    SymptomCode,
    AppearanceTurn
)

This prevents the same first-appearance event from being recorded twice.

---

# 59. Detection Delay

For a discovered symptom:

DetectionDelay =
    DiscoveredTurn - AppearanceTurn

If:

DiscoveredTurn IS NULL

then no detection score is awarded yet.

---

# 60. Early Detection Score

Let:

MaxPoints = 100

DelayPenalty = 15

Then:

SymptomPoints =
    max(
        0,
        MaxPoints
        - DelayPenalty * DetectionDelay
    )

Examples:

Discovered immediately:

DetectionDelay = 0

SymptomPoints = 100

Discovered two turns later:

DetectionDelay = 2

SymptomPoints = 70

Discovered seven turns later:

SymptomPoints = 0

---

# 61. Derived Value Rule

SymptomPoints should not be stored permanently inside SYMPTOM_EVENT if it can be calculated from:

AppearanceTurn
and
DiscoveredTurn

Instead:

SymptomPoints

is derived when needed or recorded separately as a SCORE_EVENT.

This avoids storing redundant data.

---

# 62. Normalization

All descriptive attributes depend on a candidate key.

There are no partial dependencies.

No transitive dependency is assumed.

Every determinant of a nontrivial functional dependency is a candidate key.

Therefore:

SYMPTOM_EVENT satisfies BCNF.

---

# 63. Deduction Role

SYMPTOM_EVENT contributes visible evidence.

Players may compare:

- who developed clues;
- when those clues first appeared;
- when they were discovered;
- where players had previously traveled;
- who they contacted before the clue appeared.

SYMPTOM_EVENT does not directly reveal:

- Patient Zero;
- InfectedByMemberID;
- hidden infection state.

Those remain in INFECTION_STATE.

---

# 64. CSC6033 Connection

The symptom timeline can become an event sequence:

e1, e2, e3, ..., en

The game engine may process this sequence through a finite-state machine.

The database stores the events.

The state machine interprets their order.


# 65. SCORE_EVENT Relation

Purpose:

SCORE_EVENT records every score change produced during a game session.

The player's total score is derived from these events rather than being treated as an unexplained standalone value.

Proposed relation:

SCORE_EVENT(
    ScoreEventID,
    SessionID,
    MemberID,
    EventType,
    Points,
    TurnNumber,
    SourceEventID
)

---

# 66. Functional Dependencies

Primary dependency:

ScoreEventID
    ->
SessionID,
MemberID,
EventType,
Points,
TurnNumber,
SourceEventID

Therefore:

Candidate Key = {ScoreEventID}

Primary Key:

ScoreEventID

---

# 67. Proposed Data Types

ScoreEventID:

BIGINT UNSIGNED
AUTO_INCREMENT
PRIMARY KEY

SessionID:

INT UNSIGNED
NOT NULL

MemberID:

INT UNSIGNED
NOT NULL

EventType:

VARCHAR(30)
NOT NULL

Points:

INT
NOT NULL

TurnNumber:

TINYINT UNSIGNED
NOT NULL

SourceEventID:

BIGINT UNSIGNED
NULL

---

# 68. Player Referential Integrity

Every score event must belong to a valid player in the same session.

Composite foreign key:

FOREIGN KEY (
    SessionID,
    MemberID
)
REFERENCES GAME_PLAYER(
    SessionID,
    MemberID
)

---

# 69. Turn Constraint

The game lasts 12 turns.

Therefore:

1 <= TurnNumber <= 12

Possible CHECK:

CHECK (
    TurnNumber BETWEEN 1 AND 12
)

---

# 70. Event Types

Possible score-event categories:

SYMPTOM_DETECTED

EVIDENCE_FOUND

CORRECT_DEDUCTION

WRONG_ACCUSATION

EARLY_DETECTION_BONUS

INVESTIGATION_BONUS

The allowed set may be enforced with CHECK.

Example:

CHECK (
    EventType IN (
        'SYMPTOM_DETECTED',
        'EVIDENCE_FOUND',
        'CORRECT_DEDUCTION',
        'WRONG_ACCUSATION',
        'EARLY_DETECTION_BONUS',
        'INVESTIGATION_BONUS'
    )
)

---

# 71. Positive and Negative Points

Points may be positive or negative.

Examples:

Early clue:

+100

Evidence discovery:

+40

Correct accusation:

+500

Wrong accusation:

-150

Therefore Points should use:

INT

rather than an unsigned type.

---

# 72. Derived Player Total

The authoritative score history is SCORE_EVENT.

A player's total score is calculated as:

TotalScore(p) =
SUM(Points)

for all SCORE_EVENT rows belonging to player p in the current session.

SQL concept:

SELECT
    SessionID,
    MemberID,
    SUM(Points) AS TotalScore
FROM SCORE_EVENT
GROUP BY
    SessionID,
    MemberID;

---

# 73. GAME_PLAYER Score Decision

GAME_PLAYER currently contains:

Score

This creates possible redundancy because the same value can be derived from SCORE_EVENT.

Therefore two design options exist.

Option A:

Store GAME_PLAYER.Score and keep it synchronized.

Option B:

Remove GAME_PLAYER.Score and calculate the score from SCORE_EVENT.

Preferred design:

Option B

Reason:

The total score is derivable from the event history.

Removing the stored total avoids inconsistent values.

Therefore the revised GAME_PLAYER relation becomes:

GAME_PLAYER(
    SessionID,
    MemberID,
    PlayerStatus
)

Functional dependency:

{SessionID, MemberID}
    ->
PlayerStatus

---

# 74. Score Auditability

Because every change is recorded separately, the system can answer:

- why did a player receive points?
- when were the points earned?
- what event caused the score change?
- how much did each clue contribute?
- where were penalties applied?

This makes the scoring system reproducible.

---

# 75. Symptom Scoring Integration

For a symptom event:

DetectionDelay =
DiscoveredTurn - AppearanceTurn

SymptomPoints =
max(
    0,
    100 - 15 * DetectionDelay
)

When the symptom is discovered:

1. calculate SymptomPoints;
2. create a SCORE_EVENT;
3. link the score event to the symptom through SourceEventID.

The symptom table stores evidence.

The score table stores the reward produced by that evidence.

---

# 76. Normalization

SCORE_EVENT contains one fact:

a score adjustment for one player during one session.

All attributes depend on:

{ScoreEventID}

No partial dependency exists.

No transitive dependency is assumed.

Therefore:

SCORE_EVENT satisfies BCNF.

---

# 77. CSC6033 Connection

The scoring engine may use weighted evidence vectors.

For player p:

x(p) =
[
contactEvidence,
symptomEvidence,
timelineEvidence,
locationEvidence
]

Weight vector:

w =
[
w1,
w2,
w3,
w4
]

Suspicion score:

Suspicion(p) =
w · x(p)

This value is different from the player's game score.

GameScore measures performance.

SuspicionScore measures how strongly current evidence implicates a suspect.

The two must not be confused.


# 78. ACCUSATION_EVENT Relation

Purpose:

ACCUSATION_EVENT records every formal attempt to identify Patient Zero.

An accusation may be correct or incorrect.

A correct accusation triggers the win condition.

Proposed relation:

ACCUSATION_EVENT(
    AccusationID,
    SessionID,
    AccusingMemberID,
    AccusedMemberID,
    TurnNumber,
    IsCorrect
)

---

# 79. Functional Dependency

Primary dependency:

AccusationID
    ->
SessionID,
AccusingMemberID,
AccusedMemberID,
TurnNumber,
IsCorrect

Therefore:

Candidate Key = {AccusationID}

Primary Key:

AccusationID

---

# 80. Proposed Data Types

AccusationID:

BIGINT UNSIGNED
AUTO_INCREMENT
PRIMARY KEY

SessionID:

INT UNSIGNED
NOT NULL

AccusingMemberID:

INT UNSIGNED
NOT NULL

AccusedMemberID:

INT UNSIGNED
NOT NULL

TurnNumber:

TINYINT UNSIGNED
NOT NULL

IsCorrect:

BOOLEAN
NOT NULL

---

# 81. Player Referential Integrity

Both the accusing player and accused player must participate in the same game session.

Foreign key 1:

FOREIGN KEY (
    SessionID,
    AccusingMemberID
)
REFERENCES GAME_PLAYER(
    SessionID,
    MemberID
)

Foreign key 2:

FOREIGN KEY (
    SessionID,
    AccusedMemberID
)
REFERENCES GAME_PLAYER(
    SessionID,
    MemberID
)

This prevents accusations against family members who are not participating in the current game.

---

# 82. Turn Constraint

An accusation may occur only during an active investigation turn.

Therefore:

1 <= TurnNumber <= 12

Possible CHECK:

CHECK (
    TurnNumber BETWEEN 1 AND 12
)

---

# 83. Self-Accusation Rule

A player may not accuse themselves.

Required rule:

AccusingMemberID != AccusedMemberID

Possible CHECK:

CHECK (
    AccusingMemberID <> AccusedMemberID
)

---

# 84. Correctness Rule

An accusation is correct when:

AccusedMemberID
    =
PatientZeroMemberID

for the same SessionID.

Therefore:

IsCorrect =
TRUE

only when the accused player is Patient Zero.

This rule depends on INFECTION_STATE.

Because it compares values across relations, IsCorrect should not be trusted as arbitrary user input.

Preferred approach:

The game engine or stored procedure calculates IsCorrect automatically.

---

# 85. Wrong Accusation Limit

Maximum wrong accusations:

2

Let:

W =
COUNT(
    ACCUSATION_EVENT
    WHERE
        SessionID = current session
        AND IsCorrect = FALSE
)

If:

W > 2

then:

GameStatus = 'LOST'

The count depends on multiple rows.

Therefore this is not a simple CHECK constraint.

It must be enforced through:

- stored procedure logic;
- Java game-engine logic;
- validation query.

---

# 86. Correct Accusation Rule

If:

IsCorrect = TRUE

then:

GAME_SESSION.GameStatus = 'WON'

and the session ends immediately.

No further turns may be processed.

---

# 87. Accusation Scoring

Possible scoring:

Correct accusation:

+500 points

Wrong accusation:

-150 points

The accusation itself belongs in ACCUSATION_EVENT.

The score change belongs in SCORE_EVENT.

Therefore a correct accusation may create:

ACCUSATION_EVENT
    +
SCORE_EVENT(+500)

A wrong accusation may create:

ACCUSATION_EVENT
    +
SCORE_EVENT(-150)

This keeps game history separate from score history.

---

# 88. Deduction vs Accusation

The database may internally determine:

DeductionState = 'DEDUCIBLE'

when:

|CandidateSet| = 1

However:

DEDUCIBLE

does not automatically mean:

WON

The player must still submit the correct accusation.

Therefore:

Evidence sufficient
    !=
Victory

Victory requires:

CorrectAccusation = TRUE

---

# 89. Normalization

ACCUSATION_EVENT records one accusation event.

All non-key attributes depend on:

{AccusationID}

No partial dependency exists.

No transitive dependency is assumed.

Therefore:

ACCUSATION_EVENT satisfies BCNF.

---

# 90. Game-End Logic

The game may now terminate in three major ways.

WIN:

Correct accusation.

LOSS:

CurrentTurn reaches 12 without a correct accusation.

LOSS:

InfectionRatio >= 0.75.

LOSS:

WrongAccusationCount > 2.

Conceptually:

            ACTIVE
              |
      +-------+-------+
      |               |
Correct Guess     Terminal Rule
      |               |
      v               v
     WON             LOST


# 91. Design Revision - Symptom Observation

A scoring-design problem was identified before Turn 2.

SYMPTOM_EVENT records a clue affecting a player, but the game also needs to know which player discovered that clue.

Discovery is a separate event and should not be stored as an attribute of the symptom itself.

Therefore:

DiscoveredTurn

is removed from SYMPTOM_EVENT.

A new relation is introduced:

OBSERVATION_EVENT(
    ObservationID,
    SessionID,
    ObserverMemberID,
    SymptomEventID,
    DiscoveredTurn
)

This separates:

SYMPTOM_EVENT = the clue exists

from:

OBSERVATION_EVENT = a player discovers the clue

This permits multiple players to observe the same symptom without duplicating the symptom itself.

---

# 92. OBSERVATION_EVENT Functional Dependencies

ObservationID
    ->
SessionID,
ObserverMemberID,
SymptomEventID,
DiscoveredTurn

Candidate Key:

{ObservationID}

Natural alternate candidate key:

{
    SessionID,
    ObserverMemberID,
    SymptomEventID
}

One player may discover the same symptom only once.

---

# 93. Observation Scoring

DetectionDelay =
DiscoveredTurn - AppearanceTurn

Points =
max(
    0,
    100 - 15 * DetectionDelay
)

The points belong to:

ObserverMemberID

not the player experiencing the symptom.

Therefore:

SYMPTOM_EVENT
    ->
OBSERVATION_EVENT
    ->
SCORE_EVENT

This creates an auditable evidence-to-score path.


# 94. Wrong-Accusation Rule - Locked

The game permits two incorrect accusations without immediately ending the session.

The third incorrect accusation triggers a loss.

Therefore:

WrongAccusationCount >= 3
    ->
GameStatus = 'LOST'

This replaces earlier ambiguous wording around the accusation limit.


# 95. Turn Engine Revision

The earlier AdvanceToTurn2 procedure was a prototype.

The authoritative turn engine is now:

AdvanceTurn(SessionID)

Turns 1 through 12 are playable.

If CurrentTurn = 12 and the session is still ACTIVE when another turn advance is attempted:

GameStatus = 'LOST'

Therefore Turn 12 remains available for final investigation and accusation.

The generic turn engine is responsible for:

- validating session state
- advancing infection states
- processing contact-based spread
- generating symptom clues
- updating removed players
- checking the 75 percent infection-loss threshold
- advancing CurrentTurn


# 96. Contact Recording Procedure

Contact events are created through:

RecordContact(
    SessionID,
    Member1ID,
    Member2ID,
    SiteID
)

The procedure:

- verifies the session exists
- requires GameStatus = ACTIVE
- uses the session's current turn automatically
- verifies both family members are players in the session
- rejects removed players
- rejects self-contact
- verifies the vacation site exists
- converts the pair into canonical order
- prevents duplicate contact events

Canonical ordering:

PlayerAID = MIN(Member1ID, Member2ID)

PlayerBID = MAX(Member1ID, Member2ID)

Therefore:

(2, 4)

and:

(4, 2)

represent the same undirected contact.


# 97. Activity Event

The game directly reuses the graded ACTIVITY and SITE_ACTIVITY relations.

Each active player may perform at most one activity per turn.

Proposed relation:

ACTIVITY_EVENT(
    ActivityEventID,
    SessionID,
    TurnNumber,
    MemberID,
    SiteID,
    ActivityID
)

Primary candidate key:

{ActivityEventID}

Alternate candidate key:

{
    SessionID,
    TurnNumber,
    MemberID
}

Business rule:

One player may perform at most one activity during a single turn.

Functional dependencies:

ActivityEventID
    ->
SessionID,
TurnNumber,
MemberID,
SiteID,
ActivityID

and:

{
    SessionID,
    TurnNumber,
    MemberID
}
    ->
SiteID,
ActivityID

The combination:

{SiteID, ActivityID}

must already exist in SITE_ACTIVITY.

Therefore the game cannot schedule an activity at a vacation site where that activity is unavailable.

This directly reuses the graded vacation database rather than duplicating destination/activity information.

