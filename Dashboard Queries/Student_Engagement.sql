USE Customer_Engagement;

-- Export a data result into CSV file to build a "Student Engagement With Paid" dashborad 

-- First, we need to get the relevent perchases data with end date based on "purchase_type"
-- Purchases Info View
CREATE VIEW purchase_info AS
SELECT 
	purchase_id,
    student_id,
    purchase_type,
    start_date,
    CASE
		WHEN date_refunded IS NOT NULL THEN date_refunded
        ELSE end_date
	END AS end_date
FROM
(
	SELECT 
		purchase_id,
		student_id,
		purchase_type,
		date_purchased AS start_date,
		CASE
			WHEN purchase_type = 0 THEN date_add(makedate(year(date_purchased), day(date_purchased)),INTERVAL month(date_purchased) MONTH)
			WHEN purchase_type = 1 THEN date_add(makedate(year(date_purchased), day(date_purchased)),INTERVAL month(date_purchased)+02 MONTH)
			WHEN purchase_type = 2 THEN date_add(makedate(year(date_purchased), day(date_purchased)),INTERVAL month(date_purchased)+11 MONTH)
		END AS end_date,
		date_refunded
	FROM student_purchases
) AS TAB;

-- Get the student engagement with paid 
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
GROUP BY 1,2;