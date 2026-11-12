CREATE VIEW unanswered_questions AS
SELECT question, COUNT(*) AS times_asked, MAX(asked_at) AS last_asked
FROM chat_log
WHERE matched = false
GROUP BY question
ORDER BY times_asked DESC;

CREATE VIEW top_questions AS
SELECT question, COUNT(*) AS times_asked
FROM chat_log
GROUP BY question
ORDER BY times_asked DESC
LIMIT 10;

CREATE VIEW daily_answer_rate AS
SELECT asked_at::date AS day,
       COUNT(*) AS questions,
       ROUND(100.0 * COUNT(*) FILTER (WHERE matched) / COUNT(*), 1) AS pct_answered
FROM chat_log
GROUP BY asked_at::date
ORDER BY day;