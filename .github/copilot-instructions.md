# Copilot Instructions

## Project Context

MyProject is a cross-platform C++23 application template. Clang 22, lld, CMake Presets, and Ninja are the primary toolchain. Linux and Windows are supported; Google Test and spdlog are fetched by CMake.

Read [README.md](../README.md) for the current feature and command reference and [CONTRIBUTING.md](../CONTRIBUTING.md) for coding conventions. Do not duplicate those documents here.

## Working Practices

- Make focused changes that preserve Linux and Windows behavior.
- Use CMake Presets as the supported build interface.
- Add application files to `MYPROJECT_SOURCES` or `MYPROJECT_HEADERS` in `CMakeLists.txt`.
- Add test files to the `MyProject_tests` target in `tests/CMakeLists.txt`.
- Declare source dependencies with CMake `FetchContent` and `SYSTEM`, pin a version tag, and link them explicitly.
- Keep warnings scoped to project targets through `myproject_apply_default_warnings()`.
- Update README documentation when changing presets, CMake options, scripts, dependencies, CI, generated paths, or project structure.
- Keep `TODO.md` limited to unimplemented work.
- Update Linux and PowerShell tooling together when their behavior is intended to match.

## Validation

Use the smallest relevant checks, normally:

```bash
cmake --preset debug
cmake --build --preset debug
ctest --preset debug
./tools/check-format.sh
./tools/clang-tidy.sh debug
```

Use sanitizer or coverage presets when the changed behavior warrants them. PowerShell equivalents exist for repository scripts.

## C++ Style

- Target C++23 and use the checked-in clang-format and clang-tidy configurations.
- Follow the naming and include-order rules in `CONTRIBUTING.md`.
- Prefer RAII, const-correctness, standard-library facilities, and explicit error handling.
- Use `#pragma once` in headers.
- Use `#ifdef X` or `#ifndef X` for simple preprocessor checks.
- Do not weaken project warnings or add suppressions for third-party code when a `SYSTEM` boundary is appropriate.

## Documentation Style

This repository currently builds an application and has no exported library API. Prioritize accurate Markdown over generated API documentation. Do not add JSDoc, docstrings, or routine inline comments. If public C++ headers are added later, use concise Doxygen-compatible comments for public contracts that cannot be expressed clearly through names and types.

Keep Markdown responsibilities distinct:

- `README.md`: users, features, setup, and command reference
- `CONTRIBUTING.md`: contributor process and coding conventions
- `TODO.md`: active and deferred backlog
- `SECURITY.md`: vulnerability reporting and supported versions
- This file: instructions specific to coding agents

## Intentional Design

- Presets are the single build-configuration interface; toolchain files are not used.
- FetchContent is sufficient for the template; no additional package-manager wrapper is required.
- Platform-default standard libraries are used.
- clangd is the language server, and its configuration removes PCH-related flags that it cannot consume.
- PCH remains enabled for normal builds but is disabled or stripped where coverage, sanitizers, or clang-tidy require it.
- The application template does not provide install/export configuration for downstream library consumers.

The disabled clang-tidy checks and their exact configuration are authoritative in `.clang-tidy`; do not duplicate that list in documentation.
