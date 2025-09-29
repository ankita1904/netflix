Netflix Data ETL Pipeline (Databricks → Parquet → MySQL)
=======

This package contains a ready-to-import project structure of Netflix data cleaning + analysis using parquet 

Project Structure
-----------------
/Cleaning
  - cleaning.sql          -- deduplication, staging (netflix_stg) creation and load
  - normalization.sql     -- split multi-value fields into normalized tables

/DataAnalysis
  - analysis_directors.sql
  - analysis_country.sql
  - analysis_yearly.sql
  - analysis_duration.sql
  - analysis_comedy_horror.sql + write file to MySQL

/README.md                -- this file
