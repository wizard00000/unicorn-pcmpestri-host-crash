@echo off
setlocal DisableDelayedExpansion
cd /d "%~dp0" || exit /b 1

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
set "VSINSTALL="
for /f "usebackq delims=" %%i in (`call "%VSWHERE%" -latest -products * -version "[17.0,19.0)" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSINSTALL=%%i"
if not defined VSINSTALL (
    echo Install VS 2022 or 2026 with the C++ x64 tools and a Windows SDK.
    exit /b 1
)
call "%VSINSTALL%\VC\Auxiliary\Build\vcvars64.bat" || exit /b 1
set "BUILD_DIR=unicorn\build\repro-%VCToolsVersion%"
cmake -S unicorn -B "%BUILD_DIR%" -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DUNICORN_ARCH=x86 -DUNICORN_BUILD_TESTS=OFF || exit /b 1
cmake --build "%BUILD_DIR%" || exit /b 1
cl /nologo main.c /I unicorn\include /link "%BUILD_DIR%\unicorn-import.lib" /OUT:main.exe || exit /b 1
copy /y "%BUILD_DIR%\unicorn.dll" . >nul || exit /b 1
