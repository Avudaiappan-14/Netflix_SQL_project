# Netflix Data Analysis using SQL

![Netflix_logo](https://github.com/Avudaiappan-14/Netflix_SQL_project/blob/main/Netflix_2015_logo.svg)

## Overview

This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyzed Netflix data with Oracle SQL by solving 15 practical business questions.
- Explored and analyzed Netflix data using Oracle SQL by solving 15 real-world business questions.
- Focused on content trends, actors, countries, and release patterns. 

## Dataset
The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/padmapriyatr/netflix-titles?resource=download)

## Schema

```sql
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
```
## NETFLIX SQL PROBLEMS AND SOLUTIONS:

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY TYPE;
```
**Objective:** Counted the total number of Movies and TV Shows available on Netflix.

### 2. List All Movies Released in a Specific Year IN 2020
```sql 
SELECT type, release_year
FROM netflix
WHERE release_year = 2020 AND type = 'Movie';
```
**Objective:** Listed all movies released in the year 2020.

### 3. Find the Most Common Rating for Movies and TV Shows
```sql 
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
```
**Objective:** Identified the most frequent rating for both Movies and TV Shows.


### 4. Show the Newest Movie Each Year on Netflix
```sql 
SELECT 
    title,
    release_year,
    ROW_NUMBER() OVER (PARTITION BY release_year ORDER BY title) AS row_num
FROM netflix
WHERE type = 'Movie';
```
**Objective:** Used window functions to display the first movie title per year

### 5. Identify the Longest Movie
```sql 
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
```
 **Objective:** Found the movie with the longest duration on Netflix.
    
### 6. Find Content Added in the Last 5 Years
```sql 
SELECT type as content , release_year
FROM netflix
WHERE date_added >= ADD_MONTHS(SYSDATE, -60);
```
**Objective:** Retrieved all content added to Netflix within the last 5 years.

### 7. List all titles available in 'India'
```sql 
SELECT title, country
FROM netflix
WHERE country LIKE '%India%';
```
**Objective:** Listed all Netflix titles available in India.

### 8. Top countries with most content
```sql 
SELECT country, COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC;
```
**Objective:** Displayed countries with the highest number of Netflix titles.

### 9. List unique directors
```sql 
SELECT DISTINCT director,TITLE,TYPE
FROM netflix
WHERE director IS NOT NULL
ORDER BY director;
```
**Objective:** Extracted a list of unique directors with their associated content.

### 10. List All Movies that are Documentaries
```sql 
SELECT show_id, type, director from netflix
Where listed_in like '%Documentaries';
```
**Objective:** Fetched all movies that belong to the ‘Documentaries’ genre.

### 11. Show the Total Number of Titles Released Each Year & the Running Total
```sql 
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
```
**Objective:** Calculated the number of titles released each year.

### 12. Find All Content Without a Director
```sql 
select show_id,type,director,title,type
from netflix where director is null;
```
**Objective:** Found all Netflix entries that do not have a listed director.

### 13. Assign a row number to each movie title within its release year,ordered alphabetically by title.
```sql 
SELECT 
    title,
    release_year,
    ROW_NUMBER() OVER (PARTITION BY release_year ORDER BY title) AS row_num
FROM netflix
WHERE type = 'Movie';
```
**Objective:** Assigned a row number to each movie per release year.

### 14. Top Movie Per Release Year
```sql 
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
```
**Objective:** Displayed the first-ranked movie per release year.

### 15.Find How Many Movies Actor 'Salman Khan' Appeared
```sql 
SELECT show_id, title,release_year
FROM netflix
WHERE casts LIKE '%Salman Khan%';
```
**Objective:** Retrieved all movies in which actor ‘Salman Khan’ appeared.

## Key Findings:

- Netflix has more Movies than TV Shows.

- Most content added in recent years comes from the US and India.

- 'TV-MA' is the most common rating.

- Identified longest movies, top directors, and yearly trends.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

