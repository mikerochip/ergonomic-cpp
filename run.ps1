param
(
    [string]
    $Configuration = "Debug"
)

# lower the configuration name for composing the dir name
$ConfigDirName = $Configuration.ToLower()
$BuildDir = "build-$ConfigDirName"
$BinDir = "$PSScriptRoot/$BuildDir/bin"

# this could probably be a more sophisticated check, but this works
if ( -not (Test-Path -Path $BinDir) )
{
    & $PSScriptRoot/build.ps1 $Configuration
}
Set-Location $BinDir
Start-Process -FilePath CMakeTest
