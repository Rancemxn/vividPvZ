# vividPvZ Build Guide - CMake + LLVM

本文档说明如何使用 CMake 和 LLVM/Clang 编译 vividPvZ 项目。

## 前提条件

### 1. 安装 LLVM/Clang

从 [LLVM 官网](https://releases.llvm.org/download.html) 下载并安装 LLVM:
- 推荐版本: LLVM 17.x 或更高
- 安装时选择 "Add LLVM to the system PATH"

### 2. 安装 Visual Studio Build Tools

需要 MSVC 的标准库和 Windows SDK:
- 安装 Visual Studio Build Tools 或 Visual Studio
- 选择 "C++ 桌面开发" 工作负载
- 确保安装了 Windows 10/11 SDK

### 3. 安装 CMake

从 [CMake 官网](https://cmake.org/download/) 下载安装 CMake 3.20+

### 4. 安装 Ninja (推荐)

```powershell
winget install Ninja-build.Ninja
# 或使用 chocolatey
choco install ninja
```

## 编译步骤

### 方式一: 使用 clang-cl (推荐)

clang-cl 是 Clang 的 MSVC 兼容驱动程序，最接近原始 MSVC 编译行为。

```powershell
# 进入项目目录
cd vividPvZ

# 创建构建目录
mkdir build
cd build

# 配置项目
cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE=../cmake/clang-cl-toolchain.cmake -DCMAKE_BUILD_TYPE=Release ..

# 编译
cmake --build . --config Release
```

### 方式二: 使用 clang + lld

使用纯 LLVM 工具链:

```powershell
# 创建构建目录
mkdir build
cd build

# 配置项目
cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE=../cmake/llvm-mingw-toolchain.cmake -DCMAKE_BUILD_TYPE=Release ..

# 编译
cmake --build . --config Release
```

### 方式三: 使用 MSVC (备选)

如果 Clang 编译有问题，可以使用 MSVC:

```powershell
# 打开 Visual Studio Developer Command Prompt
# 或者在 PowerShell 中运行:
& "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"

# 创建构建目录
mkdir build
cd build

# 配置项目
cmake -G "Visual Studio 17 2022" -A Win32 ..

# 编译
cmake --build . --config Release
```

## 构建类型

- `Debug`: 调试版本，包含调试符号
- `Release`: 发布版本，优化性能
- `RelWithDebInfo`: 带调试信息的发布版本

```powershell
# Debug 构建
cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE=../cmake/clang-cl-toolchain.cmake -DCMAKE_BUILD_TYPE=Debug ..
cmake --build . --config Debug

# Release 构建
cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE=../cmake/clang-cl-toolchain.cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release
```

## 运行游戏

编译完成后，可执行文件位于:
```
build/bin/PlantsVsZombies.exe
```

需要将资源文件复制到可执行文件目录:
```powershell
# 解压 Resource.zip 到 build/bin/ 目录
Expand-Archive -Path Resource.zip -DestinationPath build/bin/ -Force
```

## 常见问题

### Q: 编译时找不到 Windows.h

确保已安装 Windows SDK。在 Visual Studio Installer 中勾选:
- Windows 10 SDK
- Windows 11 SDK

### Q: 链接错误

确保 DirectX 8 SDK 位于项目的 `dx8sdk` 目录下:
```
vividPvZ/
├── dx8sdk/
│   ├── include/
│   └── lib/
```

### Q: 编码问题

使用 `-D_CRT_SECURE_NO_WARNINGS` 宏禁用安全警告。
确保源文件使用 UTF-8 编码。

### Q: 32位编译问题

本项目必须编译为 32 位程序。确保:
- 使用 Win32 平台而非 x64
- 链接 32 位版本的库

## 目录结构

```
vividPvZ/
├── CMakeLists.txt          # 主 CMake 配置
├── cmake/                  # CMake 工具链文件
│   ├── clang-cl-toolchain.cmake
│   └── llvm-mingw-toolchain.cmake
├── build/                  # 构建目录 (生成)
│   ├── bin/               # 可执行文件输出
│   └── lib/               # 库文件输出
├── Lawn/                   # 游戏核心代码
├── SexyAppFramework/       # 游戏框架
├── Sexy.TodLib/           # Tod 工具库
├── ImageLib/              # 图像处理库
├── PakLib/                # 资源打包库
├── dx8sdk/                # DirectX 8 SDK
└── bass.dll               # BASS 音频库
```

## 参考链接

- [LLVM/Clang 文档](https://llvm.org/docs/)
- [CMake 文档](https://cmake.org/documentation/)
- [clang-cl 使用指南](https://clang.llvm.org/docs/MSVCCompatibility.html)
