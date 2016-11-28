$productName = "vSphere PowerCLI"
$productShortName = "PowerCLI"
$version = Get-PowerCLIVersion
$windowTitle = "VMware $productName {0}.{1}" -f $version.Major, $version.Minor
$host.ui.RawUI.WindowTitle = "$windowTitle"
$CustomInitScriptName = "Initialize-PowerCLIEnvironment_Custom.ps1"
$currentDir = Split-Path $MyInvocation.MyCommand.Path
$CustomInitScript = Join-Path $currentDir $CustomInitScriptName


<#
        .Synopsis
        Shows the status of the SSH service
        .Description
        Retrieves the status of the SSH service of VMHosts provided, or VMHosts in the cluster provided
        .Parameter VMHosts
        The VMHosts you want to get the SSH service status of. Can be a single host or multiple hosts provided by the pipeline
        .Example
        Get-VMHostSSHServiceStatus
        Shows the SSH service status of all VMHosts in your vCenter
        .Example
        Get-VMHostSSHServiceStatus vmhost1
        Shows the SSH service status of vmhost1
        .Example
        Get-VMHostSSHServiceStatus -cluster cluster1
        Shows the SSH service status of all vmhosts in cluster1
        .Example
        Get-VMHost -location folder1 | Get-VMHostSSHServiceStatus
        Shows the SSH service status of VMHosts in folder1
        .Link
        http://www.dsatechnologies.com
#>
function global:Get-VMHostSSHServiceStatus {
    [CmdletBinding()] 
    Param (
        [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, Mandatory=$False, Position=0)][Alias('Name')]
        [string[]]$VMHosts,
        [parameter(Mandatory=$False)]
        [string]$Cluster
    )
    Process {
        If ($VMHosts) {
            foreach ($VMHost in $VMHosts) {
                get-vmhostservice $VMHost | where { $_.key -eq "tsm-ssh" } | select VMHost, Label, Running
            }
        }
        elseif ($Cluster) {
            foreach ($VMHost in (Get-VMHost -Location $Cluster)) {
                get-vmhostservice $VMHost | where { $_.key -eq "tsm-ssh" } | select VMHost, Label, Running
            }
        }
        else {
            get-vmhostservice '*' | where { $_.key -eq "tsm-ssh" } | select VMHost, Label, Running
        }
    }
}


<#
        .Synopsis
        Starts the SSH service
        .Description
        Starts the SSH service of VMHosts provided, or VMHosts in the cluster provided
        .Parameter VMHosts
        The VMHosts you want to start the SSH service on. Can be a single host or multiple hosts provided by the pipeline
        .Example
        Start-VMHostSSHService
        Starts the SSH service on all VMHosts in your vCenter
        .Example
        Start-VMHostSSHService vmhost1
        Starts the SSH service on vmhost1
        .Example
        Start-VMHostSSHService -cluster cluster1
        Starts the SSH service on all vmhosts in cluster1
        .Example
        Get-VMHost -location folder1 | Start-VMHostSSHService
        Starts the SSH service on VMHosts in folder1
        .Link
        http://www.dsatechnologies.com
#>
function global:Start-VMHostSSHService {
    [CmdletBinding(SupportsShouldProcess=$True)] 
    Param (
        [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, Mandatory=$False, Position=0)][Alias('Name')]
        [string[]]$VMHosts,
        [parameter(Mandatory=$False)]
        [string]$Cluster
    )
    Process {
        If ($VMHosts) {
            foreach ($VMHost in $VMHosts) {
                start-vmhostservice -hostservice (get-vmhostservice $VMHost | where { $_.key -eq "tsm-ssh"}) > $null
            }
            
            Get-VMHostSSHServiceStatus -VMHosts $VMHosts
        }
        elseif ($Cluster) {
            foreach ($VMHost in (Get-VMHost -Location $Cluster)) {
                start-vmhostservice -hostservice (get-vmhostservice $VMHost | where { $_.key -eq "tsm-ssh"}) > $null
            }
            
            Get-VMHostSSHServiceStatus -Cluster $Cluster
        }
        else {
            start-vmhostservice -hostservice (get-vmhostservice '*' | where { $_.key -eq "tsm-ssh"}) > $null
            
            Get-VMHostSSHServiceStatus
        }
    }
}


<#
        .Synopsis
        Stops the SSH service
        .Description
        Stops the SSH service of VMHosts provided, or VMHosts in the cluster provided
        .Parameter VMHosts
        The VMHosts you want to stops the SSH service on. Can be a single host or multiple hosts provided by the pipeline
        .Example
        Stop-VMHostSSHService
        Stops the SSH service on all VMHosts in your vCenter
        .Example
        Stop-VMHostSSHService vmhost1
        Stops the SSH service on vmhost1
        .Example
        Stop-VMHostSSHService -cluster cluster1
        Stops the SSH service on all vmhosts in cluster1
        .Example
        Get-VMHost -location folder1 | Stop-VMHostSSHService
        Stops the SSH service on VMHosts in folder1
        .Link
        http://www.dsatechnologies.com
#>
function global:Stop-VMHostSSHService {
    [CmdletBinding(SupportsShouldProcess=$True)] 
    Param (
        [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, Mandatory=$False, Position=0)][Alias('Name')]
        [string[]]$VMHosts,
        [parameter(Mandatory=$False)]
        [string]$Cluster
    )
    Process {
        If ($VMHosts) {
            foreach ($VMHost in $VMHosts) {
                stop-vmhostservice -hostservice (get-vmhostservice $VMHost | where { $_.key -eq "tsm-ssh"}) > $null
            }
            
            Get-VMHostSSHServiceStatus -VMHosts $VMHosts
        }
        elseif ($Cluster) {
            foreach ($VMHost in (Get-VMHost -Location $Cluster)) {
                stop-vmhostservice -hostservice (get-vmhostservice $VMHost | where { $_.key -eq "tsm-ssh"}) > $null
            }
            
            Get-VMHostSSHServiceStatus -Cluster $Cluster
        }
        else {
            stop-vmhostservice -hostservice (get-vmhostservice '*' | where { $_.key -eq "tsm-ssh"}) > $null
            
            Get-VMHostSSHServiceStatus
        }
    }
}


<#
        .Synopsis
        Shows the uptime of VMHosts
        .Description
        Calculates the uptime of VMHosts provided, or VMHosts in the cluster provided
        .Parameter VMHosts
        The VMHosts you want to get the uptime of. Can be a single host or multiple hosts provided by the pipeline
        .Example
        Get-VMHostUptime
        Shows the uptime of all VMHosts in your vCenter
        .Example
        Get-VMHostUptime vmhost1
        Shows the uptime of vmhost1
        .Example
        Get-VMHostUptime -cluster cluster1
        Shows the uptime of all vmhosts in cluster1
        .Example
        Get-VMHost -location folder1 | Get-VMHostUptime
        Shows the uptime of VMHosts in folder1
        .Link
        http://cloud.kemta.net
#>
function global:Get-VMHostUptime {
    [CmdletBinding()] 
    Param (
        [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)][Alias('Name')]
        [string]$VMHosts, [string]$Cluster
    )

    Process {
        If ($VMHosts) {
            foreach ($VMHost in $VMHosts) {Get-View  -ViewType hostsystem -Property name,runtime.boottime -Filter @{"name" = "$VMHost"} | Select-Object Name, @{N="Uptime (Days)"; E={[math]::round((((Get-Date) - ($_.Runtime.BootTime)).TotalDays),1)}}, @{N="Uptime (Hours)"; E={[math]::round((((Get-Date) - ($_.Runtime.BootTime)).TotalHours),1)}}, @{N="Uptime (Minutes)"; E={[math]::round((((Get-Date) - ($_.Runtime.BootTime)).TotalMinutes),1)}}}
        }
        elseif ($Cluster) {
            foreach ($VMHost in (Get-VMHost -Location $Cluster)) {Get-View  -ViewType hostsystem -Property name,runtime.boottime -Filter @{"name" = "$VMHost"} | Select-Object Name, @{N="Uptime (Days)"; E={[math]::round((((Get-Date) - ($_.Runtime.BootTime)).TotalDays),1)}}, @{N="Uptime (Hours)"; E={[math]::round((((Get-Date) - ($_.Runtime.BootTime)).TotalHours),1)}}, @{N="Uptime (Minutes)"; E={[math]::round((((Get-Date) - ($_.Runtime.BootTime)).TotalMinutes),1)}}}
        }
        else {
            Get-View  -ViewType hostsystem -Property name,runtime.boottime | Select-Object Name, @{N="Uptime (Days)"; E={[math]::round((((Get-Date) - ($_.Runtime.BootTime)).TotalDays),1)}}, @{N="Uptime (Hours)"; E={[math]::round((((Get-Date) - ($_.Runtime.BootTime)).TotalHours),1)}}, @{N="Uptime (Minutes)"; E={[math]::round((((Get-Date) - ($_.Runtime.BootTime)).TotalMinutes),1)}}
        }
    }
}


<#
        .Synopsis
        Shows the datastore usage
        .Description
        Retrieves the datastore usage of VMHosts provided
        .Parameter VMHosts
        The VMHosts you want to get the SSH service status of. Can be a single host or multiple hosts provided by the pipeline
        .Example
        Get-VMHostDatastores
        Shows the usage statistics of all unique datastores in vCenter
        .Example
        Get-VMHostDatastores vmhost1
        Shows the usage statistics of all datastores on vmhost1
        .Example
        Get-VMHost -location folder1 | Get-VMHostDatastores
        Shows the usage statistics of all datastores of hosts in 'folder1'
        .Example
        Get-VMHostDatastores (get-cluster 'cluster1' | get-vmhost)
        Shows the usage statistics of all datastores of all hosts in vCenter cluster 'cluster1'
        .Link
        http://www.dsatechnologies.com
#>
function global:Get-VMHostDatastores {
    [CmdletBinding()] 
    Param (
        [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, Mandatory=$False, Position=0)][Alias('Name')]
        [string[]]$VMHosts
    )
    Process {
        If ($VMHosts) {
            Get-Datastore -VMHost $VMHosts | select-object -unique Name, @{N='Capacity (GB)'; E={{{0:N2}} -f $_.CapacityGB}}, @{N='UsedSpace (GB)'; E={{{0:N2}} -f ($_.CapacityGB - $_.FreeSpaceGB)}}, @{N='FreeSpace (GB)'; E={{{0:N2}} -f $_.FreeSpaceGB}}
        }
        else {
            Get-Datastore | select-object -unique Name, @{N='Capacity (GB)'; E={{{0:N2}} -f $_.CapacityGB}}, @{N='UsedSpace (GB)'; E={{{0:N2}} -f ($_.CapacityGB - $_.FreeSpaceGB)}}, @{N='FreeSpace (GB)'; E={{{0:N2}} -f $_.FreeSpaceGB}}
        }
    }
}