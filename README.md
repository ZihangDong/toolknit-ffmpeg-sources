# FFmpeg sources and notices for ToolKnit

[中文说明](#中文说明)

This repository preserves the **FFmpeg 6.1.1 main source** and available
build information for the optional Windows runtime distributed by
[ToolKnit Desktop](https://github.com/ZihangDong/toolknit-desktop).
FFmpeg is developed by the FFmpeg project. The Windows executable was built
by Gyan Doshi; ToolKnit does not claim authorship of either.

**Source availability:** the matching FFmpeg main source is included.
Exact sources, patches and build scripts for all statically linked third-party
libraries have **not yet been obtained**. This is not a claim that complete
Corresponding Source for the whole executable has been assembled.
See [build and source status](BUILD-SOURCE-STATUS.md).

## Matching download and source

| Item | Identity |
| --- | --- |
| Runtime | `6.1.1-essentials_build-www.gyan.dev`, Windows x86-64, static |
| Build provider | [Gyan Doshi, release 6.1.1](https://github.com/GyanD/codexffmpeg/releases/tag/6.1.1) |
| Reported build license | GNU GPL v3 (`--enable-gpl --enable-version3`) |
| FFmpeg revision | [`e38092ef9395d7049f871ef4d5411eb410e283e0`](https://github.com/FFmpeg/FFmpeg/commit/e38092ef9395d7049f871ef4d5411eb410e283e0), tag `n6.1.1` |
| Download | [7Caiyun runtime](https://toolknit-downloads-u1ll6equ.cdn.7caiyun.com/runtime/ffmpeg/ffmpeg-win32-x64.gz) |
| Compressed bytes | `29,581,307` |
| Compressed SHA-256 | `8883a3dffbd0a16cf4ef95206ea05283f78908dbfb118f73c83f4951dcc06d77` |
| Decompressed EXE bytes | `82,797,568` |
| EXE SHA-256 | `04e1307997530f9cf2fe35cba2ca7e8875ca91da02f89d6c7243df819c94ad00` |

[Download the preserved source and notices as a ZIP](https://github.com/ZihangDong/toolknit-ffmpeg-sources/archive/refs/tags/ffmpeg-6.1.1-toolknit-1.zip).
The archive contains the materials described here; the limitations above also
apply to the ZIP. No fee or account is required to download it.

## Contents

- [`ffmpeg/`](ffmpeg/): the upstream source tree, without ToolKnit changes.
  Its Git tree is checked against the exact upstream revision.
- [`upstream-build/README.gyan.txt`](upstream-build/README.gyan.txt): original
  build notice, component list and enabled features.
- [`upstream-build/ffmpeg-version.txt`](upstream-build/ffmpeg-version.txt) and
  [`ffmpeg-buildconf.txt`](upstream-build/ffmpeg-buildconf.txt): output captured
  from the actual distributed executable on 2026-11-05.
- [`metadata/runtime.json`](metadata/runtime.json): machine-readable identity,
  hashes, provenance and source status.
- [`metadata/third-party-versions.json`](metadata/third-party-versions.json):
  dependency versions reported by the original build notice.
- [`LICENSES/GPL-3.0.txt`](LICENSES/GPL-3.0.txt): the GPL text supplied with the build.
  The upstream tree retains its original `COPYING.*`, `LICENSE.md` and per-file notices.

For an independent integrity check, install Node.js and Git, clone this repository,
then run `node scripts/verify-source.mjs`. This checks the preserved source tree;
it does not establish completeness of the missing third-party build materials.
Do not treat configuration output as a tested recipe for reproducing the binary.

## Licensing and maintenance

The distributed static executable is identified by its provider as GPL v3.
Upstream source files retain their own applicable licenses and copyright notices;
see [`ffmpeg/LICENSE.md`](ffmpeg/LICENSE.md). ToolKnit's application license and
PDF-to-document engine terms **do not apply to this FFmpeg source mirror**.
Repository maintenance documents and verification scripts are MIT licensed;
see [the maintenance license](LICENSES/MIT-maintenance.txt).

This repository contains no ToolKnit application code, user files or executable
binaries. It is a source/notice archive, not an official FFmpeg development fork.
The `ffmpeg-6.1.1-toolknit-1` tag preserves this snapshot; future runtime versions
must receive separate identity records and source snapshots. Keep old snapshots
available while distributing the matching binary. Report missing source material
through [Issues](https://github.com/ZihangDong/toolknit-ffmpeg-sources/issues)
or contact **info@toolknit.com**.

## 中文说明

本仓库单独保存 ToolKnit 按需分发的 FFmpeg 6.1.1 主源码、原始构建说明、
GPL 许可和实际程序的版本/配置输出。FFmpeg 的版权归原作者，Windows
构建由 Gyan Doshi 提供。ToolKnit 不冒充 FFmpeg 的作者。

`ffmpeg/` 对应上表中的准确提交，未加入 ToolKnit 改动。
可点击上方 ZIP 链接下载，或克隆后运行校验脚本。
当前静态构建还包含 x264、x265 等第三方组件；其完整精确源码、补丁和
构建控制材料尚未全部取得，具体见 [材料状态](BUILD-SOURCE-STATUS.md)。
不能仅凭本仓库已有 FFmpeg 主源码，就认定整个 EXE 的对应源码已经齐全。

ToolKnit 主程序及 PDF 转文档引擎的独立条款不适用于这里的 FFmpeg 源码。
本仓库不包含 ToolKnit 主程序源码、私密资料或二进制程序。
源码补充或其他问题可提交 Issue，或联系 **info@toolknit.com**。
