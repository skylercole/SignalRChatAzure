Param( 
    [Parameter(Mandatory = $true)] 
    [String]$WebDeployFile, 
    [Parameter(Mandatory = $true)] 
    [String]$SetParametersFile, 
    [Parameter(Mandatory = $true)] 
    [String]$PublishSettingsFile 
) 
 
# Begin - Actual script ----------------------------------------------------------------------------------------------------------------------------- 
  
# Set the output level to verbose and make the script stop on error 
$VerbosePreference = "Continue" 
$ErrorActionPreference = "Stop" 
  
$scriptPath = Split-Path -parent $PSCommandPath 
 
# Verify that the account credentials are current in the Windows  
#  PowerShell session. This call fails if the credentials have 
#  expired in the session. 
Write-Verbose "Verifying that Windows Azure credentials in the Windows PowerShell session have not expired." 
Get-AzureWebsite | Out-Null 
  
# Read from the publish settings file to get the user name, password, publish URL and web site name 
[Xml]$envXml = Get-Content $PublishSettingsFile 
if (!$envXml) {throw "Error: Cannot find the publish settings file: $PublishSettingsFile"} 
$userName = $envXml.publishData.publishProfile.userName[0] 
$password = $envxml.publishData.publishProfile.userPWD[0] 
$publishURL = $envXml.publishData.publishProfile.publishUrl[0] 
$websiteName = $envXml.publishData.publishProfile.msdeploySite[0] 
 
# Mark the start time of the script execution 
$startTime = Get-Date 
 
# Build and publish the project via web deploy package using msbuild.exe  
Write-Verbose ("[Start] deploying to Windows Azure website {0}" -f $websiteName) 
 
# Run MSDeploy to publish the project 
$msbuildPath="C:\Program Files\IIS\Microsoft Web Deploy V3\" 
 
if (!$env:Path.Contains($msbuildPath)) { 
    if($env:Path[-1] -ne ";") { 
     $env:Path += ";" 
    } 
    $env:Path += $msbuildPath 
} 
 
# $SetParametersFile left intentionally without quotes as, in my limited testing, MSDeploy seemed to not like quotes around this parameter  
cmd.exe /C $("msdeploy.exe -source:package='$WebDeployFile' -dest:auto,computerName='https://$publishURL/msdeploy.axd?site=$websiteName',userName='$userName',password='$password',authtype='Basic',includeAcls='False' -verb:sync -disableLink:AppPoolExtension -disableLink:ContentExtension -disableLink:CertificateExtension -setParamFile:$SetParametersFile") 
  
Write-Verbose "[Finish] deploying to Windows Azure website $websiteName" 
# Mark the finish time of the script execution 
$finishTime = Get-Date 
 
# Output the time consumed in seconds 
Write-Output "Total time used (seconds): ($finishTime - $startTime).TotalSeconds)"s