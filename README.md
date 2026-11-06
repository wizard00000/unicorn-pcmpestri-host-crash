# unicorn-pcmpestri-repro

This shows how a single PCMPESTRI instruction terminates the host process in unicorn. On real hardware it just runs normally.

## Setup

- MSVC 2022 x64
- cmake

## Build and run

```
build.bat
main.exe
```

The process exits with 0xC0000005 on the `emu_start` call, which is the bug being reported.

## Notes

- `unicorn/` is a submodule pinned to `unicorn-engine/unicorn` dev @ `938efd13` (the vulnerable commit).
- `build.bat` builds the submodule once into `unicorn/build`, then builds `main.exe`.
