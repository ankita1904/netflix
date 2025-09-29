%sql
%run "./Extract"

-- analysis_duration.sql
-- Average duration of movies in each genre
SELECT
    ng.genre,
    AVG(CAST(REPLACE(ns.duration, ' min', '') AS INT)) AS avg_movie_duration
FROM netflix_stg ns
JOIN netflix_genre ng ON ns.show_id = ng.show_id
WHERE ns.type = 'Movie' 
  AND ns.duration IS NOT NULL 
  AND ns.duration != ''
GROUP BY ng.genre
ORDER BY avg_movie_duration DESC;
