Param([string]$publishsettings="freetrial.publishsettings",
      [string]$storageaccount="nextgameschatcloud",
      [string]$subscription="Free Trial",
      [string]$service="nextgameschatcloud",
      [string]$containerName="mydeployments",
      [string]$config="C:\Users\stanislav.stoyanov\Documents\Visual Studio 2015\Projects\NextGamesChat\NextGamesChatCloud\packageapp.publish\ServiceConfiguration.Cloud.cscfg",
      [string]$package="C:\Users\stanislav.stoyanov\Documents\Visual Studio 2015\Projects\NextGamesChat\NextGamesChatCloud\packageapp.publish\NextGamesChatCloud.cspkg",
      [string]$slot="Production")
 
Function Get-File($filter){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $fd = New-Object system.windows.forms.openfiledialog
    $fd.MultiSelect = $false
    $fd.Filter = $filter
    [void]$fd.showdialog()
    return $fd.FileName
}
 
Function Set-AzureSettings($publishsettings, $subscription, $storageaccount){
	Import-AzurePublishSettingsFile $publishsettings
    #Set-AzureSubscription –SubscriptionName $subscription -CurrentStorageAccountName $storageaccount
    Select-AzureSubscription $subscription
}
 
Function Upload-Package($package, $containerName){
    $blob = "$service.package.$(get-date -f yyyy_MM_dd_hh_ss).cspkg"
     
    $containerState = Get-AzureStorageContainer -Name $containerName -ea 0
    if ($containerState -eq $null)
    {
        New-AzureStorageContainer -Name $containerName | out-null
    }
     
    Set-AzureStorageBlobContent -File $package -Container $containerName -Blob $blob -Force| Out-Null
    $blobState = Get-AzureStorageBlob -blob $blob -Container $containerName
 
    $blobState.ICloudBlob.uri.AbsoluteUri
}
 
Function Create-Deployment($package_url, $service, $slot, $config){
    $opstat = New-AzureDeployment -Slot $slot -Package $package_url -Configuration $config -ServiceName $service
}
  
Function Upgrade-Deployment($package_url, $service, $slot, $config){
    $setdeployment = Set-AzureDeployment -Upgrade -Slot $slot -Package $package_url -Configuration $config -ServiceName $service -Force
}
 
Function Check-Deployment($service, $slot){
    $completeDeployment = Get-AzureDeployment -ServiceName $service -Slot $slot
    $completeDeployment.deploymentid
}
 
try{
    Write-Host "Running Azure Imports"
    Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
 
    Write-Host "Gathering information"
    if (!$subscription){    $subscription = Read-Host "Subscription (case-sensitive)"}
    if (!$storageaccount){    $storageaccount = Read-Host "Storage account name"}
    if (!$service){            $service = Read-Host "Cloud service name"}
    if (!$publishsettings){    $publishsettings = Get-File "Azure publish settings (*.publishsettings)|*.publishsettings"}
    if (!$package){            $package = Get-File "Azure package (*.cspkg)|*.cspkg"}
    if (!$config){            $config = Get-File "Azure config file (*.cspkg)|*.cscfg"}
 
    Write-Host "Importing publish profile and setting subscription"
    Set-AzureSettings -publishsettings $publishsettings -subscription $subscription -storageaccount $storageaccount
 
    Write-Host "Upload the deployment package"
    $package_url = Upload-Package -package $package -containerName $containerName
    Write-Host "Package uploaded to $package_url"
 
    $deployment = Get-AzureDeployment -ServiceName $service -Slot $slot -ErrorAction silentlycontinue 
 
 
    if ($deployment.Name -eq $null) {
        Write-Host "No deployment is detected. Creating a new deployment. "
        Create-Deployment -package_url $package_url -service $service -slot $slot -config $config
        Write-Host "New Deployment created"
 
    } else {
        Write-Host "Deployment exists in $service.  Upgrading deployment."
        Upgrade-Deployment -package_url $package_url -service $service -slot $slot -config $config
        Write-Host "Upgraded Deployment"
    }
 
    $deploymentid = Check-Deployment -service $service -slot $slot
    Write-Host "Deployed to $service with deployment id $deploymentid"
    exit 0
}
catch [System.Exception] {
    Write-Host $_.Exception.ToString()
    exit 1
}