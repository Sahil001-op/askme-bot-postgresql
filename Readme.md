# Ask Me About Me a chatbot built entirely in PostgreSQL

A rule-based Q&A chatbot that answers questions about my background, skills and projects. It runs completely inside PostgreSQL, with no application code and no external API.

## How it works
- A `knowledge` table holds 27 question and answer rows about me.
- A generated `tsvector` column makes the rows searchable, weighting keywords highest, then the question, then the topic. A GIN index keeps search fast.
- The `ask_bot(question)` function (PLpgSQL) searches with full-text search and ranks matches with `ts_rank`. If nothing matches, it falls back to `pg_trgm` similarity so typos still work, then to a polite I don't know message.
- Every question is saved in `chat_log`. Three views (`top_questions`, `unanswered_questions`, `daily_answer_rate`) show what visitors ask and what the bot can't answer yet.

## Skills demonstrated
PostgreSQL, SQL, PLpgSQL, full-text search, GIN indexes, generated columns, the pg_trgm extension, views.

## Run it yourself
Requires PostgreSQL 12 or newer.
1. Create a database `CREATE DATABASE askme_bot;`
2. Run the files in order `01_schema.sql`, `02_data.sql`, `03_bot_function.sql`, `04_analytics.sql`
3. Ask a question
```sql
SELECT ask_bot('What are your skills');
```

## Example
Question
```sql
SELECT ask_bot('What are your skills');
```
Answer
```
My core skills are customer service and query resolution, client relationship management and retention, reconciliation and attention to detail, order processing and supplier follow up, record keeping and reporting, process improvement, and team leadership. I am strong in Microsoft Excel and Office and quick to learn new systems.
```

## Limitations
It matches keywords, so it does not understand meaning. It can only answer from what is in the `knowledge` table. This keeps every answer accurate and traceable.

## Contact
LinkedIn httpswww.linkedin.cominsahil-rana-65854a312