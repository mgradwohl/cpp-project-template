# MyProject

A cross-platform C++23 application template built around Clang, CMake Presets, Ninja, Google Test, and VS Code.

## What Is Included

- Linux and Windows presets for debug, release, optimized, coverage, and sanitizer builds
- Clang with lld as the primary toolchain
- Strict per-target warnings, with warnings treated as errors by default
- Precompiled headers and ccache/sccache support
- Google Test and spdlog through CMake `FetchContent`
- clang-format, clang-tidy, llvm-cov, and CPack integration
- GitHub Actions jobs for builds, tests, formatting, static analysis, coverage, and sanitizers
- VS Code tasks, launch configurations, and clangd settings
- A generated version header containing project, build, and compiler information

The checked-in application is intentionally small: `src/main.cpp` logs version information and prints a greeting, while `tests/test_main.cpp` contains example Google Test cases.

## Create a Project from the Template

1. Select **Use this template** on GitHub and create a repository.
2. Clone the new repository.
3. Run the one-time rename script:

```bash
# Linux
./setup.sh --name "YourProjectName" --author "Your Name"
```

```powershell
# Windows
.\setup.ps1 -Name "YourProjectName" -Author "Your Name"
```

The author argument is optional. The setup scripts replace the `MyProject`, `MYPROJECT`, and `myproject` placeholders, then remove both setup scripts.

Commit the generated changes before beginning application development.

## Requirements

| Tool | Requirement |
| --- | --- |
| Clang/LLVM | 22 or newer, including lld |
| CMake | 3.28 or newer |
| Ninja | Required by all presets |
| ccache | 4.9.1 or newer |
| clang-format and clang-tidy | Required for quality checks |
| llvm-profdata and llvm-cov | Required only for coverage |

On Windows, set `LLVM_ROOT` to the LLVM installation directory. `Devshell-Updated.ps1` can load a Visual Studio Developer Shell and configure the expected paths; update its installation paths if necessary.

Check a Linux development environment with:

```bash
./tools/check-prereqs.sh
```

The equivalent Windows command is:

```powershell
.\tools\check-prereqs.ps1
```

## Build, Run, and Test

CMake Presets are the supported interface. The older `tools/configure.*` and `tools/build.*` wrappers remain only for backward compatibility.

```bash
# Linux
cmake --preset debug
cmake --build --preset debug
ctest --preset debug
./build/debug/MyProject
```

```powershell
# Windows
cmake --preset win-debug
cmake --build --preset win-debug
ctest --preset win-debug
.\build\win-debug\MyProject.exe
```

Run `cmake --list-presets` to list the presets available on the current platform.

### Presets

| Linux | Windows | Purpose |
| --- | --- | --- |
| `debug` | `win-debug` | Debug symbols and uninitialized-variable pattern filling |
| `relwithdebinfo` | `win-relwithdebinfo` | Optimized build with debug information |
| `release` | `win-release` | Standard optimized release |
| `optimized` | `win-optimized` | `-O3`, IPO/LTO, x86-64-v3, and stripped output |
| `coverage` | `win-coverage` | LLVM coverage instrumentation with PCH disabled |
| `asan-ubsan` | - | AddressSanitizer and UndefinedBehaviorSanitizer |
| `tsan` | - | ThreadSanitizer |

Each configure preset has a matching build and test preset.

## Development Commands

```bash
./tools/clang-format.sh
./tools/check-format.sh
./tools/clang-tidy.sh debug
./tools/coverage.sh
```

PowerShell equivalents are available for each script. Use `./tools/coverage.sh --open` or `.\tools\coverage.ps1 -OpenReport` to open the generated report at `coverage/index.html`.

The coverage and sanitizer presets disable PCH where instrumentation or analysis requires it. clang-tidy uses a generated PCH-free compile database so the regular build can retain PCH.

## CMake Options

| Option | Default | Purpose |
| --- | --- | --- |
| `MYPROJECT_BUILD_TESTS` | `ON` | Build the Google Test target |
| `MYPROJECT_ENABLE_CCACHE` | `ON` | Use sccache or ccache when available |
| `MYPROJECT_ENABLE_COVERAGE` | `OFF` | Enable LLVM coverage instrumentation |
| `MYPROJECT_ENABLE_FETCHCONTENT_CACHE` | `OFF` | Share dependency downloads across build trees |
| `MYPROJECT_FETCHCONTENT_CACHE_DIR` | empty | Override the shared dependency cache path |
| `MYPROJECT_ENABLE_IPO` | `ON` | Enable interprocedural optimization when supported |
| `MYPROJECT_ENABLE_PCH` | `ON` | Enable application precompiled headers |
| `MYPROJECT_ENABLE_WARNINGS` | `ON` | Enable the project warning set |
| `MYPROJECT_WARNINGS_AS_ERRORS` | `ON` | Promote project warnings to errors |

The checked-in presets enable the shared `FetchContent` cache. Its default location is `.cache/fetchcontent`; `MYPROJECT_FETCHCONTENT_CACHE_DIR` and the `FETCHCONTENT_BASE_DIR` environment variable can override it.

Options apply to project targets without imposing project warnings on third-party dependencies.

## Packaging

Configure and build a release before invoking CPack:

```bash
cmake --preset release
cmake --build --preset release
cpack --config build/release/CPackConfig.cmake
```

CPack always configures ZIP and TGZ archives. It also enables NSIS on Windows, DragNDrop on macOS, and DEB or RPM on Unix when the corresponding packaging tools are installed. Outputs are written to `dist/`.

## Project Layout

```text
.
|-- CMakeLists.txt              Main build and packaging configuration
|-- CMakePresets.json           Configure, build, and test presets
|-- src/                        Application source and version template
|-- tests/                      Google Test target and examples
|-- tools/                      Quality, coverage, and compatibility scripts
|-- .github/
|   |-- actions/setup-llvm/     Reusable CI toolchain setup
|   |-- workflows/ci.yml        Build and quality workflow
|   `-- copilot-instructions.md Repository guidance for coding agents
|-- .vscode/                    Tasks, launch configurations, and editor settings
|-- CONTRIBUTING.md             Contributor workflow and coding conventions
|-- SECURITY.md                 Vulnerability reporting policy
`-- TODO.md                     Current project backlog
```

Generated `build/`, `coverage/`, `dist/`, `.cache/`, and `compile_commands.json` paths are ignored by Git.

## Dependencies

Runtime and test dependencies are pinned by Git tag:

| Dependency | Version | Scope |
| --- | --- | --- |
| spdlog | 1.13.0 | Application logging |
| Google Test | 1.15.2 | Tests only |

Add source dependencies with `FetchContent_Declare(... SYSTEM)` so third-party headers remain outside project warning enforcement.

## CI

`.github/workflows/ci.yml` runs on pushes and pull requests targeting `main`. It validates prerequisites, builds and tests Linux and Windows debug presets, checks formatting, runs clang-tidy, generates a coverage artifact, and exercises ASan+UBSan and TSan.

Dependabot checks GitHub Actions dependencies weekly.

## Documentation

This repository currently produces an application, not a reusable library, so it has no exported API that needs generated reference documentation. Keep user and contributor guidance in Markdown. If public headers are added later, document their public types and functions with Doxygen-compatible C++ comments; do not use JSDoc or language-style docstrings.

See [CONTRIBUTING.md](CONTRIBUTING.md) for coding conventions and the pull request workflow. Report vulnerabilities according to [SECURITY.md](SECURITY.md).

## License

Licensed under the [MIT License](LICENSE).
