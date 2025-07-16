-- Create
--

DROP TABLE IF EXISTS posts;

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL,
    title VARCHAR NOT NULL
);

INSERT INTO posts (id, date, title) VALUES
  (default, '2024-02-12 13:21:16', 'Old');

SELECT * FROM posts ORDER BY id;

-- Add new column
--

ALTER TABLE posts ADD COLUMN create_date TIMESTAMP;
UPDATE posts SET create_date = date WHERE create_date IS NULL;
ALTER TABLE posts ALTER COLUMN create_date SET NOT NULL;

CREATE OR REPLACE FUNCTION duplicate_create_date() RETURNS TRIGGER
AS $$
BEGIN
    NEW.create_date := COALESCE(NEW.create_date, NEW.date);
    NEW.date := COALESCE(NEW.date, NEW.create_date);
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER duplicate_create_date_trigger
    BEFORE INSERT ON posts
    FOR EACH ROW
EXECUTE PROCEDURE duplicate_create_date();

-- Run both apps
--

SELECT * FROM posts ORDER BY id;

INSERT INTO posts (id, date, title) VALUES
    (default, '2024-02-12 13:33:24', 'Old');

SELECT * FROM posts ORDER BY id;

INSERT INTO posts (id, create_date, title) VALUES
    (default, '2024-02-12 13:32:01', 'New');

SELECT * FROM posts ORDER BY id;

-- Delete old column
--

ALTER TABLE posts DROP COLUMN date;

SELECT * FROM posts ORDER BY id;
