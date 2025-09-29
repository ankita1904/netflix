-- analysis_comedy_horror.sql
-- Directors who have created both Comedy and Horror movies, with counts
final_result_df = spark.sql("""
WITH director_genre_counts AS (
    SELECT 
        nd.director,
        SUM(CASE WHEN ng.genre LIKE '%Comedy%' THEN 1 ELSE 0 END) AS comedy_count,
        SUM(CASE WHEN ng.genre LIKE '%Horror%' THEN 1 ELSE 0 END) AS horror_count
    FROM netflix_stg ns
    JOIN netflix_directors nd ON ns.show_id = nd.show_id
    JOIN netflix_genre ng ON ns.show_id = ng.show_id
    WHERE ns.type = 'Movie'
    GROUP BY nd.director
)

SELECT 
    director, 
    comedy_count, 
    horror_count
FROM director_genre_counts
WHERE comedy_count > 0 AND horror_count > 0
ORDER BY (comedy_count + horror_count) DESC;
""")
--If genres have extra spaces
SUM(CASE WHEN TRIM(ng.genre) LIKE '%Comedy%' THEN 1 ELSE 0 END) AS comedy_count


jdbc_url = "jdbc:mysql://localhost:3306/Netflix_project"
connection_props = {
    "user": "root",
    "password": "#####",
    "driver": "com.mysql.cj.jdbc.Driver"
}
--write to final_result_df to MySQL
final_result_df.write \
  .mode("overwrite") \
  .jdbc(url=jdbc:mysql://localhost:3306/Netflix_project, table="director_comedy_horror", properties=connection_props)

