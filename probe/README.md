Hook probe logs land here as `<event>.jsonl` (gitignored). `ship.sh` copies
them into the transcripts repo under the session, so they survive a reclaimed
cloud VM only if a ship ran after they were written — which is itself a T2
data point.
