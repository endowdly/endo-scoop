<#
.Synopsis
    Check if manifests have checkver  and autoupdate property. #>

param (
    # Manifest name.
    [Parameter(ValueFromPipeline)]
    [Alias('App')]
    [string] $Manifest = '*'
    ,
    # Directory where to search. 
    [ValidateScript({
        if (!(Test-Path $_ -Type Container)) {
            throw 'Dir must be a directory!'
        }

        $true })]
    [string] $Dir = "$PSScriptRoot\..\bucket"
)

begin {
    if (!$env:SCOOP_HOME) {
        $env:SCOOP_HOME = Resolve-Path (scoop prefix scoop)
    }

    $Dir = Resolve-Path $Dir
}

process {
    Invoke-Expression -Command "$env:SCOOP_HOME\bin\missing-checkver.ps1 -App ""$Manifest"" -Dir ""$Dir"""
}
