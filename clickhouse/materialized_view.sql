CREATE MATERIALIZED VIEW default.mv_house_point_logs TO default.house_point_logs_dest AS
SELECT
    JSONExtractInt(value, 'after', 'house_point_log_id') AS house_point_log_id,
    JSONExtractInt(value, 'after', 'house_id') AS house_id,
    JSONExtractInt(value, 'after', 'student_id') AS student_id,
    JSONExtractInt(value, 'after', 'awarded_by_staff_id') AS awarded_by_staff_id,
    JSONExtractInt(value, 'after', 'points') AS points,
    JSONExtractString(value, 'after', 'reason') AS reason,
    toDateTime64(JSONExtractInt(value, 'after', 'created_at') / 1000, 3) AS created_at
FROM default.queue_house_point_logs
WHERE JSONHas(value, 'after')
  AND JSONExtractString(value, 'op') IN ('c', 'u', 'r');