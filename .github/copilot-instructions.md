# MyProject - Copilot Instructions

This file provides guidance for GitHub Copilot coding agents working on this project.

## Project Overview

MyProject is a cross-platform C++23 application built with modern tooling. The project emphasizes:
- Modern C++23 with clang as the primary toolchain
- Clean architecture with proper separation of concerns
- Cross-platform support (Linux, Windows)

## Development Environment

### Required Tools
- **Compiler:** Clang 17+ with lld linker (21 recommended)
- **Build System:** CMake 3.26+ with Ninja
- **Testing:** Google Test (via CMake FetchContent)
- **Logging:** spdlog (via CMake FetchContent)
- **Static Analysis:** clang-tidy, clang-format

### Build Commands

Configure and build (Linux):
```bash
./tools/configure.sh debug
./tools/build.sh debug
```

Configure and build (Windows):
```powershell
.\tools\configure.ps1 debug
.\tools\build.ps1 debug
```

Run tests:
```bash
ctest --test-dir build/debug --output-on-failure
```

### VS Code Tasks
The project includes predefined tasks in `.vscode/tasks.json`:
- **Build Debug (Linux/Windows)** - Build with debug symbols (default)
- **Build RelWithDebInfo** - Build with optimizations + debug info
- **Build Release** - Build optimized release version
- **Build Optimized** - Build with LTO, march=x86-64-v3, stripped
- **Clang-Tidy** - Run static analysis
- **Clang-Format** - Format all source files
- **Run Tests** - Execute test suite

## Coding Standards

### Language and Style
- **C++ Standard:** C++23 (required)
- **Compiler:** Primarily validated with clang
- **Formatting:** Use `.clang-format` (LLVM base, Allman braces)
  - Run `./tools/clang-format.sh` before commits
- **Static Analysis:** Use `.clang-tidy` configuration
  - Run `./tools/clang-tidy.sh` regularly

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
└── main.cpp          # Application entry point

tests/
├── CMakeLists.txt    # Test configuration
└── test_main.cpp     # Test cases

tools/
├── configure.sh/ps1  # CMake configure scripts
├── build.sh/ps1      # Build scripts
├── clang-tidy.sh/ps1 # Static analysis
└── clang-format.sh   # Code formatting
```

## Testing

### Test Framework
- Use **Google Test (gtest)** for all tests
- Tests live in `tests/` directory
- Run via `ctest --test-dir build/debug`

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
- Update CMakeLists.txt and document in README.md

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
