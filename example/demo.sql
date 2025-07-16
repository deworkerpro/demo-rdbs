-- Schema
--

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR UNIQUE NOT NULL,
    name VARCHAR NOT NULL,
    is_active BOOLEAN NOT NULL
);

--
-- Inserts
--

TRUNCATE TABLE users;

INSERT INTO users (id, email, name, is_active) VALUES
    (default, 'vasya@app.test', 'Василий', FALSE),
    (default, 'petya@app.test', 'Пётр', TRUE);

SELECT * FROM users;

--

-- INSERT INTO users (id, email, name) VALUES
--     (default, 'vasya@app.test', 'Василий');

--

INSERT INTO users (id, email, name, is_active) VALUES
    (default, 'vasya@app.test', 'Василий', FALSE)
ON CONFLICT (email) DO NOTHING;

SELECT * FROM users;

--

INSERT INTO users (id, email, name, is_active) VALUES
    (default, 'vasya@app.test', 'Вася', FALSE)
ON CONFLICT (email) DO NOTHING;

SELECT * FROM users;

--

INSERT INTO users (id, email, name, is_active) VALUES
    (default, 'vasya@app.test', 'Вася', FALSE)
ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name;

SELECT * FROM users;

--

TRUNCATE TABLE users;

INSERT INTO users (id, email, name, is_active) VALUES
    (1, 'vasya@app.test', 'Василий', FALSE),
    (2, 'petya@app.test', 'Пётр', TRUE);

SELECT * FROM users;

INSERT INTO users (id, email, name, is_active) VALUES
    (3, 'vasya@app.test', 'Вася', FALSE)
ON CONFLICT (email) WHERE is_active IS FALSE DO UPDATE SET name = EXCLUDED.name;

INSERT INTO users (id, email, name, is_active) VALUES
    (3, 'petya@app.test', 'Петя', FALSE)
ON CONFLICT (email) WHERE is_active IS TRUE DO NOTHING;

SELECT * FROM users;
