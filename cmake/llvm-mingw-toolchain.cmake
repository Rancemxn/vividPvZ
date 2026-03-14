# CMake toolchain file for LLVM/Clang on Windows
# Usage: cmake -DCMAKE_TOOLCHAIN_FILE=cmake/llvm-mingw-toolchain.cmake ..

# Target system
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86)

# Find LLVM/Clang
find_program(CLANG_C_COMPILER 
    NAMES clang clang-cl
    HINTS 
        "C:/Program Files/LLVM/bin"
        "C:/Program Files (x86)/LLVM/bin"
        "$ENV{LLVM_HOME}/bin"
)

find_program(CLANG_CXX_COMPILER 
    NAMES clang++ clang-cl
    HINTS 
        "C:/Program Files/LLVM/bin"
        "C:/Program Files (x86)/LLVM/bin"
        "$ENV{LLVM_HOME}/bin"
)

# Set compilers
if(CLANG_C_COMPILER)
    set(CMAKE_C_COMPILER ${CLANG_C_COMPILER})
    message(STATUS "Found Clang C compiler: ${CLANG_C_COMPILER}")
else()
    message(FATAL_ERROR "Could not find Clang C compiler")
endif()

if(CLANG_CXX_COMPILER)
    set(CMAKE_CXX_COMPILER ${CLANG_CXX_COMPILER})
    message(STATUS "Found Clang C++ compiler: ${CLANG_CXX_COMPILER}")
else()
    message(FATAL_ERROR "Could not find Clang C++ compiler")
endif()

# Use lld linker if available
find_program(LLD_LINKER 
    NAMES lld-link ld.lld
    HINTS 
        "C:/Program Files/LLVM/bin"
        "C:/Program Files (x86)/LLVM/bin"
        "$ENV{LLVM_HOME}/bin"
)

if(LLD_LINKER)
    set(CMAKE_LINKER ${LLD_LINKER})
    message(STATUS "Found LLD linker: ${LLD_LINKER}")
endif()

# Target architecture flags
set(CMAKE_C_FLAGS_INIT "-target i686-pc-windows-msvc -m32")
set(CMAKE_CXX_FLAGS_INIT "-target i686-pc-windows-msvc -m32")

# MSVC compatibility
set(CMAKE_C_FLAGS_INIT "${CMAKE_C_FLAGS_INIT} -fms-extensions -fms-compatibility")
set(CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} -fms-extensions -fms-compatibility")

# 32-bit build
set(CMAKE_GENERATOR_PLATFORM Win32 CACHE INTERNAL "")

# Find Windows SDK
set(CMAKE_SYSTEM_WINDOWS_SDK ON)

# Use MSVC standard library
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_CRT_SECURE_NO_WARNINGS")

message(STATUS "Using LLVM/Clang toolchain for Windows x86")
