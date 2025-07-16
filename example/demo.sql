-- Init
--

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR UNIQUE NOT NULL,
    name VARCHAR NOT NULL,
    is_active BOOLEAN NOT NULL
);

TRUNCATE TABLE users;

INSERT INTO users (id, email, name, is_active) VALUES
    (1, 'vasya@app.test', 'Василий Иванов', FALSE),
    (2, 'petya@app.test', 'Пётр Сидоров', FALSE),
    (3, 'pavel@app.test', 'Павел Васильев', TRUE);

SELECT * FROM users;

-- Update
--

UPDATE users SET is_active = true WHERE id = 1;

SELECT * FROM users;

--

UPDATE users SET is_active = NOT is_active WHERE id = 1;

SELECT * FROM users;

--

ALTER TABLE users ADD COLUMN name_first VARCHAR;
ALTER TABLE users ADD COLUMN name_second VARCHAR;

SELECT * FROM users;

UPDATE users SET
    name_first = split_part(name, ' ', 1),
    name_second = split_part(name, ' ', 2)
WHERE name_first IS NULL;

SELECT * FROM users;

ALTER TABLE users ALTER COLUMN name_first SET NOT NULL;
ALTER TABLE users ALTER COLUMN name_second SET NOT NULL;
ALTER TABLE users DROP COLUMN name;

SELECT * FROM users;
