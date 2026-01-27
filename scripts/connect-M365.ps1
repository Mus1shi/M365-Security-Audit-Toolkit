<#
Name of the project : M365 Audit Toolkit

Description : This is a tools, to help people/businesses for autiding.

Author : Tommy Vlassiou
Date Start : 27/01/2026
Date End : ?
Version : 1.0
#>

 param(

  
    [string]$TenantName = "Unknown",
#param pour identifier l’environnement cible

   
    [string]$OutputPath = ".\output",
#param pour dire où les résultats seront enregistrés
    
    
    [string]$Mode = "Online",
#paramètre qui influence le mode d’exécution

    [switch]$Verbose
#parametre qui influence le switch 
)

function New-AuditFolder {
    param ()

$TimeStamp = (Get-Date).ToString("yyyyMMdd_HHmm")

if (! (Test-Path $OutputPath)) {
    New-Item -type Directory $OutputPath
}

$AuditPath = (Join-Path -Path "$OutputPath" -ChildPath "$TimeStamp")
New-Item -type Directory "$AuditPath"

return [PSCustomObject]@{
    Feature = "AuditFolder"
    Status = "OK"
    FindingsCount = 0
    OutputFiles = @($AuditPath)
    Errors = @()
    Notes = "Audit folder created at $AuditPath"
    }
}


