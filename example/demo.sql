-- Init
--

DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;

CREATE TABLE departments (
     id SERIAL PRIMARY KEY,
     name VARCHAR NOT NULL
);

INSERT INTO departments (id, name) VALUES
    (1, 'Закупки'),
    (2, 'Маркетинг'),
    (3, 'Доставка');

CREATE TABLE employees (
     id SERIAL PRIMARY KEY,
     name VARCHAR NOT NULL
);

INSERT INTO employees (id, name)
VALUES
    (1, 'Иванов'),
    (2, 'Васильев'),
    (3, 'Петров');

CREATE TABLE memberships (
    id SERIAL PRIMARY KEY,
    department_id INT NOT NULL REFERENCES departments(id),
    employee_id INT NOT NULL REFERENCES employees(id),
    date_from DATE NOT NULL,
    date_to DATE NOT NULL
);

INSERT INTO memberships (id, department_id, employee_id, date_from, date_to)
VALUES
    (default, 1, 1, '2012-03-18', '2012-06-18'),
    (default, 1, 2, '2012-04-16', '2012-07-16'),
    (default, 2, 2, '2012-06-23', '2012-08-23'),
    (default, 2, 1, '2012-05-21', '2012-08-21'),
    (default, 1, 3, '2012-09-06', '2012-11-08');

-- List
--

SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM memberships;

-- Select
--

SELECT
    e.name
FROM
    employees e
ORDER BY
    e.name;


SELECT
    e.name,
    m.date_from,
    m.date_to,
    d.name
FROM
    employees e,
    memberships m,
    departments d
WHERE
    m.employee_id = e.id AND
    m.department_id = d.id
ORDER BY
    e.name,
    m.date_from;


SELECT
    e.name,
    m.date_from,
    m.date_to,
    d.name
FROM
    memberships m, -- \
    employees e,   -- |
    departments d
WHERE
    m.employee_id = e.id AND
    m.department_id = d.id
ORDER BY
    e.name,
    m.date_from;


SELECT
    e.name,
    m.date_from,
    m.date_to,
    d.name
FROM memberships m
INNER JOIN employees e ON m.employee_id = e.id
INNER JOIN departments d ON m.department_id = d.id
ORDER BY e.name, m.date_from;

SELECT
    e.name,
    m.date_from,
    m.date_to,
    d.name
FROM memberships m
INNER JOIN employees e ON m.employee_id = e.id
INNER JOIN departments d ON m.department_id = d.id
WHERE d.name = 'Маркетинг'
ORDER BY e.name, m.date_from;

SELECT
    e.name,
    m.date_from,
    m.date_to,
    d.name
FROM memberships m
INNER JOIN employees e ON m.employee_id = e.id
INNER JOIN departments d ON m.department_id = d.id AND d.name = 'Маркетинг'
ORDER BY e.name, m.date_from;


-- Explain
--

EXPLAIN (COSTS false) SELECT
    e.name,
    m.date_from,
    m.date_to,
    d.name
FROM memberships m
INNER JOIN employees e ON m.employee_id = e.id
INNER JOIN departments d ON m.department_id = d.id AND d.name = 'Маркетинг'
ORDER BY e.name, m.date_from;


EXPLAIN (COSTS false) SELECT
    e.name,
    m.date_from,
    m.date_to,
    d.name
FROM memberships m
INNER JOIN employees e ON m.employee_id = e.id
INNER JOIN departments d ON m.department_id = d.id
WHERE d.name = 'Маркетинг'
ORDER BY e.name, m.date_from;


EXPLAIN (COSTS false) SELECT t.* FROM (
    SELECT
        e.name,
        m.date_from,
        m.date_to,
        d.name AS d_name
    FROM memberships m
    INNER JOIN employees e ON m.employee_id = e.id
    INNER JOIN departments d ON m.department_id = d.id
    ORDER BY e.name, m.date_from
) t
WHERE t.d_name = 'Маркетинг';


EXPLAIN (COSTS false) SELECT
    e.name,
    m.date_from,
    m.date_to,
    d.name
FROM
    memberships m,
    employees e,
    departments d
WHERE
    m.employee_id = e.id AND
    m.department_id = d.id AND
    d.name = 'Маркетинг'
ORDER BY e.name, m.date_from;
