function Get-OpenVasTargets
{
<#
.Synopsis
   Return the GUIDs and Target Names from an OpenVAS Server
.DESCRIPTION
   Return the GUIDs and Target Names from an OpenVAS Server
.EXAMPLE
   Get-OpenVasTargets -OmpPath "C:\Program Files (x86)\OpenVAS-OMP"
.EXAMPLE
    Get-OpenVasTargets -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" | Out-GridView
#>

param(
    [Parameter(Mandatory=$true,HelpMessage="Path to OMP.exe e.g. 'C:\Program Files (x86)\OpenVAS-OMP'")]
    [String]$OmpPath
    )
    
    #Run the query against the OpenVAS Server
    $Targets = & $OmpPath\omp.exe -T 2> $null

    #
    $OutputTargets = New-Object System.Collections.ArrayList

    foreach($line in $Targets){
        $item = New-Object -TypeName System.Object
        $item | Add-Member -MemberType NoteProperty -Name "GUID" -Value $line.Substring(0,36)
        $item | Add-Member -MemberType NoteProperty -Name "Name" -Value $line.Remove(0,38)
        $OutputTargets.Add($item) | Out-Null
    }

    return $OutputTargets
}