#!/usr/bin/env bash
# tests/run.sh <id> [attempts] [minutes-per-attempt]
#
# Outer loop around the lab-runner agent. Each attempt is a fresh interactive
# `claude --agent lab-runner` session (so fixes to agents/*.md made by the
# previous attempt are loaded), started headless on a pty, left to run until
# it commits its result file, then closed so the SessionEnd hook ships the
# transcript. Stops at the first passed result or after <attempts>.
#
# Subscription billing only: this is the interactive CLI, not `claude -p`.
# Run from the project checkout. Logs: /tmp/lab-<id>-a<n>.log (raw TUI).
set -u
ID="${1:?test id, e.g. T6-fresh-locators}"
MAX="${2:-3}"
MINUTES="${3:-45}"
U="${SLEEP_HOME:-$HOME/.ai-lab-sleep}/user"
CLAUDE="${CLAUDE_BIN:-$(command -v claude)}"
[ -x "$CLAUDE" ] || { echo "claude not found" >&2; exit 2; }
[ -f "tests/$ID.md" ] || { echo "tests/$ID.md not found (run from the project checkout)" >&2; exit 2; }
mkdir -p tests/results

for n in $(seq 1 "$MAX"); do
  git pull -q --ff-only || true
  git -C "$U" pull -q --ff-only || true
  rm -f "$U/.dream-phase"
  RESULT="tests/results/$ID-$(date -u +%Y-%m-%d)-a$n.md"
  LOG="/tmp/lab-$ID-a$n.log"
  PROMPT="Run tests/$ID.md. This is attempt $n of $MAX; write the result file to $RESULT. Earlier attempts' results are in tests/results/ — read the latest one first and do not repeat a fix it already made."
  echo "== attempt $n/$MAX  $(date -u +%H:%M:%SZ)  result: $RESULT  log: $LOG"
  nohup script -q "$LOG" "$CLAUDE" --agent lab-runner "$PROMPT" >/dev/null 2>&1 </dev/null &
  start=$(date +%s)
  verdict=""
  while :; do
    sleep 30
    if [ -f "$RESULT" ] && [ -n "$(git log -1 --format=%h -- "$RESULT" 2>/dev/null)" ]; then
      verdict=$(head -1 "$RESULT" | grep -oE 'passed|failed' | head -1)
      [ -n "$verdict" ] && break
    fi
    if ! pgrep -qf "claude --agent lab-runner"; then
      echo "   runner exited without a committed result" ; verdict="aborted"; break
    fi
    if [ $(( $(date +%s) - start )) -gt $(( MINUTES * 60 )) ]; then
      echo "   timeout after $MINUTES min"; verdict="timeout"; break
    fi
  done
  sleep 5
  pkill -f "claude --agent lab-runner" 2>/dev/null
  for i in 1 2 3 4 5 6; do pgrep -qf "claude --agent lab-runner" || break; sleep 5; done
  rm -f "$U/.dream-phase"
  echo "   verdict: $verdict"
  [ "$verdict" = "passed" ] && exit 0
done
exit 1
