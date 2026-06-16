-- liquibase formatted sql

-- changeset shapovalov:create-table-subjects
CREATE TABLE subjects
(
    subject_id  BIGSERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    is_elective BOOLEAN DEFAULT false
);
-- rollback DROP TABLE IF EXISTS subjects;

-- changeset shapovalov:create-table-exam-results
CREATE TABLE exam_results
(
    exam_result_id BIGSERIAL PRIMARY KEY,
    student_id     BIGINT NOT NULL REFERENCES students (student_id),
    subject_id     BIGINT NOT NULL REFERENCES subjects (subject_id),
    grade          TEXT   NOT NULL,
    exam_date      DATE   NOT NULL
);
-- rollback DROP TABLE IF EXISTS exam_results;

-- changeset shapovalov:create-table-spells
CREATE TABLE spells
(
    spell_id        BIGSERIAL PRIMARY KEY,
    incantation     TEXT NOT NULL UNIQUE,
    name            TEXT NOT NULL,
    is_unforgivable BOOLEAN DEFAULT false
);
-- rollback DROP TABLE IF EXISTS spells;

-- changeset shapovalov:create-table-spell-masteries
CREATE TABLE spell_masteries
(
    spell_mastery_id BIGSERIAL PRIMARY KEY,
    student_id       BIGINT NOT NULL REFERENCES students (student_id),
    spell_id         BIGINT NOT NULL REFERENCES spells (spell_id),
    mastered_date    DATE   NOT NULL
);
-- rollback DROP TABLE IF EXISTS spell_masteries;