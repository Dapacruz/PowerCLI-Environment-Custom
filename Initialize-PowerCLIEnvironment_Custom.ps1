<#
        This module extends the functionality of PowerCLI

        Initialize-PowerCLIEnvironment_Custom.ps1 1.1

        Author: David Cruz (davidcruz72@gmail.com)

        PowerCLI version: 6.5
        PowerShell version: 5.1

        Required Python packages:
        None.

        Features:
        Get/Start/Stop ESXi host SSH service
        Get ESXi host uptime
        List ESXi host datastores
        Export ESXi host networking to CSV
        Configure ESXi host networking from CSV
#>


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
        https://github.com/Dapacr/PowerCLI-Environment-Custom
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
        https://github.com/Dapacr/PowerCLI-Environment-Custom
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
        https://github.com/Dapacr/PowerCLI-Environment-Custom
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
        The VMHosts you want to get datastore usage of. Can be a single host or multiple hosts provided by the pipeline
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
        https://github.com/Dapacr/PowerCLI-Environment-Custom
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


<#
        .Synopsis
        Export host networking
        .Description
        Exports host networking of VMHosts provided
        .Parameter VMHosts
        The VMHosts you want to export networking for. Can be a single host or multiple hosts provided by the pipeline
        .Example
        Export-VMHostNetworkingToCsv vmhost*
        Exports networking for vmhosts with names that begin with "vmhost"
        .Link
        https://github.com/Dapacr/PowerCLI-Environment-Custom
#>
function global:Export-VMHostNetworkingToCsv {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, Mandatory=$True, Position=0)][Alias('Name')]
        [string[]]$VMHosts,
        [string]$VirtualSwitchesCsvPath = 'Virtual_Switches.csv',
        [string]$VirtualPortGroupsCsvPath = 'Virtual_Port_Groups.csv',
        [string]$VMHostNetworkAdaptersCsvPath = 'VMHost_Network_Adapters.csv'
    )
    Begin {
        $virtual_switches = @()
        $virtual_port_groups = @()
        $vmhost_network_adapters = @()
    }
    Process {
        # Expand to full hostname in case wildcards are used
        $VMHosts = Get-VMHost -Name $VMHosts

        foreach ($VMHost in $VMHosts) {
            # Export virtual switches
            foreach ($s in Get-VirtualSwitch -VMHost $VMHost) {
                $obj = New-Object PSObject
                $obj | Add-Member -MemberType NoteProperty -Name 'VMHost' -Value $VMHost
                $obj | Add-Member -MemberType NoteProperty -Name 'Name' -Value $s.Name
                # Convert array to a comma separated string
                $obj | Add-Member -MemberType NoteProperty -Name 'Nic' -Value "$($s.Nic)".Replace(' ', ',')
                $obj | Add-Member -MemberType NoteProperty -Name 'Mtu' -Value $s.Mtu

                $virtual_switches += $obj
            }

            # Export virtual port groups
            foreach ($s in Get-VirtualPortGroup -VMHost $VMHost) {
                $obj = New-Object PSObject
                $obj | Add-Member -MemberType NoteProperty -Name 'VMHost' -Value $VMHost
                $obj | Add-Member -MemberType NoteProperty -Name 'Name' -Value $s.Name
                $obj | Add-Member -MemberType NoteProperty -Name 'VirtualSwitch' -Value $s.VirtualSwitch
                $obj | Add-Member -MemberType NoteProperty -Name 'VLanId' -Value $s.VLanId

                $virtual_port_groups += $obj
            }

            # Export host network adapters
            # TODO Include vmnic active/standby/unused settings
            foreach ($s in Get-VMHostNetworkAdapter -VMHost $VMHost -VMKernel) {
                $obj = New-Object PSObject
                $obj | Add-Member -MemberType NoteProperty -Name 'VMHost' -Value $VMHost
                $obj | Add-Member -MemberType NoteProperty -Name 'DeviceName' -Value $s.DeviceName
                $obj | Add-Member -MemberType NoteProperty -Name 'PortGroup' -Value $s.PortGroupName
                $obj | Add-Member -MemberType NoteProperty -Name 'IP' -Value $s.IP
                $obj | Add-Member -MemberType NoteProperty -Name 'SubnetMask' -Value $s.SubnetMask
                $obj | Add-Member -MemberType NoteProperty -Name 'Mtu' -Value $s.Mtu
                $obj | Add-Member -MemberType NoteProperty -Name 'VMotionEnabled' -Value $s.VMotionEnabled
                $obj | Add-Member -MemberType NoteProperty -Name 'FaultToleranceLoggingEnabled' -Value $s.FaultToleranceLoggingEnabled
                $obj | Add-Member -MemberType NoteProperty -Name 'ManagementTrafficEnabled' -Value $s.ManagementTrafficEnabled
                $obj | Add-Member -MemberType NoteProperty -Name 'VsanTrafficEnabled' -Value $s.VsanTrafficEnabled

                $vmhost_network_adapters += $obj
            }
        }
    }
    End {         
        $virtual_switches | Export-Csv -Path $VirtualSwitchesCsvPath -NoTypeInformation
        $virtual_port_groups | Export-Csv -Path $VirtualPortGroupsCsvPath -NoTypeInformation
        $vmhost_network_adapters | Export-Csv -Path $VMHostNetworkAdaptersCsvPath -NoTypeInformation
    
        Invoke-Item -Path $VirtualSwitchesCsvPath, $VirtualPortGroupsCsvPath, $VMHostNetworkAdaptersCsvPath
    }
}

<#
        .Synopsis
        Configures host networking
        .Description
        Configures host networking for VMHosts provided utilizing the output from Export-VMHostNetworking
        .Parameter VMHosts
        The VMHosts you want to configure networking for. Can be a single host or multiple hosts provided by the pipeline
        .Example
        Configure-VMHostNetworking vmhost1
        Configures networking for vmhost1
        .Link
        https://github.com/Dapacr/PowerCLI-Environment-Custom
#>
function global:Configure-VMHostNetworking {
    # Still a work in progress
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, Mandatory=$True, Position=0)][Alias('Name')]
        [string[]]$VMHosts,
        [string]$VirtualSwitchesCsvPath = 'Virtual_Switches.csv',
        [string]$VirtualPortGroupsCsvPath = 'Virtual_Port_Groups.csv',
        [string]$VMHostNetworkAdaptersCsvPath = 'VMHost_Network_Adapters.csv'
    )
    Begin {
        $virtual_switches = Import-Csv $VirtualSwitchesCsvPath
        $virtual_port_groups = Import-Csv $VirtualPortGroupsCsvPath
        $vmhost_network_adapters = Import-Csv $VMHostNetworkAdaptersCsvPath
    }
    Process {
        # Expand to full hostname in case wildcards are used
        $VMHosts = Get-VMHost -Name $VMHosts

        foreach ($VMHost in $VMHosts) {
            # Create virtual switches. Skip vSwitch0 since it exists by default
            foreach ($s in $virtual_switches) {
                if ($s.VMHost -ne $VMHost) {
                    continue
                }
                if ($s.Name -eq 'vSwitch0') {
                    continue
                }
                $params = @{
                    'VMHost'=$VMHost
                    'Name'=$s.Name
                    'Nic'=$s.Nic
                    'Mtu'=$s.Mtu
                }
                New-VirtualSwitch @params -WhatIf
            }

            # Remove default VM Network virtual port group since it exists by default
            Remove-VirtualPortGroup -VirtualPortGroup (Get-VirtualPortGroup -VMHost $VMHost -Name 'VM Network') -WhatIf

            # Create virtual port groups
            foreach ($vpg in $virtual_port_groups) {
                if ($vpg.VMHost -ne $VMHost) {
                    continue
                }
                $params = @{
                    'Name'=$vpg.Name
                    'VirtualSwitch'=$vpg.VirtualSwitch
                    'VLanId'=$vpg.VLanId
                }
                New-VirtualPortGroup @params -WhatIf
            }

            # Create host network adapters in their original order to maintain device name
            foreach ($n in $vmhost_network_adapters | Sort-Object -Property DeviceName ) {
                if ($n.VMHost -ne $VMHost) {
                    continue
                }
                # Skip Management Network port group since it exists by default
                if ($n.PortGroup -eq 'Management Network') {
                    continue
                }
        
                # Convert empty properties to FALSE
                foreach ($p in $n.PSObject.Properties) {
                    if ($p.Value -eq '') {
                        $p.Value = "FALSE"
                    }
                }

                $params = @{
                    'VMHost'= $VMHost
                    'PortGroup'=$n.PortGroup
                    'IP'=$n.IP
                    'SubnetMask'=$n.SubnetMask
                    'Mtu'=$n.Mtu
                    'VMotionEnabled'=$n.VMotionEnabled
                    'FaultToleranceLoggingEnabled'=$n.FaultToleranceLoggingEnabled
                    'ManagementTrafficEnabled'=$n.ManagementTrafficEnabled
                    'VsanTrafficEnabled'=$n.VsanTrafficEnabled
                }
                New-VMHostNetworkAdapter @params -WhatIf
            }
        }
    }
}