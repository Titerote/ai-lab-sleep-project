# T7 — settle splits a multi-claim topic file into one note per claim, and settles each
loops: 3

Auto memory writes topic files in whatever shape it likes; MEMORY-FORMAT.md
says settle splits a file holding several claims into `notes/<slug>.md`, one
claim each, leaves a link in its place, and settles each note on its own.
Never exercised. This test seeds such a file (the fixture stands for what
auto memory would have written; a note without frontmatter is a `bet` of
`origin: note` by definition) with three claims that must end three
different ways: one is now visible in the project (→ retired), one is about
the person (→ `_user/notes/`), one is an open bet with no evidence (→ stays
a bet, dossier, `## Open`, issue).

Variables: `$U` = `${SLEEP_HOME:-$HOME/.ai-lab-sleep}/user`.

## Setup
1. `git pull -q --ff-only` here and in `$U`; remove `$U/.dream-phase` if present.
2. Record `START=$(date -u +%Y-%m-%dT%H:%M:%SZ)` and `HEAD0=$(git -C "$U" rev-parse HEAD)`.
3. Confirm the fixture's facts against the project: `grep -n '150' knowledge/water.md knowledge/descaling.md` shows 150 in both (the first claim is visible); `grep -ril 'gasket' knowledge/ | wc -l` → `0` (the second is not); `grep -ril 'double' knowledge/ | wc -l` → `0` (the third is not).
4. Write the fixture, exactly this content, to `$U/agent-memory/noter/maintenance.md` (no frontmatter):

```
# Maintenance notes

- Descale every 150 shots; the user corrected the old 200 figure.
- The group head gasket is replaced once a year. Nothing in knowledge/ says so; I assumed the usual interval.
- The user drinks two double shots a day.
```

5. Commit it as auto memory would have been committed by the ship hook: `git -C "$U" add agent-memory/noter/maintenance.md && git -C "$U" -c user.name=lab -c user.email=lab@example.invalid commit -qm "memory: noter maintenance notes (T7 fixture)" && git -C "$U" push -q origin main`. Record the commit sha.

## Act
None. The fixture is the input; no agent is exercised before the dream.

## Dream
1. `settle` — plain prompt.
2. `relate` — plain prompt.
3. `promote` — plain prompt.

Checks 1–8 are evaluated after settle; 9 after promote.

## Checks
1. `git -C "$U" log -1 --format=%s` → starts with `dream(settle)`.
2. `wc -l < "$U/agent-memory/noter/maintenance.md"` → `≤ 6`, and `grep -c '\[\[' "$U/agent-memory/noter/maintenance.md"` → `≥ 3` (the file is now a link stub pointing at the split notes, not the claims themselves), and `grep -ci 'gasket' "$U/agent-memory/noter/maintenance.md"` → `≤ 1` (a link name may mention it; the claim text is gone).
3. `A=$(git -C "$U" diff --name-only --diff-filter=A "$HEAD0"..HEAD -- agent-memory | grep -E '/notes/' ); echo "$A" | grep -c .` → `3` (exactly three new note files; `$A` lists them).
4. `R=$(echo "$A" | grep '_retired/'); echo "$R" | grep -c .` → `1`, and `grep -E '^status:' "$U/$R"` → `status: retired`, and `grep -cE '^\s*-\s*knowledge/[a-z]+\.md(#[a-z0-9-]+|:[0-9]+)' "$U/$R"` → `≥ 1` (retired on a project section or line as evidence), and `grep -qi 'descale' "$U/$R"` succeeds.
5. `P=$(echo "$A" | grep '^agent-memory/_user/notes/'); echo "$P" | grep -c .` → `1`, and `grep -qi 'double' "$U/$P"` succeeds (the person fact went to the person's root).
6. `B=$(echo "$A" | grep '^agent-memory/noter/notes/' | grep -v _retired); echo "$B" | grep -c .` → `1`, and `grep -E '^status:' "$U/$B"` → `status: bet`, and `grep -c '^## Open' "$U/$B"` → `1`, and `grep -c '^## Dossier' "$U/$B"` → `1`, and `grep -qi gasket "$U/$B"` succeeds.
7. `for f in $A; do grep -E '^origin:' "$U/$f"; done | sort | uniq -c` → one line, `3 origin: note` (the agent wrote these; settle did not relabel them as transcript or filed).
8. `grep -c "$(basename "$B" .md)" "$U/agent-memory/noter/issues.md"` → `≥ 1` (the open bet was raised to the human), and `tail -60 "$U/agent-memory/_user/dream-log.md" | grep -c -e "$(basename "$R" .md)" -e "$(basename "$P" .md)" -e "$(basename "$B" .md)"` → `≥ 3` (all three in the ledger).
9. After promote: `git -C "$U" log -3 --format=%s` → contains `dream(relate)` and `dream(promote)`, and `grep -c "$(basename "$B" .md)" "$U/agent-memory/noter/MEMORY.md"` → `≥ 1`.

## Teardown
Leave everything. The fixture commit and the split notes are real lab data
from now on. Make sure `$U/.dream-phase` does not exist.
