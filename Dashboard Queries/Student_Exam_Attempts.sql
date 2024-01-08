USE customer_engagement;

-- Student Exam Attempts >>> [exam_attempt_id	||	student_id	||	exam_id	||	exam_category	||	exam_passed	||	date_exam_completed]
SELECT 
	student_exams.exam_attempt_id,
    student_exams.student_id,
    student_exams.exam_id,
    exam_info.exam_category,
    student_exams.exam_passed,
    student_exams.date_exam_completed
FROM student_exams LEFT JOIN exam_info
	ON student_exams.exam_id = exam_info.exam_id
