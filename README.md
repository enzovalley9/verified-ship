# Verified Ship

> A disciplined path from working tree to verified CI.

## INIT PROMPT

Copy this prompt into any agentic LLM session that has filesystem access to this repository:

```text
Install the "verified-ship" skill from this repository for the agent environment in which you are running.

Read this README and plugins/verified-ship/skills/verified-ship/SKILL.md first. Treat plugins/verified-ship/skills/verified-ship as the canonical skill directory. Detect whether the current environment is Claude Code, Codex, or another agent that supports directory-based skills. Prefer the environment's native plugin or marketplace installation command when available. Otherwise, copy or symlink the canonical skill directory into the documented user skill directory, such as ~/.claude/skills/verified-ship for Claude Code or ~/.codex/skills/verified-ship for Codex.

Before making changes, inspect existing installations and preserve user-owned files. Do not overwrite an existing skill without explicit approval. Do not install unrelated components, commit, push, publish, or edit the skill's behavior. After installation, verify that the installed SKILL.md is readable, that its frontmatter name is "verified-ship", and that the agent can discover the skill. Report the exact installation method and destination path. If this environment cannot install directory-based skills, explain the exact limitation and stop.
```

## What it does

Verified Ship discovers repository-native checks, stages only the intended change, commits and pushes only within the user's authorization, and verifies the CI run associated with the delivered commit.

## Why it exists

Delivery failures often come from scope contamination, skipped checks, ambiguous push authority, or claiming that unrelated CI proves the change. This skill makes each boundary explicit.

## Capabilities

- Confirms repository, files, branch, remote, and authorization.
- Preserves unrelated working-tree changes.
- Discovers and runs proportional repository-native checks.
- Reviews the staged diff before committing.
- Separates commit, push, merge, release, and deployment permissions.
- Associates CI evidence with the exact pushed commit.
- Reports partial multi-repository delivery honestly.

## What it is not

- Automatic permission to commit or push.
- Permission to merge, release, or deploy.
- A fixed set of JavaScript-only commands.
- A reason to bypass hooks or force-push.

## Workflow

1. Confirm scope and authorization.
2. Inspect Git state, instructions, branch, and remotes.
3. Discover and run relevant checks.
4. Stage exact paths and review the staged diff.
5. Commit and push only when authorized.
6. Verify CI for the delivered commit.
7. Report repository-by-repository evidence.

## Safety model

Authorization is granular. Finishing implementation does not imply permission to commit, push, merge, release, or deploy.

## Repository layout

```text
.
├── .agents/plugins/marketplace.json       # Codex marketplace
├── .claude-plugin/marketplace.json        # Claude Code marketplace
├── plugins/verified-ship/
│   ├── .codex-plugin/plugin.json          # Codex plugin
│   ├── .claude-plugin/plugin.json         # Claude Code plugin
│   └── skills/verified-ship/
│       ├── SKILL.md                       # shared behavior
│       ├── agents/openai.yaml              # Codex UI metadata
│       ├── evals/evals.json
│       └── assets/                         # when bundled
├── AGENTS.md
├── CONTRIBUTING.md
├── SECURITY.md
├── CHANGELOG.md
└── LICENSE
```

The behavioral source of truth is [SKILL.md](plugins/verified-ship/skills/verified-ship/SKILL.md). Both Claude Code and Codex load this same file. Codex-specific UI metadata lives in [openai.yaml](plugins/verified-ship/skills/verified-ship/agents/openai.yaml).

## Bundled resources

- `evals/evals.json` - dirty-tree, commit-only, and no-authorization scenarios.

## Local installation in Codex

From this repository:

```bash
codex plugin marketplace add .
codex plugin add verified-ship@verified-ship
```

To remove it later:

```bash
codex plugin remove verified-ship
codex plugin marketplace remove verified-ship
```

## Local installation in Claude Code

From this repository:

```bash
claude plugin marketplace add .
claude plugin install verified-ship@verified-ship
```

To remove it later:

```bash
claude plugin uninstall verified-ship@verified-ship
claude plugin marketplace remove verified-ship
```

Both local marketplace flows use the same canonical `SKILL.md` and do not require a GitHub remote.

## Installation from GitHub

Codex:

```bash
codex plugin marketplace add enzovalley9/verified-ship --ref main
codex plugin add verified-ship@verified-ship
```

Claude Code:

```bash
claude plugin marketplace add enzovalley9/verified-ship
claude plugin install verified-ship@verified-ship
```

Public repository: <https://github.com/enzovalley9/verified-ship>

## Manual skill installation

Directory-based agents can use the skill without a marketplace. From the repository root, link it into one or both supported user directories:

```bash
mkdir -p ~/.codex/skills ~/.claude/skills
ln -s "$(pwd)/plugins/verified-ship/skills/verified-ship" ~/.codex/skills/verified-ship
ln -s "$(pwd)/plugins/verified-ship/skills/verified-ship" ~/.claude/skills/verified-ship
```

Install only the path needed by the target agent. Use a copy instead of a symlink if the environment cannot follow links, and inspect any existing destination before replacing it.

## Evaluation

Initial review prompts live in [evals/evals.json](plugins/verified-ship/skills/verified-ship/evals/evals.json). They cover intended triggers, important safety boundaries, and at least one near-miss or proportionality case.

The eval prompts are included for maintainer review. They have not yet been benchmarked against a baseline, so this draft does not claim an eval score.

## Automated validation

Run the same structural checks used by CI:

```bash
bash scripts/validate.sh
```

The included GitHub Actions workflow validates the Codex and Claude Code marketplace and plugin manifests, shared skill frontmatter, Codex UI metadata, and eval structure, then runs a secret scan.

## Contributing

Before publication or a pull request:

1. Keep examples fictional and organization-neutral.
2. Validate the marketplace JSON and plugin manifest with `jq`.
3. Parse the `SKILL.md` YAML frontmatter.
4. Search for credentials, personal data, private paths, and internal identifiers.
5. Run or review the bundled eval scenarios.
6. Record behavior changes in `CHANGELOG.md`.

See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md).

## License

MIT. See [LICENSE](LICENSE).
