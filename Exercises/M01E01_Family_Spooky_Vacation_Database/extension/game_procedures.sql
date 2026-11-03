
-- CSC6302 Database Principles
-- OPTIONAL EXTENSION
-- Paranormal Expedition Mode
-- Game initialization procedures
USE FamilySpookyVacation;

-- A symptom cannot be discovered before it appears.
-- =====================================================
-- 5. Resolve accusation
-- =====================================================
-- =====================================================
-- 2. Turn 12 timeout
--
-- Turn 12 itself is playable.
-- Attempting to advance beyond it causes a loss.
-- =====================================================
-- =====================================================
-- 6. Apply selected transmission
-- =====================================================
-- Avoid floating-point comparison:
--
-- infected / total >= 3 / 4
--
-- becomes:
--
-- infected * 4 >= total * 3
-- =====================================================
-- 2. Reject self-contact
-- =====================================================
-- =====================================================
-- 4. No clue found
-- =====================================================
DROP PROCEDURE IF EXISTS StartParanormalExpedition;

DELIMITER $$

CREATE PROCEDURE StartParanormalExpedition()
BEGIN
    -- If anything inside the transaction fails,
    -- undo all changes and return the original error.
    DECLARE NewSessionID INT UNSIGNED;
    DECLARE PatientZeroID INT UNSIGNED;
    DECLARE PlayerCount INT DEFAULT 0;

    START TRANSACTION;


    -- -----------------------------------------------------
    -- 1. Create a new game session
    -- -----------------------------------------------------
    -- -----------------------------------------------------
    -- 2. Convert existing FAMILY_MEMBER rows into players
    -- No names or personal information are duplicated.
    -- -----------------------------------------------------
    -- -----------------------------------------------------
    -- 5. Create hidden infection state
    -- -----------------------------------------------------
    -- =====================================================
    -- 5. Create a genuine symptom clue
    -- =====================================================
    -- =====================================================
    -- 7. Create a decoy symptom
    -- =====================================================
    -- =====================================================
    -- 9. Award immediate-detection points
    --
    -- AppearanceTurn = 2
    -- DiscoveredTurn = 2
    -- Delay = 0
    -- Score = 100
    -- =====================================================
    -- =====================================================
    -- 6. Record observation
    -- =====================================================
    -- =====================================================
    -- 7. Record score event
    -- =====================================================
    -- =====================================================
    -- 4. Record accusation
    -- =====================================================
    -- =====================================================
    -- 7. Generate first symptomatic clue
    --
    -- A symptom is generated when infection age reaches 2.
    -- =====================================================
    -- =====================================================
    -- 8. Record contact
    -- =====================================================
    -- =====================================================
    -- 4. Record activity
    --
    -- UNIQUE(SessionID, TurnNumber, MemberID)
    -- guarantees one activity per player per turn.
    -- =====================================================
    -- =====================================================
    -- 7. Record observation
    -- =====================================================
    -- =====================================================
    -- 8. Award points
    -- =====================================================
    INSERT INTO GAME_SESSION (
        CurrentTurn,
        GameStatus
    )
    VALUES (
        0,
        'READY'
    );

    -- =====================================================
    -- 5. Calculate detection score
    --
    -- Points =
    -- max(0, 100 - 15 * DetectionDelay)
    -- =====================================================
    -- =====================================================
    -- 3. Canonicalize the undirected edge
    -- =====================================================
    -- =====================================================
    -- 6. Calculate early-detection score
    -- =====================================================
    SET NewSessionID = LAST_INSERT_ID();



    INSERT INTO GAME_PLAYER (
        SessionID,
        MemberID,
        PlayerStatus
    )
    -- -----------------------------------------------------
    -- 3. Validate player count
    -- -----------------------------------------------------
    -- -----------------------------------------------------
    -- -----------------------------------------------------
    -- -----------------------------------------------------
    -- Player-safe startup result
    -- Patient Zero identity is NOT returned.
    -- -----------------------------------------------------
    -- =====================================================
    -- 1. Validate session
    -- =====================================================
    -- =====================================================
    -- 2. Find Patient Zero internally
    -- =====================================================
    -- =====================================================
    -- =====================================================
    -- =====================================================
    -- 6. Choose a healthy decoy
    -- =====================================================
    -- =====================================================
    -- 8. Choose somebody else to discover the decoy
    -- =====================================================
    -- =====================================================
    -- PLAYER-SAFE OUTPUT
    -- No hidden IDs are returned.
    -- =====================================================
    -- =====================================================
    -- 1. Validate active session
    -- =====================================================
    -- =====================================================
    -- 2. Validate observer
    -- =====================================================
    -- =====================================================
    -- 3. Validate symptom
    -- =====================================================
    -- =====================================================
    -- 4. Prevent duplicate observation by same player
    -- =====================================================
    -- =====================================================
    -- PLAYER-SAFE RESULT
    -- =====================================================
    -- =====================================================
    -- 1. Validate session
    -- =====================================================
    -- =====================================================
    -- 2. Validate both players
    -- =====================================================
    -- =====================================================
    -- 3. Validate hidden game truth
    -- =====================================================
    -- Count all wrong accusations in this session.
    -- Correctness is DERIVED rather than stored.
    -- =====================================================
    -- PLAYER-SAFE RESULT
    -- =====================================================
    -- =====================================================
    -- 1. Validate session
    -- =====================================================
    -- =====================================================
    -- 5. Find one eligible transmission from the
    -- previous turn's contact network.
    --
    -- No transmission occurs if no valid candidate exists.
    -- =====================================================
    -- Player A infected, Player B healthy
    -- Player B infected, Player A healthy
    -- =====================================================
    -- 9. Calculate infection threshold
    -- =====================================================
    -- =====================================================
    -- 10. Player-safe result
    -- =====================================================
    -- =====================================================
    -- 1. Validate session
    -- =====================================================
    -- =====================================================
    -- 4. Validate Player A
    -- =====================================================
    -- =====================================================
    -- 5. Validate Player B
    -- =====================================================
    -- =====================================================
    -- 6. Validate vacation site
    -- =====================================================
    -- =====================================================
    -- 7. Prevent duplicate contact
    -- =====================================================
    -- =====================================================
    -- 9. Player-safe result
    -- =====================================================
    -- =====================================================
    -- 1. Validate active session
    -- =====================================================
    -- =====================================================
    -- 2. Validate player
    -- =====================================================
    -- =====================================================
    -- 3. Verify the activity exists at this vacation site
    -- =====================================================
    -- =====================================================
    -- 5. Player-safe output
    -- =====================================================
    -- =====================================================
    -- 1. Validate active session
    -- =====================================================
    -- =====================================================
    -- 2. Find observer activity for current turn
    -- =====================================================
    -- =====================================================
    -- 3. Find an undiscovered clue that:
    --
    -- - has already appeared
    -- - belongs to another player
    -- - is at the same site this turn
    -- - matches the observer's investigation activity
    -- - has not already been observed by this player
    -- =====================================================
    -- =====================================================
    -- 5. Retrieve selected clue
    -- =====================================================
    -- =====================================================
    -- 9. Player-safe result
    -- =====================================================
    -- 3. Select one Turn 1 contact of Patient Zero
    -- 4. Secretly select Patient Zero
    SELECT
        NewSessionID,
        MemberID,
        'ACTIVE'
    FROM FAMILY_MEMBER;



    SELECT COUNT(*)
    INTO PlayerCount
    FROM GAME_PLAYER
    WHERE SessionID = NewSessionID;

    IF PlayerCount < 2 THEN
        ROLLBACK;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'At least two family members are required to start the game.';
    END IF;



    SELECT MemberID
    INTO PatientZeroID
    FROM GAME_PLAYER
    WHERE SessionID = NewSessionID
    ORDER BY RAND()
    LIMIT 1;



    INSERT INTO INFECTION_STATE (
        SessionID,
        MemberID,
        InfectionStatus,
        InfectionTurn,
        InfectedByMemberID,
        PatientZero
    )
    SELECT
        NewSessionID,
        MemberID,

        CASE
            WHEN MemberID = PatientZeroID
                THEN 'LATENT'
            ELSE 'HEALTHY'
        END,

        CASE
            WHEN MemberID = PatientZeroID
                THEN 0
            ELSE NULL
        END,

        NULL,

        CASE
            WHEN MemberID = PatientZeroID
                THEN TRUE
            ELSE FALSE
        END

    FROM GAME_PLAYER
    WHERE SessionID = NewSessionID;



    -- -----------------------------------------------------
    -- 6. Start Turn 1
    -- -----------------------------------------------------
    -- =====================================================
    -- 4. Create first secondary infection
    -- =====================================================
    -- Patient Zero progresses internally.
    -- =====================================================
    -- 10. Advance session
    -- =====================================================
    -- A confirmed wrong accusation clears that suspect.
    -- =====================================================
    -- 3. Progress existing infections
    --
    -- Fictional game-state progression:
    --
    -- age 0 = EXPOSED
    -- age 1 = LATENT
    -- age 2-3 = SYMPTOMATIC
    -- age 4 = CRITICAL
    -- age 5+ = REMOVED
    -- =====================================================
    -- =====================================================
    -- 4. Synchronize removed players
    -- =====================================================
    -- =====================================================
    -- 8. Advance session turn
    -- =====================================================
    UPDATE GAME_SESSION
    SET
        CurrentTurn = 1,
        GameStatus = 'ACTIVE'
    WHERE SessionID = NewSessionID;


    COMMIT;



    SELECT
        NewSessionID AS SessionID,
        PlayerCount AS Players,
        1 AS HiddenPatientZeroCount,
        1 AS CurrentTurn,
        'ACTIVE' AS GameStatus;

END$$


DELIMITER ;
DROP PROCEDURE IF EXISTS AdvanceToTurn2;

DELIMITER $$

CREATE PROCEDURE AdvanceToTurn2(
    IN pSessionID INT UNSIGNED
)
BEGIN
    DECLARE vCurrentTurn INT;
    DECLARE vGameStatus VARCHAR(10);

    DECLARE vPatientZeroID INT UNSIGNED;
    DECLARE vNewlyExposedID INT UNSIGNED;
    DECLARE vDecoyID INT UNSIGNED;
    DECLARE vObserverID INT UNSIGNED;

    DECLARE vDecoySymptomID BIGINT UNSIGNED;

    START TRANSACTION;



    SELECT
        CurrentTurn,
        GameStatus
    INTO
        vCurrentTurn,
        vGameStatus
    FROM GAME_SESSION
    WHERE SessionID = pSessionID
    FOR UPDATE;

    IF vGameStatus <> 'ACTIVE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'The game session is not active.';
    END IF;

    IF vCurrentTurn <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Turn 2 can only follow Turn 1.';
    END IF;



    SELECT MemberID
    INTO vPatientZeroID
    FROM INFECTION_STATE
    WHERE SessionID = pSessionID
      AND PatientZero = TRUE
    LIMIT 1;



    SELECT
        CASE
            WHEN PlayerAID = vPatientZeroID
                THEN PlayerBID
            ELSE PlayerAID
        END
    INTO vNewlyExposedID

    FROM CONTACT_EVENT

    WHERE SessionID = pSessionID
      AND TurnNumber = 1
      AND (
          PlayerAID = vPatientZeroID
          OR PlayerBID = vPatientZeroID
      )

    ORDER BY RAND()
    LIMIT 1;



    UPDATE INFECTION_STATE
    SET
        InfectionStatus = 'EXPOSED',
        InfectionTurn = 2,
        InfectedByMemberID = vPatientZeroID
    WHERE SessionID = pSessionID
      AND MemberID = vNewlyExposedID;


    UPDATE INFECTION_STATE
    SET InfectionStatus = 'SYMPTOMATIC'
    WHERE SessionID = pSessionID
      AND MemberID = vPatientZeroID;



    INSERT INTO SYMPTOM_EVENT (
        SessionID,
        MemberID,
        SymptomCode,
        AppearanceTurn,
        Severity
    )
    VALUES (
        pSessionID,
        vPatientZeroID,
        'STATIC_VISION',
        2,
        2
    );



    SELECT gp.MemberID
    INTO vDecoyID

    FROM GAME_PLAYER AS gp

    JOIN INFECTION_STATE AS ist
        ON gp.SessionID = ist.SessionID
        AND gp.MemberID = ist.MemberID

    WHERE gp.SessionID = pSessionID
      AND gp.MemberID <> vPatientZeroID
      AND gp.MemberID <> vNewlyExposedID
      AND ist.InfectionStatus = 'HEALTHY'

    ORDER BY RAND()
    LIMIT 1;



    INSERT INTO SYMPTOM_EVENT (
        SessionID,
        MemberID,
        SymptomCode,
        AppearanceTurn,
        Severity
    )
    VALUES (
        pSessionID,
        vDecoyID,
        'COLD_FLASH',
        2,
        1
    );

    SET vDecoySymptomID = LAST_INSERT_ID();



    SELECT MemberID
    INTO vObserverID
    FROM GAME_PLAYER

    WHERE SessionID = pSessionID
      AND MemberID <> vDecoyID

    ORDER BY RAND()
    LIMIT 1;


    INSERT INTO OBSERVATION_EVENT (
        SessionID,
        ObserverMemberID,
        SymptomEventID,
        DiscoveredTurn
    )
    VALUES (
        pSessionID,
        vObserverID,
        vDecoySymptomID,
        2
    );



    INSERT INTO SCORE_EVENT (
        SessionID,
        MemberID,
        EventType,
        Points,
        TurnNumber
    )
    VALUES (
        pSessionID,
        vObserverID,
        'SYMPTOM_DETECTED',
        100,
        2
    );



    UPDATE GAME_SESSION
    SET CurrentTurn = 2
    WHERE SessionID = pSessionID;


    COMMIT;



    SELECT
        pSessionID AS SessionID,
        2 AS CurrentTurn,
        'New evidence is available.' AS Message;

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS DiscoverSymptom;

DELIMITER $$

CREATE PROCEDURE DiscoverSymptom(
    IN pSessionID INT UNSIGNED,
    IN pObserverMemberID INT UNSIGNED,
    IN pSymptomEventID BIGINT UNSIGNED
)
BEGIN
    DECLARE vCurrentTurn INT;
    DECLARE vGameStatus VARCHAR(10);

    DECLARE vAppearanceTurn INT;
    DECLARE vSymptomCount INT DEFAULT 0;
    DECLARE vObserverCount INT DEFAULT 0;
    DECLARE vExistingObservation INT DEFAULT 0;

    DECLARE vDetectionDelay INT;
    DECLARE vPoints INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;



    SELECT
        CurrentTurn,
        GameStatus
    INTO
        vCurrentTurn,
        vGameStatus
    FROM GAME_SESSION
    WHERE SessionID = pSessionID
    FOR UPDATE;

    IF vGameStatus <> 'ACTIVE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Symptoms may only be discovered during an active game.';
    END IF;



    SELECT COUNT(*)
    INTO vObserverCount
    FROM GAME_PLAYER
    WHERE SessionID = pSessionID
      AND MemberID = pObserverMemberID;

    IF vObserverCount <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Observer is not a player in this session.';
    END IF;



    SELECT
        COUNT(*),
        MAX(AppearanceTurn)
    INTO
        vSymptomCount,
        vAppearanceTurn
    FROM SYMPTOM_EVENT
    WHERE SessionID = pSessionID
      AND SymptomEventID = pSymptomEventID;

    IF vSymptomCount <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Symptom does not exist in this session.';
    END IF;



    IF vCurrentTurn < vAppearanceTurn THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'This symptom has not appeared yet.';
    END IF;



    SELECT COUNT(*)
    INTO vExistingObservation
    FROM OBSERVATION_EVENT
    WHERE SessionID = pSessionID
      AND ObserverMemberID = pObserverMemberID
      AND SymptomEventID = pSymptomEventID;

    IF vExistingObservation > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'This player has already discovered this symptom.';
    END IF;



    SET vDetectionDelay =
        vCurrentTurn - vAppearanceTurn;

    SET vPoints =
        GREATEST(
            0,
            100 - (15 * vDetectionDelay)
        );



    INSERT INTO OBSERVATION_EVENT (
        SessionID,
        ObserverMemberID,
        SymptomEventID,
        DiscoveredTurn
    )
    VALUES (
        pSessionID,
        pObserverMemberID,
        pSymptomEventID,
        vCurrentTurn
    );



    INSERT INTO SCORE_EVENT (
        SessionID,
        MemberID,
        EventType,
        Points,
        TurnNumber
    )
    VALUES (
        pSessionID,
        pObserverMemberID,
        'SYMPTOM_DETECTED',
        vPoints,
        vCurrentTurn
    );

    COMMIT;



    SELECT
        oe.ObservationID,
        observer.MemberName AS Observer,
        affected.MemberName AS AffectedPlayer,
        sy.SymptomCode,
        sy.AppearanceTurn,
        oe.DiscoveredTurn,
        vDetectionDelay AS DetectionDelay,
        vPoints AS PointsEarned

    FROM OBSERVATION_EVENT AS oe

    JOIN SYMPTOM_EVENT AS sy
        ON oe.SymptomEventID = sy.SymptomEventID

    JOIN FAMILY_MEMBER AS observer
        ON oe.ObserverMemberID = observer.MemberID

    JOIN FAMILY_MEMBER AS affected
        ON sy.MemberID = affected.MemberID

    WHERE oe.SessionID = pSessionID
      AND oe.ObserverMemberID = pObserverMemberID
      AND oe.SymptomEventID = pSymptomEventID;

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS MakeAccusation;

DELIMITER $$

CREATE PROCEDURE MakeAccusation(
    IN pSessionID INT UNSIGNED,
    IN pAccusingMemberID INT UNSIGNED,
    IN pAccusedMemberID INT UNSIGNED
)
BEGIN
    DECLARE vSessionCount INT DEFAULT 0;
    DECLARE vCurrentTurn INT;
    DECLARE vGameStatus VARCHAR(10);

    DECLARE vAccuserCount INT DEFAULT 0;
    DECLARE vAccusedCount INT DEFAULT 0;

    DECLARE vPatientZeroCount INT DEFAULT 0;
    DECLARE vPatientZeroID INT UNSIGNED;

    DECLARE vAccusationID BIGINT UNSIGNED;
    DECLARE vWrongCount INT DEFAULT 0;
    DECLARE vPoints INT DEFAULT 0;
    DECLARE vOutcome VARCHAR(10);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;



    SELECT
        COUNT(*),
        MAX(CurrentTurn),
        MAX(GameStatus)
    INTO
        vSessionCount,
        vCurrentTurn,
        vGameStatus
    FROM GAME_SESSION
    WHERE SessionID = pSessionID;

    IF vSessionCount <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Game session does not exist.';
    END IF;

    IF vGameStatus <> 'ACTIVE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Accusations may only be made during an active game.';
    END IF;



    SELECT COUNT(*)
    INTO vAccuserCount
    FROM GAME_PLAYER
    WHERE SessionID = pSessionID
      AND MemberID = pAccusingMemberID;

    IF vAccuserCount <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Accusing member is not a player in this session.';
    END IF;


    SELECT COUNT(*)
    INTO vAccusedCount
    FROM GAME_PLAYER
    WHERE SessionID = pSessionID
      AND MemberID = pAccusedMemberID;

    IF vAccusedCount <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Accused member is not a player in this session.';
    END IF;


    IF pAccusingMemberID = pAccusedMemberID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'A player cannot accuse themselves.';
    END IF;



    SELECT
        COUNT(*),
        MAX(MemberID)
    INTO
        vPatientZeroCount,
        vPatientZeroID
    FROM INFECTION_STATE
    WHERE SessionID = pSessionID
      AND PatientZero = TRUE;

    IF vPatientZeroCount <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Game state is invalid: exactly one Patient Zero is required.';
    END IF;



    INSERT INTO ACCUSATION_EVENT (
        SessionID,
        AccusingMemberID,
        AccusedMemberID,
        TurnNumber
    )
    VALUES (
        pSessionID,
        pAccusingMemberID,
        pAccusedMemberID,
        vCurrentTurn
    );

    SET vAccusationID = LAST_INSERT_ID();



    IF pAccusedMemberID = vPatientZeroID THEN

        SET vOutcome = 'CORRECT';
        SET vPoints = 500;

        INSERT INTO SCORE_EVENT (
            SessionID,
            MemberID,
            EventType,
            Points,
            TurnNumber
        )
        VALUES (
            pSessionID,
            pAccusingMemberID,
            'CORRECT_DEDUCTION',
            vPoints,
            vCurrentTurn
        );

        UPDATE GAME_SESSION
        SET GameStatus = 'WON'
        WHERE SessionID = pSessionID;

    ELSE

        SET vOutcome = 'WRONG';
        SET vPoints = -150;

        INSERT INTO SCORE_EVENT (
            SessionID,
            MemberID,
            EventType,
            Points,
            TurnNumber
        )
        VALUES (
            pSessionID,
            pAccusingMemberID,
            'WRONG_ACCUSATION',
            vPoints,
            vCurrentTurn
        );



        UPDATE GAME_PLAYER
        SET PlayerStatus = 'CLEARED'
        WHERE SessionID = pSessionID
          AND MemberID = pAccusedMemberID;



        SELECT COUNT(*)
        INTO vWrongCount

        FROM ACCUSATION_EVENT AS ae

        JOIN INFECTION_STATE AS ist
            ON ae.SessionID = ist.SessionID
            AND ist.PatientZero = TRUE

        WHERE ae.SessionID = pSessionID
          AND ae.AccusedMemberID <> ist.MemberID;


        IF vWrongCount >= 3 THEN

            UPDATE GAME_SESSION
            SET GameStatus = 'LOST'
            WHERE SessionID = pSessionID;

        END IF;

    END IF;


    COMMIT;



    SELECT
        vAccusationID AS AccusationID,
        accuser.MemberName AS Accuser,
        accused.MemberName AS Accused,
        vOutcome AS Outcome,
        vPoints AS Points,
        vWrongCount AS WrongAccusations,

        (
            SELECT GameStatus
            FROM GAME_SESSION
            WHERE SessionID = pSessionID
        ) AS GameStatus

    FROM FAMILY_MEMBER AS accuser
    CROSS JOIN FAMILY_MEMBER AS accused

    WHERE accuser.MemberID = pAccusingMemberID
      AND accused.MemberID = pAccusedMemberID;

END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS AdvanceTurn;

DELIMITER $$

CREATE PROCEDURE AdvanceTurn(
    IN pSessionID INT UNSIGNED
)

main: BEGIN

    DECLARE vSessionCount INT DEFAULT 0;

    DECLARE vCurrentTurn INT;
    DECLARE vNextTurn INT;
    DECLARE vGameStatus VARCHAR(10);

    DECLARE vCandidateCount INT DEFAULT 0;
    DECLARE vSourceMemberID INT UNSIGNED;
    DECLARE vTargetMemberID INT UNSIGNED;

    DECLARE vTotalPlayers INT DEFAULT 0;
    DECLARE vInfectedPlayers INT DEFAULT 0;
    DECLARE vNewSymptomCount INT DEFAULT 0;


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;


    START TRANSACTION;



    SELECT COUNT(*)
    INTO vSessionCount

    FROM GAME_SESSION

    WHERE SessionID = pSessionID;


    IF vSessionCount <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Game session does not exist.';

    END IF;


    SELECT
        CurrentTurn,
        GameStatus

    INTO
        vCurrentTurn,
        vGameStatus

    FROM GAME_SESSION

    WHERE SessionID = pSessionID

    FOR UPDATE;


    IF vGameStatus <> 'ACTIVE' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Only an active game may advance turns.';

    END IF;



    IF vCurrentTurn >= 12 THEN

        UPDATE GAME_SESSION

        SET GameStatus = 'LOST'

        WHERE SessionID = pSessionID;


        COMMIT;


        SELECT
            pSessionID AS SessionID,
            12 AS CurrentTurn,
            'LOST' AS GameStatus,
            'Turn limit reached.' AS Message;


        LEAVE main;

    END IF;


    SET vNextTurn = vCurrentTurn + 1;



    UPDATE INFECTION_STATE

    SET InfectionStatus =

        CASE

            WHEN (vNextTurn - InfectionTurn) >= 5
                THEN 'REMOVED'

            WHEN (vNextTurn - InfectionTurn) >= 4
                THEN 'CRITICAL'

            WHEN (vNextTurn - InfectionTurn) >= 2
                THEN 'SYMPTOMATIC'

            WHEN (vNextTurn - InfectionTurn) >= 1
                THEN 'LATENT'

            ELSE 'EXPOSED'

        END

    WHERE SessionID = pSessionID
      AND InfectionTurn IS NOT NULL
      AND InfectionStatus <> 'REMOVED';



    UPDATE GAME_PLAYER AS gp

    JOIN INFECTION_STATE AS ist

        ON gp.SessionID = ist.SessionID
        AND gp.MemberID = ist.MemberID

    SET gp.PlayerStatus = 'REMOVED'

    WHERE gp.SessionID = pSessionID
      AND ist.InfectionStatus = 'REMOVED';



    SELECT
        COUNT(*),
        MAX(SourceMemberID),
        MAX(TargetMemberID)

    INTO
        vCandidateCount,
        vSourceMemberID,
        vTargetMemberID

    FROM (

        SELECT
            SourceMemberID,
            TargetMemberID

        FROM (


            SELECT
                ce.PlayerAID AS SourceMemberID,
                ce.PlayerBID AS TargetMemberID

            FROM CONTACT_EVENT AS ce

            JOIN INFECTION_STATE AS sourceState

                ON ce.SessionID = sourceState.SessionID
                AND ce.PlayerAID = sourceState.MemberID

            JOIN INFECTION_STATE AS targetState

                ON ce.SessionID = targetState.SessionID
                AND ce.PlayerBID = targetState.MemberID

            WHERE ce.SessionID = pSessionID
              AND ce.TurnNumber = vCurrentTurn

              AND sourceState.InfectionTurn IS NOT NULL
              AND sourceState.InfectionTurn <= vCurrentTurn
              AND sourceState.InfectionStatus <> 'REMOVED'

              AND targetState.InfectionTurn IS NULL


            UNION ALL



            SELECT
                ce.PlayerBID AS SourceMemberID,
                ce.PlayerAID AS TargetMemberID

            FROM CONTACT_EVENT AS ce

            JOIN INFECTION_STATE AS sourceState

                ON ce.SessionID = sourceState.SessionID
                AND ce.PlayerBID = sourceState.MemberID

            JOIN INFECTION_STATE AS targetState

                ON ce.SessionID = targetState.SessionID
                AND ce.PlayerAID = targetState.MemberID

            WHERE ce.SessionID = pSessionID
              AND ce.TurnNumber = vCurrentTurn

              AND sourceState.InfectionTurn IS NOT NULL
              AND sourceState.InfectionTurn <= vCurrentTurn
              AND sourceState.InfectionStatus <> 'REMOVED'

              AND targetState.InfectionTurn IS NULL

        ) AS possible_transmissions

        ORDER BY RAND()

        LIMIT 1

    ) AS selected_transmission;



    IF vCandidateCount = 1 THEN

        UPDATE INFECTION_STATE

        SET
            InfectionStatus = 'EXPOSED',
            InfectionTurn = vNextTurn,
            InfectedByMemberID = vSourceMemberID

        WHERE SessionID = pSessionID
          AND MemberID = vTargetMemberID;

    END IF;



    INSERT INTO SYMPTOM_EVENT (

        SessionID,
        MemberID,
        SymptomCode,
        AppearanceTurn,
        Severity

    )

    SELECT

        pSessionID,

        ist.MemberID,

        CASE MOD(
            ist.MemberID + vNextTurn,
            5
        )

            WHEN 0 THEN 'STATIC_VISION'
            WHEN 1 THEN 'COLD_FLASH'
            WHEN 2 THEN 'AUDIO_DISTORTION'
            WHEN 3 THEN 'MEMORY_SKIP'
            ELSE 'SHADOW_FLICKER'

        END,

        vNextTurn,

        1 + MOD(
            ist.MemberID + vNextTurn,
            5
        )

    FROM INFECTION_STATE AS ist

    WHERE ist.SessionID = pSessionID

      AND ist.InfectionTurn IS NOT NULL

      AND (
          vNextTurn - ist.InfectionTurn
      ) = 2

      AND NOT EXISTS (

          SELECT 1

          FROM SYMPTOM_EVENT AS sy

          WHERE sy.SessionID = pSessionID
            AND sy.MemberID = ist.MemberID
            AND sy.AppearanceTurn = vNextTurn

      );


    SELECT COUNT(*)

    INTO vNewSymptomCount

    FROM SYMPTOM_EVENT

    WHERE SessionID = pSessionID
      AND AppearanceTurn = vNextTurn;



    UPDATE GAME_SESSION

    SET CurrentTurn = vNextTurn

    WHERE SessionID = pSessionID;



    SELECT COUNT(*)

    INTO vTotalPlayers

    FROM GAME_PLAYER

    WHERE SessionID = pSessionID;


    SELECT COUNT(*)

    INTO vInfectedPlayers

    FROM INFECTION_STATE

    WHERE SessionID = pSessionID
      AND InfectionTurn IS NOT NULL;



    IF
        vTotalPlayers > 0
        AND
        (vInfectedPlayers * 4)
        >=
        (vTotalPlayers * 3)

    THEN

        UPDATE GAME_SESSION

        SET GameStatus = 'LOST'

        WHERE SessionID = pSessionID;

    END IF;


    COMMIT;



    SELECT

        pSessionID AS SessionID,

        vNextTurn AS CurrentTurn,

        (
            SELECT GameStatus

            FROM GAME_SESSION

            WHERE SessionID = pSessionID
        ) AS GameStatus,

        vNewSymptomCount AS NewClues,

        CASE

            WHEN vNewSymptomCount > 0
                THEN 'New evidence is available.'

            ELSE
                'No new symptom evidence was discovered.'

        END AS Message;

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS RecordContact;

DELIMITER $$

CREATE PROCEDURE RecordContact(
    IN pSessionID INT UNSIGNED,
    IN pMember1ID INT UNSIGNED,
    IN pMember2ID INT UNSIGNED,
    IN pSiteID INT UNSIGNED
)

main: BEGIN

    DECLARE vCurrentTurn INT;
    DECLARE vGameStatus VARCHAR(10);

    DECLARE vPlayerAID INT UNSIGNED;
    DECLARE vPlayerBID INT UNSIGNED;

    DECLARE vPlayerACount INT DEFAULT 0;
    DECLARE vPlayerBCount INT DEFAULT 0;
    DECLARE vSiteCount INT DEFAULT 0;
    DECLARE vDuplicateCount INT DEFAULT 0;

    DECLARE vPlayerAStatus VARCHAR(10);
    DECLARE vPlayerBStatus VARCHAR(10);

    DECLARE vContactEventID BIGINT UNSIGNED;


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;


    START TRANSACTION;



    SELECT
        CurrentTurn,
        GameStatus

    INTO
        vCurrentTurn,
        vGameStatus

    FROM GAME_SESSION

    WHERE SessionID = pSessionID

    FOR UPDATE;


    IF vGameStatus IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Game session does not exist.';

    END IF;


    IF vGameStatus <> 'ACTIVE' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Contacts may only be recorded during an active game.';

    END IF;



    IF pMember1ID = pMember2ID THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'A player cannot have a contact event with themselves.';

    END IF;



    SET vPlayerAID =
        LEAST(pMember1ID, pMember2ID);

    SET vPlayerBID =
        GREATEST(pMember1ID, pMember2ID);



    SELECT
        COUNT(*),
        MAX(PlayerStatus)

    INTO
        vPlayerACount,
        vPlayerAStatus

    FROM GAME_PLAYER

    WHERE SessionID = pSessionID
      AND MemberID = vPlayerAID;


    IF vPlayerACount <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'First player is not part of this game session.';

    END IF;


    IF vPlayerAStatus = 'REMOVED' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'A removed player cannot participate in contact events.';

    END IF;



    SELECT
        COUNT(*),
        MAX(PlayerStatus)

    INTO
        vPlayerBCount,
        vPlayerBStatus

    FROM GAME_PLAYER

    WHERE SessionID = pSessionID
      AND MemberID = vPlayerBID;


    IF vPlayerBCount <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Second player is not part of this game session.';

    END IF;


    IF vPlayerBStatus = 'REMOVED' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'A removed player cannot participate in contact events.';

    END IF;



    SELECT COUNT(*)

    INTO vSiteCount

    FROM VACATION_SITE

    WHERE SiteID = pSiteID;


    IF vSiteCount <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Vacation site does not exist.';

    END IF;



    SELECT COUNT(*)

    INTO vDuplicateCount

    FROM CONTACT_EVENT

    WHERE SessionID = pSessionID
      AND TurnNumber = vCurrentTurn
      AND PlayerAID = vPlayerAID
      AND PlayerBID = vPlayerBID
      AND SiteID = pSiteID;


    IF vDuplicateCount > 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'This contact event has already been recorded.';

    END IF;



    INSERT INTO CONTACT_EVENT (
        SessionID,
        TurnNumber,
        PlayerAID,
        PlayerBID,
        SiteID
    )

    VALUES (
        pSessionID,
        vCurrentTurn,
        vPlayerAID,
        vPlayerBID,
        pSiteID
    );


    SET vContactEventID =
        LAST_INSERT_ID();


    COMMIT;



    SELECT
        ce.ContactEventID,
        ce.TurnNumber,
        playerA.MemberName AS PlayerA,
        playerB.MemberName AS PlayerB,
        vs.SiteName

    FROM CONTACT_EVENT AS ce

    JOIN FAMILY_MEMBER AS playerA
        ON ce.PlayerAID = playerA.MemberID

    JOIN FAMILY_MEMBER AS playerB
        ON ce.PlayerBID = playerB.MemberID

    JOIN VACATION_SITE AS vs
        ON ce.SiteID = vs.SiteID

    WHERE ce.ContactEventID =
        vContactEventID;

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS RecordActivity;

DELIMITER $$

CREATE PROCEDURE RecordActivity(
    IN pSessionID INT UNSIGNED,
    IN pMemberID INT UNSIGNED,
    IN pSiteID INT UNSIGNED,
    IN pActivityID INT UNSIGNED
)
BEGIN

    DECLARE vCurrentTurn INT;
    DECLARE vGameStatus VARCHAR(10);

    DECLARE vPlayerCount INT DEFAULT 0;
    DECLARE vPlayerStatus VARCHAR(10);

    DECLARE vActivityCount INT DEFAULT 0;

    DECLARE vActivityEventID BIGINT UNSIGNED;


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;


    START TRANSACTION;



    SELECT
        CurrentTurn,
        GameStatus

    INTO
        vCurrentTurn,
        vGameStatus

    FROM GAME_SESSION

    WHERE SessionID = pSessionID

    FOR UPDATE;


    IF vGameStatus IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Game session does not exist.';

    END IF;


    IF vGameStatus <> 'ACTIVE' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Activities may only be recorded during an active game.';

    END IF;



    SELECT
        COUNT(*),
        MAX(PlayerStatus)

    INTO
        vPlayerCount,
        vPlayerStatus

    FROM GAME_PLAYER

    WHERE SessionID = pSessionID
      AND MemberID = pMemberID;


    IF vPlayerCount <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Player is not part of this game session.';

    END IF;


    IF vPlayerStatus = 'REMOVED' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'A removed player cannot perform activities.';

    END IF;



    SELECT COUNT(*)

    INTO vActivityCount

    FROM SITE_ACTIVITY

    WHERE SiteID = pSiteID
      AND ActivityID = pActivityID;


    IF vActivityCount <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'This activity is not available at the selected vacation site.';

    END IF;



    INSERT INTO ACTIVITY_EVENT (
        SessionID,
        TurnNumber,
        MemberID,
        SiteID,
        ActivityID
    )

    VALUES (
        pSessionID,
        vCurrentTurn,
        pMemberID,
        pSiteID,
        pActivityID
    );


    SET vActivityEventID =
        LAST_INSERT_ID();


    COMMIT;



    SELECT
        ae.ActivityEventID,
        ae.TurnNumber,
        fm.MemberName,
        vs.SiteName,
        a.ActivityName,
        a.ActivityCategory

    FROM ACTIVITY_EVENT AS ae

    JOIN FAMILY_MEMBER AS fm
        ON ae.MemberID = fm.MemberID

    JOIN VACATION_SITE AS vs
        ON ae.SiteID = vs.SiteID

    JOIN ACTIVITY AS a
        ON ae.ActivityID = a.ActivityID

    WHERE ae.ActivityEventID =
        vActivityEventID;

END$$

DELIMITER ;
DROP PROCEDURE IF EXISTS InvestigateForClue;

DELIMITER $$

CREATE PROCEDURE InvestigateForClue(
    IN pSessionID INT UNSIGNED,
    IN pObserverMemberID INT UNSIGNED
)
main: BEGIN

    DECLARE vCurrentTurn INT;
    DECLARE vGameStatus VARCHAR(10);

    DECLARE vActivityCount INT DEFAULT 0;
    DECLARE vSiteID INT UNSIGNED;
    DECLARE vActivityID INT UNSIGNED;

    DECLARE vClueCount INT DEFAULT 0;
    DECLARE vSymptomEventID BIGINT UNSIGNED;
    DECLARE vAffectedMemberID INT UNSIGNED;
    DECLARE vAppearanceTurn INT;

    DECLARE vDetectionDelay INT;
    DECLARE vPoints INT;


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;


    START TRANSACTION;



    SELECT
        CurrentTurn,
        GameStatus
    INTO
        vCurrentTurn,
        vGameStatus
    FROM GAME_SESSION
    WHERE SessionID = pSessionID
    FOR UPDATE;


    IF vGameStatus <> 'ACTIVE' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Investigation requires an active game.';

    END IF;



    SELECT
        COUNT(*),
        MAX(SiteID),
        MAX(ActivityID)
    INTO
        vActivityCount,
        vSiteID,
        vActivityID
    FROM ACTIVITY_EVENT
    WHERE SessionID = pSessionID
      AND TurnNumber = vCurrentTurn
      AND MemberID = pObserverMemberID;


    IF vActivityCount <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Player must record an activity before investigating.';

    END IF;



    SELECT
        COUNT(*),
        MIN(sy.SymptomEventID)

    INTO
        vClueCount,
        vSymptomEventID

    FROM SYMPTOM_EVENT AS sy

    JOIN ACTIVITY_CLUE_RULE AS ruleSet
        ON sy.SymptomCode = ruleSet.SymptomCode
        AND ruleSet.ActivityID = vActivityID

    JOIN ACTIVITY_EVENT AS affectedActivity
        ON sy.SessionID = affectedActivity.SessionID
        AND sy.MemberID = affectedActivity.MemberID
        AND affectedActivity.TurnNumber = vCurrentTurn
        AND affectedActivity.SiteID = vSiteID

    WHERE sy.SessionID = pSessionID

      AND sy.AppearanceTurn <= vCurrentTurn

      AND sy.MemberID <> pObserverMemberID

      AND NOT EXISTS (

          SELECT 1

          FROM OBSERVATION_EVENT AS oe

          WHERE oe.SessionID = pSessionID
            AND oe.ObserverMemberID = pObserverMemberID
            AND oe.SymptomEventID = sy.SymptomEventID

      );



    IF vClueCount = 0 THEN

        COMMIT;

        SELECT
            pSessionID AS SessionID,
            vCurrentTurn AS TurnNumber,
            'NO_CLUE' AS Result,
            'Nothing unusual was discovered.' AS Message;

        LEAVE main;

    END IF;



    SELECT
        MemberID,
        AppearanceTurn
    INTO
        vAffectedMemberID,
        vAppearanceTurn
    FROM SYMPTOM_EVENT
    WHERE SymptomEventID = vSymptomEventID;



    SET vDetectionDelay =
        vCurrentTurn - vAppearanceTurn;

    SET vPoints =
        GREATEST(
            0,
            100 - (15 * vDetectionDelay)
        );



    INSERT INTO OBSERVATION_EVENT (
        SessionID,
        ObserverMemberID,
        SymptomEventID,
        DiscoveredTurn
    )
    VALUES (
        pSessionID,
        pObserverMemberID,
        vSymptomEventID,
        vCurrentTurn
    );



    INSERT INTO SCORE_EVENT (
        SessionID,
        MemberID,
        EventType,
        Points,
        TurnNumber
    )
    VALUES (
        pSessionID,
        pObserverMemberID,
        'SYMPTOM_DETECTED',
        vPoints,
        vCurrentTurn
    );


    COMMIT;



    SELECT
        observer.MemberName AS Investigator,
        affected.MemberName AS AffectedPlayer,
        sy.SymptomCode,
        vCurrentTurn AS DiscoveryTurn,
        vDetectionDelay AS DetectionDelay,
        vPoints AS PointsEarned,
        vs.SiteName,
        act.ActivityName

    FROM SYMPTOM_EVENT AS sy

    JOIN FAMILY_MEMBER AS observer
        ON observer.MemberID = pObserverMemberID

    JOIN FAMILY_MEMBER AS affected
        ON affected.MemberID = vAffectedMemberID

    JOIN VACATION_SITE AS vs
        ON vs.SiteID = vSiteID

    JOIN ACTIVITY AS act
        ON act.ActivityID = vActivityID

    WHERE sy.SymptomEventID =
        vSymptomEventID;

END$$

DELIMITER ;



DROP PROCEDURE IF EXISTS ShowGameDashboard;

DELIMITER $$

CREATE PROCEDURE ShowGameDashboard(
    IN pSessionID INT UNSIGNED
)
BEGIN

    DECLARE vSessionCount INT DEFAULT 0;
    DECLARE vCurrentTurn INT DEFAULT 0;


    -- =====================================================
    -- Validate session
    -- =====================================================

    SELECT COUNT(*)
    INTO vSessionCount

    FROM GAME_SESSION

    WHERE SessionID = pSessionID;


    IF vSessionCount <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Game session does not exist.';

    END IF;


    SELECT CurrentTurn
    INTO vCurrentTurn

    FROM GAME_SESSION

    WHERE SessionID = pSessionID;


    -- =====================================================
    -- RESULT SET 1
    -- SESSION STATUS
    -- =====================================================

    SELECT
        SessionID,
        StartedAt,
        CurrentTurn,
        GameStatus,
        PlayerCount

    FROM vw_session_status

    WHERE SessionID = pSessionID;


    -- =====================================================
    -- RESULT SET 2
    -- PLAYER ROSTER + SCORES
    -- =====================================================

    SELECT
        MemberID,
        MemberName,
        PlayerStatus,
        TotalScore

    FROM vw_game_roster

    WHERE SessionID = pSessionID

    ORDER BY MemberID;


    -- =====================================================
    -- RESULT SET 3
    -- CURRENT TURN ACTIVITIES
    -- =====================================================

    SELECT
        MemberName,
        SiteName,
        ActivityName,
        ActivityCategory

    FROM vw_activity_log

    WHERE SessionID = pSessionID
      AND TurnNumber = vCurrentTurn

    ORDER BY MemberID;


    -- =====================================================
    -- RESULT SET 4
    -- CONTACT HISTORY THROUGH CURRENT TURN
    -- =====================================================

    SELECT
        TurnNumber,
        PlayerAName,
        PlayerBName,
        SiteName

    FROM vw_contact_log

    WHERE SessionID = pSessionID
      AND TurnNumber <= vCurrentTurn

    ORDER BY
        TurnNumber,
        ContactEventID;


    -- =====================================================
    -- RESULT SET 5
    -- DISCOVERED CLUES ONLY
    -- =====================================================

    SELECT
        ObserverName,
        AffectedMemberName,
        SymptomCode,
        AppearanceTurn,
        DiscoveredTurn,
        DetectionDelay,
        PotentialPoints,
        Severity

    FROM vw_observation_log

    WHERE SessionID = pSessionID

    ORDER BY ObservationID;


    -- =====================================================
    -- RESULT SET 6
    -- ACCUSATION SUMMARY
    --
    -- Uses hidden truth internally but returns only counts.
    -- =====================================================

    SELECT
        COUNT(ae.AccusationID)
            AS TotalAccusations,

        COALESCE(
            SUM(
                CASE
                    WHEN ae.AccusedMemberID <> ist.MemberID
                    THEN 1
                    ELSE 0
                END
            ),
            0
        ) AS WrongAccusations

    FROM ACCUSATION_EVENT AS ae

    JOIN INFECTION_STATE AS ist
        ON ae.SessionID = ist.SessionID
        AND ist.PatientZero = TRUE

    WHERE ae.SessionID = pSessionID;

END$$

DELIMITER ;






