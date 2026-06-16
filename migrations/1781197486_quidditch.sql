-- liquibase formatted sql

-- changeset shapovalov:create-table-quidditch-teams
CREATE TABLE quidditch_teams
(
    quidditch_team_id  BIGSERIAL PRIMARY KEY,
    house_id           BIGINT NOT NULL UNIQUE REFERENCES houses (house_id),
    captain_student_id BIGINT REFERENCES students (student_id)
);
-- rollback DROP TABLE IF EXISTS quidditch_teams;

-- changeset shapovalov:create-table-quidditch-players
CREATE TABLE quidditch_players
(
    quidditch_player_id BIGSERIAL PRIMARY KEY,
    quidditch_team_id   BIGINT NOT NULL REFERENCES quidditch_teams (quidditch_team_id),
    student_id          BIGINT NOT NULL REFERENCES students (student_id),
    position            TEXT   NOT NULL
);
-- rollback DROP TABLE IF EXISTS quidditch_players;

-- changeset shapovalov:create-table-quidditch-matches
CREATE TABLE quidditch_matches
(
    quidditch_match_id       BIGSERIAL PRIMARY KEY,
    home_team_id             BIGINT    NOT NULL REFERENCES quidditch_teams (quidditch_team_id),
    away_team_id             BIGINT    NOT NULL REFERENCES quidditch_teams (quidditch_team_id),
    match_date               TIMESTAMP NOT NULL,
    home_score               INTEGER DEFAULT 0,
    away_score               INTEGER DEFAULT 0,
    snitch_caught_by_team_id BIGINT REFERENCES quidditch_teams (quidditch_team_id)
);
-- rollback DROP TABLE IF EXISTS quidditch_matches;