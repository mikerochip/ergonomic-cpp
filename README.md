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

*NOTE: Most tools (except MSVC on Windows) are going to be installed via command prompt and added to your PATH, so make sure to close and reopen all command prompts between steps.*

## Mac C++ Tools

### Xcode

1. Download Xcode from the Mac App Store
1. Open a terminal
1. Run ```xcode-select --install```

### Homebrew

1. Go to https://brew.sh/
1. Follow the install instructions

*NOTE: Homebrew will install Xcode CLI tools these days, but that's not a guarantee*

## Windows C++ Tools

### Visual Studio 2019 (MSVC 16)

1. Download the Visual Studio 2019 Build Tools installer with [this link](https://aka.ms/vs/16/release/vs_BuildTools.exe)
1. Run the installer
1. Check the Desktop development with C++ workload
   * This is a giant download, just to warn you (~5gb)
1. Click Install

### Developer Command Prompt

1. Open your Windows search box and type "Developer PowerShell"
1. Right click the "Developer PowerShell for VS 2019" result
1. Choose Pin to Taskbar

### ⚠ **Warning** ⚠

* **You need to use a Developer Command Prompt when working with this project**
* You can't open just any command prompt to access MSVC's C++ tools. You need a Developer Command Prompt for the specific version of VS you install. The reason for this is that a bunch of env vars are added to the command prompt on launch, and the vars are specific to each MSVC version, so they'd be absent or have version conflicts otherwise.
* As of this writing (Mar 13 2022), Visual Studio 2022 (VS 17) doesn't work. A dependency of POCO, OpenSSL (specifically openssl/1.1.1l) doesn't have prebuilt binaries for VS 17, and building it from source fails because: (A) its Conan recipe uses NMake and (B) there's a (Conan?) bug where it picks the x86 version of NMake even though the target arch is x86_64.

## CMake

* Mac: ```brew install cmake```
* Win: ```winget install cmake```

## Python

Python is a dependency for Conan

The goal is to install Python 3.9.6, however...

Managing Python installations is a massive pain. We're going to do it right (i.e. version pinning) rather than depending on whatever Python version happens to be installed on your system.

1. First install pyenv, which will manage Python versions
   * Mac: ```brew install pyenv```
   * Win: https://github.com/pyenv-win/pyenv-win#installation
      * PowerShell is the easiest install option
1. Now open a command prompt to install Python via pyenv
1. ```pyenv install 3.9.6```
1. ```pyenv global 3.9.6```
1. ```python -m pip install pip --upgrade```
1. This isn't stricly needed, but you might as well install Pipenv. If you ever plan on working on Python projects, you'll want to use Pipenv to version-lock Python and packages.
   * ```python -m pip install --user pipenv```

## Conan

Install Conan 1.49.0

1. ```pip install conan==1.49.0 --force-reinstall```
2. ```pyenv rehash```

## PowerShell

PowerShell 7.2 scripts are used for the BuildSystem

The latest PowerShell is cross-platform and supports M1 ARM as of 7.2! Definitely becoming a fan of PowerShell instead of Bash or Bat, despite the extra install step.

* Open a command prompt
* Mac: ```brew install --cask powershell```
* Win: ```winget install --id Microsoft.Powershell --source winget```

# Building and Running

Build and run scripts are in ```src/BuildSystem```

You pass the configuration as the first arg e.g. ```pwsh build.ps1 Debug``` or ```pwsh run.ps1 Release```

Default configuration is ```Debug```

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
1. Preferences/Settings > Build, Execution, and Deployment
   1. Conan
      1. Install args: ```--build=missing```
      1. [Windows] Conan executable: ```C:/Users/<yourusername>/.pyenv/pyenv-win/shims/conan.bat```
         * *There seems to be a CLion bug where it can't find ```conan``` in the path even if it's there.*
   1. CMake
      1. You should see a default configuration called ```Debug```, select it and change these options
         * Build directory: ```build/debug```
         * [Mac] Generator: ```Unix Makefiles```
         * [Windows] Generator: ```Visual Studio 16 2019```
      1. Now click the plus icon to add a new configuration, which should default to ```Release```
         * Build directory: ```build/debug```
         * [Mac] Generator: ```Unix Makefiles```
         * [Windows] Generator: ```Visual Studio 16 2019```
1. Open the Conan window
   1. Click the Match profile button
      1. Set ```Debug``` to ```ergonomic-cpp-debug```
      1. Set ```Release``` to ```ergonomic-cpp-release```
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

**Error:** [Windows] CLion syntax highlighting is broken (can't find standard library headers, incorrect warnings for Conan package includes, etc) and debugging doesn't work.

**Suggestion:** Most likely your default toolchain is set to MinGW, which seems to be straight up broke on Windows. Setting it to Visual Studio should fix this.

1. File > Settings > Build, Execution, and Deployment > Toolchains
1. Click Visual Studio
1. Click the up arrow button until Visual Studio becomes the first, default item
