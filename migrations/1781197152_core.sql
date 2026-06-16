-- liquibase formatted sql

-- changeset shapovalov:create-table-persons
CREATE TABLE persons
(
    person_id    BIGSERIAL PRIMARY KEY,
    first_name   TEXT NOT NULL,
    last_name    TEXT NOT NULL,
    birth_date   DATE,
    blood_status TEXT,
    is_alive     BOOLEAN DEFAULT true
);
-- rollback DROP TABLE IF EXISTS persons;

-- changeset shapovalov:create-table-houses
CREATE TABLE houses
(
    house_id BIGSERIAL PRIMARY KEY,
    name     TEXT NOT NULL UNIQUE,
    founder  TEXT NOT NULL,
    colors   TEXT,
    animal   TEXT
);
-- rollback DROP TABLE IF EXISTS houses;

-- changeset shapovalov:create-table-locations
CREATE TABLE locations
(
    location_id BIGSERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    type        TEXT
);
-- rollback DROP TABLE IF EXISTS locations;