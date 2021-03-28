<#
.Synopsis
    Execute Pester tests in repository root directory. #>

Invoke-Pester "$PSScriptRoot\..\test" -PassThru | 
    Set-Variable result

return $result