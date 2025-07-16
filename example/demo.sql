-- Init
--

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    date TIMESTAMP NOT NULL,
    customer VARCHAR NOT NULL,
    amount INT NOT NULL
);

INSERT INTO orders (id, date, customer, amount) VALUES
    (1, '2025-05-01 11:30:30', 'Vasya', 2300),
    (2, '2025-05-03 12:32:16', 'Petya', 1680),
    (3, '2025-05-04 12:20:16', 'Petya', 450),
    (4, '2025-05-06 21:11:27', 'Slava', 2550),
    (5, '2025-05-08 09:11:27', 'Oleg', 180);

-- Selects
--

SELECT
    id,
    date,
    customer,
    amount
FROM
    orders
ORDER BY date;

SELECT
    id,
    date::date,
    customer,
    amount
FROM
    orders
ORDER BY date;

SELECT
    id,
    o.date::date,
    customer,
    amount,
    (SELECT SUM(so.amount) FROM orders so WHERE so.date <= o.date) revenue
FROM
    orders o
ORDER BY date;


SELECT
    id,
    date::date,
    customer,
    amount,
    SUM(amount) OVER (ORDER BY date) revenue
FROM
    orders
ORDER BY date;


SELECT
    id,
    date::date,
    customer,
    amount,
    COUNT(id) OVER (PARTITION BY customer ORDER BY date) c_order,
    SUM(amount) OVER (ORDER BY date) revenue
FROM
    orders
ORDER BY date;

SELECT
    id,
    date::date,
    customer,
    amount,
    COUNT(id) OVER (PARTITION BY customer ORDER BY date) c_order,
    SUM(amount) OVER (PARTITION BY customer ORDER BY date) c_sum,
    SUM(amount) OVER (ORDER BY date) revenue
FROM
    orders
ORDER BY date;


SELECT
    id,
    date::date,
    customer,
    amount,
    COUNT(id) OVER (PARTITION BY customer ORDER BY date) c_order,
    SUM(amount) OVER (PARTITION BY customer ORDER BY date) c_sum,
    rank() OVER (PARTITION BY customer ORDER BY amount DESC) c_amount_rank,
    SUM(amount) OVER (ORDER BY date) revenue
FROM
    orders
ORDER BY date;
