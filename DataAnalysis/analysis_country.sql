-- analysis_country.sql
-- Country with highest number of comedy movies
SELECT 
    TRIM(nc.country) AS country, 
    COUNT(DISTINCT ng.show_id) AS num_comedy_movies
FROM netflix_genre ng
JOIN netflix_country nc ON ng.show_id = nc.show_id
JOIN netflix_stg ns ON ng.show_id = ns.show_id
WHERE TRIM(ng.genre) LIKE '%Comedy%' 
  AND ns.type = 'Movie'
GROUP BY TRIM(nc.country)
ORDER BY num_comedy_movies DESC
LIMIT 1;
