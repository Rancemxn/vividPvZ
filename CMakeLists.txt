# CMakeLists.txt for vividPvZ - Plants vs. Zombies Decompilation
# CMake minimum version and project definition
cmake_minimum_required(VERSION 3.20)

project(vividPvZ 
    VERSION 0.9.9.1029
    LANGUAGES CXX C
    DESCRIPTION "Plants vs. Zombies Decompilation Project"
)

# =============================================================================
# Platform Check - Windows Only
# =============================================================================
if(NOT WIN32)
    message(FATAL_ERROR "This project only supports Windows platform!")
endif()

# =============================================================================
# C++ Standard and Compiler Settings
# =============================================================================
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# LLVM/Clang specific settings
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    message(STATUS "Using LLVM/Clang compiler: ${CMAKE_CXX_COMPILER}")
    
    # MSVC compatibility flags
    add_compile_options(
        -fms-extensions
        -fms-compatibility
        -fms-compatibility-version=19.29
        -Wno-microsoft-enum-value
        -Wno-microsoft-cast
        -Wno-microsoft-include
        -Wno-pragma-pack
        -Wno-deprecated-declarations
        -Wno-unused-function
        -Wno-unused-variable
        -Wno-switch
        -Wno-comment
    )
    
    # Debug flags
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0 -DDEBUG")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g -O0 -DDEBUG")
    
    # Release flags
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2 -DNDEBUG")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2 -DNDEBUG")
elseif(MSVC)
    message(STATUS "Using MSVC compiler: ${CMAKE_CXX_COMPILER}")
    
    # MSVC specific flags
    add_compile_options(
        /W3
        /MP  # Multi-processor compilation
        /utf-8
    )
    
    # Disable specific warnings
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS)
endif()

# =============================================================================
# Output Directory Configuration
# =============================================================================
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# =============================================================================
# Find Required Libraries
# =============================================================================

# DirectX 8 SDK
set(DX8SDK_DIR ${CMAKE_SOURCE_DIR}/dx8sdk)
if(EXISTS ${DX8SDK_DIR})
    message(STATUS "Found DirectX 8 SDK: ${DX8SDK_DIR}")
    set(DX8_INCLUDE_DIR ${DX8SDK_DIR}/include)
    set(DX8_LIBRARY_DIR ${DX8SDK_DIR}/lib)
else()
    message(WARNING "DirectX 8 SDK not found at ${DX8SDK_DIR}")
endif()

# =============================================================================
# Preprocessor Definitions
# =============================================================================
set(PROJECT_DEFINITIONS
    WIN32
    _WINDOWS
    _VISUALC_
    _JPEGLIB_
    _CRT_SECURE_NO_WARNINGS
    _WINSOCK_DEPRECATED_NO_WARNINGS
    NOMINMAX
)

# Debug definitions
set(PROJECT_DEFINITIONS_DEBUG
    _DEBUG
    DEBUG
)

# Release definitions
set(PROJECT_DEFINITIONS_RELEASE
    NDEBUG
)

# =============================================================================
# Include Directories
# =============================================================================
set(PROJECT_INCLUDE_DIRS
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/SexyAppFramework
    ${CMAKE_SOURCE_DIR}/Sexy.TodLib
    ${CMAKE_SOURCE_DIR}/Lawn
    ${CMAKE_SOURCE_DIR}/Lawn/System
    ${CMAKE_SOURCE_DIR}/Lawn/Widget
    ${CMAKE_SOURCE_DIR}/ImageLib
    ${CMAKE_SOURCE_DIR}/ImageLib/jpeg
    ${CMAKE_SOURCE_DIR}/ImageLib/jpeg2000
    ${CMAKE_SOURCE_DIR}/ImageLib/png
    ${CMAKE_SOURCE_DIR}/ImageLib/zlib
    ${CMAKE_SOURCE_DIR}/PakLib
    ${DX8_INCLUDE_DIR}
)

# =============================================================================
# Source Files Collection - Using GLOB for flexibility
# =============================================================================

# Main source files (root directory)
set(MAIN_SOURCES
    ${CMAKE_SOURCE_DIR}/main.cpp
    ${CMAKE_SOURCE_DIR}/LawnApp.cpp
    ${CMAKE_SOURCE_DIR}/Resources.cpp
)

# Lawn core sources
file(GLOB LAWN_SOURCES ${CMAKE_SOURCE_DIR}/Lawn/*.cpp)

# Lawn System sources
file(GLOB LAWN_SYSTEM_SOURCES ${CMAKE_SOURCE_DIR}/Lawn/System/*.cpp)

# Lawn Widget sources
file(GLOB LAWN_WIDGET_SOURCES ${CMAKE_SOURCE_DIR}/Lawn/Widget/*.cpp)

# SexyAppFramework sources
file(GLOB FRAMEWORK_SOURCES ${CMAKE_SOURCE_DIR}/SexyAppFramework/*.cpp)

# Sexy.TodLib sources
file(GLOB TODLIB_SOURCES ${CMAKE_SOURCE_DIR}/Sexy.TodLib/*.cpp)

# ImageLib sources
file(GLOB IMAGELIB_SOURCES ${CMAKE_SOURCE_DIR}/ImageLib/*.cpp)

# JPEG library sources (C files)
file(GLOB JPEG_SOURCES ${CMAKE_SOURCE_DIR}/ImageLib/jpeg/*.c)

# JPEG2000 library sources (C files)
file(GLOB JPEG2000_SOURCES ${CMAKE_SOURCE_DIR}/ImageLib/jpeg2000/*.c)

# PNG library sources (C files)
file(GLOB PNG_SOURCES ${CMAKE_SOURCE_DIR}/ImageLib/png/*.c)

# Zlib sources (C files)
file(GLOB ZLIB_SOURCES ${CMAKE_SOURCE_DIR}/ImageLib/zlib/*.c)

# PakLib sources
file(GLOB PAKLIB_SOURCES ${CMAKE_SOURCE_DIR}/PakLib/*.cpp)

# Ogg/Vorbis sources (C files)
file(GLOB OGG_SOURCES ${CMAKE_SOURCE_DIR}/SexyAppFramework/ogg/*.c)

# Combine all sources
set(ALL_SOURCES
    ${MAIN_SOURCES}
    ${LAWN_SOURCES}
    ${LAWN_SYSTEM_SOURCES}
    ${LAWN_WIDGET_SOURCES}
    ${FRAMEWORK_SOURCES}
    ${TODLIB_SOURCES}
    ${IMAGELIB_SOURCES}
    ${JPEG_SOURCES}
    ${JPEG2000_SOURCES}
    ${PNG_SOURCES}
    ${ZLIB_SOURCES}
    ${PAKLIB_SOURCES}
    ${OGG_SOURCES}
)

# =============================================================================
# Resource Files
# =============================================================================
if(EXISTS ${CMAKE_SOURCE_DIR}/SexyAppFramework/LawnProject.rc)
    set(RESOURCE_FILES ${CMAKE_SOURCE_DIR}/SexyAppFramework/LawnProject.rc)
else()
    set(RESOURCE_FILES "")
endif()

# =============================================================================
# Executable Definition
# =============================================================================
add_executable(PlantsVsZombies WIN32
    ${ALL_SOURCES}
    ${RESOURCE_FILES}
)

# =============================================================================
# Target Configuration
# =============================================================================

# Include directories
target_include_directories(PlantsVsZombies PRIVATE
    ${PROJECT_INCLUDE_DIRS}
)

# Compile definitions
target_compile_definitions(PlantsVsZombies PRIVATE
    ${PROJECT_DEFINITIONS}
)

# Debug definitions
target_compile_definitions(PlantsVsZombies PRIVATE
    $<$<CONFIG:Debug>:${PROJECT_DEFINITIONS_DEBUG}>
)

# Release definitions
target_compile_definitions(PlantsVsZombies PRIVATE
    $<$<CONFIG:Release>:${PROJECT_DEFINITIONS_RELEASE}>
)

# =============================================================================
# Link Libraries
# =============================================================================
set(WINDOWS_LIBS
    kernel32
    user32
    gdi32
    winspool
    comdlg32
    advapi32
    shell32
    ole32
    oleaut32
    uuid
    odbc32
    odbccp32
    winmm
    ws2_32
    version
    imm32
)

# DirectX 8 libraries
set(DIRECTX_LIBS
    d3d8
    d3dx8
    ddraw
    dsound
    dxguid
    dinput8
)

# Link libraries
target_link_libraries(PlantsVsZombies PRIVATE
    ${WINDOWS_LIBS}
    ${DIRECTX_LIBS}
)

# Add DirectX library path
if(EXISTS ${DX8_LIBRARY_DIR})
    target_link_directories(PlantsVsZombies PRIVATE ${DX8_LIBRARY_DIR})
endif()

# =============================================================================
# Copy Runtime Dependencies
# =============================================================================

# Copy DLL files to output directory
set(DLL_FILES
    ${CMAKE_SOURCE_DIR}/bass.dll
    ${CMAKE_SOURCE_DIR}/SexyAppFramework/bass.dll
    ${CMAKE_SOURCE_DIR}/SexyAppFramework/fmod.dll
)

foreach(DLL_FILE ${DLL_FILES})
    if(EXISTS ${DLL_FILE})
        add_custom_command(TARGET PlantsVsZombies POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${DLL_FILE}"
            "$<TARGET_FILE_DIR:PlantsVsZombies>"
            COMMENT "Copying ${DLL_FILE}"
        )
    endif()
endforeach()

# =============================================================================
# Additional Build Options
# =============================================================================

# 32-bit architecture and output directories
set_target_properties(PlantsVsZombies PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

# MSVC specific settings
if(MSVC)
    set_target_properties(PlantsVsZombies PROPERTIES
        LINK_FLAGS "/MACHINE:X86"
    )
endif()

# Clang specific settings
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set_target_properties(PlantsVsZombies PROPERTIES
            LINK_FLAGS "-m32"
        )
    endif()
endif()

# =============================================================================
# Subsystem Configuration
# =============================================================================
if(MSVC)
    set_target_properties(PlantsVsZombies PROPERTIES
        LINK_FLAGS_DEBUG "/SUBSYSTEM:WINDOWS /DEBUG"
        LINK_FLAGS_RELEASE "/SUBSYSTEM:WINDOWS /OPT:REF /OPT:ICF"
    )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set_target_properties(PlantsVsZombies PROPERTIES
        LINK_FLAGS "-Wl,/subsystem:windows"
    )
endif()

# =============================================================================
# Print Configuration Summary
# =============================================================================
message(STATUS "")
message(STATUS "===== vividPvZ CMake Configuration Summary =====")
message(STATUS "  CMake Version:    ${CMAKE_VERSION}")
message(STATUS "  Generator:        ${CMAKE_GENERATOR}")
message(STATUS "  Compiler:         ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "  Build Type:       ${CMAKE_BUILD_TYPE}")
message(STATUS "  C++ Standard:     ${CMAKE_CXX_STANDARD}")
message(STATUS "  DirectX 8 SDK:    ${DX8SDK_DIR}")
message(STATUS "  Output Dir:       ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
message(STATUS "  Source Files:     ${CMAKE_CURRENT_SOURCE_DIR}")
message(STATUS "===============================================")
message(STATUS "")

# =============================================================================
# Install Rules (Optional)
# =============================================================================
install(TARGETS PlantsVsZombies
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

# Install DLLs
foreach(DLL_FILE ${DLL_FILES})
    if(EXISTS ${DLL_FILE})
        install(FILES ${DLL_FILE} DESTINATION bin)
    endif()
endforeach()

# =============================================================================
# CPack Configuration (Optional)
# =============================================================================
set(CPACK_PACKAGE_NAME "vividPvZ")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Plants vs. Zombies Decompilation")
set(CPACK_GENERATOR "ZIP")
include(CPack)
