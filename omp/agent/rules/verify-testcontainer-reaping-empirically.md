---
name: verify-testcontainer-reaping-empirically
description: "Never claim test containers are cleaned up without checking every runtime state (created/exited/stopped), not just running ones"
condition: ["podman ps -a --format[^\\n]*\\|\\s*wc -l", "\\(empty = reaped\\)", "podman ps -a[^\\n]*\\n[^\\n]*sleep", "docker ps(?!\\s+-a)"]
scope: "tool:bash"
---

## Prove container cleanup, don't infer it

An empty `podman ps -a` / `docker ps -a` snapshot at one moment is NOT proof that reaping works. Ryuk only reaps containers it labelled, only after its reconnection timeout, and only for sessions whose test binary exited cleanly. Containers left in `Created`/`Exited` state by a failed or timed-out run are never reaped at all.

Before claiming cleanup is correct:

1. Snapshot **all states with labels**, not names only:
   `podman ps -a --filter label=org.testcontainers=true --format '{{.Names}}\t{{.Status}}\t{{.Labels}}'`
2. Also snapshot **unlabelled** leftovers — containers the product code (not testcontainers) created:
   `podman ps -a --format '{{.Names}}\t{{.Status}}'`
3. Exercise the **failure** path, not just the happy path: force a run to fail/timeout, then re-check. Orphans in `Created` state are the actual bug.
4. Volumes and networks leak too: `podman volume ls`, `podman network ls`.

If any state can leak, fix ownership rather than relying on ryuk: give the package a `TestMain` that calls `testcontainers.TerminateContainer(ctr)` (or an explicit `t.Cleanup`) so cleanup happens even when startup fails, and add a `make clean-containers` target that prunes by label. Only claim "reaped" after showing the empty result for every state and every leaked resource kind.