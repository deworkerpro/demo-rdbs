-- Series
--

SELECT * FROM generate_series('2025-05-01', '2025-05-07', '1 day'::interval);

SELECT * FROM generate_series('2025-05-01 11:30:30', '2025-05-07', '1 day'::interval);

SELECT * FROM generate_series('2025-05-01 11:30:30'::date, '2025-05-07', '1 day'::interval);

SELECT day FROM generate_series('2025-05-01', '2025-05-07', '1 day'::interval) day;

SELECT day::date FROM generate_series('2025-05-01', '2025-05-07', '1 day'::interval) day;

-- Orders
--

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    date TIMESTAMP NOT NULL,
    email VARCHAR NOT NULL,
    amount INT NOT NULL
);

INSERT INTO orders (id, date, email, amount) VALUES
    (1, '2025-05-01 11:30:30', 'vasya@app.test', 2300),
    (2, '2025-05-03 12:32:16', 'petya@app.test', 1680),
    (3, '2025-05-03 12:32:16', 'petya@app.test', 450),
    (4, '2025-05-06 21:11:27', 'slava@app.test', 2550);

-- Selects
--

SELECT
    day::date,
    (SELECT COUNT(o.id) FROM orders o WHERE o.date::date = day::date) orders_count
FROM
    generate_series('2025-05-01', '2025-05-07', '1 day'::interval) day;


SELECT
    day::date,
    (SELECT COUNT(o.id) FROM orders o WHERE o.date::date = day.date) orders_count,
    (SELECT SUM(o.amount) FROM orders o WHERE o.date::date = day.date) orders_sum
FROM
    generate_series('2025-05-01', '2025-05-07', '1 day'::interval) day;


SELECT
    day::date,
    (SELECT COUNT(o.id) FROM orders o WHERE o.date::date = day.date) orders_count,
    COALESCE((SELECT SUM(o.amount) FROM orders o WHERE o.date::date = day.date), 0) orders_sum
FROM
    generate_series('2025-05-01', '2025-05-07', '1 day'::interval) day;
