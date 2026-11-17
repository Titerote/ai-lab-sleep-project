# T8 — a memory write made in a cloud session reaches the user repo through the outbox
loops: 2

Cloud VMs cannot push to the user repo, so `ship.sh` copies any uncommitted
file under the user clone's `agent-memory/` into `<session>/memory-outbox/`
on the project's `sleep/transcripts` branch at SubagentStop/SessionEnd, and
settle's Step 0 applies it. Validated only with a hand-made outbox so far.

This test has a manual half that happens first, in a cloud session started
from the phone, and an automated half run here with `tests/run.sh`.

Variables: `$U` = `${SLEEP_HOME:-$HOME/.ai-lab-sleep}/user`,
`$TX` = `${SLEEP_HOME:-$HOME/.ai-lab-sleep}/tx/ai-lab-sleep-project`.

## Manual half (phone → cloud session on this repo, done before run.sh)
1. Start a cloud session on `ai-lab-sleep-project` (the environment runs `scripts/cloud-setup.sh`, which clones the user repo and links `~/.claude/agents` and `~/.claude/agent-memory`).
2. Send exactly: *Use the noter subagent for this: the citric descaler sachets are kept in the left kitchen drawer. Ask it to note that for next time, then report what it wrote and where.*
3. Note the session id the reply or the hook probe shows, and the file path the noter says it wrote. Wait until the reply is complete, then leave the session (it ships at SubagentStop and again at SessionEnd).

## Setup (run.sh half)
1. `git pull -q --ff-only` here and in `$U`; remove `$U/.dream-phase` if present.
2. Record `START` and `HEAD0=$(git -C "$U" rev-parse HEAD)`.
3. `git -C "$TX" fetch -q && git -C "$TX" reset -q --hard origin/sleep/transcripts; ls -d "$TX"/*/memory-outbox 2>/dev/null` → at least one directory. Record `OB` = the newest one (by its session's `manifest.json` `last_shipped`). If none: the cloud half did not ship an outbox; record that as the finding and stop (this is not a fixable lab fault from here).
4. `find "$OB" -type f | sed "s#$OB/##"` → record the list; it must contain a file under `agent-memory/noter/` or `agent-memory/_main/ai-lab-sleep-project/` (where the cloud noter wrote). `grep -rli 'drawer' "$OB" | wc -l` → `≥ 1`.
5. `python3 -c "import json;print(json.load(open('$OB/../manifest.json'))['claude_code_remote'])"` → `true` (the outbox came from a cloud VM).

## Act
None here; the act was the cloud session.

## Dream
1. `settle` — plain prompt.
2. `relate` — plain prompt.
3. `promote` — plain prompt.

Checks 1–5 after settle; 6 after promote.

## Checks
1. `git -C "$U" log -1 --format=%s` → starts with `dream(settle)`.
2. For every file `f` listed in setup 4: `test -f "$U/$f" && echo yes` → `yes` (the outbox file was applied at the same path under the user repo), or a sibling `"$U/${f%.md}".cloud-*.md` exists and `grep -c 'cloud-' "$U/agent-memory/$(dirname "${f#agent-memory/}")/../issues.md"` → `≥ 1` (a conflict was saved beside and raised, not overwritten).
3. `grep -rli 'drawer' "$U/agent-memory" --include='*.md' | grep -vE 'dream-log|issues|MEMORY\.md|wiki/' | wc -l` → `≥ 1`, and that note has `status:` and `origin:` lines (settle gave the applied file frontmatter: `grep -cE '^(status|origin):' <note>` → `2`).
4. `grep -E '^origin:' <note>` → `origin: note` (the cloud agent wrote it itself).
5. `python3 -c "import json;d=json.load(open('$U/dream-state.json'));print(any('memory-outbox' in x for x in d.get('consumed',[])))"` → `True` (the outbox is recorded as consumed), and `tail -60 "$U/agent-memory/_user/dream-log.md" | grep -ci 'outbox'` → `≥ 1`.
6. After promote: `git -C "$U" log -3 --format=%s` contains `dream(relate)` and `dream(promote)`; `grep -c "$(basename <note> .md)" "$U/agent-memory/noter/MEMORY.md" "$U/agent-memory/_main/ai-lab-sleep-project/MEMORY.md" | awk -F: '{s+=$2} END{print s}'` → `≥ 1`.

## Teardown
Leave everything. Make sure `$U/.dream-phase` does not exist.
