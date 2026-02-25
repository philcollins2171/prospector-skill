#!/bin/bash
set +x +v

REPO="https://raw.githubusercontent.com/philcollins2171/prospector-skill/main"
DEST="$HOME/.claude/skills/prospector"

mkdir -p "$DEST"

if ! curl -fsSL "$REPO/.claude/skills/prospector/SKILL.md" -o "$DEST/SKILL.md" 2>/dev/null; then
  echo "❌ Échec du téléchargement. Vérifier la connexion internet."
  exit 1
fi

echo "✅ Skill Prospector installé dans $DEST"
echo "→ Lancer /prospector dans Claude Code pour démarrer la configuration."
