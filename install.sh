#!/bin/bash
# Installe le skill Prospector dans le projet courant

DEST=".claude/skills/prospector"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$DEST"
cp "$SCRIPT_DIR/.claude/skills/prospector/SKILL.md" "$DEST/SKILL.md"

# Ajoute les fichiers sensibles au .gitignore
for entry in ".mcp.json" ".prospector.json"; do
  grep -qxF "$entry" .gitignore 2>/dev/null || echo "$entry" >> .gitignore
done

echo "✅ Skill Prospector installé dans $DEST"
echo "→ Ouvrir Claude Code dans ce répertoire et lancer /prospector"
