USE Customer_Engagement;

-- Create a temporary table to store information about studnet engagement with paid
CREATE TEMPORARY TABLE Student_Engagement
SELECT 
	student_id, date_engaged, MAX(paid) AS paid
FROM
(
	SELECT 
		E.student_id,
		date_engaged,
		start_date,
		end_date,
		CASE
			WHEN start_date IS NULL AND end_date IS NULL THEN 0
			WHEN date_engaged BETWEEN start_date AND end_date THEN 1
			WHEN date_engaged NOT BETWEEN start_date AND end_date THEN 0
		END AS paid
	FROM 
		student_engagement E LEFT JOIN purchase_info P
			ON E.student_id = P.student_id
) AS TAB
GROUP BY 1,2;

-- Create a period column to store the differnce between months in engage and cohort
SELECT 
	TAB.*,
    month(date_engaged) - month(cohort) AS period
FROM
(
	-- Create a cohort column that store the minimum engagement date based on student type
    SELECT 
		student_id,
		date_engaged,
		paid,
		MIN(date_engaged) OVER(PARTITION BY student_id, paid ORDER BY date_engaged ASC) AS cohort
	FROM Student_Engagement
)TAB;