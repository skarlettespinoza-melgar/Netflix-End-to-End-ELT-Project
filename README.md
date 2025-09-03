Netflix Data Analysis with Python & SQL Server
📌 Project Overview

This project demonstrates the process of building a relational database from raw Netflix data, cleaning and transforming it in SQL Server Management Studio (SSMS), and performing SQL queries to generate insights.

The workflow covers data extraction, cleaning, normalization, and analysis using SQL joins, CTEs, and aggregations.

🛠 Tools & Technologies

Python – Extracting and loading raw data into SQL Server

SQL Server Management Studio (SSMS) – Data cleaning, transformation, and relational schema design

SQL – CTEs, window functions, joins, aggregate functions, string manipulation, and subqueries

📂 Project Workflow

Data Extraction & Loading

Extracted raw Netflix dataset using Python.

Loaded the dataset into SQL Server for further processing.

Data Cleaning & Transformation

Converted data types (e.g., title → NVARCHAR for foreign characters, date_added → DATE).

Removed duplicates using ROW_NUMBER() and partitioning logic.

Normalized data by splitting multi-value fields into separate relational tables (netflix_directors, netflix_cast, netflix_countries, netflix_genres).

Populated missing values in country and duration columns where possible.

Relational Database Creation

Designed and implemented a relational schema to support advanced queries and analysis.

Analysis with SQL Queries
Example insights generated:

🎬 Count of movies vs. TV shows per director.

🌍 Country with the highest number of comedy movies.

📅 Yearly breakdown of directors with the most movies added to Netflix.

⏱ Average duration of movies by genre.

😂😱 Directors who created both comedy and horror movies.

📊 Example Queries
-- #1 Directors who created both TV shows and movies
SELECT nd.director,
       COUNT(DISTINCT CASE WHEN n.type='Movie' THEN n.show_id END) AS no_of_movies,
       COUNT(DISTINCT CASE WHEN n.type='TV Show' THEN n.show_id END) AS no_of_tv_shows
FROM netflix n
INNER JOIN netflix_directors nd ON n.show_id=nd.show_id
GROUP BY nd.director
HAVING COUNT(DISTINCT n.type) > 1;

-- #2 Country with the highest number of comedy movies
SELECT TOP 1 nc.country, COUNT(DISTINCT ng.show_id) AS no_of_comedies
FROM netflix_countries nc
INNER JOIN netflix_genres ng ON nc.show_id=ng.show_id
INNER JOIN netflix n ON ng.show_id=n.show_id
WHERE ng.genre='Comedies' AND n.type='Movie'
GROUP BY nc.country
ORDER BY no_of_comedies DESC;

🚀 Outcomes

Built a reusable ETL pipeline for data ingestion and transformation.

Designed a clean, normalized relational database for Netflix data.

Generated actionable insights on content trends using SQL queries.

📎 Repository Contents

python/ – Scripts for data extraction and upload to SQL Server

sql/ – Data cleaning, transformation, and analysis queries

README.md – Project documentation (this file)

📈 Key Skills Demonstrated

Data Engineering (ETL, data cleaning, schema design)

SQL (joins, CTEs, aggregations, window functions)

Python (data extraction & automation)

Relational Database Design & Normalization

✨ This project showcases the ability to transform raw, messy datasets into structured databases and extract insights through advanced SQL queries.
