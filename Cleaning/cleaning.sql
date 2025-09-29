%run "/Workspace/Users/ankitakalhapure@gmail.com/Netflix/Extract"
-- Deduplicate records and populate staging table (netflix_stg)
-- Adjust names/types if necessary. This script assumes netflix_raw exists.

-- Create a temporary deduplicated view using ROW_NUMBER
DROP TABLE IF EXISTS netflix_stg;
CREATE TABLE netflix_stg (
    show_id STRING,
    type STRING,
    title STRING,
    date_added DATE,
    release_year INT,
    rating STRING,
    duration STRING,
    description STRING
);
USING PARQUET

-- Create a temporary table with row numbers to remove duplicates
CREATE TABLE netflix_raw_dedupe_tmp1 
    USING PARQUET
    AS
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY UPPER(title), COALESCE(type,'') ORDER BY show_id) AS rn
    FROM netflix_raw
) t
WHERE rn = 1;

-- Insert into staging with casting and null handling
INSERT INTO netflix_stg (show_id, type, title, date_added, release_year, rating, duration, description)
SELECT
    show_id,
    type,
    title,
    CASE
        WHEN date_added IS NULL OR TRIM(date_added) = '' THEN NULL
        ELSE TO_DATE(date_added, 'MMMM d, yyyy')
    END AS date_added,
    release_year,
    rating,
    CASE 
        WHEN duration IS NULL OR TRIM(duration) = '' THEN rating 
        ELSE duration 
    END AS duration,
    description
FROM netflix_raw_dedupe_tmp1;

-- Clean temp table
DROP VIEW IF EXISTS netflix_raw_dedupe_tmp1;
