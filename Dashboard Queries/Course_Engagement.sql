USE customer_engagement;

-- Course engagement CSV
SELECT 
    course_info.course_id,
    course_info.course_title,
    ROUND(SUM(student_learning.minutes_watched),2) AS minutes_watched,
    ROUND(SUM(student_learning.minutes_watched) / COUNT(DISTINCT student_learning.student_id),2) AS minutes_per_student ,
    ROUND((SUM(student_learning.minutes_watched) / COUNT(DISTINCT student_learning.student_id)) / course_info.course_duration,2) AS completion_rate
FROM course_info INNER JOIN student_learning 
    ON course_info.course_id = student_learning.course_id
GROUP BY 1,2;
