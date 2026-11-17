# T6 — a fresh bet gets uuid locators that the dossier resolves
loops: 3

Every evidence locator in memory so far was retrofitted onto existing
notes. This test exercises the live path: an agent states an assumption in
a new session, the transcript ships, settle files or settles the note and
writes `transcripts/…jsonl#<uuid>` locators from the records it read, and
`bet-dossier.py` resolves every one of them by uuid.

Variables: `$U` = `${SLEEP_HOME:-$HOME/.ai-lab-sleep}/user`,
`$TX` = `${SLEEP_HOME:-$HOME/.ai-lab-sleep}/tx/ai-lab-sleep-project`.

## Setup
1. `git pull -q --ff-only` here and in `$U`; `git -C "$U" status --porcelain` must be empty apart from `.dream-phase` (remove it if present) and untracked `scripts/__pycache__/`.
2. Record `START=$(date -u +%Y-%m-%dT%H:%M:%SZ)` and `HEAD0=$(git -C "$U" rev-parse HEAD)` in the result file.
3. Confirm `knowledge/grinder.md` says the burrs are brushed every 2 kg and records no date of the last brushing (`grep -n -i 'brush' knowledge/grinder.md`). No edit; the missing date is the gap the agent has to bridge.

## Act
Spawn `noter` with exactly this prompt:

> When are the burrs next due for a brush? Answer from the knowledge files, and state any assumption you have to make to answer.

Done when the reply names `knowledge/grinder.md` and contains at least one
assumption (a sentence with "assume", "assuming" or "if"). Copy the reply
verbatim. Then confirm the ship: `tail -5 "$SLEEP_HOME/ship.log"` shows a
push after `$START`, and
`git -C "$TX" fetch -q && git -C "$TX" reset -q --hard origin/sleep/transcripts && ls "$TX"/*/subagents/ | grep -c '\.jsonl$'` is one higher than before the act (count it in setup; `.meta.json` files are not counted).

## Dream
1. `settle` — plain prompt.
2. `relate` — plain prompt.
3. `promote` — plain prompt.

Checks 1–6 are evaluated after settle; 7–8 after promote.

## Checks
1. `git -C "$U" log -1 --format=%s` → starts with `dream(settle)`.
2. `N=$(git -C "$U" diff --name-only --diff-filter=A "$HEAD0"..HEAD -- agent-memory | grep -vE 'dream-log|issues|MEMORY\.md|_retired|wiki/|decisions|\.cloud-'); echo "$N" | grep -c .` → `1`, and `grep -qi brush "$U/$N"` succeeds (exactly one note was added since setup, and it is about the brushing assumption; below, `N="$U/$N"`). `$HEAD0` is the user-clone HEAD recorded in setup. If `0`: settle neither received a note from noter nor recovered the bet from the transcript (Step 1, second bullet). If `>1`: duplicates or a split; list them.
3. `grep -E '^origin:' "$N"` → `origin: note` or `origin: transcript` (not `filed`: this is a bet, not a user statement).
4. `grep -cE 'transcripts/ai-lab-sleep-project/[0-9a-f-]+/(main|subagents/agent-[0-9a-f]+)\.jsonl#[0-9a-f-]{36}' "$N"` → `≥ 1`.
5. `python3 "$U/scripts/bet-dossier.py" "$N" | grep -c 'Could not resolve'` → `0`, and `python3 "$U/scripts/bet-dossier.py" "$N" | grep -c 'found by uuid'` → `≥ 1`.
6. `awk '/^## .*settle/{e=$0} END{print e}' "$U/agent-memory/_user/dream-log.md"` names a run after `$START`, and `tail -40 "$U/agent-memory/_user/dream-log.md" | grep -c "$(basename "$N" .md)"` → `≥ 1` (the ledger line for this note).
7. After promote: `git -C "$U" log -3 --format=%s` → contains `dream(relate)` and `dream(promote)`.
8. `grep -rl "$(basename "$N" .md)" "$U/agent-memory/noter/MEMORY.md" "$U/agent-memory/_main/ai-lab-sleep-project/MEMORY.md" 2>/dev/null | wc -l` → `≥ 1` (the index of the root that holds `$N` names it, so the next noter run can find it).

## Teardown
Leave everything: the note, the dream-log entries and the transcripts are
real lab data. Make sure `$U/.dream-phase` does not exist.
