function Get-OpenVasScans
{
<#
.Synopsis
   Return the GUIDs and Scan Names from an OpenVAS Server
.DESCRIPTION
   Return the GUIDs and Scan Names from an OpenVAS Server
.EXAMPLE
   Get-OpenVasScans -OmpPath "C:\Program Files (x86)\OpenVAS-OMP"
.EXAMPLE
   Get-OpenVasScans -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" | Out-GridView
#>

param(
    [Parameter(Mandatory=$true,HelpMessage="Path to OMP.exe e.g. 'C:\Program Files (x86)\OpenVAS-OMP'")]
    [String]$OmpPath
    )
    
    #Run the query against the OpenVAS Server
    $Scans = & $Source\omp.exe -g 2> $null

    #Build a collection to store the results in
    $OutputScans = New-Object System.Collections.ArrayList

    foreach($line in $Scans){

        #Extract the useful info from $Tasks
        $item = New-Object -TypeName System.Object
        $item | Add-Member -MemberType NoteProperty -Name "GUID" -Value $line.Substring(0,36)
        $item | Add-Member -MemberType NoteProperty -Name "Name" -Value $line.Remove(0,38)
        
        #Add it to the collection
        $OutputScans.Add($item) | Out-Null
    }

    #Return the tasks
    return $OutputScans
}