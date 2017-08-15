function Get-OpenVasTasks
{
<#
.Synopsis
   Return the GUIDs, status and Task Names from an OpenVAS Server
.DESCRIPTION
   Return the GUIDs, status and Task Names from an OpenVAS Server

   Built with infomation from http://docs.greenbone.net/GSM-Manual/gos-4/en/omp.html#access-with-omp

   See http://myworldofit.net/?p=10436 for detailed usage examples
.EXAMPLE
   Get-OpenVasTasks -OmpPath "C:\Program Files (x86)\OpenVAS-OMP"
.EXAMPLE
   Get-OpenVasTasks -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" | Out-GridView
#>

param(
    [Parameter(Mandatory=$true,HelpMessage="Path to OMP.exe e.g. 'C:\Program Files (x86)\OpenVAS-OMP'")]
    [String]$OmpPath
    )
    
    #Run the query against the OpenVAS Server
    $Tasks = & $OmpPath\omp.exe --get-tasks 2> $null

    #Build a collection to store the results in
    $OutputTasks = New-Object System.Collections.ArrayList

    foreach($line in $Tasks){

        #Extract the useful info from $Tasks
        $item = New-Object -TypeName System.Object
        $item | Add-Member -MemberType NoteProperty -Name "GUID" -Value $line.Substring(0,36)
        $item | Add-Member -MemberType NoteProperty -Name "Status" -Value $($line.Substring(38,13)).TrimEnd()
        $item | Add-Member -MemberType NoteProperty -Name "Name" -Value $line.Remove(0,51)
        
        #Add it to the collection
        $OutputTasks.Add($item) | Out-Null
    }

    #Return the tasks
    return $OutputTasks
}