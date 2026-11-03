-- CSC6302 Database Principles
-- OPTIONAL EXTENSION
-- Paranormal Expedition Mode
-- Turn 1 opening contact events

USE FamilySpookyVacation;

-- Session 1, Turn 1
-- Canonical ordering rule:
-- PlayerAID < PlayerBID

INSERT INTO CONTACT_EVENT (
    SessionID,
    TurnNumber,
    PlayerAID,
    PlayerBID,
    SiteID
)
VALUES
    (1, 1, 1, 2, 2),
    (1, 1, 1, 3, 2),
    (1, 1, 2, 4, 1),
    (1, 1, 3, 4, 3);
