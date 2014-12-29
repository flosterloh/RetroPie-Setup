rp_module_id="libdrmexynos"
rp_module_desc="libdrm-exynos"
rp_module_menus="2+"

function sources_libdrmexynos() {
  gitPullOrClone "$md_build" "git://github.com/tobiasjakobi/libdrm.git"
  pushd "$md_build"
  git pull || return 1
  git checkout exynos || return 1
  popd
}

function build_libdrmexynos() {
  ./autogen.sh || return 1
  ./configure --enable-exynos-experimental-api || return 1
  make || return 1
}

function install_libdrmexynos() {
  make install || return 1
}

