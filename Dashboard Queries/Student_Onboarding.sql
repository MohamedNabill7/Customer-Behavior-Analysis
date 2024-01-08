USE customer_engagement;

-- Student Onboarding >>> First time engagement

SELECT 
	DISTINCT student_info.student_id,
	student_info.date_registered,
	CASE 
		WHEN student_learning.student_id IS NULL THEN 0
        ELSE 1
	END AS student_onboarded
FROM student_info LEFT JOIN student_learning
	ON student_info.student_id = student_learning.student_id
ORDER BY student_info.date_registered ASC , student_onboarded ASC