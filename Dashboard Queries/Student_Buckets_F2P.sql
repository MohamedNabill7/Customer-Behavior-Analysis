USE customer_engagement;
CREATE TEMPORARY TABLE Student_buckets
WITH Student_Type AS
(
-- Free Plan >>> calculate a total minutes watched for entire period "Registeration" into "10/31/2022"
	SELECT 
		student_info.*,
		0 AS paid,
		'2022-10-31' AS last_date_to_watch
	FROM student_info LEFT JOIN student_purchases
		ON student_info.student_id = student_purchases.student_id
	WHERE student_purchases.student_id IS NULL
UNION
-- Paid Plan >>> calculate a total minutes watched for entire period "Registeration" into "First Purchase"
	SELECT 
		student_info.*,
		1 AS paid,
		MIN(student_purchases.date_purchased) AS last_date_to_watch
	FROM student_info INNER JOIN student_purchases
		ON student_info.student_id = student_purchases.student_id
	GROUP BY student_purchases.student_id
),
Total_Minutes_Watched AS 
(
	SELECT 
		Student_Type.*,
		0 AS total_minutes_watched
	FROM Student_Type LEFT JOIN student_learning
		ON Student_Type.student_id = student_learning.student_id
	WHERE student_learning.student_id IS NULL
UNION 
	SELECT 
		Student_Type.*,
		ROUND(SUM(student_learning.minutes_watched),2) AS total_minutes_watched
	FROM Student_Type INNER JOIN student_learning
		ON Student_Type.student_id = student_learning.student_id
	WHERE student_learning.date_watched BETWEEN Student_Type.date_registered AND Student_Type.last_date_to_watch
	GROUP BY student_learning.student_id
),
Final_Total_Minutes_Watched AS
(
	SELECT * FROM Total_Minutes_Watched
	UNION
	SELECT Student_Type.*, 0 AS total_minutes_watched  FROM Student_Type INNER JOIN student_learning
		ON Student_Type.student_id = student_learning.student_id
	WHERE student_learning.date_watched NOT BETWEEN Student_Type.date_registered AND Student_Type.last_date_to_watch
		AND student_learning.student_id NOT IN (SELECT student_id FROM Total_Minutes_Watched)
	GROUP BY student_learning.student_id
),
Student_Buckets_F2P AS
(
SELECT 
	*,
    CASE
		WHEN total_minutes_watched = 0  OR total_minutes_watched IS NULL THEN'[0]'
        WHEN total_minutes_watched > 0  AND total_minutes_watched <= 5  THEN '[0,5]'
        WHEN total_minutes_watched > 5  AND total_minutes_watched <= 10 THEN '[5,10]'
        WHEN total_minutes_watched > 10 AND total_minutes_watched <= 15 THEN '[10,15]'
        WHEN total_minutes_watched > 15 AND total_minutes_watched <= 20 THEN '[15,20]'
        WHEN total_minutes_watched > 20 AND total_minutes_watched <= 25 THEN '[20,25]'
        WHEN total_minutes_watched > 25 AND total_minutes_watched <= 30 THEN '[25,30]'
        WHEN total_minutes_watched > 30 AND total_minutes_watched <= 40 THEN '[30,40]'
        WHEN total_minutes_watched > 40 AND total_minutes_watched <= 50 THEN '[40,50]'
        WHEN total_minutes_watched > 50 AND total_minutes_watched <= 60 THEN '[50,60]'
        WHEN total_minutes_watched > 60 AND total_minutes_watched <= 70 THEN '[60,70]'
        WHEN total_minutes_watched > 70 AND total_minutes_watched <= 80 THEN '[70,80]'
        WHEN total_minutes_watched > 80 AND total_minutes_watched <= 90 THEN '[80,90]'
        WHEN total_minutes_watched > 90 AND total_minutes_watched <= 100 THEN '[90,100]'
        WHEN total_minutes_watched > 100 AND total_minutes_watched <= 110 THEN '[100,110]'
        WHEN total_minutes_watched > 110 AND total_minutes_watched <= 120 THEN '[110,120]'
        WHEN total_minutes_watched > 120 AND total_minutes_watched <= 240 THEN '[120,240]'
        WHEN total_minutes_watched > 240 AND total_minutes_watched <= 480 THEN '[240,480]'
        WHEN total_minutes_watched > 480 AND total_minutes_watched <= 1000 THEN '[480,1000]'
        WHEN total_minutes_watched > 1000 AND total_minutes_watched <= 2000 THEN '[1000,2000]'
        WHEN total_minutes_watched > 2000 AND total_minutes_watched <= 3000 THEN '[2000,3000]'
        WHEN total_minutes_watched > 3000 AND total_minutes_watched <= 4000 THEN '[3000,4000]'
        WHEN total_minutes_watched > 4000 AND total_minutes_watched <= 6000 THEN '[4000,6000]'
        WHEN total_minutes_watched > 6000 THEN '[6000 +]'
	END AS buckets
FROM Final_Total_Minutes_Watched
)
SELECT 
	student_id, date_registered, paid as f2p, total_minutes_watched, buckets
FROM Student_Buckets_F2P;

SELECT * FROM Student_Buckets

