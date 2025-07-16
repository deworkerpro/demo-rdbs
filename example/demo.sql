-- Init
--

DROP TABLE IF EXISTS news;

CREATE TABLE news (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL,
    title VARCHAR NOT NULL,
    text TEXT NOT NULL
);

INSERT INTO news (id, date, title, text) VALUES
   (1, '2025-06-11 12:37:18', 'Новость про слона', 'Первая новость'),
   (2, '2025-06-12 06:31:12', 'Новое мероприятие', 'Вторая новость'),
   (3, '2025-06-14 23:11:07', 'Открытие пляжа', 'Третья новость');

DROP TABLE IF EXISTS posts;

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    publish_date TIMESTAMP NOT NULL,
    title VARCHAR NOT NULL,
    text TEXT NOT NULL
);

INSERT INTO posts (id, publish_date, title, text) VALUES
   (1, '2025-06-11 12:37:18', 'Я и слон', 'Первый пост'),
   (2, '2025-06-13 08:31:12', 'Куда сходить в выходные', 'Второй пост'),
   (3, '2025-06-15 13:11:07', 'Пляжный волейбол', 'Третий пост');

-- Selects
--

SELECT id, date, title FROM news ORDER BY date DESC;

SELECT id, publish_date, title FROM posts ORDER BY publish_date DESC;


SELECT id, date, title FROM news
UNION
SELECT id, publish_date AS date, title FROM posts
ORDER BY date DESC;


SELECT id, date, title FROM news
UNION
SELECT id, publish_date AS date, title FROM posts
ORDER BY date DESC;


SELECT 'new' AS type, id, date, title FROM news
UNION
SELECT 'post' AS type, id, publish_date AS date, title FROM posts
ORDER BY date DESC;


SELECT 'new' AS type, id, date, title FROM news
UNION
SELECT 'post' AS type, id, publish_date AS date, title FROM posts
ORDER BY date DESC
LIMIT 4;


(SELECT 'new' AS type, id, date, title FROM news ORDER BY date DESC LIMIT 4)
UNION
(SELECT 'post' AS type, id, publish_date AS date, title FROM posts ORDER BY publish_date DESC LIMIT 4)
ORDER BY date DESC
LIMIT 4;

-- Wrap
--

SELECT last_items.*
FROM (
    (SELECT 'new' AS type, id, date, title FROM news ORDER BY date DESC LIMIT 4)
    UNION
    (SELECT 'post' AS type, id, publish_date AS date, title FROM posts ORDER BY publish_date DESC LIMIT 4)
) last_items
ORDER BY last_items.date DESC
LIMIT 4;

-- Common table expressions
--

WITH last_items AS (
    (SELECT 'new' AS type, id, date, title FROM news ORDER BY date DESC LIMIT 4)
    UNION
    (SELECT 'post' AS type, id, publish_date AS date, title FROM posts ORDER BY publish_date DESC LIMIT 4)
    ORDER BY date DESC
    LIMIT 4
)
SELECT * FROM last_items;

-- Views
--

DROP VIEW IF EXISTS last_items;

CREATE OR REPLACE VIEW last_items AS
    (SELECT 'new' AS type, id, date, title FROM news ORDER BY date DESC LIMIT 4)
    UNION
    (SELECT 'post' AS type, id, publish_date AS date, title FROM posts ORDER BY publish_date DESC LIMIT 4)
    ORDER BY date DESC
    LIMIT 4;

SELECT * FROM last_items;
