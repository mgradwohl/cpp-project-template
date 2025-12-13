#include <spdlog/spdlog.h>

#include <cstdio>

auto main() -> int
{
    spdlog::info("MyProject v{}", MYPROJECT_VERSION);
    std::printf("Hello, World!\n");
    return 0;
}
