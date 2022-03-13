param
(
    [string]
    $BuildType = "Debug"
)

# enable echoing
Set-PSDebug -Trace 1

$BuildTypeLower = $BuildType.ToLower()
$ConanConfigPath = "conan-config"
$ConanProfilePath = "$ConanConfigPath/profiles/ergonomic-cpp-$BuildTypeLower"
# FIXME Windows
#$BuildPath = "build"
$BuildPath = "build/$BuildTypeLower"
$CmakeBuildType = (Get-Culture).TextInfo.ToTitleCase($BuildTypeLower)

# move to repo root
Set-Location "$PSScriptRoot/../.."

# installing profiles isn't necessary, but helpful for setting up CLion
Remove-Item -Force -Path "$ConanConfigPath/.DS_Store" -ErrorAction Ignore
conan config install $ConanConfigPath

# create and cd to the BuildPath
New-Item -Type Directory -Force $BuildPath
Set-Location $BuildPath
# it's easier to install from the BuildPath since we need to run cmake here
conan install ../.. -pr="../../$ConanProfilePath" -pr="default" --build=missing
# the source dir is the parent since that's where CMakeLists.txt is
cmake -DCMAKE_BUILD_TYPE=$CmakeBuildType -S ../.. -B . -G "Unix Makefiles"
make all
# FIXME Windows
#cmake -S ../.. -B . -G "Visual Studio 17 2022"
#msbuild SimpleCmake.sln /p:Configuration=$CmakeBuildType
