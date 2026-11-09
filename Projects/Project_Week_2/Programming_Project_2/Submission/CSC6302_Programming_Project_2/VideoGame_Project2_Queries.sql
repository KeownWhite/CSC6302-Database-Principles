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
--
-- The games are named for readability, while the outer UPDATE
-- predicates on the primary-key Id so the statement also works
-- with MySQL Workbench Safe Updates enabled.
-- =========================================================

UPDATE Game
SET NumPlayers = 4
WHERE Id IN (
    SELECT Id
    FROM (
        SELECT Id
        FROM Game
        WHERE GameName IN (
            'Animal Crossing',
            'Wild World',
            'City Folk',
            'New Leaf'
        )
    ) AS SelectedGames
);

SELECT
    GameName,
    NumPlayers
FROM Game
WHERE GameName IN (
    'Animal Crossing',
    'Wild World',
    'City Folk',
    'New Leaf'
)
ORDER BY GameName;


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
--
-- In the supplied professor database, Play Station, Play Station 2-5,
-- and Play Station Portable all use the "Play Station" prefix.
-- =========================================================

SELECT
    COUNT(*) AS NumberOfPlayStationGames
FROM Game
WHERE ConsoleName IN (
    SELECT ConsoleName
    FROM Console
    WHERE ConsoleName LIKE 'Play Station%'
);


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
