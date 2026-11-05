# FFmpeg source distribution for ToolKnit

[中文说明](#中文说明)

This repository supplies matching sources, build scripts and notices for
ToolKnit's optional **FFmpeg 6.1.6-toolknit-r3 Windows x86-64 runtime**.
FFmpeg and its components are written by their upstream developers.
ToolKnit builds this profile from the sources preserved here.

## Download and verify

| Item | Identity |
| --- | --- |
| Runtime | 6.1.6-toolknit-r3, Windows x86-64 |
| Combined build license | GNU GPL version 3 or later |
| FFmpeg upstream | [n6.1.6, commit f1e3a2bf7a2f2cde936d1ed97f09a26853d20125](https://github.com/FFmpeg/FFmpeg/commit/f1e3a2bf7a2f2cde936d1ed97f09a26853d20125) |
| Runtime download | [7Caiyun gzip](https://toolknit-downloads-u1ll6equ.cdn.7caiyun.com/runtime/ffmpeg/ffmpeg-6.1.6-toolknit-r3-win32-x64.gz) |
| Gzip bytes / SHA-256 | 14642939 / c4f982b2f82dda95e079bd26129435640bc31d36d05308fada77cebc47a61fe3 |
| EXE bytes / SHA-256 | 37815808 / a2ce68645f7c9d95dfc2bda6814aa432195a83b393ec4c2d58ad1ccc9ae8245a |
| Fixed source snapshot | [ffmpeg-6.1.6-toolknit-3](https://github.com/ZihangDong/toolknit-ffmpeg-sources/tree/ffmpeg-6.1.6-toolknit-3) |

**[Download the complete source package and notices](https://github.com/ZihangDong/toolknit-ffmpeg-sources/releases/download/ffmpeg-6.1.6-toolknit-3/toolknit-ffmpeg-6.1.6-r3-sources.tar.gz)**
— no payment or account required. Its SHA-256 accompanies the
[source release](https://github.com/ZihangDong/toolknit-ffmpeg-sources/releases/tag/ffmpeg-6.1.6-toolknit-3).

## Contents and build

- [source/ffmpeg-6.1.6/](source/ffmpeg-6.1.6/): unchanged upstream main source.
- [third-party/](third-party/): exact source archives for x264, x265, LAME,
  Ogg, Vorbis, Opus, libvpx, WebP, zlib, dav1d and NVIDIA codec headers.
- [metadata/build-sources.json](metadata/build-sources.json): upstream revisions,
  archive sizes, SHA-256 hashes and license identifiers.
- [build/](build/README.md): tested Ubuntu 24.04 cross-build recipe, verification,
  packaging and notice-generation scripts. Project sources are read locally;
  they are not downloaded again during compilation.
- [upstream-build/toolknit-r3/](upstream-build/toolknit-r3/): configuration,
  compiler/package inventory, original toolchain notices, PE imports, and output
  captured from the actual executable.
- [validation/windows-runtime.json](validation/windows-runtime.json): Windows
  compatibility matrix using synthetic files and ToolKnit's CLI runtime.
- [metadata/runtime.json](metadata/runtime.json): exact runtime identity,
  successful build commit/run and source availability status.

Extract the source package, or clone this repository, then run
**node scripts/verify-source.mjs**. It checks all dependency archives,
main-source hashes and executable identity evidence, plus the Git tree in a
checkout. **python3 build/verify-archives.py** checks source hashes alone.
See [build instructions](build/README.md) for the general-purpose tools required.

The [successful build](https://github.com/ZihangDong/toolknit-ffmpeg-sources/actions/runs/42072553824)
and Windows conversion tests establish that these sources and scripts build a
working runtime. A second byte-for-byte reproducible build has not been verified.
NVIDIA hardware operation requires a supported device and user-installed driver;
the matrix validates software workflows, not every GPU.

## Licenses and legacy materials

The combined executable reports GPL-3.0-or-later. See [GPL text](LICENSES/GPL-3.0.txt),
[FFmpeg licensing](source/ffmpeg-6.1.6/LICENSE.md),
[component notices](LICENSES/Third-Party.txt) and
[toolchain/runtime notices](LICENSES/Toolchain-Runtime.txt).
Each source archive retains its original licenses and copyright notices.
Our maintenance scripts and documentation are [MIT licensed](LICENSES/MIT-maintenance.txt).
ToolKnit's application and PDF-to-document engine restrictions do not apply here.
This repository contains no ToolKnit application code, user files or executable binaries.

The earlier Gyan 6.1.1 snapshot remains in [ffmpeg/](ffmpeg/) and tag
[ffmpeg-6.1.1-toolknit-1](https://github.com/ZihangDong/toolknit-ffmpeg-sources/tree/ffmpeg-6.1.1-toolknit-1).
Its unresolved dependency/build-material gaps are documented in the
[legacy status](LEGACY-GYAN-SOURCE-STATUS.md). They were not filled by substituting
this new build's sources. See [current source status](BUILD-SOURCE-STATUS.md).

Source inquiries: [Issues](https://github.com/ZihangDong/toolknit-ffmpeg-sources/issues)
or **info@toolknit.com**.

## 中文说明

这里提供 ToolKnit 自行编译的 FFmpeg 6.1.6-toolknit-r3 对应源码：包含主源码、
11 份准确的依赖源归档、构建脚本、配置、原始许可和实际构建证据。
上方提供固定版本的完整源码包及校验值，下载不需要付费或登录。
运行包通过七彩云提供；源码包在 GitHub 独立托管。

这份源码已成功构建，Windows 音视频转换、编辑和转写预处理测试已通过。
未承诺不同工具链下生成字节完全相同的 EXE，也没有把编码器列表当成全部显卡实测。
旧 Gyan 构建及其材料缺口单独保留，不与新构建混淆。

FFmpeg 和第三方组件的权利归原作者。合并程序适用 GPL v3 或更新版本；
ToolKnit 主程序与 PDF 引擎的独立条款不适用于本仓库的 FFmpeg 源码。
