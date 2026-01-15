<#
.SYNOPSIS
Analyse les logs de connexion M365

.DESCRIPTION
Regarde les sign-in logs pour détecter des events suspects :
- Échecs de connexion multiples
- Connexions depuis des pays "bizarres"
- Patterns anormaux

.NOTES
Status: Work in progress
#>

# TODO:
# - Récupérer sign-in logs (Graph API)
# - Filtrer les échecs
# - Détecter anomalies
# - Rapport

Write-Host "Script en cours de dev" -ForegroundColor Yellow
