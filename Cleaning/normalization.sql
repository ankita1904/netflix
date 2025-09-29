%sql
%run "./Extract"
-- normalization.sql (Databricks SQL version)
-- Split multi-value columns into normalized tables: directors, country, cast, listed_in, genre
-- Using Databricks SQL SPLIT + EXPLODE instead of JSON_TABLE

-- netflix_directors
DROP TABLE IF EXISTS netflix_directors;
CREATE TABLE netflix_directors 
USING PARQUET  
AS
SELECT
  show_id,
  TRIM(director_name) AS director
FROM (
    SELECT
      show_id,
      EXPLODE(SPLIT(director, ',')) AS director_name
    FROM netflix_raw
) t
WHERE director_name IS NOT NULL AND director_name <> '';

-- netflix_country
DROP TABLE IF EXISTS netflix_country;
CREATE TABLE netflix_country
USING PARQUET
  AS
SELECT
  show_id,
  TRIM(country_name) AS country
FROM (
    SELECT
      show_id,
      EXPLODE(SPLIT(country, ',')) AS country_name
    FROM netflix_raw
) t
WHERE country_name IS NOT NULL AND country_name <> '';

-- netflix_cast
DROP TABLE IF EXISTS netflix_cast;
CREATE TABLE netflix_cast 
  USING PARQUET
  AS
SELECT
  show_id,
  TRIM(cast_name) AS cast
FROM (
    SELECT
      show_id,
      EXPLODE(SPLIT(cast, ',')) AS cast_name
    FROM netflix_raw
) t
WHERE cast_name IS NOT NULL AND cast_name <> '';

-- netflix_listed (categories)
DROP TABLE IF EXISTS netflix_listed;
CREATE TABLE netflix_listed 
USING PARQUET  
AS
SELECT
  show_id,
  TRIM(listed_name) AS listed_in
FROM (
    SELECT
      show_id,
      EXPLODE(SPLIT(listed_in, ',')) AS listed_name
    FROM netflix_raw
) t
WHERE listed_name IS NOT NULL AND listed_name <> '';

-- netflix_genre (same as listed_in, just normalized into "genre")
DROP TABLE IF EXISTS netflix_genre;
CREATE TABLE netflix_genre 
USING PARQUET
  AS
SELECT
  show_id,
  TRIM(genre_name) AS genre
FROM (
    SELECT
      show_id,
      EXPLODE(SPLIT(listed_in, ',')) AS genre_name
    FROM netflix_raw
) t
WHERE genre_name IS NOT NULL AND genre_name <> '';
