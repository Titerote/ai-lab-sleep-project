# T8-cloud-outbox — passed — 2026-11-17
inputs: project 8dc74fd56b3f8dc7a5df518eb793894b2cc96f57, user 7efb2129745ffc5c24ab1b8f13abe8aca41e6cee, dreamer models: settle sonnet relate opus promote sonnet
loops used: 2/2

## Steps
### Setup (2026-11-17T22:07:02Z)
- pulled both repos; `.dream-phase` absent. START=2026-11-17T22:07:02Z, HEAD0=7efb212.
- `ls -d "$TX"/*/memory-outbox` → `…/3da63ac1-6df7-56bc-bc4c-753f33e461b2/memory-outbox` (only one). OB = that (manifest last_shipped 2026-11-17T22:02:52+00:00, last_event SubagentStop).
- `find "$OB" -type f` →
  - `agent-memory/noter/MEMORY.md`
  - `agent-memory/noter/notes/descaler-storage-left-drawer.md`
- `grep -rli drawer "$OB" | wc -l` → `2` (≥1 ✓)
- manifest `claude_code_remote` → `true` ✓ (the value is the string "true", not a JSON boolean; it prints the same)
- Note: the cloud noter wrote its own frontmatter `status: user-stated` / `origin: user`, which breaks MEMORY-FORMAT ("Writers never set status or origin"). See Diagnosis.

### Act
None; the act was the cloud session 3da63ac1.

### Loop 0 — settle (first run)
Reply (verbatim):
> Settle pass done and pushed to main. I made no new bet notes: none of the new transcripts held an agent assumption. All three open bets stay open.
>
> **New files read**
> - Session 3d798663, three subagent files (a088de89, abbf48af, ae2b280c). These are the settle, promote and relate runs, so they hold no bets.
> - Session 3da63ac1: main.jsonl, subagent a37debc1, and its memory-outbox.
> - Session 4dad6406: main.jsonl (the T8 test prompt) and subagent a0d50150 (this settle run).
> - All are now in `consumed`. The outbox is in `outboxes_consumed`. `project_main` is 8dc74fd.
>
> **Outbox (step 0)**
> - I copied `noter/MEMORY.md` and `noter/notes/descaler-storage-left-drawer.md` into `agent-memory/`.
> - There was no conflict. The repo's `noter/MEMORY.md` had not changed since the session's `last_shipped`, and the outbox copy only adds one line.
>
> **User fact**
> - The user said the citric sachets are kept in the left kitchen drawer (3da63ac1 main#9cefa58f).
> - I filed it as `_user/notes/descaler-storage-left-drawer.md`, status confirmed, origin filed. It is a record of what the user said, not a settled bet.
> - I moved it out of the noter root and left a stub at the old path.
> - The project's `knowledge/` does not state it.
>
> **Sweep** — no note visible/contradicted; dossiers regenerated for burr-brush-due-unknown, two-double-shots-a-day, group-head-gasket-yearly (all left open); added a line to `_main` issues.md; burr-40kg rename issue left open.
>
> **Dream-logs** — appended to `_user`, noter and `_main`.
>
> **Files in the commit**: _main dream-log.md, _main issues.md, _main notes/burr-brush-due-unknown.md, _user dream-log.md, _user notes/descaler-storage-left-drawer.md, _user notes/two-double-shots-a-day.md, noter MEMORY.md, noter dream-log.md, noter notes/descaler-storage-left-drawer.md, noter notes/group-head-gasket-yearly.md, dream-state.json

(Sweep and dream-log sections condensed; the rest is verbatim.)
Commit 8deb2b7 `dream(settle): apply noter cloud outbox, file descaler drawer note, refresh bet dossiers`: 11 files; they match the report exactly.
Checks after it: C1 ✓, C2 ✓, C3 ✓, **C4 ✗ (`origin: filed`)**, **C5 ✗ (`False`; outbox under `outboxes_consumed`)**.

### Loop 1 — settle rerun after prompt fixes 9ba6388, d147d8d (state reset by revert 28e7b16)
Reply (summary of the verbatim report): the same as loop 0. "All of these are now in `consumed`, the outbox is in `outboxes_consumed`"; the drawer note was "filed … as `confirmed`, `origin: filed`" and moved to `_user/`. Commit a7063e3: 10 files, which match the report. C4 ✗ `origin: filed`, C5 ✗ `False`. The behaviour is identical, so this session's subagent still ran the pre-fix `agents/dreamer-settle.md` (the definition loads at session start; T6 finding).
Relate (f5db4a1, 3 files, match) and promote (483a525, 5 files, match) were then run. C6 passed (count 1). All three dream commits were then reverted in 39488b6 so the outbox was unconsumed again.

### Loop 2 — settle after fix c859b7c (same rules in runtime-read MEMORY-FORMAT.md)
Reply (verbatim):
> Settle pass done and pushed to main as f34ea54.
>
> **Outbox (session 3da63ac1).** The noter wrote its note in a cloud session and it was applied.
> - noter/MEMORY.md was copied over. The repo copy was unchanged since the session shipped, so there was no conflict.
> - The descaler note (sachets kept in the left kitchen drawer) was set to origin: note, replacing the writer's user-stated/user values.
> - User turn 9cefa58f-8d66-4162-aecb-a4c8efbcadb7 states the same claim, so I marked the note confirmed. Origin stays note; it is not filed.
> - I moved it to `/Users/tite/.ai-lab-sleep/user/agent-memory/_user/notes/descaler-storage-left-drawer.md`, since it is a household fact, and left a stub in noter/notes. Nothing in knowledge/ mentions the drawer.
> - The outbox directory is recorded in `consumed`, and the obsolete `outboxes_consumed` key is removed.
>
> **New transcript files read.** All were added to `consumed`.
> - 3da63ac1: `main.jsonl` and `subagents/agent-a37debc1948eab408.jsonl`.
> - 3d798663: three subagent runs, which are earlier dream phases.
> - 4dad6406: `main.jsonl`, which is the T8 runner, and four subagent runs, which are earlier dream phases.
> - These earlier dream-phase runs and the T8 runner contain no agent assumptions and no user facts.
>
> **Per-assumption list.** The agents stated no assumptions in the new files. The only user fact is the drawer location, captured by the outbox note above.
>
> **Ledger** — 9 rows; drawer note `confirmed`, "yes (moved from noter)", created; three bets left open with dossiers regenerated. Live notes by origin: note 5, transcript 2, filed 1.
>
> `git show --stat HEAD` lists: _main dream-log.md, _main notes/burr-brush-due-unknown.md, _user dream-log.md, _user notes/descaler-storage-left-drawer.md, _user notes/two-double-shots-a-day.md, noter MEMORY.md, noter dream-log.md, noter notes/descaler-storage-left-drawer.md, noter notes/group-head-gasket-yearly.md, dream-state.json

Commit f34ea54: 10 files, which match the report.

### relate (after loop 2)
Reply (summary of the verbatim report): wiki/descaling's product line became "Sachets", resting on `[[notes/descaler-product]]` and `[[_user/notes/descaler-storage-left-drawer]]`; a new issue was raised that descaler-product's body says "Steps" where the section is "Procedure"; all links resolve; no new pages. Files: _main wiki/descaling.md, issues.md, dream-log.md.
Commit 93d2752: 3 files, which match the report.

### promote (after loop 2)
Reply (summary of the verbatim report): the drawer rule went into `_user/MEMORY.md` and was mirrored into the noter and _main indexes with links back (it replaced the noter's local line); the citric2 proposal "Steps" was fixed to "Procedure"; the checker index was unchanged. "pushed … in two commits, 34751cc and 1a655e2. The first commit's message says it fixed the proposal heading, but that part failed (a BSD `sed` error), so 1a655e2 made the fix." It lists 8 files.
Commits 34751cc (7 files) + 1a655e2 (1 file) = the 8 files reported. They match.

### Ship
`tail -3 ~/.ai-lab-sleep/ship.log` after the last subagent:
```
2026-11-17T22:17:26Z ai-lab-sleep-project/4dad6406-… SubagentStop: pushed transcripts → sleep/transcripts
2026-11-17T22:17:28Z ai-lab-sleep-project/4dad6406-… Stop: committed, push debounced
2026-11-17T22:18:06Z ai-lab-sleep-project/4dad6406-… SubagentStop: pushed transcripts → sleep/transcripts
```

## Checks
(final state, after loop 2; loop-0 actual in brackets where it differed)
1. `git -C "$U" log -1 --format=%s` (after settle) → starts with `dream(settle)` — actual `dream(settle): apply noter cloud outbox (origin note kept), confirm descaler drawer note, refresh dossiers` — **pass**
2. `test -f "$U/agent-memory/noter/MEMORY.md" && echo yes` → `yes` — actual `yes`; `test -f "$U/agent-memory/noter/notes/descaler-storage-left-drawer.md" && echo yes` → `yes` — actual `yes` — **pass**
3. `grep -rli 'drawer' "$U/agent-memory" --include='*.md' | grep -vE 'dream-log|issues|MEMORY\.md|wiki/' | wc -l` → ≥1 — actual `2` (`_user/notes/descaler-storage-left-drawer.md`, plus the noter stub). `grep -cE '^(status|origin):' $U/agent-memory/_user/notes/descaler-storage-left-drawer.md` → `2` — actual `2` — **pass**
4. `grep -E '^origin:' $U/agent-memory/_user/notes/descaler-storage-left-drawer.md` → `origin: note` — actual `origin: note` [loop 0 and loop 1: `origin: filed`] — **pass**
5. `python3 -c "…any('memory-outbox' in x for x in d.get('consumed',[]))"` → `True` — actual `True` [loop 0 and loop 1: `False`]; `tail -60 "$U/agent-memory/_user/dream-log.md" | grep -ci 'outbox'` → ≥1 — actual `5` — **pass**
6. `git -C "$U" log -3 --format=%s` contains dream(relate) and dream(promote) — actual `dream(promote): proposal section name Steps -> Procedure` / `dream(promote): drawer rule to indexes, fix Procedure heading in proposal` / `dream(relate): descaler storage joins wiki/descaling; raise descaler-product section name`; `grep -c "descaler-storage-left-drawer" noter/MEMORY.md _main/…/MEMORY.md | awk sum` → ≥1 — actual `2` — **pass**

## Fixes
- 9ba6388 — user `agents/dreamer-settle.md` Step 0: applied outbox notes are `origin: note`, writer-set status/origin values are replaced, a matching user turn confirms rather than re-files — check 4 (does not reach subagents of the session that made it)
- d147d8d — user `agents/dreamer-settle.md` End: an outbox goes into `consumed` as `tx/<slug>/<session>/memory-outbox`, never under another key — check 5 (same caveat)
- 28e7b16 — user repo: `git revert` of settle 8deb2b7 so the outbox counts as unconsumed for the rerun (a state reset, not a note edit) — checks 4, 5
- 39488b6 — user repo: `git revert` of loop-1 dream commits a7063e3 f5db4a1 483a525, for the same reason — checks 4, 5
- c859b7c — user `MEMORY-FORMAT.md` "Outbox rules (settle, Step 0)": the same two rules in the file settle reads at runtime — checks 4, 5 (this is the fix that took effect)

## Diagnosis
The outbox transport works end to end: the cloud VM shipped `memory-outbox/` at SubagentStop with `claude_code_remote: true`, and settle applied both files at the same paths with no conflict. Two checks failed at first, and both were faults in the settle **dreamer prompt**, not in the test, the hooks or ship.sh.
- **C4**: Step 0 said applied files are "notes like any other" but did not say they are agent-written. The cloud noter had also (against MEMORY-FORMAT) written `status: user-stated` / `origin: user` itself. Settle treated the user's turn as "a fact with no prior bet" and re-filed the note as `origin: filed`.
- **C5**: the End step said `consumed` holds "every transcript file and outbox" but gave no form for the outbox. dream-state.json already had an empty `outboxes_consumed: []` key (since c36c98a), and settle used that.

The fixes in `agents/dreamer-settle.md` did not reach this session's subagents. The loop-1 rerun was identical, which confirms the T6 finding. The same rules in runtime-read `MEMORY-FORMAT.md` (c859b7c) did reach them, and loop 2 passed all 6 checks.

Side findings (not failures):
- The noter writes `status`/`origin` frontmatter itself. This is an agent-under-test issue; it was not fixed here because the act is the cloud half and cannot be rerun from this session.
- Promote made two commits, and the first one's message claims a fix that had failed (BSD sed).
- Settle consumed its own running transcripts again.
