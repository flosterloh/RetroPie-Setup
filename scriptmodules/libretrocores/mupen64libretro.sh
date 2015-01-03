rp_module_id="mupen64plus"
rp_module_desc="N64 LibretroCore Mupen64Plus"
rp_module_menus="2+"

function sources_mupen64plus() {
    gitPullOrClone "$md_build" git://github.com/libretro/mupen64plus-libretro.git
}

function build_mupen64plus() {
    make clean
    make platform=armv7-gles-neon-hardfloat
    md_ret_require="$md_build/mupen64plus_libretro.so"
}

function install_mupen64plus() {
    md_ret_files=(
        'mupen64plus-core/data'
        'mupen64plus_libretro.so'
        'README.md'
    )
}

function configure_mupen64plus() {
    mkRomDir "n64"

    ensureSystemretroconfig "n64"

    # Set core options
    ensureKeyValue "mupen64-gfxplugin" "rice" "$configdir/all/retroarch-core-options.cfg"
    ensureKeyValue "mupen64-gfxplugin-accuracy" "low" "$configdir/all/retroarch-core-options.cfg"
    ensureKeyValue "mupen64-screensize" "640x480" "$configdir/all/retroarch-core-options.cfg"

    # Copy config files
    cp "$md_inst/data/"{mupen64plus.cht,mupencheat.txt,mupen64plus.ini,font.ttf} "$home/RetroPie/BIOS/"
    chown -R $user:$user "$home/RetroPie/BIOS"

    rps_retronet_prepareConfig
    setESSystem "Nintendo 64" "n64" "~/RetroPie/roms/n64" ".z64 .Z64 .n64 .N64 .v64 .V64" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$emudir/retroarch/bin/retroarch -L $md_inst/mupen64plus_libretro.so --config $configdir/all/retroarch.cfg --appendconfig $configdir/n64/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile $__tmpnetplayport$__tmpnetplayframes %ROM%\"" "n64" "n64"
}
