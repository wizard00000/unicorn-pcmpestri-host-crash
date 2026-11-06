# unicorn-pcmpestri-repro

Reproduces a Unicorn crash with `PCMPESTRI` and `EAX = EDX = 0x80000000`. The same instruction runs normally on regular hardware.

## Requirements

- Windows x64
- Visual Studio 2022 or 2026 (or Build Tools) with C++ x64 tools and a Windows SDK
- Git and CMake

## Build and run

```bat
git submodule update --init --recursive
build.bat
main.exe
```

On the pinned build (`938efd13`), `uc_emu_start` crashes with `0xC0000005`.
