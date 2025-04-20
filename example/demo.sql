DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL
);

-- https://dev.to/dm8ry/populating-a-postgresql-table-with-a-random-data-a-step-by-step-guide-hlp
do $$
    declare
        username_length smallint;
        random_username varchar(100);
        random_timestamp timestamp;
        query text;
    begin
        for _ in 1..100000 loop
            username_length := floor(random()*10)+10;
            random_username := array_to_string(array(select chr((ascii('a') + round(random() * 25)) :: integer) from generate_series(1,username_length)), '');
            random_timestamp := timestamp '1900-01-01 00:00:00' + random() * (timestamp '2025-01-01 00:00:00' - timestamp '1900-01-01 00:00:00');
            query := 'insert into users values(default, $1, $2)';
            execute query using random_username, random_timestamp;
        end loop;
    end;
$$;

SELECT count(*) FROM users;

EXPLAIN (ANALYSE, BUFFERS) SELECT * FROM users ORDER BY created_at LIMIT 100;

ANALYZE;
VACUUM;

EXPLAIN (ANALYSE, BUFFERS) SELECT * FROM users ORDER BY created_at LIMIT 100;

CREATE INDEX idx_users_created_at ON users (created_at);

EXPLAIN (ANALYSE, BUFFERS) SELECT * FROM users ORDER BY created_at LIMIT 100;

EXPLAIN ANALYSE SELECT * FROM users WHERE lower(username) = 'admin';

CREATE INDEX idx_users_username_lower ON users (lower(username));

EXPLAIN ANALYSE SELECT * FROM users WHERE lower(username) = 'admin';

DROP INDEX idx_users_username;

CREATE UNIQUE INDEX idx_users_username ON users (username) WHERE created_at > '2024-01-01 00:00:00';

EXPLAIN (ANALYSE, BUFFERS) SELECT * FROM users WHERE created_at > '2024-06-01 00:00:00' ORDER BY created_at LIMIT 100;

DROP INDEX idx_users_username;

CREATE UNIQUE INDEX idx_users_username ON users (username) INCLUDE (id);

EXPLAIN (ANALYSE, BUFFERS) SELECT id FROM users WHERE username = 'admin';
