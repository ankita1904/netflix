Netflix ADF Automation Project (zip)
=====================================

This package contains a ready-to-import project structure for automating your Netflix cleaning + analysis using Azure Data Factory (ADF).
You must update Linked Services, Datasets and connection strings inside ADF before use.

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
  - analysis_comedy_horror.sql

/adf_templates
  - netflix_adf_pipeline_template.json  -- ADF pipeline JSON template (placeholder values)

/README.md                -- this file

How to use
----------
1. Upload your raw CSV files to Azure Blob Storage or ADLS. Name the container/folder as you prefer.
2. Create Linked Services in ADF:
   - Blob Storage / ADLS (source)
   - MySQL (sink) - Azure Database for MySQL or generic MySQL
3. Create Datasets in ADF for source CSV and sink MySQL table (netflix_raw).
4. Import or create a pipeline in ADF with these activities (suggested):
   - Copy Activity: Copy CSV from Blob -> netflix_raw (use Upsert if desired)
   - Script Activity or Lookup/Custom Activity: Execute cleaning SQL (cleaning.sql)
   - Script Activity: Execute normalization.sql
   - (Optional) Script Activities: Run each analysis SQL and write results to tables or export CSVs
5. Scheduling:
   - Add a trigger (time-based) or event-based trigger (Blob created) to run pipeline when new CSV arrives.

Notes & Caveats
----------------
- The SQL uses MySQL DATE parsing STR_TO_DATE with format '%M %d, %Y'. Adjust according to your CSV date format.
- The normalization SQL uses JSON_TABLE style splitting; adapt if your MySQL version lacks JSON_TABLE.
- The adf pipeline template included is a placeholder JSON — update linkedService references before importing.

If you want, I can:
 - 1) Generate an ADF ARM template with linked service placeholders filled with your connection details (you must share them), OR
 - 2) Provide step-by-step import instructions in the Azure portal with screenshots.

