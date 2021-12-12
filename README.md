# PSake Demo Pipeline

This repository leverages the functionalites introduce by [PSake](https://psake.readthedocs.io/en/latest/) DSL (Domain Specific Language).

!The .NET app used in this project, can be found [here](https://github.com/MicrosoftDocs/mslearn-capture-application-logs-app-service).
## How to Run
1. In a powershell session, run `.\build.ps1 -TaskList BuildPackagePublish -Version '1.0.0'`. Version's format must by compliant with *major.minor.revision.build* semantic.

## Notes
1. You can add as many parameters as you need. In the 'Invoke-Psake' function, the parameter '**-parameters**' takes as input a PowerShell hashtable.
    ```powershell
      Invoke-psake .\build.psake.ps1 -taskList BuildPackagePublish -parameters @{"Version"="1.2.3.4"; "param1"="Value Param 1"; "param2"="Value Param 2"}
    ```
