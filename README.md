# Purpose

This is a proof of concept for a more ergonomic, cross-platform C++ dev workflow using

* [Bazel](https://bazel.build/) build system and package management
* [Bazelisk](https://github.com/bazelbuild/bazelisk) pin Bazel versions
* [Bzlmod](https://bazel.build/external/module) + [Bazel Central Registry](https://registry.bazel.build/) for dependency management
* [CLion](https://www.jetbrains.com/clion/) default IDE
* [fmt](https://github.com/fmtlib/fmt) string formatting
* [CLI11](https://github.com/CLIUtils/CLI11) command line parsing
* [BoringSSL](https://github.com/google/boringssl) just an example dependency

With the following compilers

* macOS: Apple Clang
* Windows: MSVC

Dependencies are specified in Bazel modules that point to the Bazel Central Registry.
No per-platform configuration: just use `bazel build` and `bazel run`

# Project Layout

| Path | Purpose |
|------|------------|
| [`MODULE.bazel`](MODULE.bazel) | Bzlmod dependency declarations (`fmt`, `cli11`, `boringssl`, `rules_cc`) |
| [`.bazelversion`](.bazelversion) | Bazel version used by Bazelisk |
| [`.bazelrc`](.bazelrc) | Build flags |
| `src/Libraries/MyLibrary/BUILD.bazel` | `cc_library` example |
| `src/App/BUILD.bazel` | `cc_binary` that links the library + external deps |

# Install Requirements

## C++ Compilers

> [!WARNING]
> If this step is skipped, Bazel will fail at build time with a compiler-not-found error.

### Mac: Apple Clang

1. Install [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
2. Open a terminal
3. Run `xcode-select --install` - this ensures you get Apple Clang + Platform SDKs

### Windows: MSVC

1. Download the Visual Studio 2022 Build Tools installer with [this link](https://aka.ms/vs/17/release/vs_BuildTools.exe)
2. Run the installer
3. Check the Desktop development with C++ workload
   * This is a giant download, just to warn you (~5gb)
4. Click Install

#### Developer Command Prompt

Windows needs Developer Command Prompts for the added MSVC env vars.

1. Open your Windows search box and type "Developer PowerShell"
2. Right-click the "Developer PowerShell for VS 2022" result
3. Choose Pin to Taskbar

## Bazelisk

Bazelisk is a launcher that downloads and runs the exact Bazel version pinned in
[`.bazelversion`](.bazelversion). Even though you're using bazelisk, you invoke it
with the plain `bazel` command and let it do its version checks.

* **macOS:** `brew install bazelisk`
* **Windows:** `winget install Bazel.Bazelisk`

# CLion Setup

CLion builds this project through the Bazel plugin.

1. Install the [Bazel plugin](https://plugins.jetbrains.com/plugin/9554-bazel-for-clion)
   (Settings > Plugins > Marketplace > Bazel)
2. Restart CLion
3. File > Import Bazel Project
4. Select this repository as the workspace
5. Choose `Import project view file` and pick [`.bazelproject`](.bazelproject)

# Building and Running

## Terminal

```
bazel build //src/App:ErgonomicCpp   # build
bazel run   //src/App:ErgonomicCpp   # build (if needed) and run
```

The first build downloads the dependencies and may take a bit; subsequent builds are
incremental and cached.

Build a release-optimized binary with:

```
bazel build -c opt //src/App:ErgonomicCpp
```

Build everything (library + app):

```
bazel build //...
```

## CLion

`//src/App:ErgonomicCpp` should be a run/debug configuration after plugin setup


# Troubleshooting

**Error:** `bazel: command not found`

**Suggestion:** Install Bazelisk (see [Install Requirements](#bazelisk)). It provides
the `bazel` command. Confirm with `bazel --version` (run inside the repo so it reads
`.bazelversion`).

---

**Error:** A dependency's `BUILD` file fails with *"This rule has been removed from
Bazel. Please add a `load()` statement"* (e.g. for `cc_library`).

**Suggestion:** This happens when Bazel resolves to **9.x**, which removed the
built-in `cc_*` rules that older registry modules still use. The project pins **8.x**
in [`.bazelversion`](.bazelversion) for exactly this reason. Make sure you are
launching through Bazelisk (so the pin is honored) rather than a separately installed
`bazel`.

---

**Error:** Stale or corrupted build state after changing dependencies.

**Suggestion:** Clear Bazel's state and rebuild:

```
bazel clean --expunge
bazel build //src/App:ErgonomicCpp
```

# Uninstalling

## Mac

```
brew uninstall bazelisk
rm -rf ~/.cache/bazelisk            # Bazel binaries downloaded by Bazelisk
rm -rf "/var/tmp/_bazel_$(whoami)"  # Bazel install, build output, and repo cache
rm -f bazel-*                       # convenience symlinks in the project root
```

## Windows

```
winget uninstall Bazel.Bazelisk
rmdir /s /q "%USERPROFILE%\.cache\bazelisk"  # Bazel binaries downloaded by Bazelisk
del bazel-*                                  # convenience symlinks in the project root
```

Bazel's build output/cache on Windows lives under a temp dir (often
`C:\users\<user>\_bazel_<user>` or `%TEMP%`). Run `bazel info output_base` to see the
exact path before uninstalling.
