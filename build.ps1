param
(
    [string]
    $BuildType = "Debug"
)

# enable echoing
Set-PSDebug -Trace 1

$BuildTypeLower = $BuildType.ToLower()
$ConanConfigPath = "conan-config"
$ConanProfilePath = "$ConanConfigPath/profiles/cmake-test-$BuildTypeLower"
$BuildPath = "build-$BuildTypeLower"
$CmakeBuildType = (Get-Culture).TextInfo.ToTitleCase($BuildTypeLower)

# this isn't necessary, but helpful for setting up CLion
Remove-Item -Force -Path "$ConanConfigPath/.DS_Store" -ErrorAction Ignore
conan config install $ConanConfigPath

# create and cd to the BuildPath
New-Item -Type Directory -Force $BuildPath
Set-Location $BuildPath
# it's easier to install from the BuildPath since we need to run cmake here
conan install .. -pr="../$ConanProfilePath" -pr="default" --build=missing
# the source dir is the parent since that's where CMakeLists.txt is
cmake -DCMAKE_BUILD_TYPE=$CmakeBuildType -S .. -B .
make all
