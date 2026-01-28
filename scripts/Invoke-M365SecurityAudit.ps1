<#
Name of the project : M365 Audit Toolkit

Description : This is a tools, to help people/businesses for autiding.

Author : Tommy Vlassiou
Date Start : 27/01/2026
Version : 1.0 - Day 1 Foundation
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
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
}

$AuditPath = (Join-Path -Path "$OutputPath" -ChildPath "$TimeStamp")
    New-Item -ItemType Directory -Path $AuditPath  | Out-Null

return [PSCustomObject]@{
    Feature = "AuditFolder"
    Status = "OK"
    FindingsCount = 0
    OutputFiles = @($AuditPath)
    Errors = @()
    Notes = "Audit folder created at $AuditPath"
    }
}


function Write-AuditLog {
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        [string]$Level = "INFO"
    )

$TimeStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
$FormattedMessage = "[$($TimeStamp)] [$($Level.ToUpper())] $($Message)"
$LevelUpper = $Level.ToUpper()


if ($LevelUpper -eq "INFO") {
    $color = "Cyan"
}
elseif ($LevelUpper -eq "SUCCESS") {
    $color = "Green"
} 
elseif($LevelUpper -eq "WARNING"){
    $color = "Yellow"
}
elseif($LevelUpper -eq "ERROR"){
    $color = "Red"
}
else {
    $color = "Magenta"
}

Write-Host "$($FormattedMessage)" -ForegroundColor $color

}

function Test-Prerequisites {
    param (
        )
Write-AuditLog "Checking prerequisites..."
$psMajorVersion = $PSVersionTable.PSVersion.Major
$errors = @()
$outputFiles = @()

if ($psMajorVersion -lt 5) {
    $errors += "PowerShell $($psMajorVersion) detected. Version 5 or higher is required."
    $status = "FAILED"
}else{
    $status = "OK"
}

return [PSCustomObject]@{
    Feature = "Prerequisites"
    Status = $status
    FindingsCount = $errors.Count
    OutputFiles =	$outputFiles
    Errors = $errors
    Notes =	"Powershell major version $($psMajorVersion) detected."
}
}


function Check-RequiredModules {
    param ()
    #Vérifie si les modules existent sur la machine
    $RequiredModules = @("Microsoft.Graph", "ExchangeOnlineManagement")
    $ResultsModules = @()
    
    foreach ($Module in $RequiredModules) {
         $ModuleInfo = Get-Module -ListAvailable -Name $Module -ErrorAction SilentlyContinue
         $IsInstalled = [bool]$ModuleInfo 
         $Status = if ($IsInstalled -eq $true) { "OK" } else { "FAILED" }
         $Notes = if ($IsInstalled -eq $true) { "Module available" } else { "Module not found in PSModulePath" }
         $ModuleResults = [PSCustomObject]@{
            Module = $Module
            Installed = $IsInstalled
            Status = $Status
            Notes = $Notes
         }
          $ResultsModules += $ModuleResults
 }
 return $ResultsModules
}

function Import-RequiredModules {
    param ( )
    #Tente de charger les modules
    $RequiredModules = @("Microsoft.Graph", "ExchangeOnlineManagement")
    $ResultsModules = @()

foreach($Module in $RequiredModules){

    try {
        Import-Module -Name $Module -ErrorAction Stop
        $Status = "OK"
        $Notes = "Module imported successfully"
    }
    catch {
        $Status = "FAILED"
        $Notes = "Import FAILED for $Module"
    }
$ModuleResults = [PSCustomObject]@{
            Module = $Module
            Status = $Status
            Notes = $Notes
         }
          $ResultsModules += $ModuleResults

}
return $ResultsModules
}

function Connect-M365Services {
    param ()
    #retourne un objet de statut de connexion

    $Status = "FAILED"
    $Notes = ""

try {
    Connect-MgGraph -Scopes "User.Read.All", "Group.ReadWrite.All"
    $Status = "OK"
    $Notes = "Connected to Microsoft Graph"
}
catch {
    $Notes = "Graph connection failed: $($_.Exception.Message)"
 }
 $ConnectionResult = [PSCustomObject]@{
     Service = "Microsoft Graph"
     Status = $Status
     Notes = $Notes
 }
 return $ConnectionResult
}


try {
    Get-MgUser -Top 5
    $GraphTestStatus = "OK"
}
catch {
    $GraphTestStatus = "FAILED"
    Write-AuditLog "Graph Connection failed : $($_.Exception.Message)" 
}

$auditResults = @()

    try {
        Write-AuditLog "Starting M365 audit..."
        $auditFolderResult = New-AuditFolder 
        $auditResults += $auditFolderResult
        $currentAuditFolder = $auditFolderResult.OutputFiles[0]
        $prerequisiteResult = Test-Prerequisites
        $auditResults += $prerequisiteResult
        $csvPath = Join-Path -Path $currentAuditFolder -ChildPath "prerequisites_check.csv"
        $prerequisiteResult | Export-Csv -Path $csvPath -NoTypeInformation
        $auditResults += (Check-RequiredModules)
        $auditResults += (Import-RequiredModules)
        $auditResults += (Connect-M365Services)
        $auditResults += 
        
        if ($prerequisiteResult.status -eq "FAILED") {
            Write-AuditLog "Prerequisites check failed" "ERROR"
            throw "Prerequisites check failed"
        }
    }
    catch { 
        Write-AuditLog "Unhandled error: $($_.Exception.Message) " "ERROR"
        exit 1
    }


if ( ($auditResults | Where-Object { $_.Status -eq "FAILED" }).Count -gt 0 ) {
    $statusGlobal = "FAILED"
}
else {
    $statusGlobal = "COMPLETED"
}

$totalFindings = ($auditResults | Measure-Object -Property FindingsCount -Sum).Sum
$totalErrors = ($auditResults | ForEach-Object { $_.Errors.Count } | Measure-Object -Sum).Sum

$finalReport = [PSCustomObject]@{
    
    Tool = "M365 Audit Toolkit"
    Version = "1.0 - Day 1 Foundation"
    Status = $statusGlobal
    Date = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    TotalFeatures = $auditResults.Count
    TotalFindings = $totalFindings
    TotalErrors = $totalErrors
    AuditFolder = $currentAuditFolder
    Notes = "Day 1 foundation run"
}

if ($statusGlobal -eq "COMPLETED") {
    Write-AuditLog "Audit completed successfully" "SUCCESS"
}
else {
    Write-AuditLog "Audit finished with errors" "ERROR"
}

Check-RequiredModules | Export-Csv -Path (Join-Path $currentAuditFolder "modules_check.csv") -NoTypeInformation
Import-RequiredModules | Export-Csv -Path (Join-Path $currentAuditFolder "modules_import.csv") -NoTypeInformation
Connect-M365Services | Export-Csv -Path (Join-Path $currentAuditFolder "graph_connection.csv") -NoTypeInformation
[PSCustomObject]@{ Test="GraphQueryTop5"; Status=$GraphTestStatus } | Export-Csv -Path (Join-Path $currentAuditFolder "graph_test.csv") -NoTypeInformation


$finalReport | Format-List
