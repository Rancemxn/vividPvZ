# Plants vs. Zombies Decompilation
The original version of the decompilation for Plants vs. Zombies v0.9.9.1029.

# Building
**IMPORTANT:** Make sure to use the Debug folder along with the executables, as these binaries won't work with the original game assets.
#### Visual Studio
Open the solution file "PlantsVsZombies.sln" with Visual Studio and compile from there.

#### Build Tools for Visual Studio (MSBuild)
Go to the root directory of this project and run ``` msbuild PlantsVsZombies.sln /p:Configuration=Debug /p:Platform=x86 ```.