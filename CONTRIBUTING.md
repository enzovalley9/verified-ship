# Contributing

Contributions should keep this repository useful across organizations, operating systems, and codebases.

## Development rules

1. Keep both marketplace entries, both plugin manifests, the shared skill directory, and skill frontmatter aligned.
2. Keep `SKILL.md` focused. Put large examples or templates in `references/` or `assets/`.
3. Do not add personal names, private repository names, organization-specific paths, credentials, tokens, or production identifiers.
4. Use fictional data in examples and eval fixtures.
5. Update `evals/evals.json` when behavior or triggering changes.
6. Validate JSON, YAML frontmatter, and repository privacy checks before opening a pull request.

## Suggested checks

```bash
jq empty .agents/plugins/marketplace.json
jq empty .claude-plugin/marketplace.json
jq empty plugins/verified-ship/.codex-plugin/plugin.json
jq empty plugins/verified-ship/.claude-plugin/plugin.json
claude plugin validate --strict .
ruby -e 'require "yaml"; YAML.safe_load(File.read(ARGV[0]).split(/^---\s*$\n/)[1])' \
  plugins/verified-ship/skills/verified-ship/SKILL.md
grep -rniE 'password|secret|token|api[_-]?key|private key' . \
  --exclude=LICENSE --exclude-dir=.git
```

Run any skill-specific evals before publishing a release.
