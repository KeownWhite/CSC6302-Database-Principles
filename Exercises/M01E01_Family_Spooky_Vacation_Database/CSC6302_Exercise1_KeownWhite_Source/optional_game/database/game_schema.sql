
-- CSC6302 Database Principles
-- Module 01 Exercise 01
-- OPTIONAL EXTENSION
-- Paranormal Expedition Mode
--
-- This schema extends the graded Family Spooky Vacation Database.
-- It does not replace or modify the seven required core relations.
USE FamilySpookyVacation;



-- =========================================================
-- CLEAN OPTIONAL GAME LAYER
-- Reverse dependency order allows this script to be rerun.
-- =========================================================
DROP TABLE IF EXISTS ACCUSATION_EVENT;
DROP TABLE IF EXISTS SCORE_EVENT;
DROP TABLE IF EXISTS SYMPTOM_EVENT;
DROP TABLE IF EXISTS CONTACT_EVENT;
DROP TABLE IF EXISTS INFECTION_STATE;
DROP TABLE IF EXISTS ACTIVITY_EVENT;
DROP TABLE IF EXISTS ACTIVITY_CLUE_RULE;
DROP TABLE IF EXISTS GAME_PLAYER;
DROP TABLE IF EXISTS GAME_SESSION;
DROP TABLE IF EXISTS OBSERVATION_EVENT;



-- =========================================================
-- GAME SESSION
-- One row represents one play session.
-- =========================================================
-- =========================================================
-- GAME PLAYER
-- Converts an existing family member into a player
-- without duplicating their name or core information.
-- =========================================================
-- =========================================================
-- HIDDEN INFECTION STATE
-- Game-engine truth. Not intended for player-facing access.
-- =========================================================
-- =========================================================
-- CONTACT EVENT
-- One canonical undirected contact between two players.
-- PlayerAID < PlayerBID prevents reversed duplicates.
-- =========================================================
-- =========================================================
-- SYMPTOM EVENT
-- Fictional observable clue.
-- =========================================================
-- =========================================================
-- OBSERVATION EVENT
-- Records who discovers a symptom and when.
-- =========================================================
-- =========================================================
-- SCORE EVENT
-- Immutable scoring history.
-- Total score is derived using SUM(Points).
-- =========================================================
-- =========================================================
-- ACCUSATION EVENT
-- Correctness is DERIVED from INFECTION_STATE.
-- It is intentionally not stored here.
-- =========================================================
-- =========================================================
-- ACTIVITY EVENT
-- Connects the game to the graded vacation/activity model.
-- =========================================================
CREATE TABLE GAME_SESSION (
    SessionID INT UNSIGNED AUTO_INCREMENT,
    StartedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CurrentTurn TINYINT UNSIGNED NOT NULL DEFAULT 0,
    GameStatus VARCHAR(10) NOT NULL DEFAULT 'READY',

    CONSTRAINT pk_game_session
        PRIMARY KEY (SessionID),

    CONSTRAINT chk_game_turn
        CHECK (CurrentTurn BETWEEN 0 AND 12),

    CONSTRAINT chk_game_status
        CHECK (
            GameStatus IN (
                'READY',
                'ACTIVE',
                'WON',
                'LOST',
                'ENDED'
            )
        )
);



CREATE TABLE GAME_PLAYER (
    SessionID INT UNSIGNED NOT NULL,
    MemberID INT UNSIGNED NOT NULL,
    PlayerStatus VARCHAR(10) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT pk_game_player
        PRIMARY KEY (SessionID, MemberID),

    CONSTRAINT fk_game_player_session
        FOREIGN KEY (SessionID)
        REFERENCES GAME_SESSION(SessionID),

    CONSTRAINT fk_game_player_member
        FOREIGN KEY (MemberID)
        REFERENCES FAMILY_MEMBER(MemberID),

    CONSTRAINT chk_player_status
        CHECK (
            PlayerStatus IN (
                'ACTIVE',
                'SUSPECTED',
                'CLEARED',
                'REMOVED'
            )
        )
);



CREATE TABLE INFECTION_STATE (
    SessionID INT UNSIGNED NOT NULL,
    MemberID INT UNSIGNED NOT NULL,
    InfectionStatus VARCHAR(15) NOT NULL DEFAULT 'HEALTHY',
    InfectionTurn TINYINT UNSIGNED NULL,
    InfectedByMemberID INT UNSIGNED NULL,
    PatientZero BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT pk_infection_state
        PRIMARY KEY (SessionID, MemberID),

    CONSTRAINT fk_infection_player
        FOREIGN KEY (SessionID, MemberID)
        REFERENCES GAME_PLAYER(SessionID, MemberID),

    CONSTRAINT fk_infection_source
        FOREIGN KEY (SessionID, InfectedByMemberID)
        REFERENCES GAME_PLAYER(SessionID, MemberID),

    CONSTRAINT chk_infection_status
        CHECK (
            InfectionStatus IN (
                'HEALTHY',
                'EXPOSED',
                'LATENT',
                'SYMPTOMATIC',
                'CRITICAL',
                'REMOVED'
            )
        ),

    CONSTRAINT chk_no_self_infection
        CHECK (
            InfectedByMemberID IS NULL
            OR MemberID <> InfectedByMemberID
        ),

    CONSTRAINT chk_patient_zero
        CHECK (
            PatientZero = FALSE
            OR (
                InfectedByMemberID IS NULL
                AND InfectionTurn = 0
            )
        ),

    CONSTRAINT chk_patient_zero_boolean
        CHECK (PatientZero IN (0, 1)),

    CONSTRAINT chk_infection_turn
        CHECK (
            InfectionTurn IS NULL
            OR InfectionTurn BETWEEN 0 AND 12
        )
);



CREATE TABLE CONTACT_EVENT (
    ContactEventID BIGINT UNSIGNED AUTO_INCREMENT,
    SessionID INT UNSIGNED NOT NULL,
    TurnNumber TINYINT UNSIGNED NOT NULL,
    PlayerAID INT UNSIGNED NOT NULL,
    PlayerBID INT UNSIGNED NOT NULL,
    SiteID INT UNSIGNED NOT NULL,

    CONSTRAINT pk_contact_event
        PRIMARY KEY (ContactEventID),

    CONSTRAINT uq_contact_event
        UNIQUE (
            SessionID,
            TurnNumber,
            PlayerAID,
            PlayerBID,
            SiteID
        ),

    CONSTRAINT fk_contact_player_a
        FOREIGN KEY (SessionID, PlayerAID)
        REFERENCES GAME_PLAYER(SessionID, MemberID),

    CONSTRAINT fk_contact_player_b
        FOREIGN KEY (SessionID, PlayerBID)
        REFERENCES GAME_PLAYER(SessionID, MemberID),

    CONSTRAINT fk_contact_site
        FOREIGN KEY (SiteID)
        REFERENCES VACATION_SITE(SiteID),

    CONSTRAINT chk_contact_turn
        CHECK (TurnNumber BETWEEN 1 AND 12),

    CONSTRAINT chk_contact_canonical_order
        CHECK (PlayerAID < PlayerBID)
);



CREATE TABLE SYMPTOM_EVENT (
    SymptomEventID BIGINT UNSIGNED AUTO_INCREMENT,
    SessionID INT UNSIGNED NOT NULL,
    MemberID INT UNSIGNED NOT NULL,
    SymptomCode VARCHAR(30) NOT NULL,
    AppearanceTurn TINYINT UNSIGNED NOT NULL,
    Severity TINYINT UNSIGNED NOT NULL,

    CONSTRAINT pk_symptom_event
        PRIMARY KEY (SymptomEventID),

    CONSTRAINT uq_symptom_event
        UNIQUE (
            SessionID,
            MemberID,
            SymptomCode,
            AppearanceTurn
        ),

    CONSTRAINT fk_symptom_player
        FOREIGN KEY (SessionID, MemberID)
        REFERENCES GAME_PLAYER(SessionID, MemberID),

    CONSTRAINT chk_symptom_code
        CHECK (
            SymptomCode IN (
                'STATIC_VISION',
                'COLD_FLASH',
                'AUDIO_DISTORTION',
                'MEMORY_SKIP',
                'SHADOW_FLICKER'
            )
        ),

    CONSTRAINT chk_symptom_appearance
        CHECK (
            AppearanceTurn BETWEEN 1 AND 12
        ),

    CONSTRAINT chk_symptom_severity
        CHECK (
            Severity BETWEEN 1 AND 5
        )
);


CREATE TABLE OBSERVATION_EVENT (
    ObservationID BIGINT UNSIGNED AUTO_INCREMENT,
    SessionID INT UNSIGNED NOT NULL,
    ObserverMemberID INT UNSIGNED NOT NULL,
    SymptomEventID BIGINT UNSIGNED NOT NULL,
    DiscoveredTurn TINYINT UNSIGNED NOT NULL,

    CONSTRAINT pk_observation_event
        PRIMARY KEY (ObservationID),

    CONSTRAINT uq_observation_event
        UNIQUE (
            SessionID,
            ObserverMemberID,
            SymptomEventID
        ),

    CONSTRAINT fk_observation_player
        FOREIGN KEY (
            SessionID,
            ObserverMemberID
        )
        REFERENCES GAME_PLAYER(
            SessionID,
            MemberID
        ),

    CONSTRAINT fk_observation_symptom
        FOREIGN KEY (SymptomEventID)
        REFERENCES SYMPTOM_EVENT(SymptomEventID),

    CONSTRAINT chk_observation_turn
        CHECK (
            DiscoveredTurn BETWEEN 1 AND 12
        )
);



CREATE TABLE SCORE_EVENT (
    ScoreEventID BIGINT UNSIGNED AUTO_INCREMENT,
    SessionID INT UNSIGNED NOT NULL,
    MemberID INT UNSIGNED NOT NULL,
    EventType VARCHAR(30) NOT NULL,
    Points INT NOT NULL,
    TurnNumber TINYINT UNSIGNED NOT NULL,

    CONSTRAINT pk_score_event
        PRIMARY KEY (ScoreEventID),

    CONSTRAINT fk_score_player
        FOREIGN KEY (SessionID, MemberID)
        REFERENCES GAME_PLAYER(SessionID, MemberID),

    CONSTRAINT chk_score_event_type
        CHECK (
            EventType IN (
                'SYMPTOM_DETECTED',
                'EVIDENCE_FOUND',
                'CORRECT_DEDUCTION',
                'WRONG_ACCUSATION',
                'EARLY_DETECTION_BONUS',
                'INVESTIGATION_BONUS'
            )
        ),

    CONSTRAINT chk_score_turn
        CHECK (
            TurnNumber BETWEEN 1 AND 12
        )
);



CREATE TABLE ACCUSATION_EVENT (
    AccusationID BIGINT UNSIGNED AUTO_INCREMENT,
    SessionID INT UNSIGNED NOT NULL,
    AccusingMemberID INT UNSIGNED NOT NULL,
    AccusedMemberID INT UNSIGNED NOT NULL,
    TurnNumber TINYINT UNSIGNED NOT NULL,

    CONSTRAINT pk_accusation_event
        PRIMARY KEY (AccusationID),

    CONSTRAINT fk_accusation_accuser
        FOREIGN KEY (SessionID, AccusingMemberID)
        REFERENCES GAME_PLAYER(SessionID, MemberID),

    CONSTRAINT fk_accusation_accused
        FOREIGN KEY (SessionID, AccusedMemberID)
        REFERENCES GAME_PLAYER(SessionID, MemberID),

    CONSTRAINT chk_accusation_turn
        CHECK (
            TurnNumber BETWEEN 1 AND 12
        ),

    CONSTRAINT chk_no_self_accusation
        CHECK (
            AccusingMemberID <> AccusedMemberID
        )
);

CREATE TABLE ACTIVITY_EVENT (
    ActivityEventID BIGINT UNSIGNED AUTO_INCREMENT,
    SessionID INT UNSIGNED NOT NULL,
    TurnNumber TINYINT UNSIGNED NOT NULL,
    MemberID INT UNSIGNED NOT NULL,
    SiteID INT UNSIGNED NOT NULL,
    ActivityID INT UNSIGNED NOT NULL,

    CONSTRAINT pk_activity_event
        PRIMARY KEY (ActivityEventID),

    CONSTRAINT uq_player_activity_per_turn
        UNIQUE (
            SessionID,
            TurnNumber,
            MemberID
        ),

    CONSTRAINT fk_activity_event_player
        FOREIGN KEY (
            SessionID,
            MemberID
        )
        REFERENCES GAME_PLAYER(
            SessionID,
            MemberID
        ),

    CONSTRAINT fk_activity_event_site_activity
        FOREIGN KEY (
            SiteID,
            ActivityID
        )
        REFERENCES SITE_ACTIVITY(
            SiteID,
            ActivityID
        ),

    CONSTRAINT chk_activity_event_turn
        CHECK (
            TurnNumber BETWEEN 1 AND 12
        )
);

-- =========================================================
-- ACTIVITY CLUE RULE
-- Maps fictional clue types to investigation activities.
-- =========================================================

CREATE TABLE ACTIVITY_CLUE_RULE (
    SymptomCode VARCHAR(30) NOT NULL,
    ActivityID INT UNSIGNED NOT NULL,

    CONSTRAINT pk_activity_clue_rule
        PRIMARY KEY (SymptomCode, ActivityID),

    CONSTRAINT fk_clue_rule_activity
        FOREIGN KEY (ActivityID)
        REFERENCES ACTIVITY(ActivityID),

    CONSTRAINT chk_clue_rule_symptom
        CHECK (
            SymptomCode IN (
                'STATIC_VISION',
                'COLD_FLASH',
                'AUDIO_DISTORTION',
                'MEMORY_SKIP',
                'SHADOW_FLICKER'
            )
        )
);