# M365 Security Audit Toolkit

Toolkit PowerShell pour auditer la sécurité d'un tenant Microsoft 365.

Projet perso pour m'entraîner sur M365/Entra + PowerShell et construire un vrai projet portfolio utilisable.

## Qu'est-ce que ça fait

L'idée c'est d'automatiser les audits de sécurité M365 que je ferais normalement manuellement :
- Vérifier le statut MFA des users
- Analyser les logs de connexion suspects
- Checker les délégations Exchange (qui a accès à quoi)
- Lister les groupes et leurs membres
- Regarder les politiques d'accès conditionnel

Pour l'instant c'est en développement, je construis les scripts au fur et à mesure que j'apprends.

## Prérequis

- PowerShell 7+
- Modules : `ExchangeOnlineManagement` et `Microsoft.Graph`
- Un tenant M365 (de test)

## Installation
```Bash
git clone https://github.com/Mus1shi/M365-Security-Audit-Toolkit.git
cd M365-Security-Audit-Toolkit
```

Installer les modules nécessaires :
```Powershell
Install-Module ExchangeOnlineManagement -Scope CurrentUser
Install-Module Microsoft.Graph -Scope CurrentUser
```

## Structure
```
scripts/    → Scripts d'audit individuels
docs/       → Documentation et guides
reports/    → Exemples de rapports générés
modules/    → Fonctions réutilisables
tests/      → Tests des scripts
```

## Utilisation

Pour l'instant les scripts sont en développement. L'idée sera de les lancer via un script principal ou de les lancer individuellement.

Exemple futur :
```powershell
.\scripts\Get-MFAStatus.ps1
# Génère un rapport CSV avec le statut MFA de tous les users
```

## Roadmap

- [x] Setup du repo
- [ ] Script audit MFA
- [ ] Script analyse des connexions
- [ ] Script permissions Exchange
- [ ] Rapport global en HTML
- [ ] Maybe un dashboard si j'ai le temps

## Notes

- C'est un projet d'apprentissage, donc le code va évoluer
- Les rapports peuvent contenir des données sensibles, attention
- Pas destiné à la prod pour l'instant, plutôt pour du lab/learning

## Licence

MIT - fais ce que tu veux avec

## Contact

Tommy Vlassiou  
[LinkedIn](https://www.linkedin.com/in/tommy-vlassiou) | [GitHub](https://github.com/Mus1shi)

---
