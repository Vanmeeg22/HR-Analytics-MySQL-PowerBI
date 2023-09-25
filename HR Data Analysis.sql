-- Questions
		SELECT * FROM hr;

-- 1. What is the gender breakdown of employees in the company?

		SELECT DISTINCT gender FROM hr;
        
		# Below is the query of gender breakdown for all the employees regardless of their termdate
        SELECT gender, count(*) AS count
		FROM hr
		GROUP BY gender;
        
        # Below is the query of gender breakdown for all the employees currently working in the company
		SELECT gender, count(*) AS count
		FROM hr
		WHERE termdate = '0000-00-00'
		GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?

        SELECT race, count(*) AS count
        FROM hr
        GROUP BY race
        ORDER BY count DESC;
        
		SELECT race, count(*) AS count
        FROM hr
        WHERE termdate = '0000-00-00'
        GROUP BY race
        ORDER BY count DESC;

-- 3. What is the age distribution of employees in the company?

        SELECT
			min(age) AS youngest,
            max(age) AS oldest
		FROM hr
        WHERE termdate = '0000-00-00';
        
        # age_group count
        SELECT
		CASE
			WHEN age >= 18 AND age <= 24 THEN '18-24'
			WHEN age >= 25 AND age <= 34 THEN '25-34'
			WHEN age >= 35 AND age <= 44 THEN '35-44'
			WHEN age >= 45 AND age <= 54 THEN '45-54'
			WHEN age >= 55 AND age <= 64 THEN '55-64'
			ELSE '65+'
		END AS age_group,
		count(*) AS count
		FROM hr
		WHERE termdate = '0000-00-00'
		GROUP BY age_group
		ORDER BY age_group ASC;
        
        # age_group and gender count
        SELECT
		CASE
			WHEN age >= 18 AND age <= 24 THEN '18-24'
			WHEN age >= 25 AND age <= 34 THEN '25-34'
			WHEN age >= 35 AND age <= 44 THEN '35-44'
			WHEN age >= 45 AND age <= 54 THEN '45-54'
			WHEN age >= 55 AND age <= 64 THEN '55-64'
			ELSE '65+'
		END AS age_group, gender,
		count(*) AS count
		FROM hr
		WHERE termdate = '0000-00-00'
		GROUP BY age_group, gender
		ORDER BY age_group ASC;

-- 4. How many employees work at headquarters versus remote locations?

		SELECT DISTINCT location FROM hr;
        
        SELECT location, count(*) AS count
        FROM hr
        WHERE termdate = '0000-00-00'
        GROUP BY location;
        
        SELECT location, gender, count(*) AS count
        FROM hr
        WHERE termdate = '0000-00-00'
        GROUP BY location, gender;

-- 5. What is the average length of employment for employees who have been terminated?

        SELECT
			round(avg(datediff(termdate, hire_date)) / 365, 0) AS avg_employment_length
		FROM hr
        WHERE termdate <= curdate() AND termdate != '0000-00-00';

-- 6. How does the gender distribution vary across departments and job titles?
        
		SELECT department, jobtitle, gender, count(*) AS count
        FROM hr
        WHERE termdate = '0000-00-00'
        GROUP BY department, jobtitle, gender
        ORDER BY department;
        
        SELECT department, gender, count(*) AS count
        FROM hr
        WHERE termdate = '0000-00-00'
        GROUP BY department, gender
        ORDER BY department;
        
        SELECT jobtitle, gender, count(*) AS count
        FROM hr
        WHERE termdate = '0000-00-00'
        GROUP BY jobtitle, gender
        ORDER BY jobtitle;

-- 7. What is the distribution of job titles across the company?

		SELECT jobtitle, count(*) AS count
        FROM hr
        WHERE termdate = '0000-00-00'
        GROUP BY jobtitle
        ORDER BY jobtitle;

-- 8. Which department has the highest turnover rate?

		SELECT 
			department,
			total_count,
            terminated_count,
            terminated_count/total_count AS termination_rate
        FROM (
			SELECT 
				department, 
				count(*) AS total_count,
				sum(CASE WHEN termdate != '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
            FROM hr
			GROUP BY department
            ) AS subquery
		ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?

		SELECT location_state, location_city, count(*) AS count
        FROM hr
        WHERE termdate != '0000-00-00'
        GROUP BY location_state, location_city
        ORDER BY count DESC;
        
        SELECT location_state, count(*) AS count
        FROM hr
        WHERE termdate != '0000-00-00'
        GROUP BY location_state
        ORDER BY count DESC;
        
        SELECT location_city, count(*) AS count
        FROM hr
        WHERE termdate != '0000-00-00'
        GROUP BY location_city
        ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and termination dates?

		SELECT
			year,
            hires,
            terminations,
            hires - terminations AS net_change,
            round((hires - terminations) / hires * 100, 2) AS net_change_percentage
		FROM (
			SELECT
				year(hire_date) AS year,
                count(*) AS hires,
                SUM(CASE WHEN termdate != '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
                FROM hr
                GROUP BY year(hire_date)
			) AS subquery
		ORDER BY year;

-- 11. What is the tenure distribution for each department?

		SELECT department, round(avg(datediff(termdate, hire_date) / 365), 0) AS avg_tenure
        FROM hr
        WHERE termdate != '0000-00-00' AND termdate <= curdate()
        GROUP BY department;