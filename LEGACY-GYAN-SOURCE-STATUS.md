# Build and source status

Last checked: **2026-11-05**. Applies only to the runtime identified in
[`metadata/legacy-gyan-6.1.1.json`](metadata/legacy-gyan-6.1.1.json).

## Preserved and verified

- The FFmpeg main source at `e38092ef9395d7049f871ef4d5411eb410e283e0`.
  Its Git tree must match `dc2cc148dbd7406686d6052c6d414594ad9c5c20`.
- The original Gyan build README and GPL v3 text.
- The exact executable's `-version` and `-buildconf` output, including its GCC
  12.2.0 (Rev10, MSYS2) identification and configure flags.
- SHA-256 and byte sizes for both the compressed download and unpacked EXE.

The source snapshot is from the upstream commit identified in the build provider's
[6.1.1 release](https://github.com/GyanD/codexffmpeg/releases/tag/6.1.1).
It is not a separately supplied, complete build-provider source bundle.
No assertion is made that Gyan applied no other patches.

## Materials still missing

The original README provides version strings (often including abbreviated Git
commits) for 33 dependencies. They are also preserved in
[`metadata/third-party-versions.json`](metadata/third-party-versions.json).
This is useful identification evidence, but the corresponding source trees,
patch sets and build/install control scripts have not been obtained for the
complete static dependency set. Some transitive dependencies are not versioned
in that list. The original README lists these enabled libraries:

```text
avisynth, bzlib, gmp, gnutls, iconv, libaom, libass, libfontconfig,
libfreetype, libfribidi, libgme, libgsm, libharfbuzz, libmp3lame,
libopencore_amrnb, libopencore_amrwb, libopenjpeg, libopenmpt,
libopus, librubberband, libspeex, libsrt, libssh, libtheora,
libvidstab, libvmaf, libvo_amrwbenc, libvorbis, libvpx, libwebp,
libx264, libx265, libxml2, libxvid, libzimg, libzmq, lzma,
mediafoundation, sdl2, zlib
```

The README also lists acceleration interfaces (`amf`, `d3d11va`, `cuda`,
`cuda_llvm`, `cuvid`, `dxva2`, `ffnvcodec`, `libmfx`, `libvpl`, `nvdec`,
`nvenc`). Their role and applicable source/notice requirements must be checked
against the actual build. An interface name alone does not mean a driver is
embedded or that the driver source is required.

Version strings and configuration output alone do not provide the underlying
source trees or prove which patches were used. Unrelated current upstream
versions must not be labelled as this binary's
Corresponding Source. We have not attempted a reproducible rebuild.

## Next maintenance action

Obtain the exact dependency sources, relevant patches and build scripts from the
build provider, or move to a tested runtime with an available matching source
bundle. Preserve each dependency's applicable license and notices. Publish the
resulting materials alongside the FFmpeg snapshot, with updated integrity data.
Until then, this repository makes the main source and the outstanding gaps
available; it does not certify full distribution compliance.

FFmpeg's own licensing explanation is at <https://ffmpeg.org/legal.html>.
The static build's GPL v3 identification must not be confused with FFmpeg's
default LGPL configuration.

## 中文说明

已取得并核对：FFmpeg 对应提交的主源码、原始说明、GPL 正文、实际程序
配置和两个文件的校验值。尚缺：全部静态依赖的准确源码版本、相关补丁
及构建安装脚本。这里没有用其他版本的源码冒充，也没有承诺能复现原 EXE。

后续应补齐上游构建材料，或换成已取得完整对应材料且经过兼容测试的构建。
这些缺口与 ToolKnit 整个项目的源码授权范围是两回事。
