-- liquibase formatted sql

-- changeset wizard:create-index-house-point-logs-student runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_hpl_student_points
    ON house_point_logs (student_id) INCLUDE (points);
-- rollback DROP INDEX CONCURRENTLY IF EXISTS idx_hpl_student_points;


-- changeset wizard:create-index-house-point-logs-house runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_hpl_house_points
    ON house_point_logs (house_id) INCLUDE (points);
-- rollback DROP INDEX CONCURRENTLY IF EXISTS idx_hpl_house_points;


-- changeset wizard:create-index-exam-results-outstanding runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_exam_outstanding
    ON exam_results (student_id, subject_id)
    WHERE grade = 'O';
-- rollback DROP INDEX CONCURRENTLY IF EXISTS idx_exam_outstanding;


-- changeset wizard:create-index-wands-owner-oak runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_wand_oak_covering
    ON wands (owner_id) INCLUDE (wood_type, core_type)
    WHERE wood_type = 'Oak';
-- rollback DROP INDEX CONCURRENTLY IF EXISTS idx_wand_oak_covering;


-- changeset wizard:create-index-incidents-date runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_incident_recent
    ON incidents (incident_date DESC) INCLUDE (title);
-- rollback DROP INDEX CONCURRENTLY IF EXISTS idx_incident_recent;


-- changeset wizard:create-index-students-house runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_student_house_id
    ON students (house_id);
-- rollback DROP INDEX CONCURRENTLY IF EXISTS idx_student_house_id;


-- changeset wizard:create-index-persons-covering runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_person_join_cover
    ON persons (person_id) INCLUDE (first_name, last_name);
-- rollback DROP INDEX CONCURRENTLY IF EXISTS idx_person_join_cover;