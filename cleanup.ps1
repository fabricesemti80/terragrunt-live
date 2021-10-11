# Script to clean up cache files and log files
<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
#>
[cmdletbinding(SupportsShouldProcess = $True)]
[OutputType([int])]
param(
    [Parameter(Mandatory = $false)]
    [string]
    $CurrentPath = (Split-Path -Parent $PSCommandPath)
)
begin {
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop # All errors should be terminating
    $FormatEnumerationLimit = -1 # https://mcsaguru.com/powershell-output-truncated
}
process {
    Write-Host -ForegroundColor Yellow 'Removing Terraform cache files'
    Get-ChildItem $CurrentPath -Recurse | Where-Object { $_.FullName -match '.terragrunt-cache' } | Remove-Item -Recurse -Force -Verbose
    Write-Host -ForegroundColor Yellow 'Removing Terraform lock files'
    Get-ChildItem $CurrentPath -Recurse | Where-Object { $_.FullName -match '.terraform.lock.hcl' } | Remove-Item -Recurse -Force -Verbose
    Write-Host -ForegroundColor Yellow 'Removing Terraform log files'
    Get-ChildItem $CurrentPath -Recurse | Where-Object { $_.FullName -match 'terraform.txt' } | Remove-Item -Recurse -Force -Verbose
}
end {
}
