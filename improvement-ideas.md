# MyProject - Improvement Ideas

## High Impact / Quick Wins

| Idea | Type | Effort | Description |
|------|------|--------|-------------|
| **Dev container** | Developer Experience | Medium | A `.devcontainer/` configuration enables instant, reproducible development environments in VS Code and GitHub Codespaces. New contributors can start coding within minutes without manually installing clang, cmake, ninja, or any other dependencies. This dramatically lowers the barrier to entry for contributors and ensures everyone has identical tooling, eliminating "works on my machine" issues. |
| **Pre-commit hooks** | Developer Experience | Low | Pre-commit hooks via `.pre-commit-config.yaml` automatically run clang-format and other checks before each commit. This catches formatting issues, trailing whitespace, and other problems at the earliest possible moment—before code even reaches CI. Developers get instant feedback and never accidentally push unformatted code. |
| **Hardening flags** | Build & Tooling | Low | Security hardening compiler flags like `-fstack-protector-strong`, `-D_FORTIFY_SOURCE=2`, `-fPIE`, and Control Flow Integrity (CFI) protect against common vulnerability classes including buffer overflows and ROP attacks. These flags have minimal performance impact in release builds and represent security best practices that should be standard in any production-quality C++ project. |
| **EditorConfig** | Developer Experience | Low | An `.editorconfig` file ensures consistent editor settings (indentation, line endings, charset) across all editors and IDEs—not just VS Code. This is especially valuable for cross-platform projects where Windows developers might accidentally introduce CRLF line endings. It's a simple file that prevents annoying whitespace-only diffs. |

## Code Quality & Safety

| Idea | Type | Effort | Description |
|------|------|--------|-------------|
| **Sanitizer support** | Build & Tooling | Medium | AddressSanitizer (ASan), UndefinedBehaviorSanitizer (UBSan), and ThreadSanitizer (TSan) are runtime instrumentation tools that detect memory errors, undefined behavior, and data races. Adding dedicated CMake presets for sanitizer builds makes it trivial to run your test suite with instrumentation, catching bugs that would otherwise cause silent corruption or intermittent crashes in production. |
| **Fuzzing** | Testing & Quality | Medium | libFuzzer integration provides automated, coverage-guided fuzzing that generates random inputs to find edge cases and crashes. Unlike unit tests that check expected behavior, fuzzing discovers unexpected failures. A single fuzzing target can find more bugs in an hour than months of manual testing, especially for parsing, serialization, or any code handling untrusted input. |
| **Mutation testing** | Testing & Quality | High | Mutation testing tools like mull systematically introduce bugs into your code and verify that your tests catch them. This measures the actual quality of your test suite—not just coverage, but whether your assertions would detect real bugs. It answers the question: "If this code was wrong, would my tests fail?" |
| **Property-based testing** | Testing & Quality | Medium | Property-based testing with rapidcheck generates hundreds of random test cases from declarative properties. Instead of writing `EXPECT_EQ(reverse(reverse(list)), list)` for a few examples, you declare the property and the framework generates diverse inputs. This finds edge cases you wouldn't think to test manually. |

## Performance Optimization

| Idea | Type | Effort | Description |
|------|------|--------|-------------|
| **Benchmark framework** | Testing & Quality | Low | Google Benchmark integration provides a standard way to measure and track performance. Microbenchmarks catch performance regressions early, and the framework handles warmup, statistical analysis, and output formatting. Combined with CI, you can detect performance regressions before they reach production. |
| **Performance profiling** | Build & Tooling | Medium | Build presets optimized for profiling with `perf` (Linux) and Instruments (macOS) enable efficient performance analysis. Profile-Guided Optimization (PGO) presets use real workload data to guide compiler optimizations, often yielding 10-20% performance improvements over standard release builds. |
| **Unity builds** | Build & Tooling | Low | `CMAKE_UNITY_BUILD` combines multiple source files into single translation units, dramatically reducing compile times for full rebuilds by eliminating redundant header parsing and enabling better optimization across file boundaries. While incremental builds don't benefit, clean builds can be 2-5x faster. |

## Modern C++ Adoption

| Idea | Type | Effort | Description |
|------|------|--------|-------------|
| **C++20/23 module support** | Build & Tooling | Medium | C++ modules (`import std;`) replace header files with compiled module interfaces, offering faster compilation, better encapsulation, and elimination of include-order bugs. CMake 3.28+ has experimental module support. While tooling is still maturing, early adoption positions the project for the future of C++. |
| **Version header generation** | Build & Tooling | Low | Auto-generating a `version.h` header from CMake embeds version information directly in the binary. This enables runtime version queries, proper `--version` output, and ensures the compiled binary always knows its own version. It's a small feature that makes releases and debugging significantly easier. |
| **`std::expected` examples** | Modern C++23 | Low | `std::expected<T, E>` provides a modern, type-safe alternative to exceptions or error codes for recoverable errors. Including example patterns in the template demonstrates idiomatic C++23 error handling and helps developers adopt this powerful feature correctly. |
| **`std::generator` examples** | Modern C++23 | Low | `std::generator` enables lazy, coroutine-based sequences that can represent infinite or expensive-to-compute collections. Example code demonstrating generator patterns helps developers leverage this C++23 feature for cleaner, more memory-efficient iteration. |
| **`std::print` adoption** | Modern C++23 | Low | `std::print` and `std::println` provide type-safe, format-string-based output that's cleaner than iostream and safer than printf. For simple console output, this can replace spdlog dependencies entirely, reducing compilation time and external dependencies. |

## Platform & Distribution

| Idea | Type | Effort | Description |
|------|------|--------|-------------|
| **Cross-compilation presets** | Build & Tooling | Medium | CMake presets for ARM64 and WebAssembly (via Emscripten) targets enable building for additional platforms without leaving the familiar preset workflow. ARM64 support is increasingly important as Apple Silicon and ARM servers become mainstream; WASM enables running C++ in browsers. |
| **GitHub Release workflow** | Documentation & Release | Low | A GitHub Actions workflow that automatically creates releases with pre-built binaries when you push a version tag streamlines the release process. Users get downloadable artifacts without manual intervention, and the release notes can be auto-generated from commit history. |
| **SBOM generation** | Documentation & Release | Medium | Software Bill of Materials (SBOM) generation documents all dependencies in standard formats like SPDX or CycloneDX. This is increasingly required for supply chain security compliance and helps users understand exactly what's in your software. Some industries and government contracts now mandate SBOMs. |
| **License scanning** | Documentation & Release | Low | REUSE compliance ensures every file has clear license information via SPDX headers. This removes legal ambiguity for users and contributors, making it clear how the code can be used. Automated scanning in CI prevents accidentally adding incompatibly-licensed code. |
| **Changelog generation** | Documentation & Release | Low | Conventional commit messages combined with automated changelog generation (via tools like git-cliff or release-please) create professional, consistent release notes. This documents what changed between versions without manual effort, helping users understand upgrade impacts. |
