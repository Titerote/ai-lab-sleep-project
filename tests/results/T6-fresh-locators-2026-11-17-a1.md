# T6-fresh-locators — passed — 2026-11-17
inputs: project ca72f5a9fe235052726c2a6ec68c15e0bd4acaa0, user cd6e478e30126615060e83ba79ec4c840fd000a9, dreamer models: settle sonnet relate opus promote sonnet
loops used: 0/3

START=2026-11-17T14:00:58Z
HEAD0=cd6e478e30126615060e83ba79ec4c840fd000a9
session: 3de1b0b0-6482-42ca-bc53-8b27366896ab, claude 2.1.326 (attempt 1 of the outer loop; first run in a fresh session after the consolidated fixes a89dc58/b2c03a5/38655a3)

## Steps

### Setup
- Both pulls were clean. `git -C "$U" status --porcelain` was empty and there was no `.dream-phase`.
- `grep -n -i 'brush' knowledge/grinder.md` → `11:Brush the burrs every 2 kg of coffee.` No last-brush date is recorded.
- Baseline `ls "$TX"/*/subagents/ | grep -c '\.jsonl$'` → `18`.
- Previous result read: `T6-fresh-locators-2026-11-17.md` (failed 3/3). Its fixes were consolidated afterwards into the settle prompt (a89dc58), the format doc and dossier (b2c03a5) and noter Write/Edit (38655a3). None were repeated here.

### Act: noter
Prompt: "When are the burrs next due for a brush? Answer from the knowledge files, and state any assumption you have to make to answer."

Reply (verbatim):
```
The knowledge files give an interval but no due date: brush the burrs every 2 kg of coffee. That comes from `/Users/tite/Code/ai-lab-sleep-project/knowledge/grinder.md`, section "Cleaning". Nothing in `knowledge/` records when the burrs were last brushed or how much coffee has gone through since, so I can't name a calendar date.

Assumptions I had to make:
1. **Usage rate.** The user has said the household uses about 2 kg of beans a month. That is from my user-level memory (`/Users/tite/.claude/agent-memory/_user/MEMORY.md`), not from `knowledge/`. At that rate, 2 kg of coffee comes round about once a month, so the burrs would be due for a brush roughly monthly.
2. **Last brush.** The date is unknown. The next brush is due once about 2 kg has passed since the last one. If that was about a month ago, the burrs are due now or very soon. Please check or confirm the date.
3. **Burr-life figure.** `grinder.md` ("Burr life") says the set was installed 2025-03 and "has seen about 40 kg", but that figure has no date. I did not use it to estimate when the last brush was. At 2 kg a month, 40 kg would be about 20 months, which is roughly where we are now (2026-11), but I can't settle whether the figure is current or stale.

The monthly pellet run in the same section ("Run 20 g of grinder-cleaning pellets monthly, then purge 10 g of beans") is a separate task from brushing.
```
Done criteria met: the reply names `knowledge/grinder.md`, has an "Assumptions" list and contains "If that was about a month ago". The noter wrote no note (the user repo stayed clean), so the bet reached memory through settle's transcript recovery.
Ship: `2026-11-17T14:01:07Z … SubagentStop: pushed transcripts → sleep/transcripts` and `14:01:17Z … SubagentStop: pushed`, both after START. The subagent `.jsonl` count went 18 → **19** (+1). **OK.**

### Dream: settle
Reply (verbatim excerpt; the full report is summarised): "Settle pass (ninth) is committed and pushed to main. It produced one new open bet and left the other notes unchanged. … `3de1b0b0/subagents/agent-a00c7590dcd266397.jsonl`: the noter's burr-brushing answer, which stated three assumptions. … (handback record `5aee0090`): 1. … already captured by `_user/notes/beans-2kg-per-month`. 2. The last brush date is unknown … No note captured this, so I created `_main/ai-lab-sleep-project/notes/burr-brush-due-unknown.md`. It has `origin: transcript` and `status: bet`. 3. … already captured by `burr-40kg-figure-may-be-stale` … Files in the commit: `_main/ai-lab-sleep-project/dream-log.md`, `_main/ai-lab-sleep-project/issues.md`, `_main/ai-lab-sleep-project/notes/burr-brush-due-unknown.md`, `_user/dream-log.md`, `dream-state.json`."
Commit 38d1f55 `dream(settle): ninth pass, burr brush due bet`: the same 5 files. **Match.**
Side finding: settle listed its own still-running transcript (`agent-a39fe2880d6a0b2db.jsonl`) as read and consumed, so that file was partial when it was marked consumed. It is harmless here, because a settle run holds no bets, but a later pass will never see the rest of that file.
Ship: SubagentStop push at 14:02:38Z.

### Dream: relate
Reply (summary): it rewrote `wiki/descaling.md` and `wiki/grinder-burr-life.md`; the grinder page now carries the new open bet `notes/burr-brush-due-unknown`. It found no contradictions and raised two issues (stale index lines, and the `burr-40kg-figure-may-be-stale` slug no longer matching its content). Files: `wiki/descaling.md`, `wiki/grinder-burr-life.md`, `issues.md`, `dream-log.md` (all under `_main/ai-lab-sleep-project/`).
Commit cf56537 `dream(relate): …`: the same 4 files. **Match.**
Ship: SubagentStop push at 14:03:52Z.

### Dream: promote
Reply (summary): it rewrote the `_main/ai-lab-sleep-project`, `noter`, `checker` and `_user` `MEMORY.md` files; the project index lists "Burr brush due unknown — open bet". It appended `dream(promote)` entries to 4 dream logs, deleted 2 rule-lane proposals and added 2 knowledge-lane proposals (`descaling-schedule-150.md`, `descaler-product-citric2.md`). It listed 12 files.
Commit cf180e7 `dream(promote): …`: the same 12 files (4 MEMORY.md, 4 dream-log.md, 2 added, 2 deleted). **Match.**
Ship: SubagentStop push at 14:04:32Z.

### Teardown
`.dream-phase` is absent (`ls: … No such file or directory`). The note, logs and transcripts are left in place.

## Checks
1. `git -C "$U" log -1 --format=%s` (after settle) → expected starts with `dream(settle)`; actual `dream(settle): ninth pass, burr brush due bet` — **pass**
2. `N=…; echo "$N" | grep -c .` → expected `1` and brush; actual `1` (`agent-memory/_main/ai-lab-sleep-project/notes/burr-brush-due-unknown.md`), `grep -qi brush` succeeded — **pass**
3. `grep -E '^origin:' "$N"` → expected `origin: note|transcript`; actual `origin: transcript` — **pass**
4. `grep -cE 'transcripts/ai-lab-sleep-project/…\.jsonl#[0-9a-f-]{36}' "$N"` → expected ≥ 1; actual `1` (`…/3de1b0b0-…/subagents/agent-a00c7590dcd266397.jsonl#5aee0090-305d-4a45-8acf-c4ffe28e95f8`) — **pass**
5. `bet-dossier.py "$N" | grep -c 'Could not resolve'` → expected `0`; actual `0`. `… | grep -c 'found by uuid'` → expected ≥ 1; actual `1` — **pass**
6. `awk '/^## .*settle/{e=$0} END{print e}' …/_user/dream-log.md` → expected a run after START; actual `## 2026-11-17 settle (ninth pass)` (committed 14:02:23Z > 14:00:58Z). `tail -40 … | grep -c burr-brush-due-unknown` → expected ≥ 1; actual `2` — **pass**
7. `git -C "$U" log -3 --format=%s` → expected contains `dream(relate)` and `dream(promote)`; actual `dream(promote): refresh indexes, mirror user rules, move fact proposals to knowledge lane` / `dream(relate): rewrite descaling and grinder wiki pages, repoint links, raise index issues` / `dream(settle): ninth pass, burr brush due bet` — **pass**
8. `grep -rl burr-brush-due-unknown …/noter/MEMORY.md …/_main/ai-lab-sleep-project/MEMORY.md | wc -l` → expected ≥ 1; actual `1` — **pass**

## Fixes
None in this run. The fixes from the previous attempt (a22c6b8, 4337589, fddac60, consolidated in a89dc58, b2c03a5 and 38655a3) took effect, because this is a fresh session that loaded the updated agent definitions.

## Diagnosis
All checks passed first time. This confirms the previous diagnosis: the failure was in the settle dreamer, and agent-definition fixes need a new session to load. In this session settle read the noter's subagent transcript and its SubagentHandback record. It matched the assumptions by claim rather than topic, so it kept the 2 kg/month and 40 kg assumptions as already covered and filed the unrecorded last-brush date as a new bet with a `#uuid` locator, which the dossier resolves.
Non-blocking findings:
- Settle marks its own in-progress subagent transcript as consumed.
- The noter cited its user memory as `/Users/tite/.claude/agent-memory/_user/MEMORY.md`, not the `$SLEEP_HOME/user` path (likely a symlink; not checked).
- The noter has Write now but still did not file the bet itself, so `origin: transcript` is still the only path exercised.
