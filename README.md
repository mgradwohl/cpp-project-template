# MyProject

A modern C++23 project template with clang toolchain, CMake, Google Test, and VS Code integration.

## Features

- **Modern C++23** with clang as the primary compiler
- **CMake 3.26+** build system with Ninja
- **Google Test** for unit testing
- **spdlog** for logging (via FetchContent)
- **clang-tidy** and **clang-format** integration
- **VS Code** tasks, launch configs, and clangd support
- **Cross-platform** support for Linux and Windows

## Quick Start

### 1. Create Your Project

Use this template on GitHub, then run the setup script:

```bash
# Linux/macOS
./setup.sh --name "YourProjectName"

# Windows (PowerShell)
.\setup.ps1 -Name "YourProjectName"
```

### 2. Build

```bash
# Linux
./tools/configure.sh debug
./tools/build.sh debug

# Windows (PowerShell)
.\tools\configure.ps1 debug
.\tools\build.ps1 debug
```

### 3. Run Tests

```bash
ctest --test-dir build/debug --output-on-failure
```

## Requirements

### Linux
- Clang 17+ (21 recommended)
- CMake 3.26+
- Ninja
- lld (LLVM linker)

```bash
# Ubuntu/Debian
sudo apt install clang-21 lld-21 cmake ninja-build
```

### Windows
- LLVM/Clang (set `LLVM_ROOT` environment variable)
- CMake 3.26+
- Ninja
- (Optional) vcpkg for package management

## Project Structure

```
.
├── CMakeLists.txt          # Main build configuration
├── setup.sh / setup.ps1    # Project renaming scripts
├── src/
│   └── main.cpp            # Application entry point
├── tests/
│   ├── CMakeLists.txt      # Test configuration
│   └── test_main.cpp       # Example tests
├── tools/
│   ├── configure.sh/ps1    # CMake configure scripts
│   ├── build.sh/ps1        # Build scripts
│   ├── clang-tidy.sh/ps1   # Static analysis
│   └── clang-format.sh/ps1 # Code formatting
├── .clang-format           # Formatting rules
├── .clang-tidy             # Static analysis rules
└── .vscode/
    ├── tasks.json          # Build tasks
    ├── launch.json         # Debug configurations
    └── settings.json       # Editor settings
```

## VS Code Integration

Install recommended extensions:
- clangd (LLVM)
- CodeLLDB (for debugging)
- CMake Tools

### Build Tasks
- `Ctrl+Shift+B` - Build debug (default)
- Use Command Palette for other configurations

### Debugging
- `F5` - Debug with current launch configuration
- Multiple configurations for Debug, RelWithDebInfo, Release, Optimized

## Build Types

| Type | Description |
|------|-------------|
| `debug` | Debug symbols, no optimization |
| `relwithdebinfo` | Debug symbols + optimization |
| `release` | Optimized, no debug symbols |
| `optimized` | LTO, march=x86-64-v3, stripped |

## Code Quality Tools

### Formatting
```bash
./tools/clang-format.sh        # Apply formatting
./tools/check-format.sh        # Check compliance
```

### Static Analysis
```bash
./tools/clang-tidy.sh debug    # Run clang-tidy
```

## Adding Dependencies

Use CMake's `FetchContent` for header-only or source-based dependencies:

```cmake
FetchContent_Declare(
    mylib
    GIT_REPOSITORY https://github.com/example/mylib.git
    GIT_TAG v1.0.0
)
FetchContent_MakeAvailable(mylib)
```

## License

MIT License - See [LICENSE](LICENSE) file.
