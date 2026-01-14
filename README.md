# M365 Security Audit Toolkit
Initial repository setup.
# M365 Security Audit Toolkit

## C’est quoi ?
Ce projet est un toolkit PowerShell pour auditer rapidement la posture de sécurité d’un tenant Microsoft 365 (MFA, connexions, permissions, groupes, etc.) et sortir des rapports lisibles.

Ici deux objectifs :
- **m’entraîner sur M365 / Entra + PowerShell**
- **construire un vrai projet portfolio**, utile et évolutif

## Ce que ça audite (déjà / prévu)
- MFA des utilisateurs (activé/désactivé, méthodes)
- Logs de connexion (échecs, localisation, comportements suspects)
- Délégations Exchange (FullAccess / SendAs)
- Analyse des groupes (types, membres, groupes vides)
- Politiques d’accès conditionnel (si dispo)
- Export des résultats (CSV / TXT / HTML)

## Prérequis
- PowerShell 7+
- Modules officiels :
  - `ExchangeOnlineManagement`
  - `Microsoft.Graph`
- Un tenant Microsoft 365 (idéalement un **tenant de test**)

## Structure du dépôt
- `scripts/` : scripts PowerShell pour chaque audit
- `docs/` : documentation d’installation et de fonctionnement
- `reports/` : exemples de rapports générés
- `modules/` : éventuels modules internes réutilisables

## Installation
Cloner le repo :

```bash
git clone https://github.com/<ton_user>/M365-Security-Audit-Toolkit.git
cd M365-Security-Audit-Toolkit
