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
elseif ($IsMacOS)
{
    $ConanConfigPath = "$ProjectPath/conan-config/Mac"
    Remove-Item -Force -Path "$ConanConfigPath/.DS_Store" -ErrorAction Ignore
}
else
{
    $ConanConfigPath = "$ProjectPath/conan-config/Default"
}
conan config install $ConanConfigPath

# create and cd to the BuildPath since we need to run conan install and cmake there
$BuildTypeLower = $BuildType.ToLower()
$BuildType = (Get-Culture).TextInfo.ToTitleCase($BuildTypeLower)
$BuildPath = "$ProjectPath/build/$BuildType"
New-Item -Type Directory -Force $BuildPath
Set-Location $BuildPath

conan install $ProjectPath -pr="ergonomic-cpp-$BuildTypeLower" --build=missing

# see https://docs.conan.io/2/examples/tools/cmake/cmake_toolchain/build_project_cmake_presets.html#building-the-project-using-cmakepresets
# Ninja is a single-config generator, so the build type comes from CMAKE_BUILD_TYPE.
# It's cross-platform, so Mac and Windows share the same generate/build commands.
# On Windows you must run this from a Developer Command Prompt so Ninja can find cl.exe.
$env:CMAKE_TOOLCHAIN_FILE="generators/conan_toolchain.cmake"
$env:CMAKE_BUILD_TYPE="$BuildType"
cmake -S $ProjectPath -B . -G "Ninja"
ninja
