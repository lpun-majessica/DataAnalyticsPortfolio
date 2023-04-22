/*
Cleaning Data in SQL Queries
*/

SELECT
	*
FROM
	portfolio_project.dbo.taylor_swift_spotify
/*
ORDER BY
	number;
*/

------------------------------------------------------------------------------------------------------------------------------------------

/*
Completing the dataset

There was an error when I tried to import this dataset into SQL, which caused some cells in 'acousticness' column to become NULL
So firstly, I will fill them back in according to the original dataset
*/

SELECT
	*
FROM
	portfolio_project.dbo.taylor_swift_spotify
WHERE
	acousticness IS NULL
ORDER BY
	name;


-- Checking the number of faulty cells
SELECT
	COUNT(*) AS null_acousticness_cell
FROM
	portfolio_project.dbo.taylor_swift_spotify
WHERE
	acousticness IS NULL;


UPDATE taylor_swift_spotify
SET
	acousticness =
	CASE
		id
			WHEN '6D0MZbrShD5AK8P2Ig6bow' THEN '2.47E-05'
			WHEN '3lNRE17Ba1Verccqe2h6td' THEN '2.54E-05'
			WHEN '4WrJR6LJ8MtIxouKHUkTEM' THEN '2.71E-05'
			WHEN '4IHxBRrxgyWOruVXPjO1CK' THEN '2.71E-05'
			WHEN '0aPYUraliYu9tQP0y9hPLq' THEN '2.89E-05'
			WHEN '7x86Zn0YFrNyKQ9O7um0v2' THEN '2.89E-05'
			WHEN '743KlSMdeOl9JJ0nNHTEKR' THEN '3.12E-05'
			WHEN '3A6tHffXCorshGOtAaZRaW' THEN '3.28E-05'
			WHEN '4pvmbMjyRH4tKJiw1CjWic' THEN '3.30E-05'
			WHEN '7r7RyzNBFfTRH9NRVBrFhJ' THEN '3.30E-05'
			WHEN '2CUK34XwIWbs6J4ZJ5cFdU' THEN '3.30E-05'
			WHEN '6kFgTVa0eIjO00Pc3OA0rF' THEN '3.33E-05'
			WHEN '7eWWHv6LTMFcaj8QgTLcYf' THEN '3.34E-05'
			WHEN '6AK3WJz8eIJLePdy09nGR4' THEN '3.35E-05'
			WHEN '1gAwz7T7QfpDuSkdS7qdQ5' THEN '3.36E-05'
			WHEN '7J4cg1IeDWDY4oE19CaIra' THEN '3.52E-05'
			WHEN '4XavxNrfJD41LXLnEuCeAG' THEN '4.11E-05'
			WHEN '4Vg8MqpDQFDfKmXdpO1jD3' THEN '5.28E-05'
			WHEN '5NEP34PtTtFQaZpeeDPWeU' THEN '5.82E-05'
			WHEN '12QHKhw9K9yJOJ1nKRiBYI' THEN '6.53E-05'
			WHEN '0k7VfuL6QDZDItHMfStLGr' THEN '6.85E-05'
			WHEN '1QMmJSW0E8rdJRMGOUrnJd' THEN '7.36E-05'
			WHEN '5BIHTqXmBBdfdScTVyzUts' THEN '7.89E-05'
			WHEN '0LBW7lkY7L8cQUXXB16bXO' THEN '7.89E-05'
			WHEN '5YluKOG2VGcJMO8XVMpg9h' THEN '8.14E-05'
			WHEN '2CyfahsenMvjhR99j1x6X2' THEN '9.27E-05'
			ELSE acousticness
			END;

------------------------------------------------------------------------------------------------------------------------------------------

/*
The first column name appeared as 'column1' after I imported the data
I'm going to give it a more descriptive name
*/

EXEC sp_rename 'portfolio_project.dbo.taylor_swift_spotify.column1', 'number', 'COLUMN';

/*
And this column begins with '0' so I'm going to fix and make it start at 1
*/

UPDATE
	taylor_swift_spotify
SET
	number = number + 1

------------------------------------------------------------------------------------------------------------------------------------------

/*
Making sure the data is in the specified range that the dataset's description on Kaggle has stated
*/

SELECT
	MAX(acousticness/*,
	danceability,
	energy,
	instrumentalness,
	liveness,
	loudness,
	speechiness,
	tempo,
	valence,
	popularity*/) AS max_value,
	MIN(acousticness/*,
	danceability,
	energy,
	instrumentalness,
	liveness,
	loudness,
	speechiness,
	tempo,
	valence,
	popularity*/) AS min_value
FROM
	portfolio_project.dbo.taylor_swift_spotify;

------------------------------------------------------------------------------------------------------------------------------------------

/*
Changing the format of the duration column from miliseconds to mm:ss
*/

SELECT
	name,
	duration_ms,
	duration_ms/(1000*60) AS duration_min,
	(duration_ms%(1000*60))/1000 AS duration_sec,
	CASE
		WHEN LEN(duration_ms/(1000*60)) = 1 AND LEN((duration_ms%(1000*60))/1000) = 1
			THEN CONCAT('0', duration_ms/(1000*60), ':0', (duration_ms%(1000*60))/1000) 
		WHEN LEN(duration_ms/(1000*60)) = 1 AND LEN((duration_ms%(1000*60))/1000) = 2
			THEN CONCAT('0', duration_ms/(1000*60), ':', (duration_ms%(1000*60))/1000)
		WHEN LEN(duration_ms/(1000*60)) = 2 AND LEN((duration_ms%(1000*60))/1000) = 1
			THEN CONCAT(duration_ms/(1000*60), ':0', (duration_ms%(1000*60))/1000)
		WHEN LEN(duration_ms/(1000*60)) = 2 AND LEN((duration_ms%(1000*60))/1000) = 2
			THEN CONCAT(duration_ms/(1000*60), ':', (duration_ms%(1000*60))/1000) 
	END AS duration
FROM
	portfolio_project.dbo.taylor_swift_spotify;


ALTER TABLE
	taylor_swift_spotify
ADD
	duration CHAR(5);


UPDATE
	taylor_swift_spotify
SET
	duration =
		CASE
			WHEN LEN(duration_ms/(1000*60)) = 1 AND LEN((duration_ms%(1000*60))/1000) = 1
				THEN CONCAT('0', duration_ms/(1000*60), ':0', (duration_ms%(1000*60))/1000) 
			WHEN LEN(duration_ms/(1000*60)) = 1 AND LEN((duration_ms%(1000*60))/1000) = 2
				THEN CONCAT('0', duration_ms/(1000*60), ':', (duration_ms%(1000*60))/1000)
			WHEN LEN(duration_ms/(1000*60)) = 2 AND LEN((duration_ms%(1000*60))/1000) = 1
				THEN CONCAT(duration_ms/(1000*60), ':0', (duration_ms%(1000*60))/1000)
			WHEN LEN(duration_ms/(1000*60)) = 2 AND LEN((duration_ms%(1000*60))/1000) = 2
				THEN CONCAT(duration_ms/(1000*60), ':', (duration_ms%(1000*60))/1000)
		END;

------------------------------------------------------------------------------------------------------------------------------------------

/*
Checking if there is any duplicate in the dataset
*/

WITH duplicate AS
	(
	SELECT
		name,
		album,
		id, 
		uri,
		ROW_NUMBER() OVER
			(
			PARTITION BY
				name,
				album,
				release_date,
				acousticness,
				danceability,
				energy,
				instrumentalness,
				liveness,
				loudness,
				speechiness,
				tempo,
				valence,
				popularity,
				duration
			ORDER BY
				name
			)
			AS no_of_duplicate
FROM
	portfolio_project.dbo.taylor_swift_spotify
	)

SELECT
	*
FROM
	duplicate
WHERE
	no_of_duplicate > 1;

------------------------------------------------------------------------------------------------------------------------------------------

/*
Separating song name from "notes" after the hyphen (i.e. "Commentary", "Karaoke Version", etc.)
*/


-- Checking if there is any song that include a hyphen within its name (in this case, there is a song called 'Anti-Hero')
SELECT
	name
from
	portfolio_project.dbo.taylor_swift_spotify
WHERE
	name LIKE '%[a-z]-[a-z]%';


SELECT
	CASE
		WHEN name = 'Anti-Hero'
			THEN name
		WHEN name LIKE '%-%'
			THEN
				SUBSTRING(name, 1, CHARINDEX('-', name) - 2)
		ELSE name
	END AS song_name,
	CASE
		WHEN name = 'Anti-Hero'
			THEN '-'
		WHEN name LIKE '%-%'
			THEN
				SUBSTRING(name, CHARINDEX('-', name) + 2, LEN(name))
		ELSE '-'
	END AS note
FROM
	portfolio_project.dbo.taylor_swift_spotify;


ALTER TABLE
	taylor_swift_spotify
ADD
	note VARCHAR(250);


UPDATE
	taylor_swift_spotify
SET
	name =
		CASE
			WHEN name = 'Anti-Hero'
				THEN name
			WHEN name LIKE '%-%'
				THEN
					SUBSTRING(name, 1, CHARINDEX('-', name) - 2)
			ELSE name
		END,
	note =
		CASE
			WHEN name = 'Anti-Hero'
				THEN '-'
			WHEN name LIKE '%-%'
				THEN
					SUBSTRING(name, CHARINDEX('-', name) + 2, LEN(name))
			ELSE '-'
		END;

------------------------------------------------------------------------------------------------------------------------------------------

/*
Deleting supposedly unwanted column(s) to make the table look cleaner

I'm going to remove column 'duration_ms' as it's redundant and its format is harder to read than the newlt added 'duration' column
*/

ALTER TABLE
	taylor_swift_spotify
DROP COLUMN
	duration_ms;