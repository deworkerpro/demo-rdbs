-- https://www.postgresql.org/docs/current/queries-table-expressions.html

SELECT brand, size, sum(sales) FROM items_sold GROUP BY GROUPING SETS ((brand), (size), ());

SELECT brand, size, sum(sales) FROM items_sold GROUP BY ROLLUP ( e1, e2, e3, ... );

SELECT brand, size, sum(sales) FROM items_sold GROUP BY CUBE ( e1, e2, ... );