# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2023-present Fewtarius

PKG_NAME="box86"
PKG_VERSION="6f7a5130513776336f1934067c4e906d405d0edf"
PKG_ARCH="arm aarch64"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/ptitSeb/box86"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain ncurses SDL_sound"
PKG_LONGDESC="Box86 lets you run x86 Linux programs (such as games) on non-x86 Linux systems, like ARM."
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
  S922X*)
    PKG_CMAKE_OPTS_TARGET+= " -D ODROIDN2=1"
  ;;
  AMD64)
    PKG_CMAKE_OPTS_TARGET+= "-D CMAKE_C_FLAGS="-m32"  -D LD80BITS=1 -D NOALIGN=1"
  ;;
  *)
    PKG_CMAKE_OPTS_TARGET+=" -D ARM64=1"
  ;;
esac

PKG_CMAKE_OPTS_TARGET+=" -D CMAKE_BUILD_TYPE=Release"

case ${TARGET_ARCH} in
  aarch64)
    make_target() {
      true
    }
  ;;
esac

makeinstall_target() {
  case ${TARGET_ARCH} in
    arm)
      mkdir -p ${INSTALL}/usr/share/box86/lib
      cp ${PKG_BUILD}/x86lib/* ${INSTALL}/usr/share/box86/lib

      mkdir -p ${INSTALL}/usr/bin
      cp ${PKG_BUILD}/.${TARGET_NAME}/box86 ${INSTALL}/usr/bin/
      cp ${PKG_BUILD}/tests/bash ${INSTALL}/usr/bin/bash-x86
    ;;
    aarch64)
      mkdir -p ${INSTALL}/usr/share/box86/lib
      cp -vP ${ROOT}/build.${DISTRO}-${DEVICE}.arm/${PKG_NAME}-*/.install_pkg/usr/share/box86/lib/* ${INSTALL}/usr/share/box86/lib

      mkdir -p ${INSTALL}/usr/bin
      cp -vP ${ROOT}/build.${DISTRO}-${DEVICE}.arm/${PKG_NAME}-*/.install_pkg/usr/bin/* ${INSTALL}/usr/bin
      cp -vP ${ROOT}/build.${DISTRO}-${DEVICE}.arm/${PKG_NAME}-*/tests/bash ${INSTALL}/usr/bin/bash-x86
    ;;
  esac

  mkdir -p ${INSTALL}/usr/config
  cp ${PKG_DIR}/config/box86.box86rc ${INSTALL}/usr/config/box86.box86rc

  mkdir -p ${INSTALL}/etc
  ln -sf /storage/.config/box86.box86rc ${INSTALL}/etc/box86.box86rc

  mkdir -p ${INSTALL}/etc/binfmt.d
  cp -f ${PKG_DIR}/config/box86.conf ${INSTALL}/etc/binfmt.d/box86.conf
}
