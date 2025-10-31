-- use database
USE mentalhealth_analysis; 

-- show tables
show tables; 

-- show total records in a table
SELECT COUNT(*) FROM MentalHealth; 

-- for safe updates
SET SQL_SAFE_UPDATES = 0; 

SELECT* from academicperformance; 

-- dropping a column
ALTER TABLE academicperformance  
DROP COLUMN perf_id;

SELECT* from lifestyle;

-- shows student_id with poor sleep hours of students
SELECT student_id, sleep_hours,   
       'poor sleep quality' AS sleep_comment
FROM lifestyle
WHERE sleep_hours < 6;

-- checks if any null values
SELECT *
FROM lifestyle
WHERE sleep_hours IS NULL;

-- counts no of students with poor sleep quality
SELECT COUNT(*) AS total_poor_sleep  
FROM lifestyle
WHERE sleep_hours < 6;

-- using 2 different tables
SELECT* from academicperformance;  
SELECT* from mentalhealth; 

-- basic join to combine data of both tables
SELECT                            
    a.student_id,
    a.cgpa,
    a.attendance_percent,
    a.academic_stress,
    m.anxiety_score,
    m.stress_level,
    m.resilience_score,
    m.covid_related_anxiety,
    m.survey_date
FROM academicperformance a
JOIN mentalhealth m ON a.student_id = m.student_id;


-- Filter for Students with High Anxiety or High Academic Stress
SELECT                          
    a.student_id,
    a.cgpa,
    a.attendance_percent,
    a.academic_stress,
    m.anxiety_score,
    m.stress_level,
    m.resilience_score,
    m.covid_related_anxiety,
    m.survey_date
FROM academicperformance a
JOIN mentalhealth m ON a.student_id = m.student_id
WHERE m.anxiety_score > 7 OR a.academic_stress > 7;


-- Add a Comment Column Flagging At-Risk Students
SELECT                    
    a.student_id,
    a.cgpa,
    a.attendance_percent,
    a.academic_stress,
    m.anxiety_score,
    m.stress_level,
    m.resilience_score,
    m.covid_related_anxiety,
    m.survey_date,
    CASE
        WHEN m.anxiety_score > 7 AND a.academic_stress > 7 THEN 'High Risk'
        WHEN m.anxiety_score > 7 THEN 'High Anxiety'
        WHEN a.academic_stress > 7 THEN 'High Academic Stress'
        ELSE 'Normal'
    END AS risk_comment
FROM academicperformance a
JOIN mentalhealth m ON a.student_id = m.student_id;


-- calculate average sleep hours by gender also give the count of genders
-- join 2 tables lifestyle and students
SELECT      
	S.student_id,
    s.name,
    s.gender,
    s.department,
    l.sleep_hours
FROM students s
JOIN lifestyle l ON s.student_id = l.student_id;

SELECT         
	s.gender,
        COUNT(*) AS student_count,
    AVG(L.sleep_hours) AS avg_sleep_hours
FROM students s
JOIN lifestyle l ON s.student_id = l.student_id
GROUP BY s.gender;


-- average sleep, exercise, screen time, social media, and study hours for each gender
SELECT
    s.gender,
    COUNT(*) AS student_count,
    AVG(l.sleep_hours) AS avg_sleep_hours,
    AVG(l.exercise_hours) AS avg_exercise_hours,
    AVG(l.screen_time_hours) AS avg_screen_time_hours,
    AVG(l.social_media_hours) AS avg_social_media_hours,
    AVG(l.study_hours) AS avg_study_hours
FROM students s
JOIN lifestyle l ON s.student_id = l.student_id
GROUP BY s.gender;


-- student CGPA and mentor support
SELECT             
	 a.student_id,
     a.cgpa,
     s.mentor_support
FROM academicperformance a
JOIN supportsystem s ON a.student_id = s.student_id;


-- Categorize Mentor Support
SELECT               
    s.mentor_support,
    AVG(a.cgpa) AS avg_cgpa,
    COUNT(*) AS student_count
FROM academicperformance a
JOIN supportsystem s ON a.student_id = s.student_id
GROUP BY s.mentor_support;


-- Create a view combining lifestyle and performance data to detect at-risk students.
CREATE OR REPLACE VIEW at_risk_students AS   
SELECT 
    a.student_id,
    a.cgpa,
    a.attendance_percent,
    a.academic_stress,
    l.sleep_hours,
    l.exercise_hours,
    l.screen_time_hours,
    l.social_media_hours,
    l.study_hours,
    CASE
        WHEN a.cgpa < 6.5 
             OR a.academic_stress = 'High' 
             OR l.sleep_hours < 6 
             OR l.exercise_hours < 1
        THEN 'At Risk'
        ELSE 'Normal'
    END AS risk_status
FROM academicperformance a
JOIN lifestyle l ON a.student_id = l.student_id;


-- query the view
SELECT *
FROM at_risk_students
WHERE risk_status = 'At Risk';


-- Explore whether consistent exercise correlates with reduced anxiety.
-- join tables
SELECT
	m.student_id,
    m.anxiety_score,
    l.exercise_hours
FROM mentalhealth m
JOIN lifestyle l ON m.student_id = l.student_id;

-- categorize exercise
SELECT   
    CASE
        WHEN l.exercise_hours >= 5 THEN 'High Exercise'
        WHEN l.exercise_hours BETWEEN 2 AND 4.9 THEN 'Moderate Exercise'
        ELSE 'Low Exercise'
    END AS exercise_level,
    AVG(m.anxiety_score) AS avg_anxiety,
    COUNT(*) AS student_count
FROM mentalhealth m
JOIN lifestyle l ON m.student_id = l.student_id
GROUP BY exercise_level;


-- Analyze impact of screen time on academic performance.
-- join tables
SELECT            
    s.student_id,
    s.name,
    s.gender,
    s.department,
    l.screen_time_hours,
    l.study_hours
FROM students s
JOIN lifestyle l ON s.student_id = l.student_id;

-- categorize screentime
SELECT 		
    CASE
        WHEN l.screen_time_hours >= 5 THEN 'High Screen Time'
        WHEN l.screen_time_hours BETWEEN 2 AND 4.9 THEN 'Moderate Screen Time'
        ELSE 'Low Screen Time'
    END AS screen_time_level,
    AVG(l.study_hours) AS avg_study_hours,
    COUNT(*) AS student_count
FROM students s
JOIN lifestyle l ON s.student_id = l.student_id
GROUP BY screen_time_level;
