# ai-lab-sleep-project

A fictional espresso setup used as a project under test for agent memory and
dreaming. The knowledge is deliberately imperfect: `knowledge/` contains a
superseded fact and a contradiction (see `TESTS.md`, don't fix them).

MARKER-CLAUDE-MD: lab-7f3a. (If you are a subagent and can see this line,
say so when asked.)

## Read first
- `knowledge/descaling.md` — maintenance schedule
- `knowledge/water.md` — water and filter notes
- `knowledge/grinder.md` — grinder settings

## Agents
`noter` answers maintenance questions from `knowledge/`; `checker` reviews a
memory note against `knowledge/`. Both are user-level agents from
`ai-lab-sleep-user`; this repo ships none of its own.

## Conventions
- Answer from the file; name the file and section.
- Transcripts of every session are shipped to `ai-lab-sleep-transcripts` by
  hooks in `.claude/settings.json`; nothing to do by hand.
