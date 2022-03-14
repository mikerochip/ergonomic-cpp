# Purpose

This is a proof of concept for a more ergonomic cross-platform C++ dev workflow using

* [CMake](https://cmake.org/) build system generator
* [Conan](https://conan.io/) package manager
* [PowerShell](https://github.com/PowerShell/PowerShell) for build scripting
* [fmt](https://github.com/fmtlib/fmt) string formatting

# Windows-specific Warnings

* Getting good defaults to work on Windows is a bit more complicated than Mac since it doesn't have a built-in C++ compiler
* The canonical C++ compiler on Windows is Microsoft Visual C++ aka MSVC aka Visual Studio
* You'll need to setup what's known as a "Developer Command Prompt" in order to access the MSVC tools from a command prompt
* As of this writing (Mar 13 2022), Visual Studio 2022 (VS 17) doesn't work. The OpenSSL package (a dependency of POCO) doesn't have prebuilt binaries for VS 17. Building OpenSSL from source fails because its Conan recipe uses NMake, and there's a (Conan?) bug where it picks the x86 version of NMake even when the target arch is x86_64.

# Install Requirements

NOTE: Most tools (except MSVC for Windows) are going to be installed via command prompt and added to your PATH, so make sure to close and reopen all command prompts between steps.

## Windows Prerequisites

### Visual Studio 2019 (MSVC 16)

1. Download the Visual Studio 2019 Build Tools installer with [this link](https://aka.ms/vs/16/release/vs_BuildTools.exe)
1. Run the installer
1. Check the Desktop development with C++ workload
   * This is a giant download, just to warn you (~5gb)
1. Click Install

### Developer Command Prompt

You'll need to use a Developer command prompt to invoke MSVC tools. These steps will setup a shortcut to Developer PowerShell for VS 2019.

1. Open your Windows search box and type "Developer PowerShell"
1. Right click the "Developer PowerShell for VS 2019" result and choose Pin to Taskbar
1. Use this command prompt in all subsequent steps

**NOTE: Use this command prompt when working with this project**

## CMake

* Mac: ```brew install cmake```
* Win: ```winget install --id Kitware.CMake --source winget```

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

Just one step, plus one more on Windows.

1. ```pip install conan```
   * Win: run ```pyenv rehash```

## PowerShell

PowerShell 7.2 scripts are used for the BuildSystem. Definitely becoming a fan of PowerShell instead of Bash/Bat since it's cross-platform and supports M1 ARM as of 7.2!

* Open a command prompt
* Mac: ```brew install --cask powershell```
* Win: ```winget install --id Microsoft.Powershell --source winget```

# Building and Running

Build and run scripts are in the ```src/BuildSystem``` folder

## Command Line

First ```cd src/BuildSystem``` then run any of these:

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
