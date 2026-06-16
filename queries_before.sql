-- name: get_total_points_by_house
SELECT h.name, SUM(hpl.points) as total_points
FROM house_point_logs hpl
         JOIN houses h ON hpl.house_id = h.house_id
GROUP BY h.name;

-- name: find_student_exams
SELECT p.first_name, p.last_name, sub.name as subject_name
FROM exam_results e
         JOIN students st ON e.student_id = st.student_id
         JOIN persons p ON st.person_id = p.person_id
         JOIN subjects sub ON e.subject_id = sub.subject_id
WHERE e.grade = 'O';

-- name: get_student_wands
SELECT p.first_name, p.last_name, w.wood_type, w.core_type
FROM wands w
         JOIN persons p ON w.owner_id = p.person_id
WHERE w.wood_type = 'Oak';

-- name: recent_incidents_report
SELECT title, incident_date
FROM incidents
WHERE incident_date > NOW() - INTERVAL '30 days'
ORDER BY incident_date DESC;

-- name: house_members_count
SELECT h.name, COUNT(s.student_id) as student_count
FROM houses h
         LEFT JOIN students s ON h.house_id = s.house_id
GROUP BY h.name;

-- name: top_students_by_points
SELECT p.first_name, p.last_name, SUM(hpl.points) as total
FROM house_point_logs hpl
         JOIN students s ON hpl.student_id = s.student_id
         JOIN persons p ON s.person_id = p.person_id
GROUP BY p.first_name, p.last_name
ORDER BY total DESC LIMIT 10;