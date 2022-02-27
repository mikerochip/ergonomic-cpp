# Purpose

This is a simple C++ app built with [CMake](https://cmake.org/) and [Conan](https://conan.io/). This is really just a test-bed for a more ergonomic C++ dev workflow.

# Install Requirements

## Python

Managing Python installations is a massive pain. I used 3.10.2 for this project.

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

Python is the hard part, this is easy. Just run:

```pip install conan```

## PowerShell

This is for running the build script. Definitely becoming a fan of powershell over bash scripts since it's cross-plat now!

* Win: Nothing! It's built-in!
* Mac: ```brew install --cask powershell```

# Building

```pwsh build.ps1```

This will run conan and cmake commands before building.

# Running

```pwsh run.ps1```

This will first run ```build.ps1``` if it doesn't find the build output directory.
