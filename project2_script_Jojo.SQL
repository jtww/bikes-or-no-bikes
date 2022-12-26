-- Docking Stations & No. of Docks
SELECT DISTINCT id, name, docks
FROM santander_stations;

-- Total No. of Docks
SELECT SUM(docks)
FROM santander_stations;

-- Total No. of Docking Stations
SELECT COUNT(DISTINCT id)
FROM santander_stations;

-- Total No. of Transactions (10,310,063)
SELECT COUNT (DISTINCT rental_id)
FROM santander_2019;

-- No. of Bikes
SELECT COUNT (DISTINCT bike_id)
FROM santander_2019;

-- Max, Min & Avg Time Spent
SELECT
	MAX (AGE (end_date, start_date)) AS max_time_spent,
	MIN (AGE (end_date, start_date)) AS min_time_spent,
 	AVG (AGE (end_date, start_date)) AS avg_time_spent
FROM santander_2019;

-- No. of Transactions every hour
SELECT
	EXTRACT (hour FROM start_date) AS start_time,
	COUNT (DISTINCT rental_id)
FROM santander_2019
WHERE end_date IS NOT NULL
GROUP BY 1;

-- Avg Time Spent During the Peak Hours
SELECT AVG (AGE (end_date, start_date)) AS avg_time_spent
FROM santander_2019
WHERE DATE_PART('hour', start_date) BETWEEN 18 AND 19
AND end_date IS NOT NULL;

-- Top 5 Starting Stations 
SELECT DISTINCT
	ss1.name AS start_station_name,
	COUNT (s.rental_id) AS number_of_trans
FROM santander_2019 s
LEFT JOIN
	santander_stations ss1 ON ss1.id = s.startstationid
WHERE DATE_PART('hour', start_date) BETWEEN 7 AND 8
AND ss1.name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- No. of Transactions Every Month
WITH all_data AS (
	SELECT *
	FROM santander_2017
	UNION ALL
	SELECT *
	FROM santander_2018
	UNION ALL
	SELECT *
	FROM santander_2019
)
SELECT
	TO_CHAR(DATE_TRUNC('month', start_date), 'YYYY-MM-DD') AS start_month,
    COUNT(DISTINCT rental_id) AS number_of_trans
  FROM all_data
  WHERE end_date IS NOT NULL
  GROUP BY 1;

-- Stations with Highest No. of Transactions (Month)
SELECT DISTINCT
	ss1.name AS end_station_name,
	COUNT (s.rental_id) AS number_of_trans
FROM santander_2017 s
LEFT JOIN
	santander_stations ss1 ON ss1.id = s.startstationid
WHERE DATE_PART('month', end_date) = 7
AND ss1.name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Ref: Top 10 Starting Stations (2019)
SELECT
	ss1.name AS end_station_name,
	COUNT (s.rental_id) AS number_of_trans
FROM santander_2019 s
LEFT JOIN
	santander_stations ss1 ON ss1.id = s.startstationid
WHERE ss1.name IS NOT NULL
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 10;

-- Ref: Top 10 Ending Stations (2019)
SELECT
	ss1.name AS end_station_name,
	COUNT (s.rental_id) AS number_of_trans
FROM santander_2019 s
LEFT JOIN
	santander_stations ss1 ON ss1.id = s.endstationid
WHERE ss1.name IS NOT NULL
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 10;

-- Ref: for viewing start time, end time & time elapsed for each rental_id
SELECT 
	rental_id,
	CAST (start_date AS TIME) start_time,
	CAST (end_date AS TIME) end_time,
	AGE (end_date, start_date) AS length_of_time
FROM santander_2019;

-- Ref: desired output cols
SELECT DISTINCT
	s.rental_id AS rental_id,
	ss1.name AS start_station_name,
	CAST (s.start_date AS DATE) start_date,
	CAST (s.start_date AS TIME) start_time,
	ss2.name AS end_station_name,
	CAST (s.end_date AS DATE) end_date,
	CAST (s.end_date AS TIME) end_time
FROM santander_2019 s
LEFT JOIN
	santander_stations ss1 ON ss1.id = s.startstationid
LEFT JOIN
	santander_stations ss2 ON ss2.id = s.endstationid
ORDER BY 1;

/*Ref: for referencing two cols in santander_2019 
using one col in santander_stations*/
SELECT DISTINCT
	s.rental_id AS rental_id,
	ss1.name AS start_station_name,
	ss2.name AS end_station_name
FROM santander_2019 s
LEFT JOIN
	santander_stations ss1 ON ss1.id = s.startstationid
LEFT JOIN
	santander_stations ss2 ON ss2.id = s.endstationid
ORDER BY 1;