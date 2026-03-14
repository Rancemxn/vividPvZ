# Plants vs. Zombies Decompilation
The original version of the decompilation for Plants vs. Zombies v0.9.9.1029.

## ⚠️ Important Note
Make sure to use the Debug folder along with the executables, as these binaries won't work with the original game assets.

---

## Building

### Method 1: CMake + LLVM/Clang (Recommended)

#### Prerequisites
1. **LLVM/Clang** - Download from [LLVM releases](https://releases.llvm.org/download.html)
2. **Visual Studio Build Tools** - For MSVC standard library and Windows SDK
3. **CMake 3.20+** - Download from [cmake.org](https://cmake.org/download/)
4. **Ninja** (optional but recommended) - `winget install Ninja-build.Ninja`

#### Build Steps

```powershell
# Create build directory
mkdir build
cd build

# Configure with clang-cl (recommended for Windows)
cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE=../cmake/clang-cl-toolchain.cmake -DCMAKE_BUILD_TYPE=Release ..

# Or use Visual Studio generator with Clang
cmake -G "Visual Studio 17 2022" -A Win32 -T ClangCL ..

# Build
cmake --build . --config Release
```

#### Debug Build
```powershell
cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE=../cmake/clang-cl-toolchain.cmake -DCMAKE_BUILD_TYPE=Debug ..
cmake --build . --config Debug
```

For detailed CMake build instructions, see [CMAKE_BUILD.md](CMAKE_BUILD.md).

---

### Method 2: Visual Studio (Legacy)

#### Visual Studio IDE
Open the solution file `PlantsVsZombies.sln` with Visual Studio and compile from there.

#### Build Tools for Visual Studio (MSBuild)
```powershell
msbuild PlantsVsZombies.sln /p:Configuration=Debug /p:Platform=x86
```

---

## Project Structure

```
vividPvZ/
├── CMakeLists.txt              # Main CMake configuration
├── cmake/                      # CMake toolchain files
│   ├── clang-cl-toolchain.cmake
│   └── llvm-mingw-toolchain.cmake
├── Lawn/                       # Game core logic
│   ├── System/                 # System utilities
│   └── Widget/                 # UI widgets
├── SexyAppFramework/           # PopCap game framework
├── Sexy.TodLib/               # Animation and effects library
├── ImageLib/                  # Image processing library
├── PakLib/                    # Resource packing library
├── dx8sdk/                    # DirectX 8 SDK
├── main.cpp                   # Entry point
└── LawnApp.cpp                # Application implementation
```

---

## Supported Compilers

| Compiler | Status | Notes |
|----------|--------|-------|
| **LLVM/Clang** | ✅ Recommended | Best MSVC compatibility |
| **clang-cl** | ✅ Recommended | Drop-in MSVC replacement |
| **MSVC (VS2022)** | ✅ Supported | Original build system |
| **MinGW** | ⚠️ Experimental | May require modifications |

---

## Requirements

- Windows 10/11 (32-bit or 64-bit OS running 32-bit build)
- DirectX 8.1 or later
- [Resource.zip](https://github.com/Rancemxn/vividPvZ/releases/download/ORIGINAL/Resource.zip) extracted to the executable directory

---

## License

This project is for educational and research purposes only. Plants vs. Zombies is a trademark of PopCap Games/EA.
