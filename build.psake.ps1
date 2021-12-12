Properties {
    $ArtifactVersion     = $Version
    $SolutionDirectory   = $PSScriptRoot
    $SolutionName        = 'simpleAspDotNetapp.sln'
    $SolutionPath        = ( Join-Path $SolutionDirectory $SolutionName )

    $NugetExe            = ( Get-ChildItem -Path $SolutionDirectory -Filter 'nuget.exe' -Recurse ).FullName
    $global:MSBuildExe   = $null

    $AdditionalParameter = $AnyOtherParameter
}

# Format how PSake will display the output
FormatTaskName (("-"*25) + "[ {0} ]" + ("-"*25))

TaskTearDown {
            # Prints a new line after each task 
            "`n"
        }
Task default -depends Prerequisites

Task Prerequisites {

    Write-Host "Here you should make sure any BuildTools(MSBuild, Nuget CLI, OctopusDeploy CLI) required are available." -ForegroundColor Green

    # Check if nuget.exe exists. version 4.7.3.5893 needed for this project
    Assert ( $null -ne $NugetExe ) "nuget.exe not found in current folder"
    Write-Host "Nuget found on $nugetExe" -ForegroundColor Yellow

    if ( -not (Get-InstalledModule -Name VSSetup -ErrorAction SilentlyContinue )) {

        Write-Host "Installing VSSetup Tools ..." -ForegroundColor Cyan
        Install-Module VSSetup -Scope CurrentUser -Force
        
     }else {
        
        $VisualStudio = Get-VSSetupInstance

        if( $null -eq $VisualStudio ) 
        {
            Write-Error "VS Tools are not installed. Please install them using https://visualstudio.microsoft.com/downloads/ "
            return;
        }
        else 
        {
            $Global:MSBuildexe = (Get-ChildItem -Path $VisualStudio.InstallationPath -Filter "MSBuild.exe" -Recurse).FullName[0] 
            
            Assert ( (Test-Path $Global:MSBuildexe) -eq $true ) "MSBuild.exe not found, even though $($VisualStudio.InstallVersion) is installed on $($VisualStudio.Installationpath) " 
  
        }
     }

}

Task Build -depends Prerequisites, Restore {
    Write-Host "The build step takes care of the application. Clean, Build or anything necesarry before packaging." -ForegroundColor Green

    # Build the solution
    Write-Host "Building the solution..." -ForegroundColor Cyan
    & $global:MSBuildExe  $solutionpath /'t:Clean;Rebuild'
}

Task Restore {
    
    # Restore NuGet packages
    Write-Host "Restoring dependencies..." -ForegroundColor Cyan
    & $NugetExe restore
}

Task Test {

     Write-Host "Here the test automation frameworks come into play. E.g: NUnit, Selenium, Appium, Cucumber." -ForegroundColor Green

     Write-Host "Running Automation tests..." -ForegroundColor Cyan

}

Task Package -depends Validate {

    Write-Host "The Package step should leverage a code package method (.nupkg) that fits the project needs so you can have an immutable version of your artifacts." -ForegroundColor Green

    Write-Host "Create starting from the .nuspec file and pack the solution." -ForegroundColor Yellow

}
Task Validate {

    Write-Host "Here you should check if any dependencies are in place or application versioning is correct (incremental version numbering)." -ForegroundColor Green
    
    Assert ( $ArtifactVersion -ne $null ) "Artifact version cannot be null"
    Write-Host "Version $ArtifactVersion validated successfully." -ForegroundColor Yellow
}


Task Publish  {
    
        Write-Host "At this stage, the artifact should pe uploaded to a artifact repository. E.g: Jfrog Artifactory, Sonatype Nexus, ProGet." -ForegroundColor Green
}

Task BuildPackagePublish -depends Build, Package, Test, Publish {

        Write-Host "Application was built, tested, packed and published successfully" -ForegroundColor Yellow

        Write-Host "Also the additional parameter was parsed: $AdditionalParameter" -ForegroundColor Magenta
       
}