-- normalization.sql
-- Split multi-value columns into normalized tables: directors, country, cast, listed_in, genre
-- This example uses MySQL's JSON functions to split comma-separated lists into rows.
-- If your MySQL version supports JSON_TABLE you can adapt; otherwise you can use simple string parsing.

-- netflix_directors
DROP TABLE IF EXISTS netflix_directors;
CREATE TABLE netflix_directors AS
SELECT show_id, TRIM(director_name) AS director
FROM (
    SELECT show_id,
           TRIM(JSON_UNQUOTE(JSON_EXTRACT(json_split, '$'))) AS director_name
    FROM (
        SELECT show_id,
               CONCAT('["', REPLACE(REPLACE(REPLACE(director, '"', ''), ', ', '","'), ',', '","'), '"]') AS director_json
        FROM netflix_raw
    ) t
    CROSS JOIN JSON_TABLE(t.director_json, '$[*]' COLUMNS (json_split JSON PATH '$')) jt
) s
WHERE director <> '' AND director IS NOT NULL;

-- netflix_country
DROP TABLE IF EXISTS netflix_country;
CREATE TABLE netflix_country AS
SELECT show_id, TRIM(country_name) AS country
FROM (
    SELECT show_id,
           TRIM(JSON_UNQUOTE(JSON_EXTRACT(json_split, '$'))) AS country_name
    FROM (
        SELECT show_id,
               CONCAT('["', REPLACE(REPLACE(REPLACE(country, '"', ''), ', ', '","'), ',', '","'), '"]') AS country_json
        FROM netflix_raw
    ) t
    CROSS JOIN JSON_TABLE(t.country_json, '$[*]' COLUMNS (json_split JSON PATH '$')) jt
) s
WHERE country <> '' AND country IS NOT NULL;

-- netflix_cast
DROP TABLE IF EXISTS netflix_cast;
CREATE TABLE netflix_cast AS
SELECT show_id, TRIM(cast_name) AS cast
FROM (
    SELECT show_id,
           TRIM(JSON_UNQUOTE(JSON_EXTRACT(json_split, '$'))) AS cast_name
    FROM (
        SELECT show_id,
               CONCAT('["', REPLACE(REPLACE(REPLACE(`cast`, '"', ''), ', ', '","'), ',', '","'), '"]') AS cast_json
        FROM netflix_raw
    ) t
    CROSS JOIN JSON_TABLE(t.cast_json, '$[*]' COLUMNS (json_split JSON PATH '$')) jt
) s
WHERE cast <> '' AND cast IS NOT NULL;

-- netflix_listed
DROP TABLE IF EXISTS netflix_listed;
CREATE TABLE netflix_listed AS
SELECT show_id, TRIM(listed_name) AS listed_in
FROM (
    SELECT show_id,
           TRIM(JSON_UNQUOTE(JSON_EXTRACT(json_split, '$'))) AS listed_name
    FROM (
        SELECT show_id,
               CONCAT('["', REPLACE(REPLACE(REPLACE(listed_in, '"', ''), ', ', '","'), ',', '","'), '"]') AS listed_json
        FROM netflix_raw
    ) t
    CROSS JOIN JSON_TABLE(t.listed_json, '$[*]' COLUMNS (json_split JSON PATH '$')) jt
) s
WHERE listed_in <> '' AND listed_in IS NOT NULL;

-- netflix_genre (listed_gener)
DROP TABLE IF EXISTS netflix_genre;
CREATE TABLE netflix_genre AS
SELECT show_id, TRIM(genre_name) AS genre
FROM (
    SELECT show_id,
           TRIM(JSON_UNQUOTE(JSON_EXTRACT(json_split, '$'))) AS genre_name
    FROM (
        SELECT show_id,
               CONCAT('["', REPLACE(REPLACE(REPLACE(listed_in, '"', ''), ', ', '","'), ',', '","'), '"]') AS genre_json
        FROM netflix_raw
    ) t
    CROSS JOIN JSON_TABLE(t.genre_json, '$[*]' COLUMNS (json_split JSON PATH '$')) jt
) s
WHERE genre <> '' AND genre IS NOT NULL;
