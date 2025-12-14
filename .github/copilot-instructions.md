# MyProject - Copilot Instructions

This file provides guidance for GitHub Copilot coding agents working on this project.

## Project Overview

MyProject is a cross-platform C++23 application built with modern tooling. The project emphasizes:
- Modern C++23 with clang as the primary toolchain
- Clean architecture with proper separation of concerns
- Cross-platform support (Linux, Windows)

## Development Environment

### Required Tools
- **Compiler:** Clang 21+ with lld linker
- **Build System:** CMake 3.28+ with Ninja and CMake Presets
- **Compiler Cache:** ccache 4.9.1+ (required for faster rebuilds)
- **Static Analysis:** clang-tidy (included with LLVM)
- **Code Formatting:** clang-format (included with LLVM)
- **Coverage:** llvm-profdata, llvm-cov (included with LLVM)
- **Testing:** Google Test (via CMake FetchContent)
- **Logging:** spdlog (via CMake FetchContent)

### Build Commands

Configure and build (Linux):
```bash
cmake --preset debug
cmake --build --preset debug
```

Configure and build (Windows):
```powershell
cmake --preset win-debug
cmake --build --preset win-debug
```

Run tests:
```bash
ctest --preset debug        # Linux
ctest --preset win-debug    # Windows
```

List available presets:
```bash
cmake --list-presets
```

### VS Code Tasks
The project includes predefined tasks in `.vscode/tasks.json` that auto-detect platform:
- **CMake: Build Debug** - Build with debug symbols (default, Ctrl+Shift+B)
- **CMake: Build RelWithDebInfo** - Build with optimizations + debug info
- **CMake: Build Release** - Build optimized release version
- **CMake: Build Optimized** - Build with LTO, march=x86-64-v3, stripped
- **CMake: Test Debug** - Execute test suite
- **Clang-Tidy** - Run static analysis
- **Clang-Format** - Format all source files
- **Check Format** - Check formatting compliance
- **CPack: Create Package** - Create distributable ZIP package
- **Coverage: Generate Report** - Generate HTML code coverage report
- **Check Prerequisites** - Verify all required tools are installed with correct versions

## Coding Standards

### Language and Style
- **C++ Standard:** C++23 (required)
- **Compiler:** Primarily validated with clang
- **Formatting:** Use `.clang-format` (LLVM base, Allman braces)
  - Run `./tools/clang-format.sh` before commits
- **Static Analysis:** Use `.clang-tidy` configuration
  - Run `./tools/clang-tidy.sh` regularly
  - Note: PCH flags are automatically stripped from compile_commands.json for clang-tidy compatibility

### IDE Configuration (clangd)
The `.clangd` file configures clangd for IDE integration:
- Adds project-specific flags and system header prefixes
- **Removes PCH flags** (`-Xclang`, `-include-pch`, `-emit-pch`, etc.) that clangd cannot handle
- This does NOT disable PCH in builds - only tells clangd to ignore those flags

### Include Order

1. Matching header (`.cpp` files only)
2. Project headers (`src/`, `include/`, `tests/`), alphabetical
3. Third-party libraries (spdlog, gtest, boost), alphabetical
4. C++ standard library headers, alphabetical
5. Other (fallback)

Separate each group with a blank line. Use `#pragma once` in all headers.

**Example:**
```cpp
#include "MyClass.h"

#include "src/utils/Helper.h"

#include <spdlog/spdlog.h>

#include <memory>
#include <string>
```

### Naming Conventions
- **Classes/Types:** PascalCase (e.g., `DataProcessor`, `FileHandler`)
- **Functions/Methods:** camelCase (e.g., `processData`, `handleFile`)
- **Member Variables:** camelCase with `m_` prefix for private members (e.g., `m_data`)
- **Constants:** UPPER_SNAKE_CASE (e.g., `MAX_BUFFER_SIZE`)

### Preprocessor Directives
- Use `#ifdef X` instead of `#if defined(X)` for simple checks
- Use `#ifndef X` instead of `#if !defined(X)`
- Compound conditions like `#if defined(X) && !defined(Y)` stay as-is

## Project Structure

```
src/
├── main.cpp          # Application entry point
└── version.h.in      # Version header template (CMake generates version.h)

tests/
├── CMakeLists.txt    # Test configuration
└── test_main.cpp     # Test cases

tools/
├── DevShell.ps1        # Windows dev environment setup
├── check-prereqs.sh/ps1  # Check prerequisite tools and versions
├── clang-tidy.sh/ps1   # Static analysis
├── clang-format.sh/ps1 # Code formatting
├── check-format.sh/ps1 # Format checking
└── coverage.sh/ps1     # Code coverage reports

dist/                   # CPack output (gitignored)
coverage/               # Coverage reports (gitignored)
```
## Engineering Workflow
- When making changes to the project structure, scripts (.sh or .ps1), clang files (.clang-format, .clang-tidy, .clangd), or CMake files, update README.md accordingly and copilot-instructions.md if needed and ensure setup scripts and workflow.yml files reflect changes.
- if new folders are created under the project root, make sure to make a smart choice to .gitignore them if needed and exclude them from clangd, clang-format and clang-tidy configurations.
- When adding a new component or depency ensure to use CMake FetchContent where possible and document the addition in README.md, and update setup scripts, project scripts, readmes, workflow.yml files as needed, and copilot-instructions.md if needed. Also update clangd, clang-format and clang-tidy configurations to exclude the new dependency if needed. 

## Testing

### Test Framework
- Use **Google Test (gtest)** for all tests
- Tests live in `tests/` directory
- Run via `ctest --preset debug`

### Code Coverage
- Run `./tools/coverage.sh` to generate HTML coverage report
- Report generated at `coverage/index.html`
- Uses llvm-cov with Clang instrumentation

### Example Test Structure
```cpp
#include <gtest/gtest.h>

#include "src/MyClass.h"

TEST(MyClassTest, BasicFunctionality)
{
    MyClass obj;
    EXPECT_EQ(obj.getValue(), 42);
}
```

## Common Tasks

### Adding a New Feature
1. Create/modify source files in `src/`
2. Update `MYPROJECT_SOURCES` in CMakeLists.txt if adding files
3. Add tests in `tests/`
4. Run clang-format
5. Run clang-tidy
6. Build and test

### Adding Dependencies
- Use CMake `FetchContent` for header-only libraries (see spdlog example in CMakeLists.txt)
- **Always use `SYSTEM` keyword** in `FetchContent_Declare` to suppress warnings from third-party code
- Update CMakeLists.txt and document in README.md

**Example:**
```cmake
FetchContent_Declare(
    mylib
    GIT_REPOSITORY https://github.com/example/mylib.git
    GIT_TAG v1.0.0
    SYSTEM  # Treat as system headers to suppress warnings
)
FetchContent_MakeAvailable(mylib)
```

## Best Practices

### Code Quality
- **Minimal changes:** Make the smallest possible changes to achieve the goal
- **DRY principle:** Don't repeat yourself; extract common code
- **RAII:** Use smart pointers and RAII for resource management
- **Const correctness:** Mark methods and variables `const` when appropriate
- **Error handling:** Check return values, use exceptions sparingly

### Performance
- Avoid unnecessary copies (use const references, move semantics)
- Profile before optimizing

### Documentation
- Use clear, descriptive names that minimize need for comments
- Add comments only when code intent is not obvious
- Keep README.md up to date

### Git Workflow
- Write clear commit messages
- Keep commits focused and atomic
- Ensure code builds and tests pass before committing
- Post commit monitor the CI results for issues and address any problems promptly

## Common Pitfalls to Avoid

- Don't use `using namespace std` in headers
- Don't ignore clang-tidy warnings
- Don't skip running tests before committing
- Don't add unnecessary dependencies
- Don't commit without running clang-format

## When in Doubt

1. Check existing code for patterns and conventions
2. Run static analysis tools
3. Follow the principle of least surprise
4. Refer to C++ Core Guidelines for best practices
