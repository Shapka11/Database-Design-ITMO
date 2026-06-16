-- liquibase formatted sql

-- changeset shapovalov:create-table-incidents
CREATE TABLE incidents
(
    incident_id           BIGSERIAL PRIMARY KEY,
    title                 TEXT      NOT NULL,
    description           TEXT      NOT NULL,
    location_id           BIGINT    NOT NULL REFERENCES locations (location_id),
    incident_date         TIMESTAMPTZ NOT NULL,
    instigator_villain_id BIGINT REFERENCES villains (villain_id)
);
-- rollback DROP TABLE IF EXISTS incidents;

-- changeset shapovalov:create-table-incident-participants
CREATE TABLE incident_participants
(
    incident_participant_id BIGSERIAL PRIMARY KEY,
    incident_id             BIGINT NOT NULL REFERENCES incidents (incident_id),
    person_id               BIGINT NOT NULL REFERENCES persons (person_id),
    role                    TEXT   NOT NULL
);
-- rollback DROP TABLE IF EXISTS incident_participants;

-- changeset shapovalov:create-table-house-point-logs
CREATE TABLE house_point_logs
(
    house_point_log_id  BIGSERIAL PRIMARY KEY,
    house_id            BIGINT    NOT NULL REFERENCES houses (house_id),
    student_id          BIGINT REFERENCES students (student_id),
    awarded_by_staff_id BIGINT    NOT NULL REFERENCES staff (staff_id),
    points              INTEGER   NOT NULL,
    reason              TEXT      NOT NULL,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- rollback DROP TABLE IF EXISTS house_point_logs;