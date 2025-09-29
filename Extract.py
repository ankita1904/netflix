# Extracting netflix_raw from databricks dbfs using pyspark

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, split, explode

spark = SparkSession.builder.appName("Netflix").getOrCreate()
df = spark.read.option("header", "true").csv("dbfs:/FileStore/tables/netflix_raw.csv")
df.createOrReplaceTempView("netflix_raw")
df.show()
display(table)
