# Lab tests

Record every observation in `findings.md` (one line per data point, with
`claude --version`). The planted facts: `descaling.md` says 200 shots in the
Schedule section but 150 in Changes (supersession); `water.md` says 300 with
the filter (contradiction unless the filter condition is read).

What the lab must prove:
1. A correction given once is not needed again (noter answers from the settled note after a dream).
2. Capture is complete: the dreamer finds the correction in the transcripts unaided.
3. Write scopes hold: settle writes status, relate raises issues, promote touches only the index.

## T0 — install

Mac: clone `ai-lab-sleep-user` to `~/.ai-lab-sleep/user`, run
`scripts/install-mac.sh`, restart Claude Code. Cloud: paste
`scripts/cloud-setup.sh` as the environment's setup script; network access
Trusted (github.com is on the default allowlist). Clone this repo on the Mac;
open it once and accept the workspace trust dialog so the repo hooks run.

Check: `ls -la ~/.claude/agents` shows the symlink; `claude` then `/agents`
lists `noter`, `checker`, `dreamer-*`; `/memory` shows the auto memory folder
as `~/.ai-lab-sleep/user/agent-memory/_main/ai-lab-sleep-project` (the
`autoMemoryDirectory` in this repo's settings is honored only after the trust
dialog is accepted). Auto memory must be on (`/memory`, or no
`CLAUDE_CODE_DISABLE_AUTO_MEMORY`); without it the `memory:` field does nothing.

Nobody tells the agents what to note. `noter`/`checker` carry one line saying
what their memory is for; Claude Code's own auto memory instructions decide
the rest. If notes don't appear, that is a finding, not a prompt to fix.

## T1 — hook mechanics and feedback paths (Mac)

One session in this repo. Script:

1. "How often should I descale?" → let Claude delegate to `noter`. Expected: 200 (first hit), citing descaling.md › Schedule, and a note written.
2. Correct in the main session: "That's superseded, the Changes section says 150 since October. Ask noter to fix its answer." Expect a resume or a new run.
3. "Ask checker to review noter's note." (checker run)
4. With agent view on, open noter's transcript panel and type a correction directly to it: "Also: with the filter installed water.md says 300." (direct feedback path)
5. `/clear`, then ask one more trivial question, then exit.

Data points (from `probe/*.jsonl` and `~/.ai-lab-sleep/transcripts/<slug>/<session>/`):
- [ ] SubagentStop carries `agent_transcript_path`, `agent_id`, `agent_type` (= `noter` / `checker`)
- [ ] step 2: new `agent-<id>.jsonl` or the same file appended? (compare ids)
- [ ] step 2 correction appears in `main.jsonl`; step 4 correction appears in the subagent file
- [ ] `Stop` lag: lines in the shipped `main.jsonl` at Stop vs at the next UserPromptSubmit (ship.log timestamps + `wc -l` on the two copies, or compare commits in the transcripts repo)
- [ ] `SessionEnd` fired with reason `clear` and then `other`/`prompt_input_exit`; did its ship push within the timeout?
- [ ] transcripts repo layout: `main.jsonl`, `subagents/`, `probe/`, `manifest.json` present; `git log` shows one commit per push with the debounce honored
- [ ] `~/.ai-lab-sleep/user/agent-memory/noter/` has something written by noter's auto memory (MEMORY.md and/or a topic file): what did it write, and did it say how it knew? (Unprompted — this is the research's "say what memory is for" test.)
- [ ] `agent-memory/_main/ai-lab-sleep-project/MEMORY.md` exists and the main session recorded your step-2 correction there on its own (main-session auto memory, relocated)
- [ ] did `noter` read its memory before answering on the second run? (look for a Read of its memory folder in the subagent transcript)

## T2 — cloud pause vs reclaim (background)

Start four identical cloud sessions on this repo: ask the T1 step-1 question,
wait for the answer, leave. Reopen one after 1 h, 6 h, 24 h, 72 h.

- [ ] on reopen: were `probe/*.jsonl` still on disk (restored VM) or gone with "Run setup script" shown (rebuilt)?
- [ ] `probe/SessionStart.jsonl` on reopen: `source` value
- [ ] did any `SessionEnd` fire before the pause/reclaim? (expect none)
- [ ] transcripts repo: did the async Stop ship land before you left? (`git log` time vs your last message)
- [ ] write down the pause→reclaim boundary you observed

## T3 — user-level agents and access in the cloud

In a cloud session on this repo:
- [ ] `/agents` lists `noter` etc. (setup-script symlink works)
- [ ] ask the main agent: "Can you see MARKER-RULE?" → quotes `lab-2c9e` (rules load in cloud)
- [ ] "Ask noter whether it can see MARKER-CLAUDE-MD" → quotes `lab-7f3a` (project CLAUDE.md reaches a user-level subagent)
- [ ] `CLAUDE_CODE_REMOTE` is `"true"` in the probe records
- [ ] `/memory` in the cloud session: is `autoMemoryDirectory` from the repo settings honored (path under `/root/.ai-lab-sleep/...`), and does main-session auto memory run at all in the cloud? If it writes, the next ship should push `agent-memory/` of the user repo to `main` (`git log` on `ai-lab-sleep-user` shows a `memory:` commit from host `vm`).
- [ ] ask Claude to run `git -C ~/.ai-lab-sleep/transcripts log -1` and `git -C ~/.ai-lab-sleep/user pull`: both repos reachable through the proxy without being attached to the session
- [ ] ask Claude to `git clone https://github.com/Titerote/ai-coach-assistant /tmp/x` (a repo with the Claude GitHub App installed) and one without: which succeeds? This decides dynamic project access for the dreamer.
- [ ] ask Claude to push a trivial commit to `ai-lab-sleep-transcripts` from the VM: does the proxy allow writes to a non-attached repo?

## T5 — a hand-run dream (Mac)

Follow `ai-lab-sleep-user/DREAM-RUNBOOK.md` on the T1 transcripts.

- [ ] before dreaming: the T1 memory writes (noter's and `_main/`'s) are on `origin/main` of `ai-lab-sleep-user` as `memory:` commits made by `ship.sh` — nothing pushed by hand.
- [ ] settle: the 200-shots note is `corrected` with the main-transcript path and `knowledge/descaling.md#changes` as evidence; a filter-condition note exists from the step-4 correction
- [ ] settle attempted nothing outside `notes/`, `issues.md`, `dream-log.md` (guard log: any "Blocked" lines in the session?)
- [ ] relate: a `wiki/descaling-cadence.md` (or similar) linking the notes; the 150-vs-300 tension raised in `issues.md`, not edited into a note
- [ ] promote: `MEMORY.md` under 120 lines with the corrected rule under "Rules that matter now"; a proposal under `proposals/ai-lab-sleep-project/rules/` if it judged the lesson project-wide
- [ ] **value check**: fresh session, "How often should I descale?" → noter answers 150 (and the filter condition), citing its note or the Changes section, without being corrected

## Removed

T4 (gbrain links) — out of scope for the lab; a later spike against the coach repo only if relate proves slow.
