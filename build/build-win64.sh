#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Zihang Dong
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="${TOOLKNIT_BUILD_ROOT:-$ROOT/.build}"
PREFIX="$WORK/prefix"
JOBS="${TOOLKNIT_BUILD_JOBS:-2}"
TRIPLE=x86_64-w64-mingw32
NATIVE_MSYS=false
case "$(uname -s)" in MSYS*|MINGW*|UCRT*) NATIVE_MSYS=true ;; esac
mkdir -p "$PREFIX" "$WORK/src" "$WORK/output"
python3 "$ROOT/build/verify-archives.py"
export CC="$TRIPLE-gcc-posix" CXX="$TRIPLE-g++-posix"
export AR="$TRIPLE-ar" RANLIB="$TRIPLE-ranlib" STRIP="$TRIPLE-strip"
CROSS="$TRIPLE-"
PREFIX_NATIVE="$PREFIX"
if $NATIVE_MSYS; then
  export CC=gcc CXX=g++ AR=ar RANLIB=ranlib STRIP=strip
  CROSS=''
  PREFIX_NATIVE="$(cygpath -m "$PREFIX")"
fi
export PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_LIBDIR"
export CFLAGS="-O2 -std=gnu11 -I$PREFIX/include -D_WIN32_WINNT=0x0601"
export CXXFLAGS="-O2 -I$PREFIX/include -D_WIN32_WINNT=0x0601"
export LDFLAGS="-L$PREFIX/lib -static-libgcc -static-libstdc++ -static"
export SOURCE_DATE_EPOCH=1704016800
export GIT_CEILING_DIRECTORIES="$WORK/src"
if $NATIVE_MSYS; then
  pacman -Q > "$WORK/output/toolchain-packages.txt"
else
  dpkg-query -W -f='${Package}\t${Version}\n' > "$WORK/output/toolchain-packages.txt"
fi
"$CC" --version > "$WORK/output/compiler.txt"
mkdir -p "$WORK/output/toolchain-notices"
for package in mingw-w64-common mingw-w64-x86-64-dev gcc-mingw-w64-base gcc-mingw-w64-x86-64-posix g++-mingw-w64-x86-64-posix; do
  if [[ -f "/usr/share/doc/$package/copyright" ]]; then
    cp "/usr/share/doc/$package/copyright" "$WORK/output/toolchain-notices/$package.txt"
  fi
done
if $NATIVE_MSYS; then
  for package in mingw-w64 crt headers winpthreads gcc-libs gcc; do
    if [[ -d "/ucrt64/share/licenses/$package" ]]; then
      cp -r "/ucrt64/share/licenses/$package" "$WORK/output/toolchain-notices/$package"
    fi
  done
fi
cat > "$WORK/toolchain.cmake" <<EOF
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR AMD64)
set(CMAKE_C_COMPILER $CC)
set(CMAKE_CXX_COMPILER $CXX)
set(CMAKE_RC_COMPILER ${CROSS}windres)
set(CMAKE_FIND_ROOT_PATH $PREFIX_NATIVE)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOF
src() {
  printf '\n=== Build %s ===\n' "$1"
  cd "$WORK/src"
  mkdir -p "$1"
  tar xzf "$ROOT/third-party/$1.tar.gz" --strip-components=1 -C "$1"
  cd "$1"
}
auto() {
  autoreconf -fiv
  ./configure --host="$TRIPLE" --prefix="$PREFIX" --disable-shared --enable-static "$@"
  make -j"$JOBS"
  make install
}
src zlib
cmake -G Ninja -S . -B obj -DCMAKE_TOOLCHAIN_FILE="$WORK/toolchain.cmake" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build obj -j"$JOBS"
cmake --install obj
# zlib installs both variants; never let FFmpeg select the import library.
rm -f "$PREFIX/lib/libz.dll.a" "$PREFIX/lib/libzlib.dll.a"
if [[ -f "$PREFIX/lib/libzlibstatic.a" ]]; then cp "$PREFIX/lib/libzlibstatic.a" "$PREFIX/lib/libz.a"; fi
src ogg
auto --disable-docs
src vorbis
auto --disable-docs --disable-examples
src opus
auto --disable-doc --disable-extra-programs
src lame
auto --disable-frontend --disable-decoder
src x264
./configure --host="$TRIPLE" --cross-prefix="$CROSS" --prefix="$PREFIX" --enable-static --disable-cli --disable-opencl --extra-cflags="$CFLAGS" --extra-ldflags="$LDFLAGS"
make -j"$JOBS"
make install
src x265
cmake -G Ninja -S source -B obj -DCMAKE_TOOLCHAIN_FILE="$WORK/toolchain.cmake" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DENABLE_LIBNUMA=OFF -DENABLE_ASSEMBLY=ON
cmake --build obj -j"$JOBS"
cmake --install obj
src vpx
./configure --target=x86_64-win64-gcc --prefix="$PREFIX" --disable-shared --enable-static --disable-examples --disable-tools --disable-docs --disable-unit-tests --enable-vp9-highbitdepth
make -j"$JOBS" CROSS="$CROSS"
make install
src webp
cmake -G Ninja -S . -B obj -DCMAKE_TOOLCHAIN_FILE="$WORK/toolchain.cmake" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DBUILD_SHARED_LIBS=OFF -DWEBP_BUILD_ANIM_UTILS=OFF -DWEBP_BUILD_CWEBP=OFF -DWEBP_BUILD_DWEBP=OFF -DWEBP_BUILD_GIF2WEBP=OFF -DWEBP_BUILD_IMG2WEBP=OFF -DWEBP_BUILD_VWEBP=OFF -DWEBP_BUILD_WEBPINFO=OFF -DWEBP_BUILD_EXTRAS=OFF
cmake --build obj -j"$JOBS"
cmake --install obj
src dav1d
cat > "$WORK/cross.meson" <<EOF
[binaries]
c = '$CC'
cpp = '$CXX'
ar = '$AR'
strip = '$STRIP'
windres = '${CROSS}windres'
pkgconfig = 'pkg-config'
[host_machine]
system = 'windows'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
EOF
meson setup obj --cross-file "$WORK/cross.meson" --prefix "$PREFIX" --libdir lib --default-library static -Denable_tools=false -Denable_tests=false
ninja -C obj -j"$JOBS"
ninja -C obj install
src nv-codec-headers
make PREFIX="$PREFIX" install
cd "$WORK/src"
mkdir -p ffmpeg
cp -a "$ROOT/ffmpeg/." ffmpeg/
cd ffmpeg
./configure --prefix="$PREFIX" --arch=x86_64 --target-os=mingw32 --cross-prefix="$CROSS" --cc="$CC" --cxx="$CXX" --pkg-config=pkg-config --pkg-config-flags=--static --enable-gpl --enable-version3 --enable-static --disable-shared --disable-autodetect --disable-debug --disable-doc --disable-ffplay --enable-zlib --enable-libx264 --enable-libx265 --enable-libmp3lame --enable-libvorbis --enable-libopus --enable-libvpx --enable-libwebp --enable-libdav1d --enable-ffnvcodec --enable-nvenc --enable-nvdec --enable-cuvid --enable-dxva2 --enable-d3d11va --extra-version=toolknit-r2 --extra-cflags="$CFLAGS" --extra-cxxflags="$CXXFLAGS" --extra-ldflags="$LDFLAGS" --extra-libs='-lstdc++ -lpthread -lm'
make -j"$JOBS"
cp ffmpeg.exe "$WORK/output/ffmpeg.exe"
cp ffprobe.exe "$WORK/output/ffprobe.exe"
cp ffbuild/config.log ffbuild/config.mak config.h "$WORK/output/"
"${CROSS}objdump" -p ffmpeg.exe > "$WORK/output/pe-imports.txt"
python3 "$ROOT/build/package-output.py" "$WORK/output"
