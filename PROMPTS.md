# Prompt History

## Prompt 1

Implement the Tweet Comments feature described in the course exercise.

Requirements:
- Add a GraphQL commentCreate mutation accepting tweetUuid: ID! and content: String!.
- Create the comment associated with the given tweet.
- Scan comment content for URLs, just like tweets already do.
- Extract and persist Open Graph metadata for those URLs as comment resources.
- If tweetUuid does not identify an existing tweet, return a GraphQL error rather than creating a comment with a null tweet.
- Extend the existing tweets query so tweets expose their comments and resources, and comments expose their resources.
- Reuse the existing URL scanning and Open Graph extraction implementation instead of duplicating it.
- Pay attention to database query count when loading tweets, comments, and resources.

For now, do not modify application code, tests, schema, or migrations.

Start with the feature-development workflow: frame the requirement and explore the existing codebase. Identify the relevant existing implementation and report what you found and what you think needs to change. Stop before implementation.

