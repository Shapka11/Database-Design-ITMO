-- liquibase formatted sql

-- changeset wizard:seed_houses
INSERT INTO houses (name, founder, colors, animal)
VALUES ('Gryffindor', 'Godric Gryffindor', 'Scarlet and Gold', 'Lion'),
       ('Slytherin', 'Salazar Slytherin', 'Green and Silver', 'Serpent'),
       ('Ravenclaw', 'Rowena Ravenclaw', 'Blue and Bronze', 'Eagle'),
       ('Hufflepuff', 'Helga Hufflepuff', 'Yellow and Black', 'Badger')
ON CONFLICT (name) DO NOTHING;
-- rollback DELETE FROM houses;

-- changeset wizard:seed_locations
INSERT INTO locations (name, type)
VALUES ('Great Hall', 'Room'),
       ('Potions Dungeon', 'Classroom'),
       ('Forbidden Forest', 'Forest'),
       ('Quidditch Pitch', 'Sports Field'),
       ('Hagrid''s Hut', 'Building')
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM locations;

-- changeset wizard:seed_subjects
INSERT INTO subjects (name, is_elective)
VALUES ('Potions', false),
       ('Transfiguration', false),
       ('Charms', false),
       ('Defense Against the Dark Arts', false),
       ('History of Magic', false),
       ('Herbology', false),
       ('Astronomy', false),
       ('Flying', false),
       ('Care of Magical Creatures', true),
       ('Divination', true),
       ('Arithmancy', true),
       ('Ancient Runes', true),
       ('Muggle Studies', true)
ON CONFLICT (name) DO NOTHING;
-- rollback DELETE FROM subjects;

-- changeset wizard:seed_spells
INSERT INTO spells (incantation, name, is_unforgivable)
VALUES ('Expelliarmus', 'Disarming Charm', false),
       ('Lumos', 'Wand-Lighting Charm', false),
       ('Avada Kedavra', 'Killing Curse', true),
       ('Expecto Patronum', 'Patronus Charm', false),
       ('Wingardium Leviosa', 'Levitation Charm', false),
       ('Stupefy', 'Stunning Spell', false),
       ('Crucio', 'Cruciatus Curse', true),
       ('Imperio', 'Imperius Curse', true)
ON CONFLICT (incantation) DO NOTHING;
-- rollback DELETE FROM spells;

-- changeset wizard:seed_persons
INSERT INTO persons (first_name, last_name, birth_date, blood_status)
SELECT 'WizardFirst_' || i,
       'WizardLast_' || i,
       '1980-01-01'::date + (i || ' days')::interval,
       (ARRAY ['Pure-blood', 'Half-blood', 'Muggle-born'])[floor(random() * 3 + 1)]
FROM generate_series(1, (20 * ${SEED_COUNT})) AS i
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM persons;

-- changeset wizard:seed_students
INSERT INTO students (person_id, house_id, enrollment_year)
SELECT p.person_id,
       (SELECT house_id FROM houses ORDER BY random() LIMIT 1),
       1991 + floor(random() * 7)
FROM persons p
LIMIT (15 * ${SEED_COUNT})
ON CONFLICT (person_id) DO NOTHING;
-- rollback DELETE FROM students;

-- changeset wizard:seed_staff
INSERT INTO staff (person_id, role, hire_date)
SELECT p.person_id,
       (ARRAY ['Professor', 'Headmaster', 'Deputy Headmaster', 'Caretaker', 'Librarian'])[floor(random() * 5 + 1)],
       '1970-01-01'::date + (random() * interval '30 years')
FROM persons p
WHERE NOT EXISTS (SELECT 1 FROM students s WHERE s.person_id = p.person_id)
  AND NOT EXISTS (SELECT 1 FROM staff st WHERE st.person_id = p.person_id)
LIMIT (5 * ${SEED_COUNT})
ON CONFLICT (person_id) DO NOTHING;
-- rollback DELETE FROM staff;

-- changeset wizard:seed_wands
INSERT INTO wands (owner_id, wood_type, core_type, length_inches)
SELECT p.person_id,
       (ARRAY ['Oak', 'Holly', 'Walnut', 'Elder'])[floor(random() * 4 + 1)],
       (ARRAY ['Phoenix Feather', 'Dragon Heartstring', 'Unicorn Hair'])[floor(random() * 3 + 1)],
       9.0 + random() * 5.5
FROM persons p
LIMIT (15 * ${SEED_COUNT})
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM wands;

-- changeset wizard:seed_quidditch_teams
INSERT INTO quidditch_teams (house_id, captain_student_id)
SELECT h.house_id,
       (SELECT student_id FROM students WHERE house_id = h.house_id ORDER BY random() LIMIT 1)
FROM houses h
ON CONFLICT (house_id) DO NOTHING;
-- rollback DELETE FROM quidditch_teams;

-- changeset wizard:seed_quidditch_matches
INSERT INTO quidditch_matches (home_team_id, away_team_id, match_date, home_score, away_score)
SELECT (SELECT quidditch_team_id FROM quidditch_teams ORDER BY random() LIMIT 1),
       (SELECT quidditch_team_id FROM quidditch_teams ORDER BY random() LIMIT 1),
       NOW() - (i || ' days')::interval,
       floor(random() * 200),
       floor(random() * 200)
FROM generate_series(1, (5 * ${SEED_COUNT})) AS i
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM quidditch_matches;

-- changeset wizard:seed_quidditch_players
INSERT INTO quidditch_players (quidditch_team_id, student_id, position)
SELECT t.quidditch_team_id,
       sub.student_id,
       (ARRAY ['Chaser', 'Chaser', 'Chaser', 'Beater', 'Beater', 'Keeper', 'Seeker'])[sub.pos_idx]
FROM quidditch_teams t
         CROSS JOIN LATERAL (
    SELECT student_id, row_number() OVER (ORDER BY random()) as pos_idx
    FROM students
    WHERE house_id = t.house_id
    LIMIT 7
    ) sub
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM quidditch_players;

-- changeset wizard:seed_academic_results
INSERT INTO exam_results (student_id, subject_id, grade, exam_date)
SELECT (SELECT student_id FROM students ORDER BY random() LIMIT 1),
       (SELECT subject_id FROM subjects ORDER BY random() LIMIT 1),
       (ARRAY ['O', 'E', 'A', 'P', 'D', 'T'])[floor(random() * 6 + 1)],
       NOW() - (i || ' days')::interval
FROM generate_series(1, (20 * ${SEED_COUNT})) AS i
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM exam_results;

-- changeset wizard:seed_incidents
INSERT INTO incidents (title, description, location_id, incident_date)
SELECT 'Incident ' || i,
       'Description ' || i,
       (SELECT location_id FROM locations ORDER BY random() LIMIT 1),
       NOW() - (i || ' days')::interval
FROM generate_series(1, (10 * ${SEED_COUNT})) AS i
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM incidents;

-- changeset wizard:seed_incident_participants
INSERT INTO incident_participants (incident_id, person_id, role)
SELECT i.incident_id,
       p.person_id,
       (ARRAY ['Witness', 'Victim', 'Suspect', 'Helper'])[floor(random() * 4 + 1)]
FROM incidents i
         CROSS JOIN LATERAL (
    SELECT person_id
    FROM persons
    ORDER BY random()
    LIMIT 3
    ) p
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM incident_participants;

-- changeset wizard:seed_house_point_logs
INSERT INTO house_point_logs (house_id, student_id, awarded_by_staff_id, points, reason)
SELECT s.house_id, s.student_id, st.staff_id, 10, 'Good job'
FROM students s
         CROSS JOIN LATERAL (SELECT staff_id FROM staff ORDER BY random() LIMIT 1) st
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM house_point_logs;

-- changeset wizard:seed_villains
INSERT INTO villains (person_id, alias, threat_level, affiliation)
SELECT p.person_id, 'Dark Lord ' || i, 'High', 'Death Eaters'
FROM persons p
         JOIN generate_series(1, (2 * ${SEED_COUNT})) AS i ON p.person_id % 10 = 0
LIMIT (2 * ${SEED_COUNT})
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM villains;

-- changeset wizard:seed_spell_masteries
INSERT INTO spell_masteries (student_id, spell_id, mastered_date)
SELECT s.student_id, sp.spell_id, NOW()
FROM students s
         CROSS JOIN spells sp
WHERE random() < 0.3
ON CONFLICT DO NOTHING;
-- rollback DELETE FROM spell_masteries;