DROP TABLE IF EXISTS networks CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(32) UNIQUE NOT NULL CHECK (username != '')
);

TRUNCATE users CASCADE;

INSERT INTO users (id, username)
VALUES (1, 'vasya'),
       (2, 'petya'),
       (3, 'ilya'),
       (4, 'vlad');

CREATE TABLE networks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    name VARCHAR NOT NULL CHECK (name != ''),
    identity VARCHAR NOT NULL CHECK (identity != ''),
    UNIQUE (user_id, name),
    UNIQUE (name, identity)
);

TRUNCATE networks CASCADE;

INSERT INTO networks (user_id, name, identity)
VALUES (1, 'vk', '4331124'),
       (2, 'yandex', '234678'),
       (1, 'mail', '3456372'),
       (2, 'mail', '6735452'),
       (3, 'vk', '785636');

-- QUERIES
--

SELECT * FROM users;
SELECT * FROM networks;


SELECT
    n.name,
    count(n.id) AS records_count
FROM
    networks n
GROUP BY n.name
ORDER BY n.name;


SELECT
    u.id,
    u.username,
    (SELECT count(n.id) FROM networks n WHERE u.id = n.user_id) AS networks_count
FROM users u
ORDER BY u.username;


SELECT
    u.id,
    u.username,
    n.name AS network
FROM users u
LEFT JOIN networks n ON u.id = n.user_id
ORDER BY
    u.username,
    n.name;


SELECT
    u.id,
    u.username,
    n.name AS network,
    n.identity
FROM users u
LEFT JOIN networks n ON u.id = n.user_id
ORDER BY
    u.username,
    n.name;
-- LIMIT 3;

-- https://www.postgresql.org/docs/current/functions-aggregate.html

SELECT
    u.id,
    u.username,
    (SELECT array_agg(n.name) FROM networks n WHERE u.id = n.user_id) AS networks
FROM users u
ORDER BY u.username;


SELECT
    u.id,
    u.username,
    (SELECT array_agg(n.*) FROM networks n WHERE u.id = n.user_id) AS networks
FROM users u
ORDER BY u.username;


SELECT
    u.id,
    u.username,
    (SELECT json_agg(n.name) FROM networks n WHERE u.id = n.user_id) AS networks
FROM users u
ORDER BY u.username;


SELECT
    u.id,
    u.username,
    (SELECT json_agg(n.name ORDER BY n.name) FROM networks n WHERE u.id = n.user_id) AS networks
FROM users u
ORDER BY u.username;


SELECT
    u.id,
    u.username,
    (SELECT json_agg(n.* ORDER BY n.name) FROM networks n WHERE u.id = n.user_id) AS networks
FROM users u
ORDER BY u.username;


SELECT
    u.id,
    u.username,
    (
        SELECT json_agg(sub.* ORDER BY sub.name) FROM (
            SELECT n.name, n.identity FROM networks n WHERE u.id = n.user_id
        ) AS sub
    ) AS networks
FROM users u
ORDER BY u.username;


SELECT
    u.id,
    u.username,
    (
        SELECT json_agg(json_build_object('name', n.name, 'id', n.identity) ORDER BY n.name)
        FROM networks n WHERE u.id = n.user_id
    ) AS networks
FROM users u
ORDER BY u.username;

