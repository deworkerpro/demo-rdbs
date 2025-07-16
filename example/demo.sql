-- Init
--

DROP TABLE IF EXISTS persons;

CREATE TABLE persons (
    id SERIAL PRIMARY KEY,
    birth_date DATE,
    name_first VARCHAR NOT NULL,
    name_middle VARCHAR,
    name_second VARCHAR NOT NULL
);

INSERT INTO persons (id, birth_date, name_first, name_middle, name_second)
VALUES
    (default, '1989-10-10', 'Василий', 'Петрович', 'Иванов'),
    (default, '2001-06-11', 'Пётр', NULL, 'Васильев'),
    (default, NULL, 'Иван', NULL, 'Петров');

SELECT * FROM persons;

--
-- Selects
--

SELECT
    id,
    birth_date,
    name_first,
    name_middle,
    name_second
FROM persons
ORDER BY id;

SELECT
    id,
    birth_date,
    age(current_date, birth_date) AS age,
    name_first,
    name_middle,
    name_second
FROM persons
ORDER BY id;

SELECT
    id,
    birth_date,
    date_part('year', age(current_date, birth_date)) AS age,
    name_first,
    name_middle,
    name_second
FROM persons
ORDER BY id;

SELECT
    id,
    birth_date,
    date_part('year', age(current_date, birth_date)) AS age,
    name_first,
    COALESCE(name_middle, '-'),
    name_second
FROM persons
ORDER BY id;

SELECT
    id,
    birth_date,
    date_part('year', age(current_date, birth_date)) AS age,
    concat(name_first, ' ', name_middle, ' ', name_second) as name
FROM persons
ORDER BY id;

SELECT
    id,
    birth_date,
    date_part('year', age(current_date, birth_date)) AS age,
    concat(
        name_first,
        CASE WHEN name_middle IS NOT NULL THEN concat(' ', name_middle) ELSE '' END,
        ' ',
        name_second
    ) as name
FROM persons
ORDER BY id;

