%sql
%run "./Extract"

-- analysis_yearly.sql
-- For each year as per date_added, which director has maximum number of movies released
WITH director_counts AS (
    SELECT year(ns.date_added) AS year_added, 
           nd.director, 
           COUNT(*) AS cnt
    FROM netflix_stg ns
    JOIN netflix_directors nd 
      ON ns.show_id = nd.show_id
    WHERE ns.type = 'Movie' 
      AND ns.date_added IS NOT NULL
    GROUP BY year(ns.date_added), nd.director
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY year_added ORDER BY cnt DESC) AS rn
    FROM director_counts
)
SELECT year_added, director, cnt
FROM ranked
WHERE rn = 1
ORDER BY year_added;
