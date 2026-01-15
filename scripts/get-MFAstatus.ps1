<#
.Synopsis
Vérifie le statut MFA des users M365

.DESCRIPTION

Script pour lister tous les user du tenant et voir qui a MFA activé ou pas.
Idée : sortit un csv avec User | Email | MFAEnabled | Methods

.Notes

Status: en Progrès/Work in Progress
#>

#TODO:

#1 - Se connecter à Graph
#2 - Récuperer liste users
#3 - Checker MFA status pour chacun
#4 - Export CSV

Write-Host "Script en cours de dev" -ForegroundColor Yellow