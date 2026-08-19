# Security Policy

## Supported Versions

This template does not maintain multiple release lines. Security fixes apply to the latest revision of the default branch.

## Report a Vulnerability

Do not open a public issue for a suspected vulnerability. Use GitHub private vulnerability reporting when it is enabled for the repository, or contact the repository maintainer privately.

Include:

- A description of the issue and its potential impact
- Reproduction steps or a minimal proof of concept
- Affected versions, platforms, and configurations
- A suggested mitigation, if known

Please allow up to 48 hours for acknowledgment and one week for an initial assessment. Resolution time depends on severity and complexity.

## Security-Relevant Tooling

The repository exercises ASan, UBSan, and TSan in CI, runs clang-tidy, treats project warnings as errors by default, and pins FetchContent dependencies to Git tags. Debug and sanitizer presets also initialize trivial automatic variables with a pattern to expose uninitialized use.

These checks reduce risk but do not replace application-specific threat modeling or dependency review. Third-party source dependencies are spdlog 1.13.0 and Google Test 1.15.2; GitHub Actions dependencies are monitored by Dependabot.
