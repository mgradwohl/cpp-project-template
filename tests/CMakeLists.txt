# Google Test setup
include(FetchContent)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.15.2
    SYSTEM  # Treat as system headers to suppress warnings from gtest
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest)

include(GoogleTest)

# Example test executable
add_executable(MyProject_tests
    test_main.cpp
)

target_link_libraries(MyProject_tests PRIVATE
    GTest::gtest_main
)

myproject_apply_default_warnings(MyProject_tests)

gtest_discover_tests(MyProject_tests)
