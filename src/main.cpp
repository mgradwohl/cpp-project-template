#ifdef _WIN32
#include <windows.h>
#endif

#include <spdlog/common.h>
#include <spdlog/spdlog.h>

#ifdef _WIN32
#include <spdlog/sinks/msvc_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#endif

#include <cstdio>

#ifndef MYPROJECT_VERSION
// Do not change to constexpr, this is set and passed in by the build system
// NOLINTNEXTLINE(cppcoreguidelines-macro-usage)
#define MYPROJECT_VERSION "0.0.0-dev"
#endif

auto main() -> int
{
// Required on Windows to see console output when launching from an IDE or debugger
// if your Windows applicaiton is a "Console" subsystem application, you can skip this.
#if defined(_WIN32) && !defined(NDEBUG)
    // Try to attach to parent console (e.g., when run from terminal).
    // If no parent console exists (e.g., launched from debugger), create our own.
    if (AttachConsole(ATTACH_PARENT_PROCESS) == 0)
    {
        AllocConsole();
        // Redirect stdout/stderr to the new console
        FILE* out = nullptr;
        FILE* err = nullptr;
        freopen_s(&out, "CONOUT$", "w", stdout);
        freopen_s(&err, "CONOUT$", "w", stderr);
    }
    auto msvcSink = std::make_shared<spdlog::sinks::msvc_sink_mt>();
    auto consoleSink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
    auto logger = std::make_shared<spdlog::logger>("MyProject", spdlog::sinks_init_list{msvcSink, consoleSink});

    spdlog::set_default_logger(logger);

#endif

#ifndef NDEBUG
    spdlog::set_level(spdlog::level::debug);
    spdlog::flush_on(spdlog::level::debug);
#endif

    spdlog::info("MyProject v{}", MYPROJECT_VERSION);
    // clang doesn't support std::println yet so we're using printf for now
    // NOLINTNEXTLINE(cppcoreguidelines-pro-type-vararg, modernize-use-std-print)
    std::printf("Hello, World!\n");
    return 0;
}