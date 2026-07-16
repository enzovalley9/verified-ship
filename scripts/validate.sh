#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAME="verified-ship"
PLUGIN="$ROOT/plugins/$NAME"
SKILL="$PLUGIN/skills/$NAME"

jq -e --arg name "$NAME" '
  .name == $name
  and .version == "0.1.0"
  and .license == "MIT"
  and .skills == "./skills/"
' "$PLUGIN/.codex-plugin/plugin.json" >/dev/null

jq -e --arg name "$NAME" '
  .name == $name
  and .plugins[0].name == $name
  and .plugins[0].source.source == "local"
  and .plugins[0].source.path == ("./plugins/" + $name)
  and .plugins[0].policy.installation == "AVAILABLE"
  and .plugins[0].policy.authentication == "ON_INSTALL"
' "$ROOT/.agents/plugins/marketplace.json" >/dev/null

jq -e --arg name "$NAME" '
  .name == $name
  and (.description | type == "string")
  and .plugins[0].name == $name
  and .plugins[0].source == ("./plugins/" + $name)
' "$ROOT/.claude-plugin/marketplace.json" >/dev/null

jq -e --arg name "$NAME" '
  .name == $name
  and .version == "0.1.0"
  and (.description | type == "string")
' "$PLUGIN/.claude-plugin/plugin.json" >/dev/null

grep -q '^## INIT PROMPT$' "$ROOT/README.md"
grep -q 'claude plugin marketplace add' "$ROOT/README.md"

jq -e --arg name "$NAME" '
  .skill_name == $name
  and (.evals | type == "array")
  and (.evals | length >= 3)
' "$SKILL/evals/evals.json" >/dev/null

ruby -EUTF-8:UTF-8 -ryaml -e '
  text = File.read(ARGV[0])
  match = text.match(/^---\n(.*?)\n---/m) or abort("invalid frontmatter")
  data = YAML.safe_load(match[1])
  allowed = %w[name description license allowed-tools metadata compatibility]
  extra = data.keys - allowed
  abort("unexpected frontmatter keys: #{extra.join(", ")}") unless extra.empty?
  abort("name mismatch") unless data["name"] == ARGV[1]
  abort("description missing") unless data["description"].is_a?(String) && !data["description"].empty?
  abort("description too long") if data["description"].length > 1024
  abort("compatibility too long") if data["compatibility"].to_s.length > 500
' "$SKILL/SKILL.md" "$NAME"

ruby -EUTF-8:UTF-8 -ryaml -e '
  data = YAML.safe_load(File.read(ARGV[0]))
  abort("missing interface") unless data["interface"].is_a?(Hash)
  abort("missing display_name") unless data["interface"]["display_name"]
  abort("missing default_prompt") unless data["interface"]["default_prompt"]
' "$SKILL/agents/openai.yaml"

if grep -rnE --exclude-dir=.git '\[(T)(O)(D)(O)|(T)(O)(D)(O):' "$ROOT"; then
  echo "Unresolved placeholder found" >&2
  exit 1
fi

echo "$NAME validation passed"
