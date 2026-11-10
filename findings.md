# Findings

| date | test | claude --version | env | observation |
|---|---|---|---|---|
| 2026-11-10 | T0/T3 | 2.1.322 | Desktop+cloud | setup-script symlinks work: all lab agents listed; CLAUDE.md (lab-7f3a) and rule (lab-2c9e) markers loaded; memory marker (lab-c3e8) not loaded |
| 2026-11-10 | T3 | 2.1.322 | cloud | all five hook events fire from repo settings.json; harness has its own Stop/SessionStart hooks in /root/.claude/launcher-settings.json |
| 2026-11-10 | T3 | 2.1.322 | cloud | push to a repo not attached to the session: 403 from the git proxy ("not in this session's authorized repository set"); reads/clones of App-installed repos work |
| 2026-11-10 | T0b | 2.1.322 | cloud | auto memory inactive: write probe wrote nothing to the relocated or default folder; autoMemoryDirectory not loaded |
| 2026-11-10 | T2 | 2.1.322 | cloud | SessionEnd reason=other fired ~4.5 min after last Stop (idle pause); SessionStart source=resume 45 min later on the same VM, files intact; seconds_since_last_response in resume input |
| 2026-11-10 | T1/T3 | 2.1.322 | cloud | SubagentStop carries agent_transcript_path under <session>/subagents/, but the directory is absent afterwards and the ship 27 s later found nothing; main transcript captured |
| 2026-11-10 | T0 | 2.1.322 | Desktop+cloud | no terminal in this view; observations via the session's Bash tool |
