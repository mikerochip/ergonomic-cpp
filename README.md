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

# Building

All you have to do is run ```./build.sh```

# Running

```./build/bin/CMakeTest```