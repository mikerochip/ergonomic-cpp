param
(
    [string]
    $BuildType = "Debug"
)

$ProjectPath = "$PSScriptRoot/../.."

# sanitize the build type string
$BuildTypeLower = $BuildType.ToLower()
$BuildType = (Get-Culture).TextInfo.ToTitleCase($BuildTypeLower)
$BuildPath = "$ProjectPath/build/$BuildTypeLower"
$BinPath = "$BuildPath/bin"

# this could probably be a more sophisticated check, but this works
if (-not (Test-Path -Path $BinPath))
{
    & $PSScriptRoot/build.ps1 $BuildType
}
Set-Location $BinPath
Start-Process -NoNewWindow -FilePath ./ErgonomicCpp
