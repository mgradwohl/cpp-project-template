# Project Backlog

This file tracks work that is not implemented. Completed features belong in release history or commit history rather than the active backlog.

## Near-Term

| Idea | Area | Notes |
| --- | --- | --- |
| EditorConfig | Developer experience | Standardize line endings and basic editor behavior outside VS Code. |
| Release workflow | Distribution | Build packages and create a GitHub release from version tags. |
| Dependency scanning | Security | Scan pinned C++ dependencies; Dependabot currently covers only GitHub Actions. |
| Pre-commit checks | Developer experience | Run formatting and whitespace checks locally without duplicating CI configuration. |
| Dev container | Onboarding | Provide a reproducible LLVM, CMake, Ninja, and ccache environment. |

## Future Enhancements

| Idea | Area | Notes |
| --- | --- | --- |
| Benchmark target | Performance | Add Google Benchmark when the application has code worth measuring. |
| Fuzz targets | Testing | Add libFuzzer targets for parsers or other untrusted-input boundaries. |
| Performance profiling | Performance | Document perf/Instruments and evaluate profile-guided optimization. |
| SBOM and license scanning | Supply chain | Produce package metadata when release automation exists. |
| ARM64 or WebAssembly presets | Portability | Add only with a supported toolchain and CI coverage. |
| C++23 examples | Education | Add `std::expected`, ranges, or mdspan examples only when they support real template structure rather than demo-only code. |

## Deferred

| Idea | Reason |
| --- | --- |
| Mutation testing with Mull | Current Mull releases do not support the project LLVM version. |
| Standard library modules | Compiler, standard library, CMake, and clangd support is not yet mature enough for this cross-platform template. |
| `std::generator` example | Standard library support remains inconsistent across supported platforms. |

When implementing an item, update the README only if the supported workflow or feature set changes, then remove the item from this file.
