# Purpose

This is a proof of concept for a more ergonomic cross-platform C++ dev workflow using

* [CMake](https://cmake.org/) build system generator
* [Conan](https://conan.io/) package manager
* [PowerShell](https://github.com/PowerShell/PowerShell) for build scripting
* [fmt](https://github.com/fmtlib/fmt) string formatting

# Install Requirements

## Python

Python is a dependency for Conan. Managing Python installations is a massive pain. I used 3.10.2 for this project.

1. Install pyenv or pyenv-win
   * Mac: ```brew install pyenv```
   * Win: https://github.com/pyenv-win/pyenv-win#installation
1. Install Python 3.10.2: 
   * ```pyenv install 3.10.2```
1. Set global Python version to 3.10.2
   * ```pyenv global 3.10.2```
1. Upgrade pip
   * ```python -m pip install pip --upgrade```
1. Install pipenv
   * ```python -m pip install --user pipenv```

## Conan

Python is the hard part, Conan is easy. Just run:

```pip install conan```

## PowerShell

PowerShell 7.2 scripts are used for the BuildSystem.

Definitely becoming a fan of PowerShell instead of Bash since it's cross-platform and supports M1 ARM as of 7.2!

* Win: ```winget install --id Microsoft.Powershell --source winget```
* Mac: ```brew install --cask powershell```

# Building and Running

Scripts are in the ```src/BuildSystem``` folder

## Command Line

```pwsh build.ps1 [Debug|Release]``` will run conan and cmake commands before building

```pwsh run.ps1 [Debug|Release]``` will invoke the build script if the build output dir doesn't exist, then run the executable

## CLion

1. Open a command prompt at the project root, then
   1. ```cd src/BuildSystem```
   2. ```pwsh build.ps1 Debug```
   3. ```pwsh build.ps1 Release```
2. Open CLion
3. Install the plugin for [Conan](https://plugins.jetbrains.com/plugin/11956-conan)
4. Preferences > Build, Execution, and Deployment > Conan
   1. Install args: ```-pr=default --build=missing```
5. Preferences > Build, Execution, and Deployment > CMake
   1. You should see a default configuration called Debug, select it and change these options
      1. Generator: Unix Makefiles
      2. Build directory: ```build/debug```
   2. Now click the plus icon to add a new configuration, which should default to Release
      1. Generator: Unix Makefiles
      2. Build directory: ```build/release```
6. Open the Conan window
   1. Click the Match profile button
      1. Set Debug to ```ergonomic-cpp-debug```
      2. Set Release to ```ergonomic-cpp-release```
   2. Click the Reload button
7. Open the CMake window
   1. Click the Reload button

When using CLion, you'll have to hit the CMake and Conan reload buttons after pulling the project if dependencies change. Need to think about automating this! What a pain! It's like Unreal's ```GenerateProjectFiles```
