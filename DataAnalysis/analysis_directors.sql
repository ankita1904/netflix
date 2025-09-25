-- analysis_directors.sql
-- For each director count number of movies and tv shows (both) in separate columns
SELECT
    nd.director,
    COUNT(DISTINCT CASE WHEN ns.type = 'Movie' THEN ns.show_id END) AS num_movies,
    COUNT(DISTINCT CASE WHEN ns.type = 'TV Show' THEN ns.show_id END) AS num_tvshows
FROM netflix_stg ns
JOIN netflix_directors nd ON ns.show_id = nd.show_id
GROUP BY nd.director
HAVING num_movies > 0 AND num_tvshows > 0
ORDER BY (num_movies + num_tvshows) DESC;
