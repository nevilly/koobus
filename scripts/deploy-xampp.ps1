# KooBus - kusambaza API kwenye XAMPP (Windows)
#
# Matumizi:
#   powershell -ExecutionPolicy Bypass -File scripts\deploy-xampp.ps1
#   powershell -ExecutionPolicy Bypass -File scripts\deploy-xampp.ps1 -Mirror
#
# Nini kinahamishwa:
#   htdocs\Api\api     -> C:\xampp\htdocs\api
#   htdocs\Api\public  -> C:\xampp\htdocs\public
#
# Kwa nini si `htdocs\Api` yote? Kwa sababu PHP includes zinatafuta
# `DOCUMENT_ROOT . "/api/v1/..."`. Hivyo `api` LAZIMA iwe moja kwa moja
# chini ya htdocs, si ndani ya folder `Api` ya ziada.

[CmdletBinding()]
param(
    [string]$Destination = "C:\xampp\htdocs",
    [switch]$Mirror,
    [switch]$SkipPublic
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceApi = Join-Path $repoRoot "htdocs\Api\api"
$sourcePublic = Join-Path $repoRoot "htdocs\Api\public"
$destApi = Join-Path $Destination "api"
$destPublic = Join-Path $Destination "public"

if (-not (Test-Path $sourceApi)) {
    throw "Haipatikani: $sourceApi"
}
if (-not (Test-Path $Destination)) {
    throw "Haipatikani: $Destination (hakikisha XAMPP imewekwa)"
}

function Sync-Folder {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Target
    )

    if (-not (Test-Path $Target)) {
        New-Item -ItemType Directory -Path $Target | Out-Null
    }

    $robocopyArgs = @($Source, $Target)
    if ($Mirror) {
        $robocopyArgs += "/MIR"
    } else {
        $robocopyArgs += "/E"
    }

    # .rd ina credentials za local; tunaihamisha kando ili kutoifuta.
    $robocopyArgs += @(
        "/XD", ".idea", ".git",
        "/XF", ".rd", ".DS_Store", "Thumbs.db",
        "/NFL", "/NDL", "/NJH", "/NJS", "/NP"
    )

    & robocopy @robocopyArgs
    if ($LASTEXITCODE -ge 8) {
        throw "robocopy imeshindikana (exit code $LASTEXITCODE)"
    }
}

Write-Host "KooBus API -> XAMPP" -ForegroundColor Cyan
Write-Host "Source : $repoRoot"
Write-Host "Target : $Destination"
if ($Mirror) {
    Write-Host "Mode   : MIRROR (files zisizopo kwenye source zitafutwa kwenye target!)" -ForegroundColor Yellow
} else {
    Write-Host "Mode   : COPY (hakuna kufuta files kwenye target)"
}
Write-Host ""

Sync-Folder -Source $sourceApi -Target $destApi

if (-not $SkipPublic -and (Test-Path $sourcePublic)) {
    Sync-Folder -Source $sourcePublic -Target $destPublic
}

# .rd ni config ya siri/local. Kama haipo kwenye target, tunaweka copy ya kwanza.
# Kumbuka: .rd iko ndani ya `api/v1/`, si kwenye `api/`.
$rdSource = Join-Path $sourceApi "v1\.rd"
$rdTarget = Join-Path $destApi "v1\.rd"
if ((Test-Path $rdSource) -and -not (Test-Path $rdTarget)) {
    Copy-Item $rdSource $rdTarget
    Write-Host "Imeundwa: $rdTarget" -ForegroundColor Green
    Write-Host "Badilisha DB_USER/DB_PASS/DB/APP_ENV/SECRET kabla ya kutumia." -ForegroundColor Yellow
} else {
    Write-Host "Imebaki: $rdTarget (haijaguzwa)" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "Imekamilika." -ForegroundColor Green
Write-Host "API test : http://localhost/api/v1/doesnotexist  (inatakiwa JSON 403)"
Write-Host "Install  : http://localhost/api/v1/install"
Write-Host "Kama Apache inatumia port 8080, ongeza :8080 kwenye URL."
exit 0
