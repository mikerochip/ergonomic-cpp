param
(
    [string]
    $Configuration = "Debug"
)

# enable echoing
Set-PSDebug -Trace 1

# sanitize and store the configuration name for different purposes:
# 1. all lower for dir name
# 2. Pascal case for build type name
$ConfigDirName = $Configuration.ToLower()
$TextInfo = (Get-Culture).TextInfo
$ConfigTypeName = $TextInfo.ToTitleCase($ConfigDirName)
$BuildDir = "build-$ConfigDirName"

# create and cd to the BuildDir
New-Item -Type Directory -Force $BuildDir
Set-Location $BuildDir

conan install .. -s build_type=$ConfigTypeName --build=missing
# the source dir is the parent since that's where CMakeLists.txt is
cmake -DCMAKE_BUILD_TYPE=$ConfigTypeName -S .. -B .
make all
