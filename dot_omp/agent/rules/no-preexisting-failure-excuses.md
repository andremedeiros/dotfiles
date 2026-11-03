---
name: no-preexisting-failure-excuses
description: "Never wave off a failure, bug, or warning as pre-existing / unrelated to your change; own it and fix it"
condition:
  - "(?i)pre[- ]?existing\\W+(?:\\w+\\W+){0,3}?(?:fail|failure|failing|bug|issue|error|warning|breakage|problem|regression|flak|lint|test|type ?error|crash)"
  - "(?i)(?:fail\\w*|bug|issue|error|warning|breakage|problem|test)s?\\W+(?:\\w+\\W+){0,3}?(?:is|are|was|were|seems?|appears?)\\W+(?:\\w+\\W+){0,1}?pre[- ]?existing"
  - "(?i)(?:unrelated|not related|orthogonal) to (?:my|our|the|this|these) (?:change|edit|diff|work|refactor|fix|pr|patch)"
  - "(?i)not (?:caused|introduced|triggered) by (?:my|our|the|this|these) (?:change|edit|diff|work|refactor|fix|pr|patch)"
  - "(?i)(?:already|was|were) (?:failing|broken|red) (?:on|in|before|prior)"
  - "(?i)(?:fails|failing|broken|red) on (?:main|master|trunk|the base branch|HEAD)(?: too| as well| already)?"
  - "(?i)existed before (?:my|our|this|these|the) (?:change|edit|diff|work)"
scope: text
interruptMode: always
---

## No "pre-existing" excuses

You just started to dismiss a failure, bug, warning, or broken test as pre-existing, already failing, or unrelated to your change. Stop. Provenance is not a reason to leave something broken: the user asked for working software, not an alibi.

Do this instead:

1. **Own it.** A failure you saw is in scope. Diagnose its root cause the same way you would if your own change caused it.
2. **Fix it.** Make the real fix. Never skip, disable, mark xfail, or loosen the test, and never suppress the warning to make it go away.
3. **Prove it.** Re-run the exact failing command and show it passing.

Only when a fix is genuinely out of reach (it needs credentials or infra you lack, a product decision, or a large redesign) may you stop. In that case, show evidence that it reproduces on a clean baseline (`git stash` or a worktree at the base commit, with the command and its output), name the root cause you found, and ask the user how to proceed. Do not claim "done" while it stays broken.

Never call a failure "pre-existing", "unrelated", or "already broken" as a reason to move on.
