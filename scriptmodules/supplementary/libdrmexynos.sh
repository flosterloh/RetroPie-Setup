rp_module_id="libdrmexynos"
rp_module_desc="libdrm-exynos"
rp_module_menus="2+"

function sources_libdrmexynos() {
  gitPullOrClone "$rootdir/supplementary/libdrm" "git://github.com/tobiasjakobi/libdrm.git"
  pushd "$rootdir/supplementary/libdrm"
  git pull || return 1
  git checkout exynos || return 1
  popd
}

function build_libdrmexynos() {
  pushd "$rootdir/supplementary/libdrm"
  ./autogen.sh || return 1
  ./configure --enable-exynos-experimental-api || return 1
  make || return 1
  popd
}

function install_libdrmexynos() {
  pushd "$rootdir/supplementary/libdrm"
  make install || return 1
  popd
}

