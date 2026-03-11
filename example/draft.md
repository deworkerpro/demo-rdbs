# PostgreSQL Full-Text Search Examples

## Overview

PostgreSQL provides built-in full-text search capabilities using `tsvector` and `tsquery` types along with the `@@` match operator.

## Basic Setup

### Create a Sample Table

```sql
CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### Insert Sample Data

```sql
INSERT INTO articles (title, content) VALUES
('Introduction to PostgreSQL', 'PostgreSQL is a powerful open-source relational database system.'),
('Database Indexing', 'Indexes help improve query performance in database systems.'),
('Advanced SQL Techniques', 'Learn advanced SQL including full-text search and window functions.'),
('PostgreSQL Full-Text Search', 'Full-text search allows searching for words or phrases in text columns.');
```

## Basic Full-Text Search

### Using `to_tsvector` and `to_tsquery`

```sql
-- Search for articles containing 'postgresql'
SELECT title, content
FROM articles
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'postgresql');
```

### Using `plainto_tsquery` (simpler, no boolean operators)

```sql
-- Search for articles containing both 'database' and 'search'
SELECT title, content
FROM articles
WHERE to_tsvector('english', content) @@ plainto_tsquery('english', 'database search');
```

### Using `phraseto_tsquery` (exact phrase matching)

```sql
-- Search for exact phrase 'full text'
SELECT title, content
FROM articles
WHERE to_tsvector('english', content) @@ phraseto_tsquery('english', 'full text');
```

### Using `websearch_to_tsquery` (natural language with operators)

```sql
-- Search with natural language syntax
SELECT title, content
FROM articles
WHERE to_tsvector('english', content) @@ websearch_to_tsquery('english', 'postgresql OR database');
```

## Boolean Operators in Search

```sql
-- AND operator: both terms must be present
SELECT title FROM articles
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database & search');

-- OR operator: either term can be present
SELECT title FROM articles
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database | sql');

-- NOT operator: exclude terms
SELECT title FROM articles
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database & !sql');

-- Follow operator: one term follows another
SELECT title FROM articles
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'full -> text');
```

## Optimizing with Generated Columns

### Add a Generated `tsvector` Column

```sql
-- Add a generated column for efficient searching
ALTER TABLE articles
ADD COLUMN search_vector tsvector
GENERATED ALWAYS AS (to_tsvector('english', title || ' ' || content)) STORED;
```

### Create a GIN Index

```sql
-- Create GIN index for fast full-text search
CREATE INDEX idx_articles_search ON articles USING GIN (search_vector);
```

### Query Using the Indexed Column

```sql
-- Fast search using the indexed column
SELECT title, content
FROM articles
WHERE search_vector @@ plainto_tsquery('english', 'postgresql database');
```

## Ranking Search Results

### Using `ts_rank`

```sql
-- Rank results by relevance
SELECT title, content,
       ts_rank(search_vector, plainto_tsquery('english', 'postgresql')) AS rank
FROM articles
WHERE search_vector @@ plainto_tsquery('english', 'postgresql')
ORDER BY rank DESC;
```

### Using `ts_rank_cd` (considers proximity)

```sql
-- Rank with proximity consideration
SELECT title, content,
       ts_rank_cd(search_vector, plainto_tsquery('english', 'database search')) AS rank
FROM articles
WHERE search_vector @@ plainto_tsquery('english', 'database search')
ORDER BY rank DESC;
```

## Highlighting Search Terms

### Using `ts_headline`

```sql
-- Highlight matched terms in results
SELECT title,
       ts_headline('english', content, plainto_tsquery('english', 'postgresql'),
                   'StartSel=<b>, StopSel=</b>, MaxFragments=2, MaxWords=50') AS excerpt
FROM articles
WHERE search_vector @@ plainto_tsquery('english', 'postgresql');
```

## Complete Example with All Features

```sql
-- Create optimized search query with ranking and highlighting
SELECT 
    title,
    ts_headline('english', content, query, 
                'StartSel=**, StopSel=**, MaxFragments=1') AS excerpt,
    ts_rank_cd(search_vector, query) AS relevance
FROM articles,
     plainto_tsquery('english', 'postgresql database') AS query
WHERE search_vector @@ query
ORDER BY relevance DESC
LIMIT 10;
```

## Search Configuration Options

PostgreSQL supports multiple language configurations:

```sql
-- English
SELECT to_tsvector('english', 'databases are powerful');

-- Simple (no stemming)
SELECT to_tsvector('simple', 'databases are powerful');

-- Other supported languages: french, german, spanish, russian, etc.
SELECT to_tsvector('french', 'les bases de données');
```

## Cleanup

```sql
-- Drop the table when done
DROP TABLE IF EXISTS articles;
```
