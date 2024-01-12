USE customer_engagement;

WITH table_paid_duration AS
(
SELECT 
    student_id,
    MIN(start_date) AS first_paid_day,
    IF(MAX(end_date) <= '2022-10-31', MAX(end_date), '2022-10-31') AS last_paid_day
FROM
    purchase_info
GROUP BY student_id
),
table_content_watched_1 AS
(
SELECT 
    d.*, ROUND(SUM(l.minutes_watched), 2) AS total_minutes_watched
FROM table_paid_duration d INNER JOIN student_learning l 
	USING (student_id)
WHERE
    date_watched BETWEEN first_paid_day AND last_paid_day
GROUP BY d.student_id

UNION

SELECT 
    d.*, 0 AS total_minutes_watched
FROM table_paid_duration d LEFT JOIN student_learning l 
	USING (student_id)
WHERE
    l.student_id IS NULL
),
table_content_watched_2 as
(
SELECT 
    *
FROM
    table_content_watched_1

UNION 

SELECT 
    d.*, 0 AS total_minutes_watched
FROM table_paid_duration d INNER JOIN student_learning l 
	USING (student_id)
WHERE
    date_watched NOT BETWEEN first_paid_day AND last_paid_day
        AND l.student_id NOT IN (SELECT 
            student_id
        FROM
            table_content_watched_1)
),
table_duration_in_days AS
(
SELECT 
    *,
    DATEDIFF(last_paid_day, first_paid_day) AS difference_in_days
FROM
    table_content_watched_2
),
table_distribute_to_buckets AS
(
SELECT 
    d.*,
    i.date_registered,
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
        END AS user_buckets
FROM table_duration_in_days d INNER JOIN student_info i
    USING(student_id)
)
SELECT 
    student_id,
    date_registered,
    total_minutes_watched,
    difference_in_days AS num_paid_days,
    user_buckets AS 'buckets'
FROM
    table_distribute_to_buckets;
