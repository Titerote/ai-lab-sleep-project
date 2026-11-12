# instructions/

Project instructions that are too long to live in `CLAUDE.md` or as a
one-topic rule under `.claude/rules/`: procedures, checklists, how a
workflow is done here. Functional type: *project instructions* (yours;
changed by PR; the dream proposes, never edits).

Nothing in this folder is loaded on its own. Claude Code loads `CLAUDE.md`
and `.claude/rules/` automatically; a file here is read when `CLAUDE.md` or
a rule points at it ("before X, read `instructions/x.md`"), the same way
the coach repo's `docs/` works. Keep each file to one procedure, and keep
the pointer in `CLAUDE.md` current.
