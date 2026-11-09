-- CSC6302 Database Principles
-- Programming Project 2
-- Video Game Database: Five Required Queries
--
-- Run after the professor's VideoGameCreationScript.sql.

USE VideoGameSystems;


-- =========================================================
-- 1. What games were released on the first game console
--    you ever owned?
--
-- Selected console: Play Station 2
-- =========================================================

SELECT
    GameName
FROM Game
WHERE ConsoleName = 'Play Station 2'
ORDER BY GameName;


-- =========================================================
-- 2. Pick four games and update their NumPlayers field.
-- =========================================================

-- =========================================================
-- 2. Pick four games and update their NumPlayers field.
-- =========================================================

UPDATE Game
SET NumPlayers = 4
WHERE Id IN (1, 2, 3, 4);

SELECT
    Id,
    GameName,
    NumPlayers
FROM Game
WHERE Id IN (1, 2, 3, 4)
ORDER BY Id;


-- =========================================================
-- 3. What games were released on consoles
--    released before 2000?
-- =========================================================

SELECT
    g.GameName,
    g.ConsoleName
FROM Game g
JOIN Console c
    ON c.ConsoleName = g.ConsoleName
WHERE c.ReleaseDate < '2000-01-01'
ORDER BY c.ReleaseDate, g.GameName;


-- =========================================================
-- 4. How many games were released on all
--    of the PlayStation consoles?
-- =========================================================

SELECT
    COUNT(*) AS NumberOfPlayStationGames
FROM Game
WHERE ConsoleName LIKE 'Play Station%';


-- =========================================================
-- 5. What are the names of the games, their consoles,
--    and their series, that allow online play?
-- =========================================================

SELECT
    g.GameName,
    g.ConsoleName,
    s.SeriesName
FROM Game g
LEFT JOIN Series s
    ON s.Id = g.Series
WHERE g.IsOnline = TRUE
ORDER BY g.GameName, g.ConsoleName;
