#requires -version 7.0

<#PSScriptInfo
.Version 1.0.0
.Guid c1c7049a-29bf-414e-a8da-92d10f3f0306
.Author endowdly
.CompanyName endowdly
.Copyright 2021
.Tags Json Validate Schema
.LicenseUri https://github.Com/endowdly/endo-scoop/license
.ProjectUri https://github.Com/endowdly/endo-scoop
.IconUri 
.ExternalModuleDependencies 
.RequiredScripts 
.ExternalScriptDependencies 
.ReleaseNotes
Initial
#>

<# 
.Description 
 Verify and validate manifest files with the Scoop json schema. 
#>

param()

data Message {
    @{
        TerminatingError = @{
            ScoopNotFound = 'Scoop cannot be found in your path! Exiting.'
            SchemaFileNotFound = 'Scoop schema file cannot be found! Exiting'
        } 

        Format = @{
            Report = '{0}: {1}'
        }
    }
}

data WriteHost {
    @{
        ForegroundColor = 'Black'
        BackgroundColor = 'Cyan'
        Object = 'Manifest Validation'
    }
}

$ErrorActionPreference = 'Stop'

Get-Command scoop -ErrorAction SilentlyContinue | 
    Set-Variable isScoop

if (!$isScoop) {
    Write-Error $Message.TerminatingError.ScoopNotFound
}

(scoop prefix scoop) | 
    Join-Path -ChildPath schema.json -OutVariable pathSchemaFile | 
    Test-Path | 
    Set-Variable isSchemaFile

if (!$isSchemaFile) {
    Write-Error $Message.TerminatingError.TerminatingError.SchemaFileNotFound
}

$Report = @{}
$Schema = Get-Content $pathSchemaFile -Raw

Get-ChildItem bucket -Filter *.json -File |
    ForEach-Object {
        $_ |
            Get-Content -Raw | 
            Test-Json -Schema $Schema |
            Set-Variable isValid

        $report.Add($_.Name, $isValid) }

Write-Host @WriteHost

$Report.
    GetEnumerator().
    ForEach{ $Message.Format.Report -f $_.Key, $_.Value }
