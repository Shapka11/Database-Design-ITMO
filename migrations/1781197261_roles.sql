-- liquibase formatted sql

-- changeset shapovalov:create-table-students
CREATE TABLE students
(
    student_id      BIGSERIAL PRIMARY KEY,
    person_id       INTEGER NOT NULL UNIQUE REFERENCES persons (person_id),
    house_id        INTEGER NOT NULL REFERENCES houses (house_id),
    enrollment_year INTEGER NOT NULL
);
-- rollback DROP TABLE IF EXISTS students;

-- changeset shapovalov:create-table-staff
CREATE TABLE staff
(
    staff_id  BIGSERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL UNIQUE REFERENCES persons (person_id),
    role      TEXT    NOT NULL,
    hire_date DATE    NOT NULL
);
-- rollback DROP TABLE IF EXISTS staff;

-- changeset shapovalov:create-table-villains
CREATE TABLE villains
(
    villain_id   BIGSERIAL PRIMARY KEY,
    person_id    INTEGER NOT NULL UNIQUE REFERENCES persons (person_id),
    alias        TEXT,
    threat_level TEXT    NOT NULL,
    affiliation  TEXT
);
-- rollback DROP TABLE IF EXISTS villains;

-- changeset shapovalov:create-table-wands
CREATE TABLE wands
(
    wand_id       BIGSERIAL PRIMARY KEY,
    owner_id      INTEGER REFERENCES persons (person_id),
    wood_type     TEXT NOT NULL,
    core_type     TEXT NOT NULL,
    length_inches NUMERIC(4, 2)
);
-- rollback DROP TABLE IF EXISTS wands;