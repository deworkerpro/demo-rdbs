DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR UNIQUE NOT NULL CHECK (username ~ '^[A-Za-z0-9_-]+$')
);

DROP TABLE users CASCADE;

CREATE DOMAIN valid_username AS
    VARCHAR CHECK (value ~ '^[A-Za-z0-9_-]+$');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username valid_username UNIQUE NOT NULL
);

--
-- \dD
--

INSERT INTO users (id, username) VALUES (default, 'User_43');
-- INSERT INTO users (id, username) VALUES (default, '');
-- INSERT INTO users (id, username) VALUES (default, 'User 43');
-- INSERT INTO users (id, username) VALUES (default, 'Вася');
