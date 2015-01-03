rp_module_id="libdrmexynos"
rp_module_desc="libdrm-exynos"
rp_module_menus="2+"

function sources_libdrmexynos() {
  gitPullOrClone "$md_build" "git://github.com/tobiasjakobi/libdrm.git" NS
}

function build_libdrmexynos() {
  git checkout origin/exynos
  ./autogen.sh
  ./configure --enable-exynos-experimental-api
  make
  ldconfig # tell the system to update it's internal cache of libraries
  md_ret_require="$md_build/exynos/.libs/libdrm_exynos.so"
}

function install_libdrmexynos() {
  make install
}

