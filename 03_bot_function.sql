CREATE OR REPLACE FUNCTION ask_bot(q TEXT) RETURNS TEXT AS $$
DECLARE
  tsq tsquery;
  result TEXT;
BEGIN
  IF q IS NULL OR btrim(q) = '' THEN
    RETURN 'Please type a question.';
  END IF;

  tsq := to_tsquery('english', replace(plainto_tsquery('english', q)::text, '&', '|'));

  -- attempt 1: full-text search
  SELECT answer INTO result
  FROM knowledge
  WHERE search_vector @@ tsq
  ORDER BY ts_rank(search_vector, tsq) DESC, id
  LIMIT 1;

  -- attempt 2: typo-tolerant match
  IF result IS NULL THEN
    SELECT answer INTO result
    FROM knowledge
    WHERE word_similarity(lower(q), lower(question || ' ' || keywords)) > 0.4
    ORDER BY word_similarity(lower(q), lower(question || ' ' || keywords)) DESC, id
    LIMIT 1;
  END IF;

  IF result IS NULL THEN
    result := 'I do not have that information. Try asking about my experience, skills, projects, education or how to contact me.';
    INSERT INTO chat_log (question, answer, matched) VALUES (q, result, false);
  ELSE
    INSERT INTO chat_log (question, answer, matched) VALUES (q, result, true);
  END IF;

  RETURN result;
END;
$$ LANGUAGE plpgsql;