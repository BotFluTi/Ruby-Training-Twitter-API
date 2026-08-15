# Feature development rules

Non-default choices for the `feature-development` skill. Anything not listed here uses the
skill's default.

## Spec & issue workflow

The spec for a feature or bug fix lives in a **GitHub issue** on
`BotFluTi/Ruby-Training-Twitter-API`.

- If an issue already exists for the work at hand, use it — never open a duplicate.
- If none exists, create one holding the problem statement, numbered acceptance criteria,
  and out-of-scope notes.

## Branch naming

Bare kebab-case, branched from `main` — matching the existing history (`tweet-comms`,
`week7`). No `feature/` prefix.

## Review hand-off

Delegate the structured review to the `code-review` skill before presenting the walkthrough
and PR description.
