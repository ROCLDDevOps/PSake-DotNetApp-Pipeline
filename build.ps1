Param (
    [ Parameter( Mandatory = $false ) ]
    [ ValidateSet( 'BuildPackagePublish', 'Build', 'Test', 'Publish')]
    [string] $TaskList = "BuildPackagePublish",

    [ Parameter ( Mandatory = $false) ]
    [ ValidatePattern( '\d{1,2}.\d{1,2}.\d{1,3}.\d{1,4}' ) ]
    [string] $Version = '1.0.0.0'
)
# Check if psake is installed
$ErrorActionPreference = 'stop'
$ModuleName = 'Psake'

$location = $PSScriptRoot
Set-Location $location

if ( -not( Get-Module -ListAvailable -Name $ModuleName ) ) {

    Write-Host "- - - $ModuleName not present. Will be installed shortly. - - -" -ForegroundColor Cyan
    Write-Host "- - - Installation will be restricted to the CurrentUser. If you want to use for other users, please run as an administrator the  following command: `
     `n >>>> Find-Package -Name $ModuleName -Source 'PSGallery'  | Install-Module <<<< `n " -ForegroundColor Yellow
    
}

Invoke-psake .\build.psake.ps1 -taskList $TaskList -parameters @{"Version"=$Version; "AnyOtherParameter"="Additional Parameter required"}