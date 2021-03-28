<#
.Synopsis
    Check if all urls inside manifest are valid. #>

param(
    # Manifest to check. Wildcards are supported.
    [Parameter(ValueFromPipeline)]
    [Alias('App')]
    [string[]] $Manifest = '*'
    ,
    # Location where to search manifests. Default to bucket directory.
    [ValidateScript({
        if (!(Test-Path $_ -Type Container)) { 
            throw 'Dir must be a directory!'
        }

        $true })]
    [string] $Dir = "$PSScriptRoot\..\bucket"
    ,
    # Seconds until Url is marked invalid. Default: 5
    [int] $Timeout = 5
    ,
    [Parameter(ValueFromRemainingArguments)]
    [string[]] $Rest = @()
)

begin {
    if (!$env:SCOOP_HOME) {
        $env:SCOOP_HOME = Resolve-Path (scoop prefix scoop)
    }

    $Dir = Resolve-Path $Dir
    $Script = Join-Path $env:SCOOP_HOME \bin\checkurls.ps1 
}

process {
    foreach ($man in $Manifest) {
        Invoke-Expression -Command "$Script -App ""$man"" -Dir ""$Dir"" -Timeout $Timeout"
    }
}