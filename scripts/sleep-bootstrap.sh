#!/usr/bin/env bash
# SessionStart: make sure the user repo and the transcripts repo are present
# and fresh. The only script a project has to carry; everything else lives in
# ai-lab-sleep-user. Safe to re-run; never fails the session.
SLEEP_HOME="${SLEEP_HOME:-$HOME/.ai-lab-sleep}"
mkdir -p "$SLEEP_HOME"
clone_or_pull() { # <url> <dir>
  if [ -d "$2/.git" ]; then git -C "$2" pull -q --ff-only 2>/dev/null || git -C "$2" pull -q --rebase 2>/dev/null
  else git clone -q "$1" "$2" 2>/dev/null; fi
}
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then base=https://github.com/Titerote; else base=git@github.com:Titerote; fi
clone_or_pull "$base/ai-lab-sleep-user.git" "$SLEEP_HOME/user"
clone_or_pull "$base/ai-lab-sleep-transcripts.git" "$SLEEP_HOME/transcripts"
chmod +x "$SLEEP_HOME"/user/scripts/*.sh 2>/dev/null
# Symlinks are made by install-mac.sh / cloud-setup.sh; here only repair if missing.
mkdir -p "$HOME/.claude"
[ -e "$HOME/.claude/agents" ]       || ln -sfn "$SLEEP_HOME/user/agents" "$HOME/.claude/agents"
[ -e "$HOME/.claude/agent-memory" ] || ln -sfn "$SLEEP_HOME/user/agent-memory" "$HOME/.claude/agent-memory"
exit 0
