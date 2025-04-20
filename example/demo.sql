DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR UNIQUE NOT NULL CHECK (username != '')
);

DROP TABLE users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR UNIQUE NOT NULL CHECK (username != '' AND lower(trim(username)) != 'admin')
);

DROP TABLE users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR UNIQUE NOT NULL CHECK (username != '') CHECK (lower(trim(username)) != 'admin')
);

DROP TABLE users CASCADE;

CREATE TABLE users (
    id SERIAL,
    PRIMARY KEY (id),
    username VARCHAR NOT NULL,
    UNIQUE (username),
    CHECK (username != ''),
    CHECK (lower(trim(username)) != 'admin')
);

DROP TABLE users CASCADE;

CREATE TABLE users (
    id SERIAL,
    CONSTRAINT users_pk PRIMARY KEY (id),
    username VARCHAR NOT NULL,
    CONSTRAINT users_username_uniq UNIQUE (username),
    CONSTRAINT users_username_not_empty CHECK (username != ''),
    CONSTRAINT users_username_not_admin CHECK (lower(trim(username)) != 'admin')
);

DROP TABLE users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR UNIQUE NOT NULL CHECK (username != '')
);

DROP TABLE users CASCADE;

CREATE TABLE users (
    id SERIAL CONSTRAINT users_pk PRIMARY KEY,
    username VARCHAR CONSTRAINT users_username_uniq UNIQUE NOT NULL CONSTRAINT users_username_not_empty CHECK (username != '')
);

DROP TABLE IF EXISTS networks CASCADE;

CREATE TABLE networks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users (id),
    name VARCHAR NOT NULL CHECK (name != ''),
    UNIQUE (user_id, name)
);

DROP TABLE networks CASCADE;

CREATE TABLE networks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users (id) ON UPDATE RESTRICT ON DELETE CASCADE,
    name VARCHAR NOT NULL CHECK (name != ''),
    UNIQUE (user_id, name)
);

DROP TABLE networks CASCADE;

CREATE TABLE networks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    name VARCHAR NOT NULL CHECK (name != ''),
    UNIQUE (user_id, name)
);

DROP TABLE networks CASCADE;

CREATE TABLE networks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL CONSTRAINT networks_user REFERENCES users (id) ON DELETE CASCADE,
    name VARCHAR NOT NULL CHECK (name != ''),
    UNIQUE (user_id, name)
);

DROP TABLE networks CASCADE;

CREATE TABLE networks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name VARCHAR NOT NULL CHECK (name != ''),
    UNIQUE (user_id, name),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

DROP TABLE networks CASCADE;

CREATE TABLE networks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name VARCHAR NOT NULL CHECK (name != ''),
    UNIQUE (user_id, name),
    CONSTRAINT networks_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

DROP TABLE networks CASCADE;

CREATE TABLE networks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name VARCHAR NOT NULL CHECK (name != ''),
    UNIQUE (user_id, name),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

DROP TABLE networks CASCADE;

CREATE TABLE networks (
    id SERIAL,
    user_id INTEGER NOT NULL,
    name VARCHAR NOT NULL
);

ALTER TABLE networks ADD PRIMARY KEY (id);
ALTER TABLE networks DROP CONSTRAINT networks_pkey;

ALTER TABLE networks ADD CONSTRAINT networks_pk PRIMARY KEY (id);
ALTER TABLE networks DROP CONSTRAINT networks_pk;

ALTER TABLE networks ADD CHECK (name != '');
ALTER TABLE networks ADD UNIQUE (user_id, name);

-- CREATE UNIQUE INDEX networks_uniq ON networks (user_id, name)

ALTER TABLE networks ADD CONSTRAINT networks_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE networks DROP CONSTRAINT networks_user;

ALTER TABLE networks ADD FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE users ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users ALTER COLUMN created_at DROP DEFAULT;
ALTER TABLE users ALTER COLUMN created_at DROP NOT NULL;
ALTER TABLE users DROP COLUMN created_at;

ALTER TABLE users ADD COLUMN created_at TIMESTAMP;
ALTER TABLE users ALTER COLUMN created_at SET NOT NULL;
ALTER TABLE users ALTER COLUMN created_at SET DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users DROP COLUMN created_at;
