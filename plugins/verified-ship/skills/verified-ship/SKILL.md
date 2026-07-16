---
name: verified-ship
description: Deliver a code change through scoped staging, repository-native checks, commit, push, and verified CI. Use this skill only when the user explicitly asks to ship, commit, push, publish, or take the change through CI; do not trigger it merely because implementation work is finished.
compatibility: Requires Git. Push and remote CI access are used only when explicitly authorized.
---

# Verified Ship

Move an intended change from working tree to verified delivery without absorbing unrelated work or overstating CI status.

## Confirm authorization and destination

Before mutating Git or a remote, establish:

- which repository or repositories are in scope;
- which files belong to the change;
- target branch and remote;
- whether commit is authorized;
- whether push is authorized;
- whether release, merge, or deployment is also authorized.

A request to commit does not automatically authorize push. A request to push does not automatically authorize merge or deployment.

## Inspect state and instructions

Read the applicable repository instructions and inspect:

```bash
git status --short
git diff --stat
git diff
git branch --show-current
git remote -v
```

Identify unrelated modifications and preserve them. If changes overlap or ownership is unclear, stop before staging.

## Discover repository-native checks

Use the project's documented commands and manifests. Select checks proportional to the change:

- formatting or lint;
- type checking or compilation;
- focused tests;
- integration tests for changed boundaries;
- build or packaging;
- rendered or interactive verification for user-facing changes.

Run focused checks first. Run broader checks when repository policy or risk requires them. Record exact commands and results.

## Stage deliberately

Stage only intended paths:

```bash
git add <path>...
git diff --cached --stat
git diff --cached
```

Do not use broad staging when unrelated work exists. Re-check that generated files, secrets, local configuration, and debug output are absent.

## Commit only when authorized

Use the repository's message convention. Before committing:

- confirm staged scope;
- confirm required checks passed;
- confirm hooks are allowed to run;
- avoid bypassing hooks unless the user explicitly accepts the reason.

Record the resulting commit identifier.

## Synchronize and push safely

Inspect remote divergence before rebasing, merging, or pushing. Do not rewrite shared history or force-push without explicit authorization.

Push only when the user has authorized it. Report the exact remote and branch.

## Verify CI

Associate the CI run with the pushed commit. Watch or poll with a bounded strategy:

- capture workflow and run identifier;
- inspect failed jobs and relevant logs;
- stop blind polling after repeated unchanged results;
- fix and repeat only within the authorized scope.

Say `CI passed` only after the run for the delivered commit is observed passing. If CI is absent, queued, skipped, cancelled, or unrelated, report that exact state.

## Multi-repository delivery

Order repositories by dependency. Complete checks, commit, push, and CI evidence for each repository separately. Do not hide a partial failure behind an overall success statement.

## Final report

Include:

- repository, branch, and commit;
- files delivered;
- checks run and results;
- push destination;
- CI workflow, run, and conclusion;
- anything intentionally not included;
- any remaining release or deployment step.

Never equate a local commit with remote delivery.
