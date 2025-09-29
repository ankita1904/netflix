%sql
%run "./Extract"

-- Directors who have both Movies and TV Shows

SELECT
    nd.director,
    COUNT(DISTINCT CASE WHEN ns.type = 'Movie' THEN ns.show_id END) AS num_movies,
    COUNT(DISTINCT CASE WHEN ns.type = 'TV Show' THEN ns.show_id END) AS num_tvshows
FROM netflix_stg ns
JOIN netflix_directors nd ON ns.show_id = nd.show_id
GROUP BY nd.director
HAVING COUNT(DISTINCT CASE WHEN ns.type = 'Movie' THEN ns.show_id END) > 0
   AND COUNT(DISTINCT CASE WHEN ns.type = 'TV Show' THEN ns.show_id END) > 0
ORDER BY (COUNT(DISTINCT CASE WHEN ns.type = 'Movie' THEN ns.show_id END) 
          + COUNT(DISTINCT CASE WHEN ns.type = 'TV Show' THEN ns.show_id END)) DESC;
