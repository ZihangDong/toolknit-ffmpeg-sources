# Verified build: toolknit-win64-6.1.6-r3

This recipe built the selected runtime successfully in Ubuntu 24.04, workflow run 42072553824.
The executable passed the Windows compatibility matrix. Runtime identity and
evidence are in metadata/runtime.json and upstream-build/toolknit-r3/.
This recipe does not describe how Gyan's old executable was built.

The candidate builds the preserved FFmpeg 6.1.6 tree in `source/ffmpeg-6.1.6/` and the eleven exact source
archives in `metadata/build-sources.json`. Every dependency archive is stored in
`third-party/` and checked by SHA-256 before compilation. No source is fetched at
build time. Configure-generated changes are made only in `.build/src`; all build
commands are recorded in `build-win64.sh`. No separate dependency patches apply.

On Ubuntu 24.04 install the general-purpose cross compiler and build tools listed
in `.github/workflows/build-runtime.yml`, then run:

```sh
bash build/build-win64.sh
```

The script also contains an experimental MSYS2 UCRT64 fallback on Windows
with GCC, CMake, Meson, Ninja, pkgconf, NASM/Yasm, Autoconf, Automake, Libtool,
GNU Make, diffutils, tar and Python installed. Start it with `/ucrt64/bin` before
`/usr/bin` in PATH. Package inventory and toolchain notices are captured for the
platform actually used. It does not change the system's default compiler or
install any runtime into ToolKnit's managed directory. Release validation uses
the Ubuntu cross-build; the native MSYS2 route is not yet release-validated.

The output is a single statically linked Windows x86-64 FFmpeg executable plus
FFprobe for validation, a deterministic gzip container, hashes, PE imports and
configuration logs. Installed compiler package versions are recorded with each
build. Exact byte-for-byte reproducibility across toolchain versions is not
claimed. The build uses MinGW-w64's general-purpose compiler/runtime; their
applicable license notices must accompany distributed artifacts.

The profile retains ToolKnit's audio/video outputs (H.264/AAC, VP9/Opus, MP3,
Vorbis, FLAC, ALAC, WAV, MPEG-4/MP3 and WMV/WMA), image/GIF filters and local
decoding. It additionally enables x265, WebP, AV1 decoding via dav1d, and NVIDIA
codec headers for supported hardware paths. Hardware operation still requires
a compatible user-installed GPU driver. It is not advertised as all of Gyan's
unused external libraries. Windows software conversion/editing/transcription preprocessing tests are
recorded in validation/windows-runtime.json; physical GPU operation is not
claimed by those tests.

Licenses and copyrights remain in each archived source tree. The build and
maintenance scripts are MIT licensed, and the resulting combined FFmpeg build
is GPL v3 or later under `--enable-gpl --enable-version3`. The main application's license
does not apply to these sources.
