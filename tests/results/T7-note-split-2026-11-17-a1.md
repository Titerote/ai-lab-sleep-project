# T7-note-split — passed — 2026-11-17
inputs: project 9afb0122848283b6eff0e6b827ea4d69de3d6eb5, user cf180e7d2a7da51848ac6fb9dceedec7b2e3f258, dreamer models: settle sonnet relate opus promote sonnet
loops used: 0/3

START=2026-11-17T17:53:47Z
HEAD0=cf180e7d2a7da51848ac6fb9dceedec7b2e3f258
fixture commit: 52fde31171d0695b132c402b187b5def1c0262ce
session: 3d798663-7167-48ec-a1d9-7ff087ab2248, claude 2.1.326, Mac (attempt 1 of the outer loop)

Pre-existing state, not made by this run and left untouched:
- Project working tree: `knowledge/descaling.md` modified but not committed. "Schedule" says 150 (was 200), and "Changes" has a new line `2026-11-17: Schedule section rewritten to 150 shots (user decision)`.
- User repo working tree: `agent-memory/_main/ai-lab-sleep-project/issues.md` modified but not committed. The 2026-11-16 Schedule issue is ticked, with the note "user decided 150 … not yet committed".

No earlier T7 result existed, so there were no prior fixes to avoid repeating.

## Steps

### Setup
- Both pulls were clean, and there was no `.dream-phase`.
- `grep -n '150' knowledge/water.md knowledge/descaling.md` shows 150 in both files: `descaling.md:5` (the uncommitted Schedule edit), `descaling.md:17` (Changes) and `water.md:10`. HEAD alone already satisfies this, through `descaling.md` Changes and `water.md:10`.
- `grep -ril 'gasket' knowledge/ | wc -l` → `0`. `grep -ril 'double' knowledge/ | wc -l` → `0`.
- The fixture was written exactly as specified to `$U/agent-memory/noter/maintenance.md`, committed as `lab` (52fde31) and pushed.

### Act
None, per the test.

### Dream: settle
Reply (verbatim):
```
Settle phase done, committed and pushed to main as `dream(settle): tenth pass, split noter maintenance into three notes`. I did not run the T7 checks, so none of them is confirmed.

**New transcript files read**
- `3d798663/main.jsonl` is the T7 runner session. It holds setup and the launch of this dream, with no bets or user facts.
- `3de1b0b0/subagents/agent-a3307409c7150bbee.jsonl` (relate run) and `agent-a7ff0d3a98c8fc716.jsonl` (promote run) carry no bets or user facts.
- No outbox files. The project clone is at `9afb012`.
- All three files are added to `consumed`, and `project_main` is updated.

**Split of the T7 fixture `agent-memory/noter/maintenance.md`**
1. "Descale every 150 shots" is retired as `noter/notes/_retired/descale-every-150-shots.md`, origin note. It rests on `knowledge/water.md:10` and `knowledge/descaling.md:17`, and it links to the existing retired note `_main/.../descale-150-both-setups`.
2. "Group head gasket replaced yearly" is `noter/notes/group-head-gasket-yearly.md`, a bet with origin note. Nothing in `knowledge/` or any transcript mentions a gasket, so it has `## Open` and `## Dossier`, plus a line in `agent-memory/noter/issues.md`.
3. "User drinks two double shots a day" is `_user/notes/two-double-shots-a-day.md`, a bet with origin note. I filed it under `_user` because it is about the person. It has `## Open`, `## Dossier` and a line in the new `agent-memory/_user/issues.md`. Two 18 g doubles a day is about 1.1 kg a month. That is below the user's stated 2 kg a month, so it neither confirms nor contradicts.
4. `maintenance.md` is now a 4-line stub with 3 `[[...]]` links. The word "gasket" appears once in it, in a link name.

**Sweep**
- The existing notes (burr-40kg corrected, burr-brush-due-unknown bet, descaler-product, `beans-2kg-per-month`, `feedback_shot_counting`) were all swept. All four questions came out no, with no action, and the burr-brush bet stays open for the user's date.
- The ledger and per-claim list are in `_user/dream-log.md` and `noter/dream-log.md`.
- Counts by origin of new notes: note 3, transcript 0, filed 0. Open bets: 3.
- `.dream-phase` still exists, and I did not remove it. The test runner or the promote step should handle it.

**Files in the commit (`git show --stat HEAD`)**
- /Users/tite/.ai-lab-sleep/user/agent-memory/_user/dream-log.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/_user/issues.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/_user/notes/two-double-shots-a-day.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/noter/dream-log.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/noter/issues.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/noter/maintenance.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/noter/notes/_retired/descale-every-150-shots.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/noter/notes/group-head-gasket-yearly.md
- /Users/tite/.ai-lab-sleep/user/dream-state.json
```
- Commit 957dac3 `dream(settle): tenth pass, split noter maintenance into three notes` holds the same 9 files. **Match.**
- Settle said the stub has 4 lines; `wc -l` reports 5 (title, a blank line and 3 links). This is cosmetic.
- Ship: memory was pushed at SubagentStop 17:54:19Z. The transcript push at settle's final SubagentStop failed at 17:55:48Z (`transcripts push failed (left committed)`); see Diagnosis.

### Dream: relate
Reply (verbatim):
```
The relate phase is finished: I updated two wiki pages, added one new page, and closed one issue. It is committed as b4cb212 and pushed to `main` in `~/.ai-lab-sleep/user`. My link check found no broken `[[...]]` links in any wiki page or note.

**What changed**
- **Descaling page:** the 150-shot cadence now rests on two retired notes, one from the default agent's project memory and one from noter. They are the same lesson, learned separately by two agents. I also updated the line about `knowledge/descaling.md`. The user ruled that its "Schedule" section should say 150 instead of 200. That edit is in the project's working tree but not committed, so `origin/main` still says 200.
- **Grinder burr page:** unchanged in substance. It now links to the new coffee consumption page.
- **New coffee consumption page:** joins the user's 2 kg of beans a month (confirmed) with the open bet that the user drinks two doubles a day. The bet works out to about 1.1 kg a month, lower than the household figure. That is unconfirmed but not contradicted, since others in the household may drink too. That tension was already raised in `_user/issues.md`, so I did not add it again.
- **`_main/ai-lab-sleep-project/issues.md`:** I ticked the issue saying the memory indexes lagged the notes. The previous promote (cf180e7) fixed both indexes.
- **No page for `noter/notes/group-head-gasket-yearly`:** it is the only note on its subject. Nothing on checker either, which has no notes.
- **No new contradictions:** no note conflicts with another beyond the one already raised.

**Files changed**
- /Users/tite/.ai-lab-sleep/user/agent-memory/_main/ai-lab-sleep-project/wiki/descaling.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/_main/ai-lab-sleep-project/wiki/grinder-burr-life.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/_user/wiki/coffee-consumption.md (new)
- /Users/tite/.ai-lab-sleep/user/agent-memory/_main/ai-lab-sleep-project/issues.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/_main/ai-lab-sleep-project/dream-log.md
- /Users/tite/.ai-lab-sleep/user/agent-memory/_user/dream-log.md
```
- Commit b4cb212 holds the same 6 files. **Match.**
- Ship: the transcript push failed at 17:56:16Z (left committed).

### Dream: promote
Reply (verbatim):
```
Promote phase done. I committed af22f90 and pushed it to main. My first combined command was denied by the permission classifier, so I re-ran the edits and the commit separately. The push then succeeded.

Changes:
- **`_main` index:**
  - The cadence rule now says 150 shots agrees across water.md, the "Changes" entry and descaling.md "Schedule". The Schedule edit is the user's uncommitted working-tree change from 2026-11-17.
  - The rule also says Schedule still counts by the machine counter, so the last-descale baseline applies.
  - I added a link to `_user/wiki/coffee-consumption.md`.
  - I updated the proposals line.
- **`noter` index:**
  - The cadence rule now links `notes/_retired/descale-every-150-shots.md`.
  - The gasket note is listed under "Open bets (do not state as fact)" and is not a rule.
  - I added `issues.md` and the `maintenance.md` stub to the map.
  - The two mirrored `_user` rules are unchanged.
- **`checker` index:** the mirrored rules are unchanged, and I left the file alone.
- **`_user` index:** the map now lists the `coffee-consumption` wiki page.
- **Proposals:** I narrowed the knowledge proposal `descaling-schedule-150.md`. The 200 to 150 change is already made in the working tree, so only the counting clause remains: "count from the last descale, not the counter reset". I proposed no new rules. The citric2 proposal is unchanged.
- **Dream logs:** I appended a `dream(promote)` entry to each of the four roots.

Not promoted:
- **Two-doubles bet:** `two-double-shots-a-day` is an open bet, so it is not mirrored as a rule.
- **Burr-brush bet:** `burr-brush-due-unknown` is also an open bet, so it is not promoted either.

Files changed (all under `/Users/tite/.ai-lab-sleep/user/`):
- agent-memory/_main/ai-lab-sleep-project/MEMORY.md
- agent-memory/_main/ai-lab-sleep-project/dream-log.md
- agent-memory/noter/MEMORY.md
- agent-memory/noter/dream-log.md
- agent-memory/checker/dream-log.md
- agent-memory/_user/MEMORY.md
- agent-memory/_user/dream-log.md
- proposals/ai-lab-sleep-project/knowledge/descaling-schedule-150.md
```
- Commit af22f90 `dream(promote): refresh indexes, narrow schedule proposal` holds the same 8 files. **Match.**
- Ship: the transcript push failed at 17:57:06Z and 17:57:37Z (left committed).

### Teardown
`ls $U/.dream-phase` → `No such file or directory`. Everything else is left in place.

## Checks
1. `git -C "$U" log -1 --format=%s` (after settle): expected starts with `dream(settle)`; actual `dream(settle): tenth pass, split noter maintenance into three notes`. **pass**
2. `wc -l < …/noter/maintenance.md`: expected ≤ 6; actual `5`. `grep -c '\[\['`: expected ≥ 3; actual `3`. `grep -ci 'gasket'`: expected ≤ 1; actual `1`. **pass**
3. `A=…; echo "$A" | grep -c .`: expected `3`; actual `3` (`agent-memory/_user/notes/two-double-shots-a-day.md`, `agent-memory/noter/notes/_retired/descale-every-150-shots.md`, `agent-memory/noter/notes/group-head-gasket-yearly.md`). **pass**
4. `echo "$R" | grep -c .`: expected `1`; actual `1`. `grep -E '^status:'`: expected `status: retired`; actual `status: retired`. Locator count: expected ≥ 1; actual `2`. `grep -qi descale`: expected success; actual success. **pass**
5. `echo "$P" | grep -c .`: expected `1`; actual `1`. `grep -qi double`: expected success; actual success. **pass**
6. `echo "$B" | grep -c .`: expected `1`; actual `1`. Status: expected `status: bet`; actual `status: bet`. `^## Open`: expected `1`; actual `1`. `^## Dossier`: expected `1`; actual `1`. `grep -qi gasket`: expected success; actual success. **pass**
7. `for f in $A; do grep -E '^origin:' "$U/$f"; done | sort | uniq -c`: expected `3 origin: note`; actual `   3 origin: note`. **pass**
   - Run under `bash -c`. The runner's shell is zsh, which does not word-split the unquoted `$A`. Under zsh, the same text passed all three paths as one filename and got `No such file or directory`. The check assumes POSIX splitting, and this is a shell artefact rather than a lab fault.
8. `grep -c group-head-gasket-yearly …/noter/issues.md`: expected ≥ 1; actual `1`. `tail -60 …/_user/dream-log.md | grep -c -e … -e … -e …`: expected ≥ 3; actual `6`. **pass**
9. (after promote) `git -C "$U" log -3 --format=%s`: expected to contain `dream(relate)` and `dream(promote)`; actual `dream(promote): refresh indexes, narrow schedule proposal` / `dream(relate): cadence page joins noter's retired note, new _user coffee-consumption page, tick index issue` / `dream(settle): tenth pass, split noter maintenance into three notes`. `grep -c group-head-gasket-yearly …/noter/MEMORY.md`: expected ≥ 1; actual `1`. **pass**

## Fixes
None.

## Diagnosis
All checks passed first time. Settle split the multi-claim topic file into three one-claim notes, each settled its own way:
- The descale claim was retired on `knowledge/water.md:10` and `knowledge/descaling.md:17`.
- The person fact went to `_user/notes/`.
- The gasket claim stayed a bet, with a dossier, `## Open` and an issue.

Settle kept `origin: note` on all three. Relate and promote handled them correctly: open bets were not promoted, and the gasket bet is listed in the noter index as an open bet.

Side findings (no check failed, so no fix was made):
1. **The transcript ship diverged, and every push since has failed.**
   - In `$SLEEP_HOME/tx/ai-lab-sleep-project`, commit 7cd9000 (SubagentStop 12:54:13-05:00, holding a 24-line partial `agent-a088de895b2ec9993.jsonl`) was pushed. Commit e8c7641 (Stop 12:54:19-05:00) was committed locally on the same parent, 482a80b, so the two diverged.
   - From then on, every `pull --rebase` in `push_branch` fails, and ship logs `transcripts push failed (left committed)`. The local clone is ahead 7 and behind 1.
   - Likely cause: the async subagent's SubagentStop and the parent's Stop hook raced. The early SubagentStop fired about 10 s after the async launch. The per-session `mkdir` lock did not keep the second commit off the pushed one.
   - Effect: this session's transcripts after 17:54Z are not on `sleep/transcripts` until the conflict is resolved. That matters for the next settle's transcript recovery.
2. **The ship hook committed a human's in-progress edit.** It swept the user's uncommitted `_main/…/issues.md` edit into its memory commit 4bfbe39 (`memory: … (SubagentStop)`). Relate and promote then wrote "uncommitted working-tree edit" of `knowledge/descaling.md` into the wiki, the `_main` index and the narrowed proposal. Memory now states as current a knowledge change that `origin/main` does not have.
3. **Settle again listed its own running session** (`3d798663/main.jsonl`) as read and consumed, the same as the T6 nit.
4. **The checks assume bash.** Check 7 needs word splitting, which the runner's zsh does not do.
