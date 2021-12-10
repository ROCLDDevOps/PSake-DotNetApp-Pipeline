Param (
    
    $TaskList = "Build",
    $Version = "0.0.1"
)
# Check if psake is installed
$ErrorActionPreference = 'stop'
$ModuleName = 'Psake'

if ( -not( Get-Module -ListAvailable -Name $ModuleName ) ) {

    Write-Host "- - - $ModuleName not present. Will be installed shortly. - - -" -ForegroundColor Cyan
    Write-Host "- - - Installation will be restricted to the CurrentUser. If you want to use for other users, please run as an administrator the  following command: `
     `n >>>> Find-Package -Name $ModuleName -Source 'PSGallery'  | Install-Module <<<< `n " -ForegroundColor Yellow

    Find-Package -Name $ModuleName -Source 'PSGallery'  | Install-Module -Scope CurrentUser -Force -Confirm:$false
    Import-Module -Name $ModuleName
    
    if( Get-InstalledModule -Name $ModuleName -ErrorAction SilentlyContinue ) {
        Write-Host "- - - $ModuleName installed successfully. - - -" -ForegroundColor Green
    }
    
}

Invoke-psake .\build.psake.ps1 -taskList $TaskList