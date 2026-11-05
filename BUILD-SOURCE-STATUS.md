# Build and source status

Checked **2026-11-06** for 6.1.6-toolknit-r3, identified in
[metadata/runtime.json](metadata/runtime.json).

## Preserved materials

- Unmodified FFmpeg n6.1.6 at f1e3a2bf7a2f2cde936d1ed97f09a26853d20125.
  Git tree: 9aaca04fcc4bb2a56d3a06bab6d262d587956dc2. All 8195 files have
  independent hashes for verification outside Git.
- Eleven exact project dependency archives, upstream revisions, licenses,
  sizes and hashes in metadata/build-sources.json. These are the inputs
  actually consumed by build/build-win64.sh.
- Build/install control scripts, generated configuration evidence and original
  component notices. No separate source patches apply. Autoconf-generated files
  and build outputs are created in .build/, outside the archived source trees.
- General-purpose Ubuntu/MinGW compiler package versions, compiler identity,
  original package copyrights and combined runtime notices. Standard OS libraries
  and general-purpose compilation tools are identified separately from project
  dependency sources. PE imports contain only Windows system DLLs; no separate
  compiler DLL is needed by this EXE.
- Actual executable version, configuration, license output, gzip/EXE sizes and
  hashes, plus the Windows runtime acceptance report.

Text evidence uses LF with trailing blanks removed; notice indentation is
normalized for readability. Copyright/license wording and the exact archived
project sources are retained.

The package includes the corresponding project sources and control materials
for this selected profile. This is based on our own controlled build, rather
than an inference from another provider's version string.

## Build evidence and limits

The binary was built from source-repository commit
95439c04417eef49b4a5dcbac484ce921f50d0ab in
[workflow run 42072553824](https://github.com/ZihangDong/toolknit-ffmpeg-sources/actions/runs/42072553824).
Source hashes were verified before compilation. The release snapshot adds
evidence and notices; it does not change the source/build inputs used by that run.

Windows tests cover six audio and eight video outputs, extraction, clipping,
image/GIF filters, HEVC, WebP, independent AV1 decoding, Whisper preprocessing,
cancellation and source/existing-file preservation. See validation/windows-runtime.json.
A minimal Windows PATH run succeeds. Hardware encoders are compiled in;
physical GPU/driver combinations have not all been tested. Native MSYS2 remains
experimental; Ubuntu cross-compilation is the validated recipe.

The gzip container is deterministic, but a second complete byte-for-byte
reproducible build has **not** been verified. Buildability and binary
reproducibility are different claims.

## Version maintenance

Keep the fixed tag/source package available while distributing its binary.
Updates need a separate snapshot, exact inputs, build evidence, notices and
compatibility checks. Never overwrite a versioned runtime with different bytes.

The old Gyan 6.1.1 materials remain a separate historical snapshot. Its status
and unresolved materials are in [LEGACY-GYAN-SOURCE-STATUS.md](LEGACY-GYAN-SOURCE-STATUS.md)
and metadata/legacy-gyan-6.1.1.json. This bundle is not claimed to rebuild Gyan's
executable or fill its missing materials.

## 中文说明

当前维护构建的主源码、11 份项目依赖源码、构建控制脚本和原始许可均已归档，
并使用这些输入成功编译和完成 Windows 功能测试。一般工具链、系统库的边界及
实际包版本单独记录。没有额外源补丁，构建生成文件留在独立工作目录。
没有承诺第二次构建字节完全一致；旧 Gyan 构建缺口保留在历史说明中。
