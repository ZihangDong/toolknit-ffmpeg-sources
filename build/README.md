# Candidate build: toolknit-win64-6.1.1-r2

This recipe is being validated. It does **not** describe how Gyan's old executable
was built. The old runtime identity remains in `metadata/runtime.json` until a
new binary has passed Windows compatibility checks and been published.

The candidate builds the preserved FFmpeg 6.1.1 tree and the eleven exact source
archives in `metadata/build-sources.json`. Every dependency archive is stored in
`third-party/` and checked by SHA-256 before compilation. No source is fetched at
build time. Configure-generated changes are made only in `.build/src`; all build
commands are recorded in `build-win64.sh`. No separate dependency patches apply.

On Ubuntu 24.04 install the general-purpose cross compiler and build tools listed
in `.github/workflows/build-runtime.yml`, then run:

```sh
bash build/build-win64.sh
```

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
unused external libraries. Windows tests must confirm the product's complete
conversion/editing/transcription workflows before any runtime switch.

Licenses and copyrights remain in each archived source tree. The build and
maintenance scripts are MIT licensed, and the resulting combined FFmpeg build
is GPL v3 under `--enable-gpl --enable-version3`. The main application's license
does not apply to these sources.
