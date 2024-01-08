USE customer_engagement;

-- Career Track Funnel
with table_course_exams as
(
SELECT DISTINCT
    se.student_id, e.course_id
FROM
    student_exams se
        JOIN
    exam_info e USING (exam_id)
WHERE
    e.exam_category = 2
),
table_course_certificates as
(
SELECT DISTINCT
    student_id, course_id
FROM
    student_certificates
WHERE
    certificate_type = 1
),
table_attempted_course_exam_certificate_issued as
(
SELECT 
    student_id,
    enrolled_in_track_id,
    MAX(attempted_course_exam) AS attempted_course_exam,
    MAX(certificate_course_id) as certificate_course_id
FROM
(-- Get the successful course exams
SELECT 
    c.*,
    CASE
        WHEN cc.course_id IS NULL THEN 0
        WHEN
            cc.course_id IS NOT NULL
                AND c.attempted_course_exam = 0
        THEN
            0
        WHEN
            cc.course_id IS NOT NULL
                AND c.attempted_course_exam = 1
        THEN
            1
    END AS certificate_course_id
    FROM
( -- Get the enrollment in track and the attempted_course_exam column
SELECT 
        a.student_id,
            a.track_id as enrolled_in_track_id,
            a.course_id,
            b.track_id,
            CASE
                WHEN a.course_id IS NULL THEN 0
                WHEN
                    a.course_id IS NOT NULL
                        AND b.track_id IS NULL
                THEN
                    0
                WHEN
                    a.course_id IS NOT NULL
                        AND b.track_id IS NOT NULL
                THEN
                    1
            END AS attempted_course_exam
    FROM
        (-- Get the course id's of the course exams that a student has attempted
        SELECT DISTINCT
    *
FROM
    student_career_track_enrollments en
        LEFT JOIN
    table_course_exams ex USING (student_id)
ORDER BY student_id , track_id , course_id) a
    LEFT JOIN career_track_info b ON a.track_id = b.track_id
        AND a.course_id = b.course_id) c
	LEFT JOIN table_course_certificates cc ON c.student_id = cc.student_id
	AND c.course_id = cc.course_id ) d
GROUP BY student_id , enrolled_in_track_id
),
table_track_exams as
(
SELECT DISTINCT
    se.student_id, e.track_id
FROM
    student_exams se
        JOIN
    exam_info e USING (exam_id)
WHERE
    e.exam_category = 3
),
table_attempted_final_exam as
(
SELECT DISTINCT
    i.*, ex.track_id AS attempted_track_id
FROM
    table_attempted_course_exam_certificate_issued i
        LEFT JOIN
    table_track_exams ex ON i.student_id = ex.student_id
        AND i.enrolled_in_track_id = ex.track_id
),
table_certificates as
(
SELECT 
    student_id, track_id, cast(date_issued as date) as date_issued
FROM
    student_certificates
WHERE
    certificate_type = 2
),
table_issued_certificates as
(
SELECT DISTINCT
    e.*, c.track_id as certificate_track_id, c.date_issued
FROM
    table_attempted_final_exam e
    LEFT JOIN
    table_certificates c
    ON e.student_id = c.student_id
        AND e.enrolled_in_track_id = c.track_id
),
table_final as
(
SELECT 
    enrolled_in_track_id AS track_id,
    COUNT(enrolled_in_track_id) AS enrolled_in_track_id,
    SUM(attempted_course_exam) AS attempted_course_exam,
    SUM(certificate_course_id) AS certificate_course_id,
    COUNT(attempted_track_id) AS attempted_track_id,
    COUNT(certificate_track_id) AS certificate_track_id
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
),
table_reordered as
(
SELECT 
    'Enrolled in a track' AS 'action',
    enrolled_in_track_id AS 'track',
    COUNT(enrolled_in_track_id) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
UNION
SELECT 
    'Attempted a course exam' AS 'action',
    enrolled_in_track_id AS 'track',
    SUM(attempted_course_exam) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
UNION
SELECT 
    'Completed a course exam' AS 'action',
    enrolled_in_track_id AS 'track',
    SUM(certificate_course_id) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
UNION
SELECT 
    'Attempted a final exam' AS 'action',
    enrolled_in_track_id AS 'track',
    COUNT(attempted_track_id) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
UNION
SELECT 
    'Earned a career track certificate' AS 'action',
    enrolled_in_track_id AS 'track',
    COUNT(certificate_track_id) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
)
select * from table_reordered;













