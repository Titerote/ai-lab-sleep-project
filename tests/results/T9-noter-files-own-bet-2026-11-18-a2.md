# T9-noter-files-own-bet — passed — 2026-11-17 (attempt 2; file named per runner prompt)
inputs: project 0bf559c, user 9190128, dreamer models: settle sonnet relate opus promote sonnet
loops used: 0/3
baseline: HEAD0=860c5ca (from attempt 1); act commit 5360987 (session 4c10eb5f, noter subagent agent-a2aff49efddb920e2)

## Steps

### Setup
- `git pull -q --ff-only` in both repos; HEADs above. `.dream-phase` absent.
- Setup 1: `grep -c 'write that assumption to memory' "$U/agents/noter.md"` → `1`.
- Setup 2–4: per the runner prompt, not redone; HEAD0=860c5ca is attempt 1's. Setup 3's baseline
  was recomputed from git at HEAD0 (`git grep -l '^origin: <o>' 860c5ca -- 'agent-memory/*.md' | grep -v _retired | wc -l`):
  origin note **5**, origin transcript **2**.
- Note: the user repo between HEAD0 and this run also has attempt 1's settle commit (ccfa2c4, reverted 6338c26 and
  reapplied 4659114) and attempt 1's settle fix with its revert (f1433e1/759d891, net zero). So this attempt's settle ran on
  memory already split by attempt 1's settle.

### Act (attempt 1, not rerun)
Prompt: `How many descaler sachets should we keep in stock for the next six months? Answer from the knowledge files.`
Reply verbatim (the noter's SubagentHandback in `tx/ai-lab-sleep-project/4c10eb5f-…/subagents/agent-a2aff49efddb920e2.jsonl`):

> Keep 5 sachets in stock for the next six months. The knowledge files don't give a usage rate, so that number rests on my assumptions.
>
> **What the files settle**
> - Descale every 150 shots, filtered or not (`knowledge/descaling.md`, "Schedule"; `knowledge/water.md`, "Effect on descaling").
> - Use one sachet per descale (`knowledge/descaling.md`, "Procedure"). The file says only "citric". My memory says the product is "citric2" sachets.
> - A shot is an 18 g dose (`knowledge/grinder.md`, "Settings").
>
> **What the files don't settle**
> - Shots per day or per month. I used the roughly 2 kg of beans a month from my memory, which is not in `knowledge/`.
>
> **Calculation**
> - 2 kg a month is about 111 shots a month (2000 g ÷ 18 g).
> - Six months is about 666 shots, and 666 ÷ 150 is about 4.4.
> - That gives 4 descales that fall due, so I rounded up to 5. I don't know how many shots have run since the last descale. A fifth sachet covers that.
>
> **Caveats**
> - If the household pulls two doubles a day (4 shots), that is about 730 shots in six months. You would still need 5 descales, so stock 5 or 6.
> - Schedule counts by the machine counter, which resets when you hold the brew button. You count from the last descale, so apply that baseline.
> - Tell me your real shots per day or the shots since the last descale and I'll recompute.
>
> I saved these assumptions to memory before answering: `/Users/tite/.claude/agent-memory/noter/notes/sachet-stock-six-months-assumptions.md`.

Tool order in the transcript: Read ×4 knowledge/memory → **Write** note → Edit MEMORY.md → handback. So the note was written before the answer.
Ship: `ship.log` line 212: `2026-11-17T22:56:29Z ai-lab-sleep-project/4c10eb5f-… SubagentStop: pushed memory` → commit 5360987.

### Dream 1 — settle
`.dream-phase`=settle → `dreamer-settle`, "Run the settle phase." → `.dream-phase` removed.
Reported (summary): no new assumptions. The sachet-stock assumptions were already captured by attempt 1's settle: `noter/notes/sachet-demand-six-months` and
`noter/notes/last-descale-shot-count-unknown`, with the rate inputs in `_user`. "The format prescribes the split, so the stub at
`noter/notes/sachet-stock-six-months-assumptions` stands." Renamed the burr note `burr-40kg-figure-may-be-stale` → `burr-40kg-figure-current` (stub left).
Regenerated dossiers for 5 open bets. Raised an issue about the missing locator for the burr ruling. Counts: origin note 8, transcript 2, filed 1.
Reported files: 12. Commit 63373fe `dream(settle): rename burr note, refresh dossiers, consume T9 runner files`, 12 files: **match**.

### Dream 2 — relate
`.dream-phase`=relate → `dreamer-relate`, "Run the relate phase." → removed.
Reported: new `noter/wiki/sachet-stock.md` linking both noter bets, the `_user` rate notes and shot counting. Updated `_main` wiki/descaling (Schedule 150
now committed on 0bf559c; Stock line), repointed wiki/grinder-burr-life to the renamed burr note, cross-linked from `_user` wiki/coffee-consumption.
Raised an issue that the `_main` MEMORY cadence line still says "uncommitted". Reported files: 8.
Commit 24c77fa `dream(relate): sachet-stock page, descaling Schedule now on main, burr link repointed`, 8 files: **match**.

### Dream 3 — promote
`.dream-phase`=promote → `dreamer-promote`, "Run the promote phase." → removed.
Reported: `_main` MEMORY cadence line no longer says "uncommitted", and the burr links point to the new slug. The noter MEMORY lists both sachet bets and wiki/sachet-stock in place of the stub
link. Updated proposal `descaling-schedule-150.md`; ticked the `_main` issues.md entry, which the agent itself flagged as outside promote's scope.
Reported files: 6. Commit 2a9db36 `dream(promote): refresh main and noter indexes, update cadence proposal`, 6 files: **match**.

## Checks
Run with `bash -c` / `bash script`. U=~/.ai-lab-sleep/user, HEAD0=860c5ca, ACT=5360987.
Checks 1–3 apply "before the dream". In this attempt HEAD already contains attempt 1's settle, so they were evaluated at the act commit (HEAD→ACT).
The as-written outputs at current HEAD are quoted for transparency.

1. `git -C "$U" log --format=%s "$HEAD0"..ACT | grep -c '^memory:'` → expected ≥1; actual `1` (also `1` as written at HEAD) — **pass**
2. `… diff --name-only --diff-filter=A "$HEAD0"..ACT -- agent-memory/noter | grep -vE 'MEMORY\.md|dream-log|issues'` → expected `1`; actual `1`
   (`agent-memory/noter/notes/sachet-stock-six-months-assumptions.md`). As written at HEAD: `3` (adds settle's split notes
   `last-descale-shot-count-unknown.md`, `sachet-demand-six-months.md`, which is post-dream state) — **pass** (pre-dream)
3. On $N at ACT (`git show 5360987:…/sachet-stock-six-months-assumptions.md`): `grep -ciE 'assum|rate|shots'` → expected ≥1, actual `9`;
   `grep -c 'sachet\|descal'` → expected ≥1, actual `6` — **pass**. (The current stub gives `1` / `1`.)
4. `git -C "$U" log -1 --format=%s` (after settle) → expected starts `dream(settle)`; actual `dream(settle): rename burr note, refresh dossiers, consume T9 runner files` — **pass**
5. $N has no `^origin:` (stub) → NOTES = `noter/notes/sachet-demand-six-months.md`, `noter/notes/last-descale-shot-count-unknown.md`; count expected ≥1, actual `2`.
   origin: expected `origin: note`, actual `origin: note` / `origin: note`; status: expected bet|confirmed, actual `status: bet` / `status: bet` — **pass**
6. locator grep `transcripts/ai-lab-sleep-project/…/subagents/agent-….jsonl#<uuid>` → expected ≥1; actual `1` / `1`.
   `bet-dossier.py <file> | grep -c 'Could not resolve'` → expected `0`; actual `0` / `0` — **pass**
7. `tail -80 "$U/agent-memory/_user/dream-log.md" | grep -c <basename>` → expected ≥1; actual `4` (sachet-demand-six-months) / `4` (last-descale-shot-count-unknown) — **pass**
8. `git -C "$U" log -3 --format=%s` → expected contains dream(relate) and dream(promote); actual
   `dream(promote): refresh main and noter indexes, update cadence proposal` / `dream(relate): sachet-stock page, …` / `dream(settle): rename burr note, …`.
   `grep -c <basename> "$U/agent-memory/noter/MEMORY.md"` → expected ≥1 for at least one; actual `1` (sachet-demand-six-months), `1` (last-descale-shot-count-unknown) — **pass**
   Origin share (non-retired notes under agent-memory): before (HEAD0) note **5** / transcript **2**; after (2a9db36) note **7** / transcript **2**.

## Fixes
none

## Diagnosis
All checks passed first time in this attempt (attempt 1 aborted on defective checks 5–7, since fixed in 0bf559c). The tuned noter purpose line works:
the noter wrote its usage-rate assumption to its own root before answering, the SubagentStop ship committed it (5360987), and settle split it into one claim per note
(prescribed by the format). Both resulting notes keep `origin: note` / `status: bet`, carry a `#uuid` locator into the noter's subagent transcript, and are
logged and indexed. Origin share moved from 5:2 to 7:2 (note:transcript).

Side findings (not checks):
- **Scope guard gap:** promote edited `_main/…/issues.md` (ticked a box) although `scripts/scope-guard.sh` only allows promote to write MEMORY.md, dream-log.md and proposals/.
  The write was not blocked, which suggests a path the guard doesn't cover, for example a Bash edit. The agent flagged it itself. Not reverted.
- Attempt 1 left its settle commit in history (reverted and then reapplied). This attempt's settle therefore found the split already done and did only incidental work
  (burr note rename, dossier refresh).
- **Knowledge fixture changed by a tests commit:** relate and promote are right that "Schedule" says 150 on main. Project commit 0bf559c
  (`tests(T9): checks follow a split…`) also committed `knowledge/descaling.md` (200→150 in "Schedule", plus a "2026-11-17 … user decision" Changes entry).
  That was the uncommitted user edit that memory had been tracking. It removes the deliberate superseded fact that CLAUDE.md/TESTS.md say not to fix, so later tests
  that rely on the 200-vs-150 contradiction will no longer find it. The dreamers handled it correctly. Not touched here (knowledge/ is out of scope).
