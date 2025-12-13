#include <spdlog/spdlog.h>

#include <iostream>
#include <string>

auto main(int argc, char* argv[]) -> int
{
    spdlog::info("MyProject v{}", MYPROJECT_VERSION);
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
