param
(
    [string]
    $BuildType = "Debug"
)

$BuildTypeLower = $BuildType.ToLower()
$BuildPath = "build-$BuildTypeLower"
$BinPath = "$PSScriptRoot/../../$BuildPath/bin"

# this could probably be a more sophisticated check, but this works
if ( -not (Test-Path -Path $BinPath) )
{
    & $PSScriptRoot/build.ps1 $BuildType
}
Set-Location $BinPath
Start-Process -FilePath CMakeTest
