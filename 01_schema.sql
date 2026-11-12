CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE knowledge (
  id SERIAL PRIMARY KEY,
  topic VARCHAR(50) NOT NULL,
  keywords VARCHAR(255) NOT NULL,
  question VARCHAR(255) NOT NULL,
  answer TEXT NOT NULL,
  search_vector tsvector GENERATED ALWAYS AS (
    setweight(to_tsvector('english', keywords), 'A') ||
    setweight(to_tsvector('english', question), 'B') ||
    setweight(to_tsvector('english', topic), 'C')
  ) STORED
);

CREATE INDEX idx_knowledge_search ON knowledge USING GIN (search_vector);

CREATE TABLE chat_log (
  id SERIAL PRIMARY KEY,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  matched BOOLEAN NOT NULL,
  asked_at TIMESTAMP DEFAULT NOW()
);