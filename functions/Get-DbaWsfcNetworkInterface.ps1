#ValidationTags#Messaging,FlowControl,Pipeline,CodeStyle#
function Get-DbaWsfcNetworkInterface {
    <#
    .SYNOPSIS
        Gets information about one or more network adapters in a failover cluster.

    .DESCRIPTION
        Gets information about one or more network adapters in a failover cluster.

        All Windows Server Failover Clustering (Wsfc) commands require local admin on each member node.

    .PARAMETER ComputerName
        The target cluster name. Can be a Network or the cluster name itself.

    .PARAMETER Credential
        Allows you to login to the cluster using alternative credentials.

    .PARAMETER EnableException
        By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
        This avoids overwhelming you with "sea of red" exceptions, but is inconvenient because it basically disables advanced scripting.
        Using this switch turns this "nice by default" feature off and enables you to catch exceptions with your own try/catch.

    .NOTES
        Tags: Cluster, WSFC, FCI, HA
        Author: Chrissy LeMaire (@cl), netnerds.net

        Website: https://dbatools.io
        Copyright: (c) 2018 by dbatools, licensed under MIT
        License: MIT https://opensource.org/licenses/MIT

    .LINK
        https://dbatools.io/Get-DbaWsfcNetworkInterface

    .EXAMPLE
        PS C:\> Get-DbaWsfcNetworkInterface -ComputerName cluster01

        Gets network interface information from the failover cluster cluster01

    .EXAMPLE
        PS C:\> Get-DbaWsfcNetworkInterface -ComputerName cluster01 | Select-Object *

        Shows all network interface  values, including the ones not shown in the default view

    #>
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline)]
        [DbaInstanceParameter[]]$ComputerName = $env:COMPUTERNAME,
        [PSCredential]$Credential,
        [switch]$EnableException
    )
    process {
        foreach ($computer in $computername) {
            $cluster = Get-DbaWsfcCluster -ComputerName $computer -Credential $Credential
            $network = Get-DbaCmObject -Computername $computer -Credential $Credential -Namespace root\MSCluster -ClassName MSCluster_NetworkInterface
            $network | Add-Member -Force -NotePropertyName ClusterName -NotePropertyValue $cluster.Name
            $network | Add-Member -Force -NotePropertyName ClusterFqdn -NotePropertyValue $cluster.Fqdn
            $network | Select-DefaultView -Property ClusterName, ClusterFqdn, Name, Network, Node, Adapter, Address, DhcpEnabled, IPv4Addresses, IPv6Addresses, IPv6Addresses
        }
    }
}