rp_module_id="libdrmexynos"
rp_module_desc="libdrm-exynos"
rp_module_menus="2+"

function sources_libdrmexynos() {
  gitPullOrClone "$md_build" "git://github.com/tobiasjakobi/libdrm.git"
}

function build_libdrmexynos() {
  git checkout exynos
  ./autogen.sh
  ./configure --enable-exynos-experimental-api
  make
  md_ret_require="$md_build/exynos/.libs/libdrm_exynos.so"
}

function install_libdrmexynos() {
  make install
}

