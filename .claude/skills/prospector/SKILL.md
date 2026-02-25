---
name: prospector
description: Gestionnaire Prospector - gerer la prospection LinkedIn (pipeline, leads chauds, relances, RDV, quotas, campagnes, offres, statistiques).
argument-hint: [setup|pipeline|hot-leads|quota|toggle|add-lead|search|relances|meeting|new-campaign|list-offers|list-campaigns|stats|edit-offer|edit-campaign]
allowed-tools: AskUserQuestion, Read, Write, mcp__airtable__list_records, mcp__airtable__create_record, mcp__airtable__update_records, mcp__airtable__search_records, mcp__airtable__get_record, mcp__airtable__describe_table, mcp__airtable__create_field
---

# Prospector - Gestionnaire de prospection LinkedIn

Tu es un assistant qui aide a gerer la prospection LinkedIn via le template Airtable **Prospector**.

## Démarrage : Vérification de la configuration

**Avant toute sous-commande**, effectuer les 2 vérifications suivantes dans l'ordre.

### Étape A — MCP Airtable

Lire le fichier `.mcp.json` dans le répertoire courant.

- Si le fichier **n'existe pas** ou **ne contient pas** de section `mcpServers.airtable` → aller à **[Setup : Installation MCP]**
- Sinon → continuer à l'Étape B

### Étape B — BaseId

Lire le fichier `.prospector.json` dans le répertoire courant.

- Si le fichier **n'existe pas** ou **ne contient pas** le champ `baseId` → aller à **[Setup : Saisie BaseId]**
- Sinon → charger `baseId` depuis ce fichier et l'utiliser comme **Base ID** pour tous les appels Airtable

Si les deux étapes sont OK → continuer vers le **[Routage des sous-commandes]**.

---

## [Setup : Installation MCP]

Afficher :
```
⚙️ CONFIGURATION INITIALE — MCP Airtable

Le connecteur Airtable n'est pas encore configuré.
Je vais vous guider pour créer votre clé d'accès Airtable (Personal Access Token).
```

### Étape 1 : Instructions de création du token

Afficher les instructions suivantes mot pour mot :

```
📋 CRÉER VOTRE CLÉ AIRTABLE (2 minutes)
════════════════════════════════════════

1. Ouvrir : https://airtable.com/create/tokens
   (connexion à votre compte Airtable requise)

2. Cliquer "Create new token"

3. Remplir :
   • Nom       : Prospector Claude
   • Scopes    : cocher les 4 suivants :
       ✅ data.records:read
       ✅ data.records:write
       ✅ schema.bases:read
       ✅ schema.bases:write
   • Access    : "All current and future bases"
                 (ou sélectionner uniquement votre base Prospector)

4. Cliquer "Create token"

5. COPIER le token affiché (commence par "pat...")
   ⚠️  Il ne sera affiché qu'une seule fois.
```

### Étape 2 : Saisir le token

Via `AskUserQuestion`, demander :
- **Votre Personal Access Token Airtable** (le token commençant par "pat...")

Valider que la valeur commence bien par `pat`. Si ce n'est pas le cas, redemander.

### Étape 3 : Écrire `.mcp.json`

Écrire (ou fusionner) le fichier `.mcp.json` à la racine du projet avec le contenu suivant (en remplaçant TOKEN par la valeur saisie) :

```json
{
  "mcpServers": {
    "airtable": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "airtable-mcp-server"],
      "env": {
        "AIRTABLE_API_KEY": "TOKEN"
      }
    }
  }
}
```

Si `.mcp.json` existe déjà avec d'autres serveurs MCP, lire son contenu d'abord et fusionner (ajouter uniquement la section `airtable` sans écraser les autres).

### Étape 4 : Confirmer et demander redémarrage

Afficher :
```
✅ Configuration MCP Airtable enregistrée dans .mcp.json

⚠️  ACTION REQUISE : Redémarrer Claude Code
   Le connecteur Airtable sera actif au prochain démarrage.

   → Fermer cette session Claude Code
   → Rouvrir dans ce même répertoire
   → Relancer /prospector
```

Stopper l'exécution ici.

---

## [Setup : Saisie BaseId]

Afficher :
```
⚙️ CONFIGURATION INITIALE — Base Airtable

Dernière étape : identifier votre base Airtable Prospector.
```

Via `AskUserQuestion`, demander :
- **L'identifiant de votre base Airtable** (commence par "app...")

Instructions à afficher pour aider l'utilisateur à le trouver :
```
📋 TROUVER VOTRE BASE ID
════════════════════════
1. Ouvrir votre base Airtable Prospector dans le navigateur
2. L'URL ressemble à :
   https://airtable.com/appXXXXXXXXXXXXXX/...
3. Copier la partie "appXXXXXXXXXXXXXX"
```

Valider que la valeur commence par `app`. Si ce n'est pas le cas, redemander.

Écrire le fichier `.prospector.json` :
```json
{
  "baseId": "appXXXXXXXXXXXXXX"
}
```

Afficher :
```
✅ Configuration enregistrée.
```

Continuer vers le **[Routage des sous-commandes]**.

---

## Constantes

Les IDs de tables sont fixes pour toutes les bases Prospector :

- **Base ID**: dynamique — lu depuis `.prospector.json` (champ `baseId`)
- **Table Offres**: `tblPsGgjuFm9UISU4`
- **Table Campagnes** (nommee "Listes" dans Airtable): `tblZv6vnehZZQVGS8`
- **Table Contacts**: `tbld8SE8EicdEjihW`
- **Table Parametres**: `tblru8gj2bgB68HNb`
- **Table Messages envoyes**: `tbluSWYSPHUwXJ7mt`

## Routage des sous-commandes

Analyser `$ARGUMENTS` pour determiner la sous-commande :

- `setup` → Aller directement à **[Setup : Installation MCP]** (reset de la configuration)
- `pipeline` ou `pipe` → Aller a **[Sous-commande : pipeline]**
- `hot-leads` ou `hot` ou `leads-chauds` ou `urgents` → Aller a **[Sous-commande : hot-leads]**
- `quota` ou `quotas` ou `limites` → Aller a **[Sous-commande : quota]**
- `toggle` ou `activer` ou `pause` ou `automatisations` → Aller a **[Sous-commande : toggle]**
- `add-lead` ou `ajouter` ou `nouveau-prospect` → Aller a **[Sous-commande : add-lead]**
- `search` ou `recherche` ou `rechercher` → Aller a **[Sous-commande : search]**
- `relances` ou `relancer` ou `follow-ups` → Aller a **[Sous-commande : relances]**
- `meeting` ou `rdv` ou `rendez-vous` → Aller a **[Sous-commande : meeting]**
- `edit-offer` ou `modifier-offre` → Aller a **[Sous-commande : edit-offer]**
- `edit-campaign` ou `modifier-campagne` → Aller a **[Sous-commande : edit-campaign]**
- `new-campaign` ou `new` ou vide → Aller a **[Sous-commande : new-campaign]**
- `list-offers` ou `offers` → Aller a **[Sous-commande : list-offers]**
- `list-campaigns` ou `campaigns` → Aller a **[Sous-commande : list-campaigns]**
- `stats` → Aller a **[Sous-commande : stats]**

Si `$ARGUMENTS` ne correspond a aucune sous-commande, demander a l'utilisateur ce qu'il souhaite faire via `AskUserQuestion`.

---

## [Sous-commande : pipeline]

Vue kanban du pipeline commercial par statut.

### Etape 1 : Recuperer les contacts par statut

Faire 7 appels paralleles a `mcp__airtable__list_records` sur la table Contacts (`tbld8SE8EicdEjihW`) :

1. `filterByFormula: "{Statut} = 'A INVITER'"` — a inviter sur LinkedIn
2. `filterByFormula: "{Statut} = 'A INITIER'"` — connexions a contacter
3. `filterByFormula: "{Statut} = 'A RELANCER'"` — a relancer
4. `filterByFormula: "{Statut} = 'QUALIFICATION'"` — en conversation active (**priorite commerciale**)
5. `filterByFormula: "{Statut} = 'INVITATION ENVOYEE'"` — invitations en attente
6. `filterByFormula: "{Statut} = 'QUALIFIE'"` — qualifies (**a convertir en RDV**)
7. `filterByFormula: "{Statut} = 'MEETING FIXE'"` — RDV confirmes

Pour chaque appel, recuperer les champs : `Nom complet`, `Titre`, `Entreprise`.

### Etape 2 : Afficher le pipeline

Presenter le pipeline sous forme de colonnes avec, pour chaque colonne : le nombre de prospects et les 3 premiers noms. Mettre en evidence **QUALIFICATION** (action urgente) et **QUALIFIE** (opportunites a convertir). Afficher separement les totaux : invitations envoyees, pas interesses, archives.

Exemple de rendu :
```
PIPELINE PROSPECTOR — [date du jour]
════════════════════════════════════════════════════════════

 A INVITER    A INITIER   A RELANCER   QUALIFICATION   QUALIFIE   MEETING FIXE
   [N]           [N]          [N]          [N] ⚡         [N] ✅      [N] 📅
  ────────     ────────     ────────     ────────────   ────────   ────────────
  • Dupont     • Martin     • Bernard    • Leroy         • Simon    • Mercier
  • Moreau     • Petit      • ...        • ...           • ...
  • ...

Invitations en attente : [N] | Pas interesses : [N] | Archives : [N]
```

### Etape 3 : Suggestions contextuelles

- Si QUALIFICATION > 0 : proposer `/prospector hot-leads` pour voir les conversations urgentes
- Si QUALIFIE > 0 : proposer `/prospector meeting` pour planifier les RDV
- Si A RELANCER > 0 : proposer `/prospector relances` pour voir les relances a effectuer

---

## [Sous-commande : hot-leads]

Liste des prospects chauds a traiter en priorite absolue.

### Etape 1 : Recuperer les leads urgents

Faire 2 appels paralleles sur la table Contacts (`tbld8SE8EicdEjihW`) :

1. Statut **QUALIFICATION** (ont repondu, attendent une reponse de ta part) :
   `filterByFormula: "{Statut} = 'QUALIFICATION'"`
   Champs : `Nom complet`, `Titre`, `Entreprise`, `Dernier message`, `Dernier message date`, `Analyse de la conversation`, `Reponse proposee`, `Strategie de reponse`, `Prochain message`, `Linkedin profil URL`

2. Statut **QUALIFIE** (a convertir en RDV) :
   `filterByFormula: "{Statut} = 'QUALIFIE'"`
   Champs : `Nom complet`, `Titre`, `Entreprise`, `Infos Qualif`, `Analyse de la conversation`, `Linkedin profil URL`

### Etape 2 : Afficher

**Section 1 — A repondre MAINTENANT**

Pour chaque contact en QUALIFICATION :
```
🔥 [Nom complet] — [Titre] @ [Entreprise]
   Dernier message recu : "[Dernier message]"
   Analyse IA           : [Analyse de la conversation]
   Reponse suggeree     : [Reponse proposee]
   Strategie            : [Strategie de reponse]
   LinkedIn             : [Linkedin profil URL]
```

Si `Reponse proposee` est vide : indiquer que l'IA n'a pas encore genere de reponse et suggerer d'activer `▶️ Reponse Auto` via `/prospector toggle`.

**Section 2 — A convertir en RDV**

Pour chaque contact QUALIFIE :
```
✅ [Nom complet] — [Titre] @ [Entreprise]
   Notes : [Infos Qualif]
   → Planifier un RDV : /prospector meeting
```

Si aucun lead chaud : "Pas de prospect chaud en ce moment. Consultez `/prospector pipeline` pour l'etat general."

---

## [Sous-commande : quota]

Quotas LinkedIn restants et etat des automatisations.

### Etape 1 : Identifier l'utilisateur

Lister les records de la table Parametres (`tblru8gj2bgB68HNb`). Si plusieurs utilisateurs, demander lequel consulter.

### Etape 2 : Lire et afficher

Recuperer le record Parametres et afficher :

```
📊 QUOTAS LINKEDIN — [date du jour]
════════════════════════════════════
[Contenu du champ "Quotas restants" formate proprement]

⚙️ AUTOMATISATIONS
════════════════════════════════════
▶️ Listes Auto      : [▶️ Activer / ⏸️ Pause]
▶️ Invitation Auto  : [▶️ Activer / ⏸️ Pause]
▶️ Contact Auto     : [▶️ Activer / ⏸️ Pause]
▶️ Relance Auto     : [▶️ Activer / ⏸️ Pause]
▶️ Reponse Auto     : [▶️ Activer / ⏸️ Pause]
▶️ Warmup           : [▶️ Activer / ⏸️ Pause]
▶️ Potentiel Auto   : [▶️ Activer / ⏸️ Pause]

→ Pour modifier : /prospector toggle
```

---

## [Sous-commande : toggle]

Activer ou mettre en pause les automatisations LinkedIn.

### Etape 1 : Identifier l'utilisateur

Lister les records de la table Parametres (`tblru8gj2bgB68HNb`). Si plusieurs utilisateurs, demander lequel.

### Etape 2 : Afficher l'etat actuel

Recuperer le record et afficher :
```
⚙️ AUTOMATISATIONS — [NAME]
════════════════════════════════════
1. ▶️ Listes Auto      : [etat]
2. ▶️ Invitation Auto  : [etat]
3. ▶️ Contact Auto     : [etat]
4. ▶️ Relance Auto     : [etat]
5. ▶️ Reponse Auto     : [etat]
6. ▶️ Warmup           : [etat]
7. ▶️ Potentiel Auto   : [etat]
```

### Etape 3 : Demander l'action

Via `AskUserQuestion`, demander :
- Quelle(s) automatisation(s) modifier (par numero ou nom)
- Ou : "Tout activer" / "Tout mettre en pause"

### Etape 4 : Appliquer

Mettre a jour le record Parametres via `mcp__airtable__update_records`.
- Valeur active : `▶️ Activer`
- Valeur pause : `⏸️ Pause`

Confirmer les changements.

---

## [Sous-commande : add-lead]

Ajouter un prospect manuellement dans une campagne.

### Etape 1 : Collecter les informations

Si `$ARGUMENTS` contient du texte apres `add-lead`, l'utiliser comme URL LinkedIn ou nom du prospect.

Via `AskUserQuestion` :
1. **URL LinkedIn** du prospect (`Linkedin profil URL`)
2. **Campagne** : lister les campagnes actives (`tblZv6vnehZZQVGS8`) et demander laquelle associer (afficher : Nom, Source, Offre liee)
3. **Icebreaker personnalise** (optionnel) : message specifique pour ce prospect (`Icebraker Manuel`)
4. **Le prospect est-il deja connecte ?** (oui/non) — important pour le statut initial

### Etape 2 : Creer le contact

Creer un record dans la table Contacts (`tbld8SE8EicdEjihW`) :
- `Linkedin profil URL` : URL saisie
- `Source` : `["record_id_campagne"]` (lien vers la campagne choisie)
- `Enrichir` : `🪄 Enrichir` (declenche l'enrichissement automatique du profil)
- `Icebraker Manuel` : si fourni par l'utilisateur

### Etape 3 : Confirmer

Afficher le resume et indiquer :
- L'enrichissement du profil demarrera automatiquement (si `▶️ Potentiel Auto` est actif)
- Le systeme le traitera lors de la prochaine execution de campagne
- Pour suivre son avancement : `/prospector search [nom ou URL]`

---

## [Sous-commande : search]

Rechercher un prospect par nom, entreprise ou titre.

### Etape 1 : Terme de recherche

Si `$ARGUMENTS` contient du texte apres `search`, l'utiliser directement. Sinon, demander a l'utilisateur.

### Etape 2 : Rechercher

Utiliser `mcp__airtable__search_records` sur la table Contacts (`tbld8SE8EicdEjihW`) avec le terme de recherche.

### Etape 3 : Afficher les resultats

Pour chaque contact :
```
👤 [Nom complet] — [Titre] @ [Entreprise]
   Statut       : [Statut]
   Localisation : [Localisation]
   Dernier msg  : [Dernier message date]
   LinkedIn     : [Linkedin profil URL]
```

Si plusieurs resultats, proposer d'afficher le detail complet d'un contact via `mcp__airtable__get_record`.

Detail complet inclut : analyse du potentiel, profil DISC, infos de qualification, historique conversation, follow-ups envoyes (dates Follow-up 1-5), video status, reponse proposee par l'IA.

Si aucun resultat : "Aucun contact trouve pour '[terme]'. Pour l'ajouter : `/prospector add-lead`"

---

## [Sous-commande : relances]

Liste des prospects a relancer en priorite.

### Etape 1 : Recuperer les relances

Faire 2 appels paralleles :

1. Contacts en statut **A RELANCER** :
   `filterByFormula: "{Statut} = 'A RELANCER'"` sur table Contacts (`tbld8SE8EicdEjihW`)
   Champs : `Nom complet`, `Titre`, `Entreprise`, `Dernier message`, `Dernier message date`, `Sélection dans Listes`

2. Messages sans reponse depuis 3+ jours :
   `filterByFormula: "{A relancer ?} = 1"` sur table Messages envoyes (`tbluSWYSPHUwXJ7mt`)
   Champs : `Nom`, `Linkedin profil URL`, `Message envoyé`, `Date d'envoi`, `Durée sans réponse`

### Etape 2 : Afficher

Trier par anciennete (les plus anciens en premier).

```
🔔 RELANCES A EFFECTUER — [date du jour]
════════════════════════════════════════
[N] contacts en statut A RELANCER :

• [Nom complet] — [Titre] @ [Entreprise]
  Campagne : [Sélection dans Listes]
  Dernier contact : [Dernier message date]

[N] messages sans reponse (3+ jours) :

• [Nom] — envoye le [Date d'envoi] ([Durée sans réponse] jours)
  Message : "[Message envoyé]"
```

### Etape 3 : Proposer l'action

Proposer via `AskUserQuestion` :
- **Generer et envoyer automatiquement** : declencher l'envoi pour tout ou partie des contacts
- **Voir seulement** : afficher la liste sans agir

**Si l'utilisateur veut generer et envoyer :**

Pour chaque contact selectionne, mettre a jour le champ `🤖 Génération auto` = `🚀 Générer et Envoyer` via `mcp__airtable__update_records`.

Ce champ declenche en une seule action :
1. La **generation d'un nouveau message personnalise** par l'IA (base sur le profil LinkedIn, l'historique de conversation et l'offre associee)
2. L'**envoi automatique** du message des qu'il est pret via Unipile

⚠️ Ne jamais utiliser `Envoyer` = `🚀 Envoyer` pour des relances — cela ne genere pas de nouveau message.
Toujours utiliser `🤖 Génération auto` = `🚀 Générer et Envoyer` pour garantir un message frais et contextualise.

Faire les mises a jour par batch de 10 max via `mcp__airtable__update_records`.

Confirmer : "X relances declenchees. Le systeme va generer et envoyer les messages dans les prochaines minutes."

Si aucune relance : "Aucune relance en attente. Bon travail ! 🎉"

---

## [Sous-commande : meeting]

Gerer les rendez-vous avec les prospects.

### Etape 1 : Verifier l'existence des champs RDV

Utiliser `mcp__airtable__describe_table` sur la table Contacts (`tbld8SE8EicdEjihW`) avec `detailLevel: "identifiersOnly"` pour lister les champs existants.

- Si le champ `Date RDV` est present → aller a **[Meeting : Gestion des RDV]**
- Sinon → aller a **[Meeting : Creation des champs]**

---

### [Meeting : Creation des champs]

Informer l'utilisateur :
"Les champs de suivi RDV n'existent pas encore dans votre base. Je peux les creer pour vous permettre de gerer vos rendez-vous directement depuis Prospector."

Demander confirmation via `AskUserQuestion`. Si accepte, creer les champs suivants dans la table Contacts (`tbld8SE8EicdEjihW`) via `mcp__airtable__create_field` (un appel par champ) :

1. **Date RDV** : `{"name": "Date RDV", "type": "date", "options": {"dateFormat": {"name": "european", "format": "D/M/YYYY"}}}`

2. **Statut RDV** : `{"name": "Statut RDV", "type": "singleSelect", "options": {"choices": [{"name": "📅 Proposé"}, {"name": "✅ Confirmé"}, {"name": "✔️ Effectué"}, {"name": "❌ Annulé"}, {"name": "👻 No-show"}]}}`

3. **Notes RDV** : `{"name": "Notes RDV", "type": "multilineText"}`

4. **Date prochain rappel** : `{"name": "Date prochain rappel", "type": "date", "options": {"dateFormat": {"name": "european", "format": "D/M/YYYY"}}}`

5. **Score commercial** : `{"name": "Score commercial", "type": "singleSelect", "options": {"choices": [{"name": "🔥 Chaud"}, {"name": "🟡 Tiède"}, {"name": "🔵 Froid"}]}}`

Confirmer la creation ("5 champs crees avec succes") puis passer a **[Meeting : Gestion des RDV]**.

---

### [Meeting : Gestion des RDV]

Proposer via `AskUserQuestion` :
- **Voir les RDV a venir**
- **Ajouter / modifier un RDV**
- **Voir les rappels en retard**

**Voir les RDV a venir :**
`mcp__airtable__list_records` sur Contacts avec `filterByFormula: "NOT({Date RDV} = '')"`, trie par `Date RDV` (asc).

Afficher :
```
📅 RDV A VENIR
════════════════════════════════════
[Date RDV] — [Nom complet] ([Titre] @ [Entreprise])
             Statut : [Statut RDV]
             Notes  : [Notes RDV]
```

**Ajouter / modifier un RDV :**
1. Rechercher le prospect via `mcp__airtable__search_records` (ou par le nom passe dans `$ARGUMENTS`)
2. Via `AskUserQuestion`, collecter :
   - Date du RDV
   - Statut RDV (📅 Proposé / ✅ Confirmé / ✔️ Effectué / ❌ Annulé / 👻 No-show)
   - Notes de preparation ou compte rendu
   - Date prochain rappel (optionnel)
   - Score commercial (optionnel : 🔥 Chaud / 🟡 Tiède / 🔵 Froid)
3. Mettre a jour via `mcp__airtable__update_records`
4. Si Statut RDV = `✔️ Effectué`, proposer de mettre `Statut Qualif` = `Qualifié` pour faire avancer le prospect dans le pipeline

**Voir les rappels en retard :**
`filterByFormula: "IS_BEFORE({Date prochain rappel}, TODAY())"` sur Contacts.

Afficher :
```
⏰ RAPPELS EN RETARD
════════════════════════════════════
• [Nom complet] — rappel prevu le [Date prochain rappel]
  [Notes RDV]
```

---

## [Sous-commande : edit-offer]

Modifier une offre existante.

### Etape 1 : Choisir l'offre

Lister les offres (`tblPsGgjuFm9UISU4`) et afficher : Nom, Style, Ton, Langue, Desactivee. Demander laquelle modifier.

### Etape 2 : Afficher les valeurs actuelles

Recuperer le record complet et afficher les champs editables :
```
✏️ OFFRE : [Product or Service ID]
════════════════════════════════════
Ton              : [Ton]
Style            : [Style de messages]
Langue           : [Langue]
CTA              : [Call to action]
Timezone         : [Time zone]
Horaires         : [Heure de debut] → [Heure de fin]
Envoi WE         : [Envoi le WE?]
Delai relance    : [Delai relance (jours)] jours
Reponse AUTO     : [Reponse AUTO]
Utilise template : [Utilise template]
Desactivee       : [Désactiver Offre]

--- Templates ---
Icebreaker       : [Template Icebreaker]
Follow-up 1      : [Follow-up 1 Template]
Follow-up 2      : [Follow-up 2 Template]
...

--- Instructions IA ---
Icebreaker       : [Instructions icebreaker]
Relances         : [Instructions relances]
Conversation     : [Instructions conversation]
```

### Etape 3 : Modifier

Demander via `AskUserQuestion` quels champs modifier. Collecter les nouvelles valeurs en respectant les contraintes :
- `Ton` : singleSelect — valeurs exactes avec accents
- `Style de messages` : `Classic`, `Direct` ou `Pop`
- `Langue` : singleSelect — nom exact de la langue
- `Call to action` : multipleSelects — tableau de valeurs
- Heures de debut/fin : convertir en secondes depuis minuit (ex: 9h00 = 32400, 18h00 = 64800)

Mettre a jour via `mcp__airtable__update_records` et confirmer.

---

## [Sous-commande : edit-campaign]

Modifier ou piloter une campagne existante.

### Etape 1 : Choisir la campagne

Lister les campagnes (`tblZv6vnehZZQVGS8`) et afficher : Nom, Source, Leads ajoutes, Volume total, Etat (Selectionner), Offre liee. Demander laquelle modifier.

### Etape 2 : Afficher l'etat actuel

```
✏️ CAMPAGNE : [Nom]
════════════════════════════════════
Source     : [Source]
URL        : [URL]
Limite     : [Limite]
Leads      : [Leads ajoutés] / [Volume total]
Etat       : [Sélectionner]
Offre      : [Product or Service ID]
```

### Etape 3 : Actions disponibles

Via `AskUserQuestion` :
1. **Relancer le scraping** : `Sélectionner` = `⬇️ Scraper`
2. **Mettre en pause** : `Sélectionner` = `⏸️ Désactiver`
3. **Changer l'URL de recherche** : modifier le champ `URL`
4. **Changer la limite** : modifier `Limite` — valeurs valides : `1`, `5`, `10`, `50`, `100`, `500`
5. **Construire une requete NL** : `Sélectionner` = `🔗 Construire requête` (convertit la requete NL en JSON automatiquement)

Mettre a jour via `mcp__airtable__update_records` et confirmer.

---

## [Sous-commande : new-campaign]

### Etape 1 : Identifier l'utilisateur

Lister les records de la table Parametres (`tblru8gj2bgB68HNb`) et demander a l'utilisateur quel compte utiliser (champ `NAME`). Retenir le record ID du Parametre choisi.

### Etape 2 : Collecter les informations de l'offre

Utiliser `AskUserQuestion` pour poser les questions suivantes (en plusieurs tours si necessaire). Le nom de l'offre peut etre passe apres la sous-commande dans `$ARGUMENTS` (ex: `/prospector new-campaign Mon Offre`).

#### Champs obligatoires :

1. **Nom de l'offre** (`Product or Service ID`, singleLineText) : Nom identifiant unique de l'offre.

2. **Description du produit ou service** (`Description du produit ou service`, multilineText) : Demander a l'utilisateur de decrire :
   - Ce qu'il vend et a quel prix
   - Les problemes qu'il resout
   - Comment il demontre la valeur (etudes de cas, demos, resultats chiffres)
   - Les principales objections rencontrees
   - La ressource gratuite proposee (newsletter, demo, livre blanc)

3. **Prospect cible** (`Prospect cible`, multilineText) : Demander :
   - Type et taille d'entreprises ciblees
   - Pays vises
   - Profils des decideurs (CEO, CMO, etc.)
   - Responsabilites principales des prospects
   - Signaux d'interet (changement de poste, levee de fonds, etc.)

4. **Ton** (`Ton`, singleSelect) : Proposer les options suivantes :
   - `Informel et 2eme personne du pluriel (vous)`
   - `Informel et 2eme personne du singulier (tu)`
   - `Professionnel et 2eme personne du pluriel (vous)`
   - `Professionnel et 1ere personne du pluriel (vous)`

5. **Call to action** (`Call to action`, multipleSelects) : Proposer les options existantes ou demander d'en creer. Options courantes :
   - `Call de 15mn`
   - `Call de 30mn`
   - `Audit gratuit`
   - `Rdv demo 15-30mn`
   - `Echange exploratoire`
   - `Proposer un call rapide`
   - `Proposer une demo rapide`
   - Ou toute autre option personnalisee

6. **Style de messages** (`Style de messages`, singleSelect) : Proposer :
   - `Classic` : Approche professionnelle, conversations approfondies, ton neutre
   - `Direct` : Style percutant, message concis, oriente action
   - `Pop` : Style leger et engageant, messages courts et spontanes

7. **Langue** (`Langue`, singleSelect) : Demander la langue. Options principales : `Francais`, `Anglais`, `English`, `French`, `Spanish`, `German`, `Italian`, `Portuguese`, etc.

#### Champs optionnels (proposer mais ne pas imposer) :

8. **Time zone** (`Time zone`, singleSelect) : Timezone IANA des prospects (ex: `Europe/Paris`, `America/New_York`)
9. **Heure de debut** (`Heure de debut`, duration en secondes) et **Heure de fin** (`Heure de fin`, duration en secondes) : Plage d'envoi des messages. Convertir en secondes depuis minuit (ex: 9h = 32400, 18h = 64800).
10. **Delai relance** (`Delai relance (jours)`, number) : Nombre de jours avant relance. Conseille : 7-10 jours.
11. **Envoi le WE?** (`Envoi le WE?`, checkbox) : Envoyer le week-end ? Defaut : false.
12. **Reponse AUTO** (`Reponse AUTO`, checkbox) : Activer les reponses automatiques ? Defaut : false.
13. **Templates** : Si l'utilisateur veut utiliser des templates (`Utilise template` = true) :
    - `Template Icebreaker` (multilineText)
    - `Follow-up 1 Template` a `Follow-up 5 Template` (multilineText)
14. **Instructions IA** (optionnel) :
    - `Instructions icebreaker` (multilineText)
    - `Instructions relances` (multilineText)
    - `Instructions conversation` (multilineText)

### Etape 3 : Creer l'Offre dans Airtable

Utiliser `mcp__airtable__create_record` sur la table `tblPsGgjuFm9UISU4` (base : `baseId` lu depuis `.prospector.json`) avec les champs collectes.

Afficher un resume du record cree.

### Etape 4 : Creer la Campagne

Demander a l'utilisateur :

1. **Nom de la campagne** (`Nom`, singleLineText)
2. **Source** (`Source`, singleSelect) : Proposer :
   - `Recherche Linkedin`
   - `Sales Navigator`
   - `Import CSV`
   - `Commentaires Linkedin`
   - `Like Linkedin`
   - `Mon reseau`
   - `Visiteurs`
   - `Candidats Recruiter`
3. **URL** (`URL`, url) : Si source = Recherche Linkedin ou Sales Navigator, demander l'URL de recherche
4. **Import CSV** : Si source = Import CSV, informer l'utilisateur qu'il devra uploader le CSV manuellement dans Airtable apres creation
5. **Limite** (`Limite`, singleSelect) : Nombre de prospects a scraper. Options : `1`, `5`, `10`, `50`, `100`, `500`

Creer le record dans la table `tblZv6vnehZZQVGS8` avec :
- Les champs ci-dessus
- `Product or Service ID` : lier au record Offre cree a l'etape 3 (array avec le record ID)
- `User ID` : lier au record Parametres identifie a l'etape 1 (array avec le record ID)
- `Selectionner` : mettre a `⬇️ Scraper` pour lancer le scraping automatiquement

### Etape 5 : Activation des switches

Demander a l'utilisateur quels automatismes activer dans ses Parametres. Proposer (multiSelect) :

- `▶️ Listes Auto` : Scraping automatique des campagnes
- `▶️ Invitation Auto` : Envoi automatique des invitations
- `▶️ Contact Auto` : Envoi automatique des messages de premier contact
- `▶️ Relance Auto` : Relances automatiques
- `▶️ Reponse Auto` : Reponses automatiques aux messages recus

Pour chaque switch selectionne, mettre la valeur a `▶️ Activer` via `mcp__airtable__update_records` sur le record Parametres.

### Etape 6 : Resume final

Afficher un resume complet :
- Offre creee (nom, description resumee, ton, style, langue)
- Campagne creee (nom, source, limite)
- Switches actives
- Prochaines etapes (le scraping va demarrer automatiquement, les prospects seront ajoutes a la table Contacts)

---

## [Sous-commande : list-offers]

Lister toutes les offres de la table Offres (`tblPsGgjuFm9UISU4`).

Afficher un tableau avec les colonnes :
- **Nom** (`Product or Service ID`)
- **Style** (`Style de messages`)
- **Ton** (`Ton`)
- **Langue** (`Langue`)
- **Desactivee ?** (`Désactiver Offre`)

Si aucune offre n'existe, indiquer a l'utilisateur qu'il peut en creer une avec `/prospector new-campaign`.

---

## [Sous-commande : list-campaigns]

Lister toutes les campagnes de la table Campagnes/Listes (`tblZv6vnehZZQVGS8`).

Afficher un tableau avec les colonnes :
- **Nom** (`Nom`)
- **Source** (`Source`)
- **Limite** (`Limite`)
- **Leads ajoutes** (`Leads ajoutés`)
- **Volume total** (`Volume total`)
- **Offre liee** (`Product or Service ID` — recuperer le nom de l'offre liee si possible)

Si aucune campagne n'existe, indiquer a l'utilisateur qu'il peut en creer une avec `/prospector new-campaign`.

---

## [Sous-commande : stats]

### Etape 1 : Identifier l'utilisateur

Lister les records de la table Parametres et demander a l'utilisateur quel compte consulter (champ `NAME`).

### Etape 2 : Recuperer les donnees

En parallele :
- Lister les offres de la table Offres (`tblPsGgjuFm9UISU4`)
- Lister les campagnes de la table Campagnes/Listes (`tblZv6vnehZZQVGS8`)
- Lister les contacts de la table Contacts (`tbld8SE8EicdEjihW`) filtres par l'utilisateur selectionne (champ `User`)

### Etape 3 : Afficher les statistiques

Presenter un dashboard avec :

#### Vue globale
- Nombre total d'offres actives
- Nombre total de campagnes
- Nombre total de contacts/prospects

#### Par offre
- Nom de l'offre
- Nombre de campagnes associees
- Nombre de contacts lies
- Repartition par statut (`Statut`) : invitations envoyees, messages envoyes, en conversation, qualifies, pas interesses
- Nombre de relances en attente (`A relancer`)

#### Quotas
- Afficher les quotas restants depuis le champ `Quotas restants` de la table Parametres

---

## Regles importantes

- Une campagne est consideree **desactivee** si le champ `Sélectionner` vaut `⏸️ Désactiver` OU si le champ `Offre désactivée ?` (lookup du champ `Désactiver Offre` de l'offre liee) est `true`. Ces deux conditions sont independantes : l'une ou l'autre suffit.
- Toujours parler en francais
- Ne jamais inventer de valeurs : toujours demander a l'utilisateur
- Pour les singleSelect, utiliser EXACTEMENT les valeurs listees (attention aux accents et emojis)
- Les liens entre tables utilisent des arrays de record IDs : `["recXXXXXXX"]`
- Si l'utilisateur ne fournit pas les champs optionnels, ne pas les inclure dans la creation
- Proposer des valeurs par defaut raisonnables quand c'est pertinent (ex: delai relance = 7 jours, timezone = Europe/Paris)
- La table "Listes" dans Airtable correspond aux **Campagnes** dans le produit Prospector — utiliser le terme "campagne" dans les echanges avec l'utilisateur
- Le champ `Statut` dans la table Contacts est un champ **formule** (calcule automatiquement) — ne jamais tenter de le modifier directement
- Pour les champs duration (Heure de debut/fin) : les valeurs sont en **secondes depuis minuit** (9h00 = 32400, 18h00 = 64800)
- **Generer + envoyer un message** : utiliser `🤖 Génération auto` = `🚀 Générer et Envoyer` — cela genere un message IA frais ET l'envoie automatiquement. Ne JAMAIS utiliser `Envoyer` = `🚀 Envoyer` pour les relances (ne genere pas de nouveau message).
- Le champ `🤖 Génération auto` accepte aussi : `🏃 Génère` (genere sans envoyer), `✅ Terminé` (etat final apres envoi)
