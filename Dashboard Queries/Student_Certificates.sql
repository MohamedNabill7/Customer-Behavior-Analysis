USE customer_engagement;


-- student certificates CSV
SELECT 
    DISTINCT certificate_id,
    student_certificates.student_id,
    certificate_type,
    date_issued,
    MAX(paid) AS paid
FROM student_certificates LEFT JOIN
(
	SELECT 
		student_id,
		date_engaged,
		MAX(paid) AS paid
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
GROUP BY 1,2) Tab ON student_certificates.student_id = Tab.student_id
GROUP BY 1,2,3,4