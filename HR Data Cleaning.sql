CREATE DATABASE HumanResource;

-- Setting the database or schema 'humanresource' to active or default
USE humanresource;

-- Viewing the imported table, 'hr'
SELECT * FROM hr;

-- Changing the name of the column to a meaningful name
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- Viewing the data type of each column
DESCRIBE hr;

SELECT birthdate FROM hr;

-- Changing the 'sql_safe_updates' to '0' to be able to update without any safety warnings or errors
SET sql_safe_updates = 0;	-- Change back to '1' after cleaning the data since it protects the data

-- Changing the date format of the date in the column 'birthdate' to a standard format
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
	WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Changing the data type of column 'birthdate' to 'DATE'
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

SELECT hire_date FROM hr;

-- Changing the date format of the date in the column 'hire_date' to a standard format
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
	WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SELECT termdate FROM hr;

SET GLOBAL sql_mode = '';

-- Converting the date-time initial format to the standard date format
UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '';

UPDATE hr
SET termdate = (date_format(termdate, '%Y-%m-%d'))
WHERE termdate IS NULL AND termdate = '';

-- Modifying the column 'termdate' to 'date' data-type
ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- Adding a new column 'age'
ALTER TABLE hr
ADD COLUMN age INT;

-- Filling the age column with records of the difference between the 'YEAR' of 'CURDATE()' and the column 'birthdate'
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT birthdate, age FROM hr;

SELECT
	min(age) AS Youngest_employee,
    max(age) AS Oldest_employee
FROM hr;

SELECT round(avg(age), 0) AS avg_age
FROM hr;