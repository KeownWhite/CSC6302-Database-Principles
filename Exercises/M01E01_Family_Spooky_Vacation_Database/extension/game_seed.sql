-- CSC6302 Database Principles
-- OPTIONAL EXTENSION
-- Paranormal Expedition Mode
-- Static game configuration data

USE FamilySpookyVacation;

INSERT INTO ACTIVITY_CLUE_RULE
    (SymptomCode, ActivityID)
VALUES
    ('STATIC_VISION', 1),
    ('COLD_FLASH', 3),
    ('AUDIO_DISTORTION', 6),
    ('MEMORY_SKIP', 2),
    ('SHADOW_FLICKER', 4);
