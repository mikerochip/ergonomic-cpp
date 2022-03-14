param
(
    [string]
    $BuildType = "Debug"
)

$ProjectPath = "$PSScriptRoot/../.."

# installing profiles is a dependency for installing packages since the profiles have
# shared settings that affect which package versions are downloaded
if ($IsWindows)
{
    $ConanConfigPath = "$ProjectPath/conan-config/Windows"
}
else
{
    $ConanConfigPath = "$ProjectPath/conan-config/Default"
    Remove-Item -Force -Path "$ConanConfigPath/.DS_Store" -ErrorAction Ignore
}
conan config install $ConanConfigPath

# create and cd to the BuildPath since we need to run conan install and cmake there
$BuildTypeLower = $BuildType.ToLower()
$BuildType = (Get-Culture).TextInfo.ToTitleCase($BuildTypeLower)
if ($IsWindows)
{
    $BuildPath = "$ProjectPath/build"
}
else
{
    $BuildPath = "$ProjectPath/build/$BuildTypeLower"
}
New-Item -Type Directory -Force $BuildPath
Set-Location $BuildPath

conan install $ProjectPath -pr="ergonomic-cpp-$BuildTypeLower" --build=missing

$env:CMAKE_BUILD_TYPE = $BuildType
if ($IsWindows)
{
    cmake -S $ProjectPath -B . -G "Visual Studio 16 2019" -A x64
    msbuild ErgonomicCpp.sln /p:Configuration=$BuildType
}
else
{
    cmake -D -S $ProjectPath -B . -G "Unix Makefiles"
    make all
}
