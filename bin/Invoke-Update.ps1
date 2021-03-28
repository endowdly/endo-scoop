<#
.Synopsis
    Updates manifests and pushes them or creates pull-requests. #>

param (
    # The manifest to update.
    [Alias('App', 'Name')]
    [string] $Manifest = '*'
    ,
    [ValidateScript({
        if (!(Test-Path $_ -Type Container)) {
            throw 'Dir must be a directory!'
        }

        $true })]
    [string] $Dir = "$PSScriptRoot\..\bucket"
    ,
    [ValidatePattern('^(.+)\/(.+):(.+)$')]
    [string] $Upstream = $((git config --get remote.origin.url) -replace '^.+[:/](?<user>.*)\/(?<repo>.*)(\.git)?$', '${user}/${repo}:master')
    ,
    [switch] $Push
    ,
    [switch] $Request
    ,
    [string[]] $SpecialSnowflakes
)

begin {
    if (!$env:SCOOP_HOME) {
        if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
            throw 'Scoop installation or SCOOP_HOME env is required!'
        }

        $env:SCOOP_HOME = Resolve-Path (scoop prefix scoop )
    }

    $params = @{
        App               = $Manifest
        Dir               = Resolve-Path $Dir
        Upstream          = $Upstream
        Push              = $Push
        Request           = $Request
        SpecialSnowflakes = $SpecialSnowflakes
        SkipUpdated       = $true
    }
}

process {
    & "$env:SCOOP_HOME\bin\auto-pr.ps1" @params
}
