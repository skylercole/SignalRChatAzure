$msbuild = "& 'C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe' "
$build = $msbuild + " NextGamesChatCloud\NextGamesChatCloud.ccproj /p:Configuration=Release /p:DebugType=None /p:OutputPath=package /p:Platform=AnyCpu /p:TargetProfile=Cloud /t:publish"
Invoke-Expression $build