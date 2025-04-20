DROP TABLE IF EXISTS posts;

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP(0) WITHOUT TIME ZONE,
    title VARCHAR NOT NULL
);

CREATE INDEX posts_date ON posts(date);

INSERT INTO posts (date, title)
VALUES ('2024-06-15 18:06:11', 'First Post'),
       ('2024-08-17 12:23:44', 'Second Post'),
       (null, 'Third Post');


SELECT
    id,
    date,
    title
FROM posts
ORDER BY date;


SELECT
    id,
    to_char(date, 'YYYY-MM-DD"T"HH24:MI:SS+00:00') AS date,
    title
FROM posts
ORDER BY date;


DROP FUNCTION IF EXISTS date_atom;

CREATE OR REPLACE FUNCTION date_atom(date timestamp) RETURNS varchar
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT
    RETURN to_char(date, 'YYYY-MM-DD"T"HH24:MI:SS+00:00');


SELECT
    id,
    date_atom(date) AS date,
    title
FROM posts
ORDER BY date;
