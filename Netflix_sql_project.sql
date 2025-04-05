create table netflix 
(
	show_id	VARCHAR2(5),
	type    VARCHAR2(10),
	title	VARCHAR2(250),
	director VARCHAR2(550),
	casts	VARCHAR2(1050),
	country	VARCHAR2(550),
	date_added	VARCHAR2(55),
	release_year	NUMBER,
	rating	VARCHAR2(15),
	duration	VARCHAR2(15),
	listed_in	VARCHAR2(250),
	description VARCHAR2(550)
);

SELECT * FROM netflix;

--NETFLIX SQL PROBLEMS QUESTIONS:

--1. Count the Number of Movies vs TV Shows
--2. List All Movies Released in a Specific Year IN 2020
--3. Find the Most Common Rating for Movies and TV Shows
--4. Show the Newest Movie Each Year on Netflix
--5. Identify the Longest Movie
--6. Find Content Added in the Last 5 Years
--7. List all titles available in 'India'
--8. Top countries with most content
--9. List unique directors
--10. List All Movies that are Documentaries
--11. Show the Total Number of Titles Released Each Year & the Running Total
--12. Find All Content Without a Director
--13. Assign a row number to each movie title within its release year,ordered alphabetically by title.
--14. Top Movie Per Release Year
--15. Find How Many Movies Actor 'Salman Khan' Appeared


--NETFLIX SQL PROBLEMS SOLUTIONS:

--1. Count the Number of Movies vs TV Shows

SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY TYPE;

--2. List All Movies Released in a Specific Year IN 2020
 
SELECT type, release_year
FROM netflix
WHERE release_year = 2020 AND type = 'Movie';

--3. Find the Most Common Rating for Movies and TV Shows

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

--4. Show the Newest Movie Each Year on Netflix

SELECT 
    title,
    release_year,
    ROW_NUMBER() OVER (PARTITION BY release_year ORDER BY title) AS row_num
FROM netflix
WHERE type = 'Movie';

--5. Identify the Longest Movie

SELECT 
    title AS movie,
    duration
FROM netflix
WHERE 
    type = 'Movie'
    AND duration IS NOT NULL
    AND INSTR(duration, ' ') > 0
ORDER BY 
    TO_NUMBER(SUBSTR(duration, 1, INSTR(duration, ' ') - 1)) DESC;
    
--6. Find Content Added in the Last 5 Years

SELECT type as content , release_year
FROM netflix
WHERE date_added >= ADD_MONTHS(SYSDATE, -60);


--7. List all titles available in 'India'

SELECT title, country
FROM netflix
WHERE country LIKE '%India%';

--8. Top countries with most content

SELECT country, COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC;

--9. List unique directors

SELECT DISTINCT director,TITLE,TYPE
FROM netflix
WHERE director IS NOT NULL
ORDER BY director;

--10. List All Movies that are Documentaries

SELECT show_id, type, director from netflix
Where listed_in like '%Documentaries';

--11. Show the Total Number of Titles Released Each Year & the Running Total

WITH yearly_count AS (
    SELECT 
        release_year,
        COUNT(*) AS total_titles
    FROM netflix
    WHERE release_year IS NOT NULL
    GROUP BY release_year
)
SELECT 
    release_year,
    total_titles,
    SUM(total_titles) OVER (ORDER BY release_year) AS running_total
FROM yearly_count
ORDER BY release_year;

--12. Find All Content Without a Director

select show_id,type,director,title,type
from netflix where director is null;

--13. Assign a row number to each movie title within its release year, 
--ordered alphabetically by title.

SELECT 
    title,
    release_year,
    ROW_NUMBER() OVER (PARTITION BY release_year ORDER BY title) AS row_num
FROM netflix
WHERE type = 'Movie';

--14. Top Movie Per Release Year

SELECT *
FROM (
    SELECT 
        title,
        release_year,
        RANK() OVER (PARTITION BY release_year ORDER BY title) AS rank
    FROM netflix
    WHERE type = 'Movie'
)
WHERE rank = 1;

--15.Find How Many Movies Actor 'Salman Khan' Appeared

SELECT show_id, title,release_year
FROM netflix
WHERE casts LIKE '%Salman Khan%';



