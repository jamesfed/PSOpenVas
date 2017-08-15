function Start-OpenVasTask
{
<#
.Synopsis
   Start and existing Task in OpenVAS
.DESCRIPTION
   Start and existing Task in OpenVAS

   Built with infomation from http://docs.greenbone.net/GSM-Manual/gos-4/en/omp.html#access-with-omp
   
   See http://myworldofit.net/?p=10436 for detailed usage examples
.EXAMPLE
   Start-OpenVasTask -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -TaskName 'Scan VLAN4'
.EXAMPLE
   Start-OpenVasTask -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -TaskGUID '4b787cf2-fc7c-44ad-8244-668284fee850'
#>

param(
    [Parameter(Mandatory=$true,HelpMessage="Path to OMP.exe e.g. 'C:\Program Files (x86)\OpenVAS-OMP'")]
    [String]$OmpPath,
    [Parameter(Mandatory=$true,HelpMessage="The name of the task e.g. 'VLAN4'",ParameterSetName='By Task Name')]
    [String]$TaskName,
    [Parameter(Mandatory=$true,HelpMessage="The GUID of the task e.g. 'daba56c8-73ec-11df-a475-002264764cea'",ParameterSetName='By Task GUID')]
    [String]$TaskGUID
    )
    
    #Handle the use of By Task GUID
    if($TaskGUID -ne ""){
        #Run the query against the OpenVAS Server
        & $OmpPath\omp.exe -S $TaskGUID 2> $null
    }
    elseif($TaskName -ne ""){
        #Get the GUIDs needed from OpenVAS
        $Tasks = Get-OpenVasTasks -OmpPath $OmpPath

        foreach($Task in $Tasks){
            if ($TaskName -eq $Task.Name)
            {
                $TaskGUID = $Task.GUID
            }
        }

        #Run the query against the OpenVAS Server
        & $OmpPath\omp.exe -S $TaskGUID 2> $null 
    }
}