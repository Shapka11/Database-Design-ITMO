CREATE TABLE default.house_point_logs_dest
(
    house_point_log_id  Int64,
    house_id            Int64,
    student_id          Nullable(Int64),
    awarded_by_staff_id Int64,
    points              Int32,
    reason              String,
    created_at          DateTime64(3)
) ENGINE = MergeTree() ORDER BY house_point_log_id;