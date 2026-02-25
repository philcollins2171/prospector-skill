#!/bin/bash
set +x +v

REPO="https://raw.githubusercontent.com/philcollins2171/prospector-skill/main"
DEST="$HOME/.claude/skills/prospector"

if ! mkdir -p "$DEST"; then
  echo "❌ Impossible de créer $DEST (droits insuffisants ?)"
  exit 1
fi

if ! curl -fsSL "$REPO/.claude/skills/prospector/SKILL.md" -o "$DEST/SKILL.md"; then
  echo "❌ Échec du téléchargement depuis GitHub."
  exit 1
fi

echo "✅ Skill Prospector installé dans $DEST"
echo "→ Lancer /prospector dans Claude Code pour démarrer la configuration."
