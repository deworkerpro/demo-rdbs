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
    birth_date DATE,
    name VARCHAR NOT NULL
);

INSERT INTO employees (id, birth_date, name)
VALUES
    (1, '1989-10-10', 'Иванов'),
    (2, '2001-06-11', 'Васильев'),
    (3, NULL, 'Петров'),
    (4, NULL, 'Сидоров'),
    (5, '2003-12-10', 'Карпов'),
    (11, '2003-01-15', 'Крылов');

CREATE TABLE memberships (
    department_id INT NOT NULL REFERENCES departments(id),
    employee_id INT NOT NULL REFERENCES employees(id),
    PRIMARY KEY(department_id, employee_id)
);

INSERT INTO memberships (department_id, employee_id)
VALUES
    (1, 1),
    (3, 2),
    (2, 2),
    (2, 4),
    (3, 4),
    (1, 3);

-- List
--

SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM memberships;

-- Selects
--

SELECT
    id,
    birth_date,
    name
FROM employees
ORDER BY id;

SELECT
    id,
    birth_date,
    name
FROM employees
ORDER BY name;

SELECT
    id,
    birth_date,
    name
FROM employees
ORDER BY birth_date;

SELECT
    id,
    birth_date,
    name
FROM employees
ORDER BY birth_date NULLS FIRST;

SELECT
    e.id,
    e.name
FROM
    employees e
WHERE EXISTS(SELECT m.employee_id FROM memberships m WHERE m.employee_id = e.id AND m.department_id = 1)
ORDER BY e.name;

SELECT
    e.id,
    e.name
FROM
    employees e
WHERE e.id IN (SELECT m.employee_id FROM memberships m WHERE m.employee_id = e.id AND m.department_id = 1)
ORDER BY e.name;

---

SELECT
    e.id,
    e.name,
    (SELECT COUNT(m.department_id) FROM memberships m WHERE m.employee_id = e.id) as deps_count
FROM employees e
ORDER BY e.id;

SELECT
    e.id,
    e.name,
    (SELECT COUNT(m.department_id) FROM memberships m WHERE m.employee_id = e.id) as deps_count
FROM employees e
ORDER BY deps_count;

SELECT t.*
FROM (
    SELECT
        e.id,
        e.name,
        (SELECT COUNT(m.department_id) FROM memberships m WHERE m.employee_id = e.id) as deps_count
    FROM employees e
) t
WHERE t.deps_count > 0
ORDER BY t.deps_count;

---

SELECT
    e.id,
    e.name,
    COUNT(m.department_id) as deps_count
FROM employees e
LEFT JOIN memberships m ON m.employee_id = e.id
GROUP BY e.id
ORDER BY deps_count;


SELECT
    e.id,
    e.name,
    COUNT(m.department_id) as deps_count
FROM employees e
LEFT JOIN memberships m ON m.employee_id = e.id
GROUP BY e.id
HAVING COUNT(m.department_id) > 0
ORDER BY deps_count;

---

SELECT
    id,
    name
FROM employees
WHERE id IN (3, 5, 11, 1);

SELECT * FROM unnest(ARRAY[3, 5, 11, 1]) WITH ORDINALITY t(id, ord);

SELECT
    e.id,
    e.name
FROM employees e
JOIN unnest(ARRAY[3, 5, 11, 1]) WITH ORDINALITY t(id, ord) ON e.id = t.id
ORDER BY t.ord;

SELECT
    e.id,
    e.name
FROM employees e
INNER JOIN unnest(ARRAY[3, 5, 11, 1]) WITH ORDINALITY t(id, ord) USING (id)
ORDER BY t.ord;
