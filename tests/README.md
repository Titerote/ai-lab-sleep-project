# Lab tests

One file per test, `tests/<id>.md`, run unattended by the `lab-runner`
agent from this checkout:

```
claude --agent lab-runner "Run tests/T6-fresh-locators.md"
```

Results land in `tests/results/<id>-<date>.md` and one row in
`findings.md`. The runner may fix the lab (dreamer prompts, scripts, hooks)
between loops; it may never change a test's checks or hand-edit memory.

Agent definitions (`agents/*.md`) load when a session starts, so a fix to
a dreamer prompt cannot be exercised by the session that made it. The
outer loop handles that:

```
tests/run.sh T6-fresh-locators 3 45
```

starts a fresh runner session per attempt (headless, on a pty), waits for
its committed result file (`tests/results/<id>-<date>-a<n>.md`), closes
the session so the transcript ships, and stops at the first pass or after
the attempt budget.

## Format

```markdown
# <id> — <one-line purpose>
loops: 3                       # rerun budget, default 3

## Setup
Numbered steps the runner performs before acting: file edits in this
project (committed and pushed to main), state to verify, files to remove.

## Act
Which agent to spawn (`subagent_type`), the exact prompt, and what the
reply should contain for the step to count as done (not yet a check).

## Dream
Which phases to run, in order, and any sentence to add to a phase's prompt.

## Checks
Numbered. Each has a command (run exactly as written, from this checkout,
`$U` = the user clone) and an expected result stated so that the output
either matches or does not. No judgement calls.

## Teardown
What to leave in place (usually everything: notes are real) and what to
remove.
```

A check is a command and an expectation. "The note looks right" is not a
check; `grep -c '#[0-9a-f-]\{36\}' <note>` → `≥ 1` is.
