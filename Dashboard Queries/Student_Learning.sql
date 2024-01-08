USE customer_engagement;

-- Students Learning >>> [student_id	||	date_watched	||	minutes_watched	||	paid]
SELECT 
	student_id,
    date_watched,
    SUM(minutes_watched) AS minutes_watched,
    paid 
FROM(
	SELECT 
		student_id,
		date_watched,
		minutes_watched,
		MAX(paid) AS paid
	FROM
	(
		SELECT 
			student_learning.student_id,
			date_watched,
			minutes_watched,
			CASE	
				WHEN start_date IS NULL AND end_date IS NULL THEN 0
				WHEN date_watched BETWEEN start_date AND end_date THEN 1
				WHEN date_watched NOT BETWEEN start_date AND end_date THEN 0
			END AS paid
		FROM student_learning LEFT JOIN purchase_info
			ON student_learning.student_id = purchase_info.student_id
	) TAB
	GROUP BY 1,2) TAB2
GROUP BY 1,2
ORDER BY 2 ASC, 1 ASC;
