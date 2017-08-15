function Get-OpenVasReport
{
<#
.Synopsis
    Return an OpenVAS report
.DESCRIPTION
    Return an OpenVAS report
    
    Built with infomation from http://docs.greenbone.net/GSM-Manual/gos-4/en/omp.html#access-with-omp

    See http://myworldofit.net/?p=10436 for detailed usage examples
.EXAMPLE
    Get-OpenVasReport -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -TaskGUID 7a11e9a4-a64c-4281-84c2-76d9440e1514 -ReportFormat 'CSV Results' -OutputPath C:\Reports\OpenVAS-Report.csv
.EXAMPLE
    Get-OpenVasReport -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -TaskGUID 7a11e9a4-a64c-4281-84c2-76d9440e1514 -ReportFormat HTML -OutputPath C:\Reports\OpenVAS-Report.htm
.EXAMPLE
    Get-OpenVasReport -OmpPath "C:\Program Files (x86)\OpenVAS-OMP" -ReportGUID 0b80171d-402b-4c0c-a353-800fbffa564a -ReportFormat HTML -OutputPath C:\Temp\OpenVAS-Report.htm
#>

param(
    [Parameter(Mandatory=$true,HelpMessage="Path to OMP.exe e.g. 'C:\Program Files (x86)\OpenVAS-OMP'")]
    [String]$OmpPath,
    [Parameter(Mandatory=$true,HelpMessage="The name of the task e.g. 'VLAN4'",ParameterSetName='By Task Name')]
    [String]$TaskName,
    [Parameter(Mandatory=$true,HelpMessage="The GUID of the task e.g. 'daba56c8-73ec-11df-a475-002264764cea'",ParameterSetName='By Task GUID')]
    [String]$TaskGUID,
    [Parameter(Mandatory=$true,HelpMessage="The GUID of the report e.g. '14740905-0928-47d4-902e-8acfc6a218ec'",ParameterSetName='By Report GUID')]
    [String]$ReportGUID,
    [Parameter(Mandatory=$true,HelpMessage="Select the format out of the exported report e.g. CSV Results")]
    [ValidateSet("Anonymous XML","ARF","CPE","CSV Hosts","CSV Results","HTML","ITG","LaTeX","NBE","PDF","Topology SVG","TXT","Verinice ISM","Verinice ITG","XML")]
    [String]$ReportFormat,
    [Parameter(Mandatory=$true,HelpMessage="The path to export the report to (including filename) e.g. 'C:\Reports\OpenVAS-Repot.csv'")]
    [String]$OutputPath
    )
    
    #Get the report formats and return the GUID of the format required for the value of $ReportFormat
    $ReportFormats = Get-OpenVasReportFormats -OmpPath $OmpPath

    foreach($Format in $ReportFormats){
        if($Format.Name -eq $ReportFormat){
            $ReportFormatGUID = $Format.GUID
        }
    }

    #If a Task GUID has been provided get the most recent report and return it's results
    if($TaskGUID -ne ""){
        #Get the list of reports and select only the last one
        $Reports = & $OmpPath\omp.exe --get-tasks $TaskGUID 2> $null

        $LastRow = $Reports[-1]
        $ReportGUID = $LastRow.Substring(2,36)

        #Export the report in the requested format
        & $OmpPath\omp.exe --get-report $ReportGUID --format $ReportFormatGUID 2> $null | Out-File $OutputPath
    }
    #If a Task Name has been provided get the most recent report and return it's results
    elseif($TaskName -ne ""){
        #Get the GUIDs needed from OpenVAS
        $Tasks = Get-OpenVasTasks -OmpPath $OmpPath

        foreach($Task in $Tasks){
            if ($TaskName -eq $Task.Name)
            {
                $TaskGUID = $Task.GUID
            }
        }
        #Get the list of reports and select only the last one
        $Reports = & $OmpPath\omp.exe --get-tasks $TaskGUID 2> $null

        $LastRow = $Reports[-1]
        $ReportGUID = $LastRow.Substring(2,36)

        #Export the report in the requested format
        & $OmpPath\omp.exe --get-report $ReportGUID --format $ReportFormatGUID 2> $null | Out-File $OutputPath
    }
    #If a specific Report GUID has been provided get that specific report
    elseif($ReportGUID -ne ""){
        & $OmpPath\omp.exe --get-report $ReportGUID --format $ReportFormatGUID 2> $null | Out-File $OutputPath
    }
}