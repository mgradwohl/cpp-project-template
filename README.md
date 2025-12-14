# MyProject

A modern C++23 project template with clang toolchain, CMake Presets, Google Test, and VS Code integration.

## Features

- **Modern C++23** with clang as the primary compiler
- **CMake 3.28+** build system with CMake Presets and Ninja
- **Precompiled headers** for faster compilation
- **Compiler caching** via ccache/sccache for faster rebuilds
- **GNUInstallDirs** for portable installation paths
- **Google Test** for unit testing
- **spdlog** for logging (via FetchContent)
- **clang-tidy** and **clang-format** integration
- **VS Code** tasks, launch configs, and clangd support
- **Cross-platform** support for Linux and Windows

## Getting Started

### Step 1: Create a New Repository from This Template

1. Click the green **"Use this template"** button at the top of this page
2. Select **"Create a new repository"**
3. Name your repository (e.g., `AwesomeApp`)
4. Click **"Create repository"**

### Step 2: Clone Your New Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
```

### Step 3: Run the Setup Script

The setup script renames all placeholder names (`MyProject`, `MYPROJECT`, `myproject`) throughout the codebase to your project name:

```bash
# Linux/macOS
./setup.sh --name "YourProjectName"

# Windows (PowerShell)
.\setup.ps1 -Name "YourProjectName"

# Optional: include author name
./setup.sh --name "YourProjectName" --author "Your Name"
```

> **Note:** The setup script deletes itself after running - it's only needed once.

### Step 4: Commit the Changes

```bash
git add -A
git commit -m "Initial project setup"
git push
```

### Step 5: Build and Run

Using CMake Presets (recommended):

```bash
# Linux
cmake --preset debug
cmake --build --preset debug
./build/debug/YourProjectName

# Windows (PowerShell)
cmake --preset win-debug
cmake --build --preset win-debug
.\build\win-debug\YourProjectName.exe
```

List all available presets:
```bash
cmake --list-presets
```

### Step 6: Run Tests

```bash
# Linux
ctest --preset debug

# Windows
ctest --preset win-debug
```

## Requirements

### Linux
- Clang 21+ recommended
- CMake 3.28+ (4.2.1+ recommended)
- Ninja
- lld (LLVM linker)
- ccache 4.9.1+ (required for faster rebuilds)

```bash
# Ubuntu/Debian
sudo apt install clang-21 lld-21 cmake ninja-build ccache
```

### Windows
- LLVM/Clang 21+ (set `LLVM_ROOT` environment variable)
- CMake 3.28+
- Ninja
- ccache 4.9.1+ (install via `choco install ccache` or `scoop install ccache`)

## Project Structure

```
.
├── CMakeLists.txt          # Main build configuration
├── CMakePresets.json       # CMake presets for all platforms/configs
├── setup.sh / setup.ps1    # Project renaming scripts (deleted after use)
├── src/
│   └── main.cpp            # Application entry point
├── tests/
│   ├── CMakeLists.txt      # Test configuration
│   └── test_main.cpp       # Example tests
├── tools/
│   ├── clang-tidy.sh/ps1   # Static analysis
│   ├── clang-format.sh/ps1 # Code formatting
│   └── check-format.sh/ps1 # Format checking
├── .clang-format           # Formatting rules
├── .clang-tidy             # Static analysis rules
├── .clangd                 # clangd LSP configuration
└── .vscode/
    ├── tasks.json          # Build tasks (platform-aware)
    ├── launch.json         # Debug configurations (platform-aware)
    └── settings.json       # Editor settings
```

## VS Code Integration

Install recommended extensions (VS Code will prompt you):
- **clangd** (LLVM) - IntelliSense and code completion
- **CodeLLDB** - Debugging support
- **CMake Tools** - CMake integration

### Build Tasks

Tasks automatically use the correct preset for your platform (Linux or Windows):

- `Ctrl+Shift+B` - Build debug (default)
- Use Command Palette (`Ctrl+Shift+P`) → "Tasks: Run Task" for other configurations

Available tasks:
- CMake: Configure/Build Debug, RelWithDebInfo, Release, Optimized
- CMake: Test Debug
- Clang-Tidy, Clang-Format, Check Format

### Debugging

Launch configurations automatically use the correct paths for your platform:

- `F5` - Debug with current launch configuration
- Configurations: Debug (Debug), Debug (RelWithDebInfo), Run (Release), Run (Optimized)

## Build Types

Available as CMake presets (use `cmake --list-presets` to see all):

| Preset (Linux) | Preset (Windows) | Description |
|----------------|------------------|-------------|
| `debug` | `win-debug` | Debug symbols, no optimization |
| `relwithdebinfo` | `win-relwithdebinfo` | Debug symbols + optimization |
| `release` | `win-release` | Optimized, no debug symbols |
| `optimized` | `win-optimized` | LTO, march=x86-64-v3, stripped |

## Code Quality Tools

### Formatting
```bash
./tools/clang-format.sh        # Apply formatting (modifies files)
./tools/check-format.sh        # Check compliance (no changes)
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

Then link to your target:

```cmake
target_link_libraries(YourProjectName PRIVATE mylib)
```

## CI/CD

This template includes a GitHub Actions workflow (`.github/workflows/ci.yml`) that automatically:
- Builds on Linux (Ubuntu 24.04) and Windows
- Runs all tests
- Checks code formatting

## License

MIT License - See [LICENSE](LICENSE) file.
