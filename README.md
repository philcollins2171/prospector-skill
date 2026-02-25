# Prospector Skill — Claude Code

Skill Claude Code pour gérer votre prospection LinkedIn via Airtable Prospector.

## Installation

### En 1 commande

```bash
git clone https://github.com/philcollins2171/prospector-skill /tmp/prospector-skill && bash /tmp/prospector-skill/install.sh
```

Ou via curl :

```bash
curl -fsSL https://raw.githubusercontent.com/philcollins2171/prospector-skill/main/install.sh | bash
```

### Manuellement

Copier le dossier `.claude/` à la racine de votre projet.

## Prérequis

- [Claude Code](https://claude.ai/code) installé
- Un compte [Airtable](https://airtable.com) avec la base **Prospector**

## Premier lancement

Ouvrir Claude Code dans votre projet et taper :

```
/prospector
```

Le wizard de configuration démarre automatiquement :
1. Création de votre Personal Access Token Airtable (instructions incluses)
2. Saisie de votre Base ID Airtable

## Sous-commandes disponibles

| Commande | Description |
|---|---|
| `/prospector` | Vue pipeline |
| `/prospector pipeline` | Kanban commercial complet |
| `/prospector hot-leads` | Prospects chauds à traiter en priorité |
| `/prospector quota` | Quotas LinkedIn et état des automatisations |
| `/prospector toggle` | Activer / mettre en pause les automatisations |
| `/prospector add-lead` | Ajouter un prospect manuellement |
| `/prospector search` | Rechercher un prospect |
| `/prospector relances` | Relances à effectuer |
| `/prospector meeting` | Gérer les rendez-vous |
| `/prospector new-campaign` | Créer une offre + campagne |
| `/prospector list-offers` | Lister les offres |
| `/prospector list-campaigns` | Lister les campagnes |
| `/prospector stats` | Statistiques globales |
| `/prospector setup` | Reconfigurer (token ou base ID) |

## Fichiers générés (ignorés par git)

- `.mcp.json` — configuration du connecteur Airtable (contient votre token)
- `.prospector.json` — identifiant de votre base Airtable
