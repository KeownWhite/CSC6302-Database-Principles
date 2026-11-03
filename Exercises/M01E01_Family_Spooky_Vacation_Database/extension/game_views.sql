
-- CSC6302 Database Principles
-- OPTIONAL EXTENSION
-- Paranormal Expedition Mode
-- Player-safe views
USE FamilySpookyVacation;
DROP VIEW IF EXISTS vw_symptom_log;



-- =========================================================
-- GAME ROSTER
-- =========================================================
-- =========================================================
-- CONTACT LOG
-- =========================================================
-- =========================================================
-- OBSERVATION LOG
--
-- Only discovered symptoms appear here.
-- Undiscovered symptoms remain hidden.
-- =========================================================
-- =========================================================
-- SESSION STATUS
-- =========================================================
CREATE OR REPLACE VIEW vw_game_roster AS
SELECT
    gp.SessionID,
    gp.MemberID,
    fm.MemberName,
    gp.PlayerStatus,
    COALESCE(SUM(se.Points), 0) AS TotalScore
FROM GAME_PLAYER AS gp
JOIN FAMILY_MEMBER AS fm
    ON gp.MemberID = fm.MemberID
LEFT JOIN SCORE_EVENT AS se
    ON gp.SessionID = se.SessionID
    AND gp.MemberID = se.MemberID
GROUP BY
    gp.SessionID,
    gp.MemberID,
    fm.MemberName,
    gp.PlayerStatus;



CREATE OR REPLACE VIEW vw_contact_log AS
SELECT
    ce.ContactEventID,
    ce.SessionID,
    ce.TurnNumber,
    ce.PlayerAID,
    playerA.MemberName AS PlayerAName,
    ce.PlayerBID,
    playerB.MemberName AS PlayerBName,
    ce.SiteID,
    vs.SiteName
FROM CONTACT_EVENT AS ce
JOIN FAMILY_MEMBER AS playerA
    ON ce.PlayerAID = playerA.MemberID
JOIN FAMILY_MEMBER AS playerB
    ON ce.PlayerBID = playerB.MemberID
JOIN VACATION_SITE AS vs
    ON ce.SiteID = vs.SiteID;



CREATE OR REPLACE VIEW vw_observation_log AS
SELECT
    oe.ObservationID,
    oe.SessionID,

    oe.ObserverMemberID,
    observer.MemberName AS ObserverName,

    sy.MemberID AS AffectedMemberID,
    affected.MemberName AS AffectedMemberName,

    sy.SymptomCode,
    sy.AppearanceTurn,
    oe.DiscoveredTurn,

    (oe.DiscoveredTurn - sy.AppearanceTurn)
        AS DetectionDelay,

    GREATEST(
        0,
        100 - (
            15 * (
                oe.DiscoveredTurn
                - sy.AppearanceTurn
            )
        )
    ) AS PotentialPoints,

    sy.Severity

FROM OBSERVATION_EVENT AS oe

JOIN SYMPTOM_EVENT AS sy
    ON oe.SymptomEventID = sy.SymptomEventID
    AND oe.SessionID = sy.SessionID

JOIN FAMILY_MEMBER AS observer
    ON oe.ObserverMemberID = observer.MemberID

JOIN FAMILY_MEMBER AS affected
    ON sy.MemberID = affected.MemberID;



CREATE OR REPLACE VIEW vw_session_status AS
SELECT
    gs.SessionID,
    gs.StartedAt,
    gs.CurrentTurn,
    gs.GameStatus,
    COUNT(gp.MemberID) AS PlayerCount
FROM GAME_SESSION AS gs
LEFT JOIN GAME_PLAYER AS gp
    ON gs.SessionID = gp.SessionID
GROUP BY
    gs.SessionID,
    gs.StartedAt,
    gs.CurrentTurn,
    gs.GameStatus;

-- =========================================================
-- ACTIVITY LOG
-- Player-safe activity history.
-- =========================================================

CREATE OR REPLACE VIEW vw_activity_log AS

SELECT
    ae.ActivityEventID,
    ae.SessionID,
    ae.TurnNumber,
    ae.MemberID,
    fm.MemberName,
    ae.SiteID,
    vs.SiteName,
    ae.ActivityID,
    a.ActivityName,
    a.ActivityCategory

FROM ACTIVITY_EVENT AS ae

JOIN FAMILY_MEMBER AS fm
    ON ae.MemberID = fm.MemberID

JOIN VACATION_SITE AS vs
    ON ae.SiteID = vs.SiteID

JOIN ACTIVITY AS a
    ON ae.ActivityID = a.ActivityID;