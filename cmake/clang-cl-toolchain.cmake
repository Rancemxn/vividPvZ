# CMake toolchain file for clang-cl (Clang with MSVC compatibility)
# Usage: cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE=cmake/clang-cl-toolchain.cmake ..

# Target system
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86)

# Find clang-cl
find_program(CLANG_CL_COMPILER 
    NAMES clang-cl
    HINTS 
        "C:/Program Files/LLVM/bin"
        "C:/Program Files (x86)/LLVM/bin"
        "$ENV{LLVM_HOME}/bin"
        "$ENV{PATH}"
)

if(CLANG_CL_COMPILER)
    set(CMAKE_C_COMPILER ${CLANG_CL_COMPILER})
    set(CMAKE_CXX_COMPILER ${CLANG_CL_COMPILER})
    message(STATUS "Found clang-cl: ${CLANG_CL_COMPILER}")
else()
    message(FATAL_ERROR "Could not find clang-cl. Please install LLVM/Clang.")
endif()

# Find MSVC build tools
set(VS_INSTALLATION_PATH "")
if(EXISTS "C:/Program Files/Microsoft Visual Studio/2022/Community")
    set(VS_INSTALLATION_PATH "C:/Program Files/Microsoft Visual Studio/2022/Community")
elseif(EXISTS "C:/Program Files/Microsoft Visual Studio/2022/Professional")
    set(VS_INSTALLATION_PATH "C:/Program Files/Microsoft Visual Studio/2022/Professional")
elseif(EXISTS "C:/Program Files/Microsoft Visual Studio/2022/Enterprise")
    set(VS_INSTALLATION_PATH "C:/Program Files/Microsoft Visual Studio/2022/Enterprise")
elseif(EXISTS "C:/Program Files (x86)/Microsoft Visual Studio/2019/Community")
    set(VS_INSTALLATION_PATH "C:/Program Files (x86)/Microsoft Visual Studio/2019/Community")
elseif(EXISTS "C:/Program Files (x86)/Microsoft Visual Studio/2019/Professional")
    set(VS_INSTALLATION_PATH "C:/Program Files (x86)/Microsoft Visual Studio/2019/Professional")
endif()

if(VS_INSTALLATION_PATH)
    message(STATUS "Found Visual Studio: ${VS_INSTALLATION_PATH}")
endif()

# Clang-cl flags for 32-bit
set(CMAKE_C_FLAGS_INIT "-m32")
set(CMAKE_CXX_FLAGS_INIT "-m32")

# MSVC compatibility
set(CMAKE_C_FLAGS_INIT "${CMAKE_C_FLAGS_INIT} /utf-8 /D_CRT_SECURE_NO_WARNINGS")
set(CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} /utf-8 /D_CRT_SECURE_NO_WARNINGS")

# Note: For Ninja generator, do not set CMAKE_GENERATOR_PLATFORM
# The -m32 flag above handles 32-bit compilation
# CMAKE_GENERATOR_PLATFORM is only for Visual Studio generators

# Find linker
find_program(LINKER 
    NAMES link
    HINTS 
        "${VS_INSTALLATION_PATH}/VC/Tools/MSVC/*/bin/Hostx64/x86"
        "${VS_INSTALLATION_PATH}/VC/Tools/MSVC/*/bin/Hostx86/x86"
)

if(LINKER)
    set(CMAKE_LINKER ${LINKER})
    message(STATUS "Found MSVC linker: ${LINKER}")
endif()

# Find lib.exe
find_program(LIB_TOOL 
    NAMES lib
    HINTS 
        "${VS_INSTALLATION_PATH}/VC/Tools/MSVC/*/bin/Hostx64/x86"
        "${VS_INSTALLATION_PATH}/VC/Tools/MSVC/*/bin/Hostx86/x86"
)

if(LIB_TOOL)
    set(CMAKE_AR ${LIB_TOOL})
    message(STATUS "Found lib.exe: ${LIB_TOOL}")
endif()

message(STATUS "Using clang-cl toolchain for Windows x86")
