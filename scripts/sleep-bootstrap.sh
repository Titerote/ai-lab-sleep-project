#!/usr/bin/env bash
# SessionStart: make sure the user repo (agents + memory + scripts) is present
# and fresh, then inject the memory indexes auto memory does not load. The
# only script a project has to carry; everything else lives in
# ai-lab-sleep-user. Safe to re-run; never fails the session.
#
# Hooks in one SessionStart group run in parallel, so the injection is run
# from here, after the pull, rather than as a sibling hook: on a VM restored
# from a snapshot the sibling would run before the script exists.
#
# Transcripts need no extra repo: ship.sh writes them to an orphan branch of
# this project's own origin (sleep/transcripts), which is the one remote a
# cloud session is allowed to push to.
SLEEP_HOME="${SLEEP_HOME:-$HOME/.ai-lab-sleep}"
mkdir -p "$SLEEP_HOME"
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then base=https://github.com/Titerote; else base=git@github.com:Titerote; fi
if [ -d "$SLEEP_HOME/user/.git" ]; then
  git -C "$SLEEP_HOME/user" pull -q --ff-only 2>/dev/null || git -C "$SLEEP_HOME/user" pull -q --rebase --autostash 2>/dev/null
else
  git clone -q "$base/ai-lab-sleep-user.git" "$SLEEP_HOME/user" 2>/dev/null
fi
chmod +x "$SLEEP_HOME"/user/scripts/*.sh 2>/dev/null
# Symlinks are made by install-mac.sh / cloud-setup.sh; here only repair if missing.
mkdir -p "$HOME/.claude"
[ -e "$HOME/.claude/agents" ]       || ln -sfn "$SLEEP_HOME/user/agents" "$HOME/.claude/agents"
[ -e "$HOME/.claude/agent-memory" ] || ln -sfn "$SLEEP_HOME/user/agent-memory" "$HOME/.claude/agent-memory"
# Memory indexes into the session context (stdout of a SessionStart hook is added as context).
[ -f "$SLEEP_HOME/user/scripts/inject-memory.sh" ] && bash "$SLEEP_HOME/user/scripts/inject-memory.sh"
exit 0
