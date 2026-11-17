# T9 — the noter writes its own assumption to memory before answering; settle keeps `origin: note`
loops: 3

Every bet in memory so far is `origin: transcript`: the noter stated its
assumptions in replies and never wrote them, even with `Write` available
(T6, T8 side findings). Its purpose line now says *when* to write — an
assumption goes to memory before the answer that rests on it. This test asks
a question that cannot be answered from `knowledge/` without assuming a
usage rate, and checks that the note exists **before** any dream runs, that
the ship hook carried it to the user repo, and that settle keeps it as the
agent's own (`origin: note`) rather than re-filing it from the transcript.

Variables: `$U` = `${SLEEP_HOME:-$HOME/.ai-lab-sleep}/user`,
`$TX` = `${SLEEP_HOME:-$HOME/.ai-lab-sleep}/tx/ai-lab-sleep-project`.

## Setup
1. `git pull -q --ff-only` here and in `$U`; remove `$U/.dream-phase` if present. `grep -c 'write that assumption to memory' "$U/agents/noter.md"` → `1` (the tuned purpose line is what's under test).
2. Record `START=$(date -u +%Y-%m-%dT%H:%M:%SZ)` and `HEAD0=$(git -C "$U" rev-parse HEAD)`.
3. Baseline for the origin share: `grep -rl '^origin: note' "$U/agent-memory" --include='*.md' | grep -v _retired | wc -l` and the same for `^origin: transcript`; record both.
4. Confirm the question has no answer in the files: `grep -rniE 'sachet|stock|per month|shots a month' knowledge/` shows the sachet in `descaling.md` Procedure and no monthly shot count anywhere.

## Act
Spawn `noter` with exactly this prompt:

> How many descaler sachets should we keep in stock for the next six months? Answer from the knowledge files.

Done when the reply gives a number of sachets and names `knowledge/descaling.md`. Copy the reply verbatim. Then confirm the ship: `tail -5 "$SLEEP_HOME/ship.log"` shows a push after `$START`.

## Dream
1. `settle` — plain prompt.
2. `relate` — plain prompt.
3. `promote` — plain prompt.

Checks 1–3 are evaluated **before** the dream (right after the act); 4–7 after settle; 8 after promote.

## Checks
1. `git -C "$U" log --format=%s "$HEAD0"..HEAD | grep -c '^memory:'` → `≥ 1` (the SubagentStop ship committed memory written during the act).
2. `N=$(git -C "$U" diff --name-only --diff-filter=A "$HEAD0"..HEAD -- agent-memory/noter | grep -vE 'MEMORY\.md|dream-log|issues'); echo "$N" | grep -c .` → `1` (one new file under the noter's root, written by the noter itself; below, `N="$U/$N"`). If `0`: the noter answered without writing — the finding is about the purpose line, and the test fails here; do not run the dream to compensate.
3. `grep -ciE 'assum|rate|shots' "$N"` → `≥ 1`, and `grep -c 'sachet\|descal' "$N"` → `≥ 1` (the note is the usage assumption behind the sachet count, not a copy of the answer).
4. `git -C "$U" log -1 --format=%s` → starts with `dream(settle)`.
5. Settle may have split `$N` into one claim per note (the format prescribes it). Define `NOTES`: if `grep -q '^origin:' "$N"` succeeds, `NOTES="$N"`; otherwise `$N` is a stub and `NOTES` = every `[[notes/<slug>]]` link in it resolved to `$U/agent-memory/noter/notes/<slug>.md` (`grep -o '\[\[notes/[^]]*\]\]' "$N"`). `echo "$NOTES" | grep -c .` → `≥ 1`. For **every** file in `NOTES`: `grep -E '^origin:'` → `origin: note` (settle kept the agent's authorship; it did not re-file from the transcript), and `grep -E '^status:'` → `status: bet` or `status: confirmed`.
6. For every file in `NOTES`: `grep -cE 'transcripts/ai-lab-sleep-project/[0-9a-f-]+/subagents/agent-[0-9a-f]+\.jsonl#[0-9a-f-]{36}'` → `≥ 1` (settle added the locator of the turn where the assumption was stated), and `python3 "$U/scripts/bet-dossier.py" <file> | grep -c 'Could not resolve'` → `0`.
7. For every file in `NOTES`: `tail -80 "$U/agent-memory/_user/dream-log.md" | grep -c "$(basename <file> .md)"` → `≥ 1`.
8. After promote: `git -C "$U" log -3 --format=%s` contains `dream(relate)` and `dream(promote)`; for at least one file in `NOTES`: `grep -c "$(basename <file> .md)" "$U/agent-memory/noter/MEMORY.md"` → `≥ 1`. Then recompute the two counts from setup 3 and write all four numbers in the result (origin share before/after: this test's purpose is to move it).

## Teardown
Leave everything. Make sure `$U/.dream-phase` does not exist.
