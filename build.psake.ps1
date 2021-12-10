Properties {
    $SolutionDirectory = $PSScriptRoot
    $SolutionName = 'simpleAspDotNetapp.sln'
    $SolutionPath = ( Join-Path $SolutionDirectory $SolutionName)

    $NugetExe = ( Get-ChildItem -Path $SolutionDirectory -Filter 'nuget.exe' -Recurse).FullName
    $global:MSBuildExe = (Get-ItemProperty hklm:\software\Microsoft\MSBuild\ToolsVersions\4.0).MSBuildToolsPath
}

# Format how PSake will display the output
FormatTaskName (("-"*25) + "[ {0} ]" + ("-"*25))

Task default -depends Prerequisites

Task Prerequisites {

    # Check if nuget.exe exists. version 4.7.3.5893 needed for this project
    Assert ( $null -ne $NugetExe ) "nuget.exe not found in current folder"
    Write-Host "Nuget found on $nugetExe" -ForegroundColor Green

    # Check if MSBuild v4.0 is present
    Assert ( $null -ne $global:MSBuildExe ) "MSBuild.exe not found. Please install .NET Framework 4.0" 
    $global:MSBuildExe = ( Join-Path $MSBuildExe "MSBuild.exe" )

    Assert ( (Test-Path $global:MSBuildExe) ) "MSBuild.exe not found on path"
    Write-Host "MSBuild found on $global:MSBuildExe" -ForegroundColor Green
}

Task Build -depends Prerequisites, Restore {
    
    Write-Host "Building solution..." -ForegroundColor Cyan
    & $global:MSBuildExe $SolutionPath
}

Task Restore {

    # Restore NuGet packages and build solution
    Write-Host "Restoring dependencies..." -ForegroundColor Cyan
    & $NugetExe restore
}