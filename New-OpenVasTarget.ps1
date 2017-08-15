function New-OpenVasTarget
{
<#
.Synopsis
   Add a new Target (with or without Exceptions) to OpenVAS
.DESCRIPTION
   Add a new Target (with or without Exceptions) to OpenVAS

   Built with infomation from http://docs.greenbone.net/GSM-Manual/gos-4/en/omp.html#access-with-omp

   See http://myworldofit.net/?p=10436 for detailed usage examples
.EXAMPLE
   New-OpenVasTarget -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -Name "Subnet" -Target "10.128.16.0/21" -Exclude "10.128.16.1"
.EXAMPLE
   New-OpenVasTarget -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -Name "Range" -Target "10.128.16.1-10.128.16.32"
.EXAMPLE
    New-OpenVasTarget -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -Name "Client" -Target "10.128.16.1"
.EXAMPLE
    New-OpenVasTarget -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -Name "Hostname" -Target "pc1.work.com"
#>

param(
    [Parameter(Mandatory=$true,HelpMessage="Path to OMP.exe e.g. 'C:\Program Files (x86)\OpenVAS-OMP'")]
    [String]$OmpPath,
    [Parameter(Mandatory=$true,HelpMessage="Descriptive name for the target")]
    [String]$Name,
    [Parameter(Mandatory=$true,HelpMessage="Enter a Subnet, IP Range, Single IP or Hostname for the target")]
    [String]$Target,
    [Parameter(Mandatory=$false,HelpMessage="Enter a subnet, IP Range or Single IP to exclude from the target")]
    [String]$Exclude
    )
    
    #Run the query against the OpenVAS Server
    & $OmpPath\omp.exe -X "<create_target><name>$Name</name><hosts>$Target</hosts><exclude_hosts>$Exclude</exclude_hosts></create_target>" 2> $null
}