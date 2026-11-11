# Lab tests

Record every observation in `findings.md` (one line per data point, with
`claude --version`). The planted facts: `descaling.md` says 200 shots in the
Schedule section but 150 in Changes (supersession); `water.md` says 300 with
the filter (contradiction unless the filter condition is read).

## Surfaces and how to observe

Run every test on three surfaces where it applies: **CLI** (terminal),
**Desktop** (the Claude app's Code tab, Local), **Cloud** (claude.ai/code,
or Desktop with a cloud environment selected). `/memory` and `/context`
exist only in the CLI, so no test depends on them. Four observation methods
work everywhere:

1. **Marker quote.** Every file that should be in a context carries a marker
   (`CLAUDE.md` → `lab-7f3a`, `.claude/rules/marker.md` → `lab-2c9e`,
   `noter/MEMORY.md` → `lab-91d4`, `checker/MEMORY.md` → `lab-4b70`,
   `_main/ai-lab-sleep-project/MEMORY.md` → `lab-c3e8`). Ask "which lab
   markers can you see?" and the answer says what was loaded, on any surface.
2. **Write probe.** Tell Claude something to keep ("For next time: the
   descaler we use is the citric sachets") and look for the file. On any
   surface you can ask Claude itself to run `ls -la` / `git -C
   ~/.ai-lab-sleep/user status --short agent-memory` and `cat` what changed.
3. **Hook probe.** `probe/<event>.jsonl` in this repo and the shipped copy in
   the transcripts repo; `~/.ai-lab-sleep/ship.log`.
4. **Git.** `git log` on the transcripts and user repos, from any machine.

CLI-only steps are marked **(CLI)**. Where the Desktop app lacks a feature
(agent view, `--agent`), skip that step there and note it in `findings.md`.

What the lab must prove:
1. A correction given once is not needed again (noter answers from the settled note after a dream).
2. Capture is complete: the dreamer finds the correction in the transcripts unaided.
3. Write scopes hold: settle writes status, relate raises issues, promote touches only the index.

## T0 — install

Mac: clone `ai-lab-sleep-user` to `~/.ai-lab-sleep/user`, run
`scripts/install-mac.sh`, restart Claude Code. Clone this repo on the Mac;
open it once and accept the workspace trust dialog so the repo hooks run.

Cloud: create a **new cloud environment** on claude.ai/code (Desktop: pick
"cloud" and manage environments) named `ai-lab-sleep`, network access
Trusted, and paste the contents of `ai-lab-sleep-user/scripts/cloud-setup.sh`
into its **setup script** field. Nothing runs on the Mac for this. The
script runs as root on the VM before Claude Code launches, clones the user
and transcripts repos (they must exist on GitHub with the Claude GitHub App
installed) and makes the `/root/.claude/agents` symlink; the first session
snapshots the result, later sessions start from the snapshot and the
project's SessionStart hook pulls both repos fresh.

Check: `ls -la ~/.claude/agents` shows the symlink; in a session (any
surface) ask "which subagents are available?" and expect `noter`, `checker`,
`dreamer-*` (**CLI**: `/agents` lists them). Ask "which lab markers can you
see?" → `lab-7f3a` (CLAUDE.md), `lab-2c9e` (rule) and `lab-c3e8` (the
relocated default-agent memory; `autoMemoryDirectory` in this repo's settings
is honored only after the trust dialog is accepted). Auto memory must be on
(Desktop: the app's memory setting; CLI: no `CLAUDE_CODE_DISABLE_AUTO_MEMORY`
in the shell); without it the `memory:` field does nothing.

Nobody tells the agents what to note. Claude Code injects its own memory
instructions when `memory:` is set. As an A/B, `noter` carries one extra line
saying what its memory is for; `checker` carries nothing. T1 records whether
each writes anything unprompted. If notes don't appear, that is a finding,
not a prompt to fix.

Memory is pushed to `main` by `ship.sh` only when a unit of work ends
(SubagentStop, SessionEnd, the SessionStart catch-up) and by each dream
phase; per-turn events ship transcripts only.

## T0b — memory toggles (CLI, Desktop, Cloud)

Same two probes on every surface, with the Desktop app's memory setting on,
then off, then on again:

1. Marker quote: "which lab markers can you see?" → `lab-c3e8` present means
   the relocated default-agent `MEMORY.md` was loaded.
2. Write probe: "For next time: the descaler we use is the citric sachets."
   Then ask Claude to run `git -C ~/.ai-lab-sleep/user status --short
   agent-memory` (cloud: `/root/.ai-lab-sleep/user`) and, if nothing changed,
   `ls ~/.claude/projects/*/memory/` (cloud: `/root/.claude/projects/`) to
   see whether it wrote to the default location instead. The write is a Write
   tool call in the transcript, so the shipper captures it either way.

- [ ] CLI: toggle honored (marker disappears when off); folder is the relocated one
- [ ] Desktop: same two probes; does the app's setting govern the Code tab?
- [ ] Cloud: auto memory active at all? marker visible? which path did the write land in? (`autoMemoryDirectory` from repo settings honored without a trust dialog?)

## T1 — hook mechanics and feedback paths (CLI and Desktop)

One session in this repo, once from the CLI and once from the Desktop app
(Local). Script:

1. "How often should I descale?" → let Claude delegate to `noter`. Expected: 200 (first hit), citing descaling.md › Schedule, and a note written.
2. Correct in the main session: "That's superseded, the Changes section says 150 since October. Ask noter to fix its answer." Expect a resume or a new run.
3. "Ask checker to review noter's note." (checker run)
4. **(CLI, agent view)** open noter's transcript panel and type a correction directly to it: "Also: with the filter installed water.md says 300." (direct feedback path). On Desktop, if there is no way to address the subagent directly, skip and note it.
5. `/clear`, then ask one more trivial question, then end the session (CLI: exit; Desktop: close the session).

Data points (from `probe/*.jsonl` and `~/.ai-lab-sleep/tx/<slug>/<session>/` (the project's `sleep/transcripts` branch)):
- [ ] SubagentStop carries `agent_transcript_path`, `agent_id`, `agent_type` (= `noter` / `checker`)
- [ ] step 2: new `agent-<id>.jsonl` or the same file appended? (compare ids)
- [ ] step 2 correction appears in `main.jsonl`; step 4 correction appears in the subagent file
- [ ] `Stop` lag: lines in the shipped `main.jsonl` at Stop vs at the next UserPromptSubmit (ship.log timestamps + `wc -l` on the two copies, or compare commits in the transcripts repo)
- [ ] `SessionEnd` fired with reason `clear` and then `other`/`prompt_input_exit`; did its ship push within the timeout? Desktop: does closing a session fire `SessionEnd` at all, and with which reason?
- [ ] `sleep/transcripts` branch on the project repo: `main.jsonl`, `subagents/`, `probe/`, `manifest.json` under `<session>/`; `git log origin/sleep/transcripts` shows one commit per push with the debounce honored; `main` untouched
- [ ] `~/.ai-lab-sleep/user/agent-memory/noter/` has something written by noter's auto memory (MEMORY.md and/or a topic file): what did it write, and did it say how it knew?
- [ ] same for `checker/` (no purpose line): did it write anything at all? (the A/B)
- [ ] `memory:` commits on `ai-lab-sleep-user` appear only at SubagentStop/SessionEnd, none from Stop
- [ ] `agent-memory/_main/ai-lab-sleep-project/MEMORY.md` exists and the main session recorded your step-2 correction there on its own (main-session auto memory, relocated)
- [ ] did `noter` read its memory before answering on the second run? (look for a Read of its memory folder in the subagent transcript)

## T1b — which context owns which memory (CLI and Desktop)

Memory belongs to the definition a context runs under, not to "main vs
subagent". Ask the same question ("How often should I descale?") each way
below in a fresh session; in each, first ask "which lab markers can you
see?" (which MEMORY.md was loaded), then after the answer ask Claude to run
`git -C ~/.ai-lab-sleep/user status --short agent-memory` (which folder was
written):

| case | how | expected loaded marker | expected writer |
|---|---|---|---|
| vanilla session | just ask, tell Claude not to delegate | `lab-c3e8` | `_main/ai-lab-sleep-project/` |
| fork | `/subtask How often should I descale?` (if the surface has it) | `lab-c3e8` | `_main/...` |
| subagent | "ask noter" and have noter report its markers | `lab-91d4` | `noter/` |
| session as agent **(CLI)** | `claude --agent noter` then ask | **unknown** | **unknown** — `noter/`, `_main/`, both, or none |

- [ ] record marker and writer for each, per surface; the fourth row decides whether "open a session as an agent" keeps that agent's memory
- [ ] a subagent without `memory:` (ask the built-in general-purpose agent) sees no memory marker and writes nowhere — confirm

## T2 — cloud pause vs reclaim (background)

Start four identical cloud sessions on this repo: ask the T1 step-1 question,
wait for the answer, leave. Reopen one after 1 h, 6 h, 24 h, 72 h.

- [ ] on reopen: were `probe/*.jsonl` still on disk (restored VM) or gone with "Run setup script" shown (rebuilt)?
- [ ] `probe/SessionStart.jsonl` on reopen: `source` value
- [ ] did any `SessionEnd` fire before the pause/reclaim? (expect none)
- [ ] `sleep/transcripts`: did the async Stop ship land before you left? (`git log` time vs your last message)
- [ ] write down the pause→reclaim boundary you observed

## T3 — user-level agents and access in the cloud

In a cloud session on this repo (start it from claude.ai/code once and from
the Desktop app with the cloud environment selected once):
- [ ] "which subagents are available?" names `noter` etc. (setup-script symlink works)
- [ ] ask the main agent: "Can you see MARKER-RULE?" → quotes `lab-2c9e` (rules load in cloud)
- [ ] "Ask noter whether it can see MARKER-CLAUDE-MD" → quotes `lab-7f3a` (project CLAUDE.md reaches a user-level subagent)
- [ ] `CLAUDE_CODE_REMOTE` is `"true"` in the probe records
- [ ] T0b's two probes in the cloud: `lab-c3e8` visible? write landed under `/root/.ai-lab-sleep/user/agent-memory/_main/...` or under `/root/.claude/projects/`? If it wrote to the relocated path, the next SubagentStop/SessionEnd ship pushes it (`git log` on `ai-lab-sleep-user` shows a `memory:` commit from host `vm`).
- [x] 2026-11-10/11: reads/clones of App-installed repos work through the proxy without attaching; writes to a non-attached repo are refused (403 before credentials), with or without a PAT; attaching several repos disables the project's hooks. Hence transcripts ship to the project's own `sleep/transcripts` branch.
- [ ] `cat ~/.ai-lab-sleep/ship.log` shows `pushed transcripts → sleep/transcripts` from the cloud, and `git log origin/sleep/transcripts` on the project repo shows the VM's commits

## T5 — a hand-run dream (CLI)

Follow `ai-lab-sleep-user/DREAM-RUNBOOK.md` on the T1 transcripts. The
phases run with `claude --agent`, which is CLI-only; if T1b's fourth row
shows `--agent` doesn't bind memory the way we expect, that changes nothing
here (the dreamer agents have no `memory:` field and write through the
scope guard).

- [ ] before dreaming: the T1 memory writes (noter's and `_main/`'s) are on `origin/main` of `ai-lab-sleep-user` as `memory:` commits made by `ship.sh` — nothing pushed by hand.
- [ ] settle: the 200-shots note is `corrected` with the main-transcript path and `knowledge/descaling.md#changes` as evidence; a filter-condition note exists from the step-4 correction
- [ ] settle attempted nothing outside `notes/`, `issues.md`, `dream-log.md` (guard log: any "Blocked" lines in the session?)
- [ ] relate: a `wiki/descaling-cadence.md` (or similar) linking the notes; the 150-vs-300 tension raised in `issues.md`, not edited into a note
- [ ] promote: `MEMORY.md` under 120 lines with the corrected rule under "Rules that matter now"; a proposal under `proposals/ai-lab-sleep-project/rules/` if it judged the lesson project-wide
- [ ] **value check** (CLI and Desktop): fresh session, "How often should I descale?" → noter answers 150 (and the filter condition), citing its note or the Changes section, without being corrected

## Removed

T4 (gbrain links) — out of scope for the lab; a later spike against the coach repo only if relate proves slow.
