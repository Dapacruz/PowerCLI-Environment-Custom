PowerCLI-Environment-Custom
---------------------------
*Extends the functionality of the VMware PowerCLI module*  

**Get-VMHostSSHServiceStatus**  
Retrieves the status of the SSH service of VMHosts provided, or VMHosts in the cluster provided

**Start-VMHostSSHService**  
Starts the SSH service of VMHosts provided, or VMHosts in the cluster provided

**Stop-VMHostSSHService**  
Stops the SSH service of VMHosts provided, or VMHosts in the cluster provided

**Get-VMHostUptime (included, but not developed by me)**  
Calculates the uptime of VMHosts provided, or VMHosts in the cluster provided

**Get-VMHostDatastores**  
Retrieves the datastore usage of VMHosts provided

**New-VMHostNetworkingCsvTemplate**  
Creates a host networking CSV import template to be used with Import-VMHostNetworkingFromCsv

**Export-VMHostNetworkingToCsv**  
Exports host networking for VMHosts provided

**Import-VMHostNetworkingFromCsv**  
Imports host networking for VMHosts provided utilizing the output from Export-VMHostNetworking

**Test-VMHostNetworking**  
Pings addresses from each provided VMkernel port for VMHosts provided

Installation
--------------
To load custom VMware PowerCLI settings automatically, you can create a script configuration file named Initialize-PowerCLIEnvironment_Custom.ps1 in the Scripts folder. The application recognizes and loads the custom file after loading the default script configuration file.

**PowerCLI Pre 6.5**  
*  Copy Initialize-PowerCLIEnvironment_Custom.ps1 to %ProgramFiles(x86)%\VMware\Infrastructure\PowerCLI\Scripts

**PowerCLI 6.5 and Later**  
*  Copy Initialize-PowerCLIEnvironment_Custom.ps1 to %ProgramFiles(x86)%\VMware\Infrastructure\PowerCLI\Scripts
*  Add "%ProgramFiles(x86)%\VMware\Infrastructure\PowerCLI\Scripts" to the system path.
*  Modify the PowerCLI shortcut: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -noe -c ". Initialize-PowerCLIEnvironment.ps1 $true; . Initialize-PowerCLIEnvironment_Custom.ps1"
