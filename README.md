# Purpose

This is a proof of concept for a more ergonomic cross-platform C++ dev workflow using

* [CMake](https://cmake.org/) build system generator
* [Conan](https://conan.io/) package manager
* [PowerShell](https://github.com/PowerShell/PowerShell) for build scripting
* [fmt](https://github.com/fmtlib/fmt) string formatting

With the following compilers / build systems

* Mac: Apple Clang / Unix Makefiles
* Windows: Visual Studio 2019 (MSVC 16) / MSBuild

# Install Requirements

NOTE: Most tools (except MSVC on Windows) are going to be installed via command prompt and added to your PATH, so make sure to close and reopen all command prompts between steps.

## Mac Prerequisites

### C++ Compilers and CLI Tools

1. Open a terminal
1. Run ```xcode-select --install```

### Homebrew

1. Go to https://brew.sh/
1. Follow the install instructions

## Windows Prerequisites

### Visual Studio 2019 (MSVC 16)

1. Download the Visual Studio 2019 Build Tools installer with [this link](https://aka.ms/vs/16/release/vs_BuildTools.exe)
1. Run the installer
1. Check the Desktop development with C++ workload
   * This is a giant download, just to warn you (~5gb)
1. Click Install

### Developer Command Prompt

You'll need to use a Developer command prompt to access MSVC tools

1. Open your Windows search box and type "Developer PowerShell"
1. Right click the "Developer PowerShell for VS 2019" result and choose Pin to Taskbar

**NOTE: Use this command prompt when working with this project**

### ⚠ Warning ⚠

* You can't open just any command prompt to access MSVC's C++ tools. You need a Developer Command Prompt for the specific version of VS you install. The reason for this is that a bunch of env vars are added to the command prompt on launch, and the vars are specific to each MSVC version, so they'd be absent or have version conflicts otherwise.
* As of this writing (Mar 13 2022), Visual Studio 2022 (VS 17) doesn't work. A dependency of POCO, OpenSSL (specifically openssl/1.1.1l) doesn't have prebuilt binaries for VS 17, and building it from source fails because: (A) its Conan recipe uses NMake and (B) there's a (Conan?) bug where it picks the x86 version of NMake even though the target arch is x86_64.

## CMake

* Mac: ```brew install cmake```
* Win: ```winget install --id Kitware.CMake --source winget```

## Python

Python is a dependency for Conan. Managing Python installations is a massive pain, but we're going to do it right (i.e. version pinning) rather than implicitly depending on whatever the system Python happens to be.

1. Install pyenv or pyenv-win
   * Mac: ```brew install pyenv```
   * Win: https://github.com/pyenv-win/pyenv-win#installation
1. Install Python 3.9.6: 
   * ```pyenv install 3.9.6```
1. Set global Python version to 3.9.6
   * ```pyenv global 3.9.6```
1. Upgrade pip
   * ```python -m pip install pip --upgrade```
1. Install pipenv
   * ```python -m pip install --user pipenv```

## Conan

To install

1. ```pip install conan```
2. ```pyenv rehash```

To update

```pip install conan --upgrade```

## PowerShell

PowerShell 7.2 scripts are used for the BuildSystem. Definitely becoming a fan of PowerShell instead of Bash/Bat since it's cross-platform and supports M1 ARM as of 7.2!

* Open a command prompt
* Mac: ```brew install --cask powershell```
* Win: ```winget install --id Microsoft.Powershell --source winget```

# Building and Running

Build and run scripts are in ```src/BuildSystem```

## Command Line

First ```cd src/BuildSystem``` then run any of these:

```pwsh build.ps1 [Debug|Release]``` will run conan and cmake commands before compiling

```pwsh run.ps1 [Debug|Release]``` will invoke the build script if the build output dir doesn't exist, then run the executable

## CLion

1. Open a command prompt at the project root, then
   1. ```cd src/BuildSystem```
   1. ```pwsh build.ps1 Debug```
   1. ```pwsh build.ps1 Release```
1. Open CLion
1. Install the plugin for [Conan](https://plugins.jetbrains.com/plugin/11956-conan)
1. Preferences > Build, Execution, and Deployment > Conan
   1. Install args: ```--build=missing```
1. Preferences > Build, Execution, and Deployment > CMake
   1. You should see a default configuration called Debug, select it and change these options
      * Mac
         * Generator: Unix Makefiles
         * Build directory: ```build/debug```
      * Windows
         * Generator: Visual Studio 16 2019
         * Build directory: ```build```
   1. Now click the plus icon to add a new configuration, which should default to Release
      * Mac
         * Generator: Unix Makefiles
         * Build directory: ```build/release```
      * Windows
         * Generator: Visual Studio 16 2019
         * Build directory: ```build```
1. Open the Conan window
   1. Click the Match profile button
      1. Set Debug to ```ergonomic-cpp-debug```
      1. Set Release to ```ergonomic-cpp-release```
   1. Click the Reload button
1. Open the CMake window
   1. Click the Reload button

When using CLion, you'll have to hit the CMake and Conan reload buttons after pulling the project if dependencies change. Need to think about automating this! What a pain! It's like Unreal's ```GenerateProjectFiles```

# Troubleshooting

**Error:** When running the build script ```CMake Error at build/debug/conanbuildinfo.cmake:1299 (message): Detected a mismatch for the compiler version between your conan profile settings and CMake```

**Suggestion:** Generally, your compiler changing (install, update, etc) will cause this error. This project relies on the CMake and Conan compiler defaults being the same.

Run this:

1. ```pip install conan --upgrade```
2. ```conan profile new default --detect --force```

Then re-run the build script.

**Error:** ```ERROR: Invalid setting 'x.x' is not a valid 'settings.compiler.version' value.```

**Suggestion:** If you're on Mac and you get this error then probably Conan itself hasn't been updated to support the latest compiler version from the XCode CLI tools, which presumably you just downloaded. The workaround for this, which admittedly sucks pretty bad, is to add the new version to your ```~/.conan/settings.yml``` manually in the ```apple-clang/version``` array.
