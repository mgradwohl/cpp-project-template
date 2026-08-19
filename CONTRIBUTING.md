# Contributing to MyProject

This guide covers the contributor workflow and coding conventions. Project capabilities and command reference live in [README.md](README.md).

## Set Up the Toolchain

Install the tools listed in the README, then validate them:

```bash
./tools/check-prereqs.sh
```

On Windows, set `LLVM_ROOT` and run `.\tools\check-prereqs.ps1`. The repository is primarily validated with Clang 22, CMake 3.28 or newer, Ninja, lld, and ccache 4.9.1 or newer.

## Build and Test

Use CMake Presets rather than the deprecated configure and build wrappers:

```bash
cmake --preset debug
cmake --build --preset debug
ctest --preset debug
```

Use `win-debug` for the corresponding Windows commands. Run `cmake --list-presets` for other build and test configurations.

Before opening a pull request, run the checks relevant to the change:

```bash
./tools/check-format.sh
./tools/clang-tidy.sh debug
ctest --preset debug
```

Apply formatting with `./tools/clang-format.sh`. PowerShell equivalents are available in `tools/`.

## C++ Conventions

- Use C++23 and follow the repository `.clang-format` and `.clang-tidy` configurations.
- Name types in `PascalCase`, functions in `camelCase`, constants in `UPPER_SNAKE_CASE`, and private members with an `m_` prefix.
- Prefer RAII, const-correctness, explicit error handling, and standard-library facilities.
- Use `#pragma once` in headers.
- Use `#ifdef X` and `#ifndef X` for simple preprocessor checks.
- Avoid `using namespace std` in headers.

Order includes in groups separated by blank lines:

1. The matching header in a `.cpp` file
2. Project headers, alphabetically
3. Third-party headers, alphabetically
4. Standard library headers, alphabetically
5. Other platform or system headers when needed

Warnings are configured per project target. Do not weaken them globally to accommodate a dependency; declare fetched dependencies as `SYSTEM`.

## Tests

Use Google Test and place tests under `tests/`. Add new test source files to `tests/CMakeLists.txt`, and add application source or header files to the corresponding lists in the root `CMakeLists.txt`.

Prefer behavior-focused test names and assertions. Tests should cover changed behavior rather than implementation details.

## Documentation

Keep each document focused:

- `README.md` describes the template, supported workflows, and command reference.
- `CONTRIBUTING.md` defines contributor expectations and code conventions.
- `TODO.md` contains only current backlog and deferred ideas.
- `SECURITY.md` defines vulnerability reporting and support expectations.
- `.github/copilot-instructions.md` contains repository-specific agent guidance.

Update documentation when changing CMake options, presets, scripts, CI, dependencies, generated paths, or project structure.

This project currently has no public library API. Do not add JSDoc, docstrings, or comments to self-explanatory implementation code. If reusable public headers are introduced, use Doxygen-compatible comments for public contracts where names and types are insufficient; keep internal implementation commentary minimal.

## Pull Requests

1. Create a focused branch.
2. Make the smallest complete change.
3. Add or update tests when behavior changes.
4. Run formatting, static analysis, and relevant test presets.
5. Update documentation when the user or developer workflow changes.
6. Open a pull request and complete the repository template.

Do not include unrelated cleanup in the same pull request.

Use the issue templates for public bug reports and feature requests. Report security vulnerabilities privately as described in [SECURITY.md](SECURITY.md).
