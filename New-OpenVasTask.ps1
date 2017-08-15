function New-OpenVasTask
{
<#
.Synopsis
   Add a new Task to OpenVAS
.DESCRIPTION
   Add a new Task to OpenVAS

   Built with infomation from http://docs.greenbone.net/GSM-Manual/gos-4/en/omp.html#access-with-omp

   See http://myworldofit.net/?p=10436 for detailed usage examples
.EXAMPLE
   New-OpenVasTask -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -Name "Test VLAN4" -TargetName "VLAN4" -ScanName "Full and fast"
#>

param(
    [Parameter(Mandatory=$true,HelpMessage="Path to OMP.exe e.g. 'C:\Program Files (x86)\OpenVAS-OMP'")]
    [String]$OmpPath,
    [Parameter(Mandatory=$true,HelpMessage="Descriptive name for the task")]
    [String]$Name,
    [Parameter(Mandatory=$true,HelpMessage="The name of the target for the scan e.g. 'VLAN4'",ParameterSetName='By Target/Scan Name')]
    [String]$TargetName,
    [Parameter(Mandatory=$true,HelpMessage="The GUID of the target for the scan e.g. '947e874d-3c57-4047-9cb8-594a19b3a51b'",ParameterSetName='By Target/Scan GUID')]
    [String]$TargetGUID,
    [Parameter(Mandatory=$true,HelpMessage="The name of the scan for the task e.g. 'Full and fast'",ParameterSetName='By Target/Scan Name')]
    [String]$ScanName,
    [Parameter(Mandatory=$true,HelpMessage="The GUID of the scan for the task e.g. 'daba56c8-73ec-11df-a475-002264764cea'",ParameterSetName='By Target/Scan GUID')]
    [String]$ScanGUID
    )
    
    #Handle the use of By Target/Scan GUID
    if($TargetGUID -ne ""){
        #Run the query against the OpenVAS Server
        & $OmpPath\omp.exe -C -c $ScanGUID --name $Name -t $TargetGUID 2> $null
    }
    elseif($TargetName -ne ""){
        #Get the GUIDs needed from OpenVAS
        $Scans = Get-OpenVasScans -OmpPath $OmpPath
        $Targets = Get-OpenVasTargets -OmpPath $OmpPath

        foreach($Target in $Targets){
            if ($TargetName -eq $Target.Name)
            {
                $TargetGUID = $Target.GUID
            }
        }
        foreach($Scan in $Scans){
            if ($ScanName -eq $Scan.Name)
            {
                $ScanGUID = $Scan.GUID
            }
        }
        #Run the query against the OpenVAS Server
        & $OmpPath\omp.exe -C -c $ScanGUID --name $Name -t $TargetGUID 2> $null 
    }
}