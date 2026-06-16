-- name: get_total_points_by_house
WITH aggregated_points AS (SELECT house_id, SUM(points) as total_points
                           FROM house_point_logs
                           GROUP BY house_id)
SELECT h.name, ap.total_points
FROM aggregated_points ap
         JOIN houses h ON ap.house_id = h.house_id;

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
SELECT h.name,
       (SELECT COUNT(*) FROM students s WHERE s.house_id = h.house_id) as student_count
FROM houses h;

-- name: top_students_by_points
WITH top_students AS (SELECT student_id, SUM(points) as total
                      FROM house_point_logs
                      GROUP BY student_id
                      ORDER BY total DESC
                      LIMIT 10)
SELECT p.first_name, p.last_name, ts.total
FROM top_students ts
         JOIN students s ON ts.student_id = s.student_id
         JOIN persons p ON s.person_id = p.person_id
ORDER BY ts.total DESC;