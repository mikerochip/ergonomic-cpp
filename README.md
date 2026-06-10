# Purpose

This is a proof of concept for a more ergonomic, cross-platform C++ dev workflow using

* [CMake](https://cmake.org/) build system generator
* [Ninja](https://ninja-build.org/) build system
* [Conan](https://conan.io/) package manager
* [uv](https://docs.astral.sh/uv/) to install and run Conan (manages Python for you)
* [PowerShell](https://github.com/PowerShell/PowerShell) for build scripting
* [CLion](https://www.jetbrains.com/clion/) as the default IDE
* [fmt](https://github.com/fmtlib/fmt) for string formatting
* [CLI11](https://github.com/CLIUtils/CLI11) for command line parsing

With the following compilers / build systems

* Mac: Apple Clang / Ninja
* Windows: Visual Studio 2019 (MSVC 16) / Ninja

# Install Requirements

*NOTE: Most tools (except MSVC on Windows) are going to be installed via command prompt and added to your PATH, so make sure to close and reopen all command prompts between steps.*

## Mac C++ Tools

### Homebrew

1. Go to https://brew.sh/
2. Follow the installation instructions

*NOTE: Homebrew will install Xcode CLI tools these days, but that's not a guarantee*

### Xcode

[Download Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12) from the Mac App Store

## Windows C++ Tools

### Visual Studio 2019 (MSVC 16)

1. Download the Visual Studio 2019 Build Tools installer with [this link](https://aka.ms/vs/16/release/vs_BuildTools.exe)
2. Run the installer
3. Check the Desktop development with C++ workload
   * This is a giant download, just to warn you (~5gb)
4. Click Install

### Developer Command Prompt

1. Open your Windows search box and type "Developer PowerShell"
2. Right-click the "Developer PowerShell for VS 2019" result
3. Choose Pin to Taskbar

### ⚠ **Warning** ⚠

* **You need to use a Developer Command Prompt when working with this project**
* You can't open just any command prompt to access MSVC's C++ tools. You need a Developer Command Prompt for the specific version of VS you install. The reason for this is that a bunch of env vars are added to the command prompt on launch, and the vars are specific to each MSVC version, so they'd be absent or have version conflicts otherwise.
* As of this writing (Mar 13 2022), Visual Studio 2022 (MSVC 17) doesn't work. A dependency of POCO, OpenSSL (specifically openssl/1.1.1l) doesn't have prebuilt binaries for MSVC 17, and building it from source fails because: (A) its Conan recipe uses NMake and (B) there's a (Conan?) bug where it picks the x86 version of NMake even though the target arch is x86_64.

## CMake

* Mac: ```brew install cmake```
* Win: ```winget install cmake```

## Ninja

* Mac: ```brew install ninja```
* Win: ```winget install Ninja-build.Ninja```

## uv

Conan is a Python tool, but you don't need to manage Python yourself anymore. [uv](https://docs.astral.sh/uv/) installs Conan into its own isolated environment and downloads whatever Python it needs automatically.

1. Install uv
   * Mac: ```brew install uv```
   * Win: ```winget install --id=astral-sh.uv```
   * Or follow https://docs.astral.sh/uv/getting-started/installation/

## Conan

Install Conan 2 as a uv tool. This puts ```conan``` on your PATH without touching any system Python.

1. ```uv tool install conan```
2. Verify with ```conan --version```

To upgrade Conan later, run ```uv tool upgrade conan```

## PowerShell

PowerShell scripts are used for the BuildSystem

The latest PowerShell is cross-platform and supports M1 ARM as of 7.2! Definitely becoming a fan of PowerShell instead of Bash or Bat, despite the extra install step.

* Open a command prompt
* Mac: ```brew install powershell```
* Win: ```winget install --id Microsoft.Powershell --source winget```

# Building and Running

Build and run scripts are in ```src/BuildSystem```

You pass the configuration as the first arg e.g. ```pwsh build.ps1 Debug``` or ```pwsh run.ps1 Release```

Default configuration is ```Debug```

## From a Command Prompt

First ```cd src/BuildSystem``` then run any of these:

```pwsh build.ps1 [Debug|Release]``` will run conan and cmake commands before compiling

```pwsh run.ps1 [Debug|Release]``` will invoke the build script if the build output dir doesn't exist, then run the executable

## From CLion

1. You'll need to run the build scripts in Debug and Release first
   1. Open a command prompt at the project root, then...
   2. ```cd src/BuildSystem```
   3. ```pwsh build.ps1 Debug```
   4. ```pwsh build.ps1 Release```
2. Open CLion
3. Install the plugin for [Conan](https://plugins.jetbrains.com/plugin/11956-conan)
4. Preferences/Settings > Build, Execution, and Deployment
   1. CMake
      1. You should see a default configuration called ```Debug```, select it and change these options
         * Build directory: ```build/Debug```
         * Generator: ```Ninja```
         * CMake Options: ```-G "Ninja" -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="conan_provider.cmake"```
      2. Click the plus icon to add a new configuration, which should default to ```Release```
         * Build directory: ```build/Release```
         * Generator: ```Ninja```
         * CMake Options: ```-G "Ninja" -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="conan_provider.cmake"```
5. Open the Conan window
   1. Click the gear button `Configure Conan`
      * Check `Use Conan installed in the system`
      * Check `Automatically add Conan for all configurations`
      * Check `Debug` and `Release` for `Use Conan for the following configurations`
      * Check `Let Conan manage the Advanced Settings > Reload CMake profiles sequentially option`
   2. Click the Reload button `Update packages and dependency provider`
6. Open the CMake window
   1. Click the Reload button

# Troubleshooting

**Error:** When running the build script ```Detected a mismatch for the compiler version between your conan profile settings and CMake```

**Suggestion:** Generally, your compiler changing (install, update, etc.) will cause this error. This project relies on the CMake and Conan compiler defaults being the same.

Try this:

1. Reinstall Conan with ```uv tool install conan --reinstall```
2. ```conan profile detect --force```

Then re-run the build script.

**Error:** ```ERROR: Invalid setting 'x.x' is not a valid 'settings.compiler.version' value.```

**Suggestion:** If you're on Mac and you get this error then probably Conan itself has not been updated to support the latest compiler version from the XCode CLI tools, which presumably you just downloaded. The workaround for this, which admittedly sucks pretty bad, is to add the new version to your ```~/.conan2/settings.yml``` manually in the ```apple-clang/version``` array.

**Error:** [Windows] CLion syntax highlighting is broken (can't find standard library headers, incorrect warnings for Conan package includes, etc.) and debugging doesn't work.

**Suggestion:** Most likely your default toolchain is set to MinGW, which seems to be straight up broke on Windows. Setting it to Visual Studio should fix this.

1. File > Settings > Build, Execution, and Deployment > Toolchains
2. Click Visual Studio
3. Click the up arrow button until Visual Studio becomes the first, default item

**Error:** Compile error from a package dependency

**Suggestion:** Try this

1. Wipe out your caches
   * Conan cache: `~/.conan2`
   * CMake cache: `<ProjectRoot>/build`
2. Make sure your compilers are up-to-date, see instructions above
3. Run the build script, see instructions above

**Error:** CLion Conan plugin is missing

**Suggestion:** CLion 2022.3 won't work with Conan plugin 1.2.0 per a [commit message](https://github.com/conan-io/conan-clion-plugin/commit/9844b05cc5d70a40b4f5c84450f98be6464e813b) on the repo:

> **WARNING: This plugin has stopped working since CLion 2022.3. The team is currently focused on releasing Conan 2.0, so this will be on hold for a while,
and work on this plugin will be resumed after 2.0 launch**
