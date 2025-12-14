cmake_minimum_required(VERSION 3.28)

project(MyProject VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_COLOR_DIAGNOSTICS ON)

# Keep clangd fed regardless of config: copy compile_commands.json to source root on build.
if(NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    add_custom_target(copy-compile-commands ALL
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_BINARY_DIR}/compile_commands.json"
            "${CMAKE_SOURCE_DIR}/compile_commands.json"
        BYPRODUCTS "${CMAKE_SOURCE_DIR}/compile_commands.json"
        COMMENT "Copying compile_commands.json to source tree for clangd"
    )
endif()

option(MYPROJECT_ENABLE_IPO "Enable interprocedural optimization" ON)
option(MYPROJECT_ENABLE_WARNINGS "Enable extra compiler warnings" ON)
option(MYPROJECT_BUILD_TESTS "Build tests" ON)
option(MYPROJECT_ENABLE_PCH "Enable precompiled headers" ON)
option(MYPROJECT_ENABLE_CCACHE "Enable compiler caching (ccache/sccache)" ON)
option(MYPROJECT_ENABLE_COVERAGE "Enable code coverage instrumentation" OFF)

# Compiler caching (ccache/sccache) - required for development
if(MYPROJECT_ENABLE_CCACHE)
    find_program(CCACHE_PROGRAM ccache)
    find_program(SCCACHE_PROGRAM sccache)
    if(SCCACHE_PROGRAM)
        message(STATUS "Using sccache: ${SCCACHE_PROGRAM}")
        set(CMAKE_C_COMPILER_LAUNCHER "${SCCACHE_PROGRAM}")
        set(CMAKE_CXX_COMPILER_LAUNCHER "${SCCACHE_PROGRAM}")
    elseif(CCACHE_PROGRAM)
        message(STATUS "Using ccache: ${CCACHE_PROGRAM}")
        set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
        set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
    else()
        message(WARNING "Neither ccache nor sccache found. Install ccache for faster rebuilds:\n"
            "  Linux: sudo apt install ccache\n"
            "  macOS: brew install ccache\n"
            "  Windows: choco install ccache OR scoop install ccache")
    endif()
endif()

# Code coverage support (Clang only)
if(MYPROJECT_ENABLE_COVERAGE)
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        message(STATUS "Code coverage enabled")
        add_compile_options(-fprofile-instr-generate -fcoverage-mapping)
        add_link_options(-fprofile-instr-generate -fcoverage-mapping)
    else()
        message(WARNING "Code coverage is only supported with Clang. Disabling coverage.")
        set(MYPROJECT_ENABLE_COVERAGE OFF)
    endif()
endif()

function(myproject_apply_default_warnings target_name)
    if(NOT MYPROJECT_ENABLE_WARNINGS)
        return()
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "AppleClang")
        target_compile_options(${target_name} PRIVATE
            -Wall
            -Wextra
            -Wpedantic
            -Wconversion
            -Wimplicit-fallthrough
            -Werror=return-type
        )
    elseif(MSVC)
        target_compile_options(${target_name} PRIVATE /W4 /permissive- /EHsc)
    endif()
endfunction()

find_program(CLANG_TIDY_EXE NAMES clang-tidy
    HINTS
        "/usr/lib/llvm-21/bin"
        "$ENV{LLVM_ROOT}/bin"
        "$ENV{ProgramFiles}/LLVM/bin"
        "C:/Program Files/LLVM/bin"
)

find_program(CLANG_FORMAT_EXE NAMES clang-format
    HINTS
        "/usr/lib/llvm-21/bin"
        "$ENV{LLVM_ROOT}/bin"
        "$ENV{ProgramFiles}/LLVM/bin"
        "C:/Program Files/LLVM/bin"
)

if(MYPROJECT_ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT ipo_supported)
    if(ipo_supported)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    endif()
endif()

include(FetchContent)
include(GNUInstallDirs)
set(FETCHCONTENT_TRY_FIND_PACKAGE_MODE ALWAYS)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    message(STATUS "Configuring MyProject with clang: ${CMAKE_CXX_COMPILER}")
else()
    message(WARNING "MyProject is validated primarily with clang; proceeding with ${CMAKE_CXX_COMPILER_ID}.")
endif()

# Prefer header-only spdlog and std::format to sidestep MSVC fmt deprecation noise.
set(SPDLOG_HEADER_ONLY ON CACHE BOOL "Build spdlog in header-only mode" FORCE)

FetchContent_Declare(
    spdlog
    GIT_REPOSITORY https://github.com/gabime/spdlog.git
    GIT_TAG v1.13.0
)

FetchContent_MakeAvailable(spdlog)

if(TARGET spdlog_header_only)
    target_compile_definitions(spdlog_header_only INTERFACE SPDLOG_USE_STD_FORMAT $<$<PLATFORM_ID:Windows>:_SILENCE_STDEXT_ARR_ITERS_DEPRECATION_WARNING>)
endif()

if(TARGET spdlog)
    target_compile_definitions(spdlog PUBLIC SPDLOG_USE_STD_FORMAT $<$<PLATFORM_ID:Windows>:_SILENCE_STDEXT_ARR_ITERS_DEPRECATION_WARNING>)
endif()

# Generate version header from template
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/src/version.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/version.h
    @ONLY
)

set(MYPROJECT_SOURCES
    src/main.cpp
)

set(MYPROJECT_HEADERS
)

if(CLANG_TIDY_EXE)
    add_custom_target(run-clang-tidy
        COMMAND ${CLANG_TIDY_EXE}
            --config-file=${CMAKE_SOURCE_DIR}/.clang-tidy
            -p ${CMAKE_BINARY_DIR}
            --extra-arg=-std=c++23
            ${MYPROJECT_SOURCES}
            ${MYPROJECT_HEADERS}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Running clang-tidy on project sources"
    )
    add_dependencies(run-clang-tidy copy-compile-commands)
endif()

if(CLANG_FORMAT_EXE)
    add_custom_target(run-clang-format
        COMMAND ${CLANG_FORMAT_EXE} -i
            ${MYPROJECT_SOURCES}
            ${MYPROJECT_HEADERS}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Applying clang-format to project sources"
    )
endif()

add_executable(MyProject
    ${MYPROJECT_SOURCES}
    ${MYPROJECT_HEADERS}
)

target_compile_features(MyProject PRIVATE cxx_std_23)

# Precompiled headers
if(MYPROJECT_ENABLE_PCH)
    target_precompile_headers(MyProject PRIVATE
        <string>
        <vector>
        <memory>
        <algorithm>
        <functional>
        <optional>
        <variant>
        <span>
        <format>
        <spdlog/spdlog.h>
    )
endif()

myproject_apply_default_warnings(MyProject)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(MyProject PRIVATE
        $<$<CONFIG:Debug>:-glldb>
        $<$<CONFIG:RelWithDebInfo>:-glldb>
    )
endif()

if(WIN32)
    target_compile_definitions(MyProject PRIVATE NOMINMAX WIN32_LEAN_AND_MEAN)
endif()

target_include_directories(MyProject PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_BINARY_DIR}/generated
)

target_link_libraries(MyProject PRIVATE
    spdlog::spdlog_header_only
)

install(TARGETS MyProject
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

if(MYPROJECT_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# CPack configuration for packaging
set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_NAME} - A modern C++23 application")
set(CPACK_PACKAGE_VENDOR "")
set(CPACK_PACKAGE_CONTACT "")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/README.md")

# Output directory for packages
set(CPACK_PACKAGE_DIRECTORY "${CMAKE_SOURCE_DIR}/dist")

# Archive generators (cross-platform)
set(CPACK_GENERATOR "ZIP;TGZ")

# Platform-specific generators
if(WIN32)
    list(APPEND CPACK_GENERATOR "NSIS")
    set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
    set(CPACK_NSIS_MODIFY_PATH ON)
elseif(APPLE)
    list(APPEND CPACK_GENERATOR "DragNDrop")
elseif(UNIX)
    # Check for dpkg (Debian/Ubuntu)
    find_program(DPKG_PROGRAM dpkg)
    if(DPKG_PROGRAM)
        list(APPEND CPACK_GENERATOR "DEB")
        set(CPACK_DEBIAN_PACKAGE_MAINTAINER "${CPACK_PACKAGE_CONTACT}")
        set(CPACK_DEBIAN_PACKAGE_SECTION "utils")
    endif()
    # Check for rpmbuild (Red Hat/Fedora)
    find_program(RPMBUILD_PROGRAM rpmbuild)
    if(RPMBUILD_PROGRAM)
        list(APPEND CPACK_GENERATOR "RPM")
    endif()
endif()

include(CPack)
