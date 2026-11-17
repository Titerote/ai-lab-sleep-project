# T6-fresh-locators — failed — 2026-11-17
inputs: project ce9776bd0be1e6c97d18bf56b934db8b57951642, user 6cdc47069e8d9236df5c6690a3add1f35deabc42, dreamer models: settle sonnet relate opus promote sonnet
loops used: 3/3

START=2026-11-17T13:36:55Z
HEAD0=6cdc47069e8d9236df5c6690a3add1f35deabc42
session: 652b2c70-9887-4090-9002-6f99cf78248a, claude 2.1.326

## Steps

### Setup
- Both pulls clean. `git -C "$U" status --porcelain` → `?? scripts/__pycache__/` (untracked bytecode left by an earlier `bet-dossier.py` run; not in the test's allowed list, harmless, left in place). There was no `.dream-phase`.
- `grep -n -i 'brush' knowledge/grinder.md` → `11:Brush the burrs every 2 kg of coffee.` There is no date of the last brushing.
- Baseline `ls "$TX"/*/subagents/ | grep -c agent-` → `41`.

### Act: noter
Prompt: "When are the burrs next due for a brush? Answer from the knowledge files, and state any assumption you have to make to answer."

Reply (verbatim):
```
I can't give a calendar date, because nothing in the files records when the burrs were last brushed. The interval is 2 kg of coffee, which works out to about once a month.

**What the knowledge says**
- `/Users/tite/Code/ai-lab-sleep-project/knowledge/grinder.md`, section "Cleaning": "Brush the burrs every 2 kg of coffee."
- The same section says to run 20 g of cleaning pellets monthly and then purge 10 g of beans. That is a separate task from brushing.
- Section "Burr life" says the current set was installed 2025-03 and "has seen about 40 kg". That figure is undated.

**Assumptions**
1. **Usage rate.** The knowledge files give no usage rate, so I can't convert 2 kg into a time. I used the user's own figure of about 2 kg of beans a month, from my memory notes (`wiki/grinder-burr-life.md`). On that rate, brushing falls due about once a month.
2. **Last brush.** The files don't say when the burrs were last brushed or what the total was at that point. To get the next due date, add 2 kg to the bean total at the last brush (about a month of use). If you tell me the last brush date, I can give you a date.
3. **The 40 kg figure.** It is undated, so I wouldn't use it to place the next brush. Roughly 20 months since the 2025-03 install at 2 kg a month would give about 40 kg, so it may be current. That is not confirmed.

The shot-counting baseline I keep (count from the last descale) doesn't apply here, because this question is about kilograms of coffee and not shots.
```
Done criteria met: the reply names `knowledge/grinder.md` and has "If you tell me…" and an Assumptions list.
Ship: `2026-11-17T13:37:23Z ai-lab-sleep-project/652b2c70-… SubagentStop: pushed transcripts → sleep/transcripts` (after START). The subagent count went 41 → **43**, not +1. The test's count matches both `agent-a44d29c3ef7203dc1.jsonl` and `agent-a44d29c3ef7203dc1.meta.json`, so one agent run adds 2. This is a wording defect in the test (the Act done-criterion), not in the lab. Only one agent ran.
The noter has no Write tool (`tools: Read, Grep, Glob`), so the bet can only reach memory through settle's transcript recovery.

### Dream: settle (run 1)
Reply (summary of the verbatim report): "One new session, 652b2c70… It is a lab-runner session whose only user turn is 'Run tests/T6-fresh-locators.md'. It has no user fact and no agent bet about a note, so I consumed it and filed nothing." Counts: note 0, transcript 0, filed 0. Files: `agent-memory/_user/dream-log.md`, `dream-state.json`.
Commit b055b22 `dream(settle): T6 runner session consumed, no note changes`: the same 2 files. **Match.**
Ship: SubagentStop push 13:38:41Z.

### Dream: settle (rerun 1, after fix a22c6b8)
Reply: "There were no new transcripts and no outbox: all 17 sessions were already consumed … I appended a sixth-pass entry to `dream-log.md`, set `last_settled` in `dream-state.json` …" Files reported: `dream-log.md`, `dream-state.json`.
Commit 1529500 `dream(settle): sixth pass, no new transcripts`: **only `agent-memory/_user/dream-log.md`**. **Mismatch (finding):** the report names `dream-state.json`, but that file is not in the commit (it was unchanged; `last_settled` stayed the date-only `2026-11-17`).
The subagent's transcript does not contain the new prompt text ("New is per file" 0 hits, old prompt text 3 hits): **agent definitions edited mid-session do not reach subagents of the same session.**
Ship: SubagentStop push 13:40:10Z.

### Dream: settle (rerun 2, after fix 4337589)
Reply: "17 subagent files (from sessions 4600eb0b, 4be089a6, 5764ef00, 652b2c70, 9db72d39, b70f89e8, dac6cba5 and f1eb9a45) were not yet in `consumed`. I read each one, including its SubagentHandback reply. … All of them restated notes that were already settled: 150-shot cadence, citric2 sachets, shot counting, 2 kg/month, and the undated 40 kg burr figure. No new bet and no new user fact turned up." Files: `dream-log.md`, `dream-state.json`.
Commit `dream(settle): seventh pass, subagent files consumed, no note changes`: `dream-log.md`, `dream-state.json` (+21 lines; it now lists `agent-a44d29c3ef7203dc1.jsonl` and `last_settled` = `2026-11-17T13:41:32Z`). **Match.**
Ship: SubagentStop push 13:41:43Z.

### Dream: settle (rerun 3, after fix fddac60)
Reply: "there were no new `main.jsonl` or subagent files and no `memory-outbox/`. The only new files were hook probe logs … I added those to `consumed`." Counts 0/0/0. Files: `dream-log.md`, `dream-state.json`.
Commit 60d6e0b `dream(settle): eighth pass, probe logs only`: `dream-log.md`, `dream-state.json`. **Match.**
Its tool calls: `cat MEMORY-FORMAT.md | head -80` …, ledger, a Python new-file diff, then the handback. It ran no `grep -il assum` and never re-read anything. The re-read rule starts at MEMORY-FORMAT.md line 82 (`### Reading transcripts (settle)`), so `head -80` cut it off.
Ship: SubagentStop push 13:43:02Z.

### relate, promote
Not run: the loop budget was spent on settle, and checks 2–6 cannot pass without the note.

## Checks
(final state, after settle rerun 3, user HEAD 60d6e0b)
1. `git -C "$U" log -1 --format=%s` → expected starts with `dream(settle)`; actual `dream(settle): eighth pass, probe logs only` — **pass**
2. `N=…; echo "$N" | grep -c .` → expected `1` + brush; actual `0` — **fail** (settle did not recover the bet from the transcript)
3. `grep -E '^origin:' "$N"` → expected `origin: note|transcript`; not evaluable, N empty — **fail**
4. `grep -cE 'transcripts/…#[0-9a-f-]{36}' "$N"` → expected ≥ 1; not evaluable, N empty — **fail**
5. `bet-dossier.py "$N" | grep -c 'Could not resolve'` → `0`, `found by uuid` ≥ 1; not evaluable, N empty — **fail**
6. `awk '/^## .*settle/{e=$0} END{print e}' …dream-log.md` → a run after START; actual `## 2026-11-17 settle (eighth pass)` (written 13:42Z, after 13:36:55Z), but the second half (`grep -c "$(basename "$N" .md)"` ≥ 1) is not evaluable with N empty — **fail**
7. `git -C "$U" log -3 --format=%s` contains `dream(relate)` and `dream(promote)` — not run (budget spent before relate) — **fail**
8. `grep -rl "$(basename "$N" .md)" …MEMORY.md | wc -l` ≥ 1 — not run — **fail**

## Fixes
- a22c6b8 — user `agents/dreamer-settle.md` — check 2: read every `subagents/agent-*.jsonl` per file, read `SubagentHandback` tool_use replies, use a full-timestamp `last_settled`. Correct, but it did not take effect in this session (definitions load at session start). It applies from the next session.
- 4337589 — user `MEMORY-FORMAT.md` (`### Reading transcripts (settle)`) — check 2: the same rule, placed where settle reads it at runtime. Took effect: rerun 2 consumed 17 subagent files including the noter's.
- fddac60 — user `MEMORY-FORMAT.md` — check 2: re-read files consumed under older rules if they state assumptions; each stated assumption is a bet unless a note states the same claim (a rate note does not capture "last brush unrecorded"). It did not take effect: rerun 3 read only `head -80` of the file, and the section is at line 82+.

## Diagnosis
Failed at check 2: settle never created a note for the noter's brushing assumption. There were three causes, found one per loop. All are in the **settle dreamer** (its prompt and the format doc it reads). The hooks shipped every transcript on time, and the noter behaved correctly.
1. Settle read only `main.jsonl`. In this session that is a lab-runner transcript, and the noter's reply lives in `subagents/agent-a44d29c3ef7203dc1.jsonl` as a `SubagentHandback` tool_use, with no text block. `dream-state.json` had never listed a single subagent file. The prompt fix (a22c6b8) cannot reach subagents of the session that edited it. **Lab-runner limitation:** `agents/*.md` fixes are untestable within one runner session. Runtime-read files (MEMORY-FORMAT.md) are the only in-session lever.
2. Once settle read subagent files (rerun 2), it judged the reply as "restating settled notes" (2 kg/month, 40 kg). It matched on topic, not claim. The bet "no last-brush date is recorded; the brush falls due about monthly from an unknown point" has no note.
3. The rule fixing (2) and forcing a re-read of the now-consumed file (fddac60) sat below line 80 of MEMORY-FORMAT.md, and rerun 3 read it with `head -80`.
Next run: start a fresh lab-runner session so a22c6b8 loads, and move `### Reading transcripts (settle)` to the top of MEMORY-FORMAT.md (or have the settle prompt say "read the whole file"). The noter file is already in `consumed`, so the re-read rule (or a fresh act) is needed for the bet to be recovered.
Other findings: the rerun-1 report named `dream-state.json`, which was not in its commit. In the test text, `ls subagents | grep -c agent-` counts `.meta.json` files, so it rises by 2 per agent, not 1.
