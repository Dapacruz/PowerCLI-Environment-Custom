PowerCLI-Environment-Custom
---------------------------
*Provides useful functions missing from the default PowerCLI installation*

**Get-VMHostSSHServiceStatus**  
Retrieves the status of the SSH service of VMHosts provided, or VMHosts in the cluster provided

**Start-VMHostSSHService**  
Starts the SSH service of VMHosts provided, or VMHosts in the cluster provided

**Stop-VMHostSSHServic**  
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
Configures host networking for VMHosts provided utilizing the output from Export-VMHostNetworking

**Installation - PowerCLI Pre 6.5**
-----------------------------------
To load custom vSphere PowerCLI settings automatically, you can create a script configuration file named Initialize-PowerCLIEnvironment_Custom.ps1 in the Scripts folder. The application recognizes and loads the custom file after loading the default script configuration file.

**Installation - PowerCLI 6.5 and Later**  
-----------------------------------------
Add "%ProgramFiles(x86)%\VMware\Infrastructure\PowerCLI\Scripts" to the system path.

Modify the PowerCLI shortcut: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -noe -c ". Initialize-PowerCLIEnvironment.ps1 $true; . Initialize-PowerCLIEnvironment_Custom.ps1"
