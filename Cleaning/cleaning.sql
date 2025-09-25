-- cleaning.sql
-- 1) Deduplicate records and populate staging table (netflix_stg)
-- Adjust names/types if necessary. This script assumes netflix_raw exists.

-- Create a temporary deduplicated view using ROW_NUMBER
DROP TABLE IF EXISTS netflix_stg;
CREATE TABLE netflix_stg (
    show_id VARCHAR(50) PRIMARY KEY,
    type VARCHAR(20),
    title VARCHAR(500),
    date_added DATE,
    release_year INT,
    rating VARCHAR(50),
    duration VARCHAR(100),
    description VARCHAR(1000)
);

-- Create a temporary table with row numbers to remove duplicates
DROP TABLE IF EXISTS netflix_raw_dedupe_tmp;
CREATE TABLE netflix_raw_dedupe_tmp AS
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
    -- Try to parse date_added; if not parsable, NULL
    CASE
        WHEN date_added IS NULL OR TRIM(date_added) = '' THEN NULL
        ELSE STR_TO_DATE(date_added, '%M %d, %Y') -- example format: 'January 1, 2020'
    END AS date_added,
    release_year,
    rating,
    CASE WHEN duration IS NULL OR TRIM(duration) = '' THEN rating ELSE duration END AS duration,
    description
FROM netflix_raw_dedupe_tmp;

-- Cleanup temp table
DROP TABLE IF EXISTS netflix_raw_dedupe_tmp;
