# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2023-present Fewtarius

PKG_NAME="box64"
PKG_VERSION="e8972efca192e988cdd72fc765ef001defe9a5a4"
PKG_ARCH="aarch64"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/ptitSeb/box64"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain ncurses SDL_sound"
PKG_LONGDESC="Box64 lets you run x86_64 Linux programs (such as games) on non-x86_64 Linux systems, like ARM."
PKG_TOOLCHAIN="cmake"

if [ "${OPENGL}" = "no" ]; then
  PKG_DEPENDS_TARGET+=" gl4es"
fi

case ${DEVICE} in
  RK3399)
    PKG_CMAKE_OPTS_TARGET+= " -D RK3399=1"
  ;;
  RK3588)
    PKG_CMAKE_OPTS_TARGET+= " -D RK3588=1"
  ;;
  RK3326)
    PKG_CMAKE_OPTS_TARGET+= " -D RK3326=1"
  ;;
  S922X*)
    PKG_CMAKE_OPTS_TARGET+= " -D ODROIDN2=1"
  ;;
  AMD64)
    PKG_CMAKE_OPTS_TARGET+= " -D LD80BITS=1 -D NOALIGN=1"
  ;;
  *)
    PKG_CMAKE_OPTS_TARGET+=" -D ARM64=1"
  ;;
esac

PKG_CMAKE_OPTS_TARGET+=" -DCMAKE_BUILD_TYPE=Release"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/box64/lib
  cp ${PKG_BUILD}/x64lib/* ${INSTALL}/usr/share/box64/lib

  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/.${TARGET_NAME}/box64 ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/tests/bash ${INSTALL}/usr/bin/bash-x64

  mkdir -p ${INSTALL}/usr/config
  cp ${PKG_DIR}/config/box64.box64rc ${INSTALL}/usr/config/box64.box64rc

  mkdir -p ${INSTALL}/etc
  ln -sf /storage/.config/box64.box64rc ${INSTALL}/etc/box64.box64rc

  mkdir -p ${INSTALL}/etc/binfmt.d
  cp -f ${PKG_DIR}/config/box64.conf ${INSTALL}/etc/binfmt.d/box64.conf
}
