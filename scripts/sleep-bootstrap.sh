#!/usr/bin/env bash
# SessionStart: make sure the user repo and the transcripts repo are present
# and fresh. The only script a project has to carry; everything else lives in
# ai-lab-sleep-user. Safe to re-run; never fails the session.
SLEEP_HOME="${SLEEP_HOME:-$HOME/.ai-lab-sleep}"
mkdir -p "$SLEEP_HOME"
clone_or_pull() { # <url> <dir>
  if [ -d "$2/.git" ]; then git -C "$2" pull -q --ff-only 2>/dev/null || git -C "$2" pull -q --rebase --autostash 2>/dev/null
  else git clone -q "$1" "$2" 2>/dev/null; fi
}
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then base=https://github.com/Titerote; else base=git@github.com:Titerote; fi
clone_or_pull "$base/ai-lab-sleep-user.git" "$SLEEP_HOME/user"
clone_or_pull "$base/ai-lab-sleep-transcripts.git" "$SLEEP_HOME/transcripts"
chmod +x "$SLEEP_HOME"/user/scripts/*.sh 2>/dev/null

# Cloud: the git proxy only injects credentials for repos attached to the
# session, and attaching several repos disables the repo's hooks. So when the
# environment provides SLEEP_GH_TOKEN (a fine-grained PAT scoped to the two
# sleep repos), answer github.com credential prompts from it, on these two
# clones only. The token stays in the environment; nothing is written to disk.
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ] && [ -n "${SLEEP_GH_TOKEN:-}" ]; then
  for d in "$SLEEP_HOME/user" "$SLEEP_HOME/transcripts"; do
    [ -d "$d/.git" ] || continue
    git -C "$d" config credential.helper '!f(){ echo username=x-access-token; echo "password=$SLEEP_GH_TOKEN"; }; f'
    git -C "$d" config credential.useHttpPath false
  done
fi

# Symlinks are made by install-mac.sh / cloud-setup.sh; here only repair if missing.
mkdir -p "$HOME/.claude"
[ -e "$HOME/.claude/agents" ]       || ln -sfn "$SLEEP_HOME/user/agents" "$HOME/.claude/agents"
[ -e "$HOME/.claude/agent-memory" ] || ln -sfn "$SLEEP_HOME/user/agent-memory" "$HOME/.claude/agent-memory"
exit 0
