#!/bin/bash
# Installe le skill Prospector dans le projet courant

REPO="https://raw.githubusercontent.com/philcollins2171/prospector-skill/main"
DEST=".claude/skills/prospector"

mkdir -p "$DEST"

if ! curl -fsSL "$REPO/.claude/skills/prospector/SKILL.md" -o "$DEST/SKILL.md"; then
  echo "❌ Échec du téléchargement. Vérifier la connexion internet."
  exit 1
fi

# Ajoute les fichiers sensibles au .gitignore
for entry in ".mcp.json" ".prospector.json"; do
  grep -qxF "$entry" .gitignore 2>/dev/null || echo "$entry" >> .gitignore
done

echo "✅ Skill Prospector installé dans $DEST"
echo "→ Ouvrir Claude Code dans ce répertoire et lancer /prospector"
