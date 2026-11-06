@echo off
cd /d "%~dp0"
call "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" || exit /b 1
if not exist "unicorn\build\Release\unicorn-import.lib" (
    cmake -S unicorn -B unicorn\build -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release -DUNICORN_ARCH=x86 -DUNICORN_BUILD_TESTS=OFF || exit /b 1
    cmake --build unicorn\build --config Release || exit /b 1
)
cl /nologo main.c /I unicorn\include /link unicorn\build\Release\unicorn-import.lib /OUT:main.exe || exit /b 1
copy /y unicorn\build\Release\unicorn.dll . >nul
