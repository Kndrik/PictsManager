# GIT

## 📚 Table des matières
 * [Nommage des branches](#nommage-des-branches)
 * [Fusion des branches](#fusion-des-branches)
 * [Nommage des commits](#nommage-des-commits)

---

## Git

### Nommage des branches

#### Règle

Nous utilisons le format suivant pour nommer nos
branches :

>`add/<informations supplémentaires sur la branche>`
>
> exemple: `add/implement-login`

Pour les branches "techniques" ne correspondant pas à un ticket, nous utilisons :
>`tech/<informations supplémentaires sur la branche>`

#### Justification

- **Clarté:** 
  - Les informations supplémentaires offrent un contexte immédiat sur l'objectif ou la fonction de la branche.

---

### Fusion des branches

#### Règle

Lors de la fusion d'une branche, gardez tous les commits pertinents. Si des commits de travail ou insignifiants sont
présents, réécrivez l'historique. La branche doit être rebasée sur `main` sans merge fast-forward.

#### Justification

- **Historique propre:** 
  - En évitant les commits de fusion et en réécrivant l'historique, nous maintenons un historique
    Git propre et linéaire.
- **Traçabilité:** 
  - La conservation des commits pertinents facilite la traçabilité et la compréhension des changements
    apportés.

---

### Nommage des commits

#### Règle

Nous utilisons la norme [commits conventionnels](https://www.conventionalcommits.org/fr/v1.0.0/) pour nommer nos
commits. Le format est :
>`type: <MON_MESSAGE_DE_COMMIT>`.
>
> example => add: fancy animation
>
> ou encore => tech: add cache

Le type doit être l’un des suivants (inspiré de
[angular](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#type)):

- **add**: 
  - Une nouvelle fonctionnalité
- **fix**: 
  - Une correction de bug
- **refactor**: 
  - Une modification du code qui ne corrige pas un bug et n'ajoute pas de fonctionnalité
- **style**: 
  - Modifications qui n'affectent pas le sens du code (espaces blancs, mise en forme, omissions de point-virgules, etc.)
- **tech**: 
  - Tâche technique diverse qui ne s'inscrit pas dans d'autres types spécifiques
- **test**: 
  - Ajout de tests manquants ou correction de tests existants

#### Justification

- **Uniformité:** 
  - L'utilisation d'une norme permet une cohérence dans la nomination, facilitant la recherche et la
    compréhension des commits.
- **Lisibilité:**
  - L'ajout du type fournit des détails essentiels sur le commit, ce qui améliore la lisibilité de l'historique.

---

