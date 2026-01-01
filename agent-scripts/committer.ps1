#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Usage {
  $scriptName = [System.IO.Path]::GetFileName($PSCommandPath)
  Write-Error ("Usage: {0} [--force] \"commit message\" \"file\" [\"file\" ...]" -f $scriptName)
  exit 2
}

$argsList = @($args)
$forceDeleteLock = $false

if ($argsList.Count -ge 1 -and $argsList[0] -eq "--force") {
  $forceDeleteLock = $true
  if ($argsList.Count -eq 1) {
    Usage
  }
  $argsList = $argsList[1..($argsList.Count - 1)]
}

if ($argsList.Count -lt 2) {
  Usage
}

$commitMessage = $argsList[0]
$files = @()
if ($argsList.Count -gt 1) {
  $files = $argsList[1..($argsList.Count - 1)]
}

if (-not ($commitMessage -match "\S")) {
  Write-Error "Error: commit message must not be empty"
  exit 1
}

if (Test-Path -LiteralPath $commitMessage) {
  Write-Error ("Error: first argument looks like a file path (\"{0}\"); provide the commit message first" -f $commitMessage)
  exit 1
}

if ($files.Count -eq 0) {
  Usage
}

foreach ($file in $files) {
  if ($file -eq ".") {
    Write-Error "Error: \".\" is not allowed; list specific paths instead"
    exit 1
  }
}

function Test-GitFileExists {
  param([string]$Path)

  if (Test-Path -LiteralPath $Path) {
    return $true
  }

  & git ls-files --error-unmatch -- $Path *> $null
  if ($LASTEXITCODE -eq 0) {
    return $true
  }

  & git cat-file -e ("HEAD:{0}" -f $Path) *> $null
  return ($LASTEXITCODE -eq 0)
}

foreach ($file in $files) {
  if (-not (Test-GitFileExists -Path $file)) {
    Write-Error ("Error: file not found: {0}" -f $file)
    exit 1
  }
}

& git restore --staged :/
& git add -A -- @files

& git diff --staged --quiet
if ($LASTEXITCODE -eq 0) {
  Write-Error ("Warning: no staged changes detected for: {0}" -f ($files -join " "))
  exit 1
}

function Run-GitCommit {
  param(
    [string]$Message,
    [string[]]$Paths
  )

  $output = & git commit -m $Message -- @Paths 2>&1
  return @{
    ExitCode = $LASTEXITCODE
    Output = $output
  }
}

$commitResult = Run-GitCommit -Message $commitMessage -Paths $files

if ($commitResult.ExitCode -ne 0 -and $forceDeleteLock) {
  $lockPath = $null
  foreach ($line in $commitResult.Output) {
    if ($line -match "'([^']*index\.lock)'") {
      $lockPath = $Matches[1]
      break
    }
  }

  if ($lockPath -and (Test-Path -LiteralPath $lockPath)) {
    Remove-Item -LiteralPath $lockPath -Force
    Write-Error ("Removed stale git lock: {0}" -f $lockPath)
    $commitResult = Run-GitCommit -Message $commitMessage -Paths $files
  }
}

if ($commitResult.ExitCode -ne 0) {
  exit 1
}

Write-Host ("Committed \"{0}\" with {1} files" -f $commitMessage, $files.Count)

# SIG # Begin signature block
# MIIFrQYJKoZIhvcNAQcCoIIFnjCCBZoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCO03IHA8zhp3Nt
# FQ4m/1RJBTE9bfXuir9Hektq2ujHm6CCAxowggMWMIIB/qADAgECAhAe5GZmKMNC
# gUjasMjG9F++MA0GCSqGSIb3DQEBCwUAMCMxITAfBgNVBAMMGENvZGV4IExvY2Fs
# IENvZGUgU2lnbmluZzAeFw0yNjAxMDEyMDAzMDBaFw0yNzAxMDEyMDIzMDBaMCMx
# ITAfBgNVBAMMGENvZGV4IExvY2FsIENvZGUgU2lnbmluZzCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBANAWTwPW0oyrRw72AN+9RbNbeB4ZcyHmSBiv3JOb
# leXi2iASgZ0VojjY9vuJsq9258FEEfwDBvjRZhFjKZlFxceJ0ri6RfVbrEATs/oA
# kK1Q/FwXILA4uqUYf394XtKYHMqcJlXOxyRDSjGQb6oEGFU3mVQKhY7RZ0ose2wV
# KA0fQPd3Pt3I2FHHU3KXvJurkuizVd/COKZafBD5EwsfAI0HqSwZVNY0qYY/AM7c
# o4KBnRqvWajoEOmIRbwIUnaxUtp4JQDSseFfJcQYdE9Oez147y+4+LJ9nqZGs2ou
# TrgItqRQD/IBmI0E0mkakFFQ5dGLK3wn92CWJlKyu6KLzn0CAwEAAaNGMEQwDgYD
# VR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBQB25iH
# Ii+RSC2XKLhrdbmiUTH79zANBgkqhkiG9w0BAQsFAAOCAQEALvFHPQLnaNVrAR9q
# 7he22mwYLz8EwMlpTC77bPB2ZyIb1mz3qG51tl0lvpfc23RKYR3J6Krdu8VQd1uS
# jFEILtbqNgIq3U1VmTJ1e1jmRTfTvWE5wV+YtjNNNyGJIsr9lAZv1opx1FiCrAC1
# bc1AWbmmIN1jIrB/qmp7NHEXaY1kVzTdKjmf3C5A4yE70fEpx1XR5k8Gefb64KcT
# dpo62RPZnAn1QM8ZcLzqOyTs2fE/TYHOE+i7+qcHMZpH9ZySCrSj4A0sCBNrOA0h
# M388EyI5rdlqNamlQFVHu3h3ys2PMWs94suq8mzbURtGLTVxOpME6IUve8gfjn55
# Ed7XZzGCAekwggHlAgEBMDcwIzEhMB8GA1UEAwwYQ29kZXggTG9jYWwgQ29kZSBT
# aWduaW5nAhAe5GZmKMNCgUjasMjG9F++MA0GCWCGSAFlAwQCAQUAoIGEMBgGCisG
# AQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIF1k
# HbdgbBzQiO+8cwO3LAyBdeF8/zawIIeZX4ra2MK9MA0GCSqGSIb3DQEBAQUABIIB
# AKYCv3qrMUa8w/OJaR2zGIrHM7jAYvaRXVz3LuF6nQ3M/w6MtxcsEAgwhHIFZJ3r
# 0Wkh9SB1HetjAhwlwlFrYEWWkY5AS1vC9btd9kRHtMrC6gNuZ30d/g78BGvPc7E5
# JYHj2X23R+j5dZiVebKYePhWi2Jz2wkO9Fj4ZkmERGUzRCk2O8TWD0yBSECUbEAI
# JDBHSN2H2PpgVs8mqQwExWj+i9ByqywLKCv4MW2IZsXpA3jj+Y5V43Ciwdxnz77X
# Pz8Sl4nm8y8ctGqp8WXB/ou1Skm2NezjXylzwfpiupznd68f9338jRrPTWhM+Nit
# IVHYJY8T2/u6DfyCoNv2lNQ=
# SIG # End signature block
