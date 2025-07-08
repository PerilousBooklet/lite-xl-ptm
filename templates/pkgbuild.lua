-- mod-version:3
local ptm = require 'plugins.ptm'

-- This module installs 1 template:
-- 1. PKGBUILD, Base (line 7)
-- TODO: 2. PKGBUILD, arch-chroot
-- TODO: 3. PKGBUILD, arch-nspawn
-- TODO: 4. PKGBUILD, arch-nspawn + auto-recursive-dependency-get (for AUR packages)

-- PKGBUILD, Base
local pkgbuild_base = [[
# This is an example PKGBUILD file. Use this as a start to creating your own,
# and remove these comments. For more information, see 'man PKGBUILD'.
# NOTE: Please fill out the license field for your package! If it is unknown,
# then please put 'unknown'.

# Maintainer: Your Name <youremail@domain.com>
pkgname=NAME
pkgver=VERSION
pkgrel=1
epoch=
pkgdesc=""
arch=()
url=""
license=('GPL')
groups=()
depends=()
makedepends=()
checkdepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=("$pkgname-$pkgver.tar.gz"
        "$pkgname-$pkgver.patch")
noextract=()
sha256sums=()
validpgpkeys=()

prepare() {
	cd "$pkgname-$pkgver"
	patch -p1 -i "$srcdir/$pkgname-$pkgver.patch"
}

build() {
	cd "$pkgname-$pkgver"
	./configure --prefix=/usr
	make
}

check() {
	cd "$pkgname-$pkgver"
	make -k check
}

package() {
	cd "$pkgname-$pkgver"
	make DESTDIR="$pkgdir/" install
}
]]

ptm.add_template() {
  name = "pkgbuild-base",
  desc = "The base PKGBUILD template.",
  files = {
    ["PKGBUILD"] = {
      content = pkgbuild_base,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {}
}
