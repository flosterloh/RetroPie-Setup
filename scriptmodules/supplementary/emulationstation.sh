rp_module_id="emulationstation"
rp_module_desc="EmulationStation"
rp_module_menus="2+"

function depends_emulationstation() {
    checkNeededPackages \
        libboost-locale-dev libboost-system-dev libboost-filesystem-dev libboost-date-time-dev \
        libfreeimage-dev libfreetype6-dev libeigen3-dev libcurl4-openssl-dev \
        libasound2-dev cmake g++-4.7

    # rp_callModule "sdl2binaries"
    rp_callModule "sdl2"
}

function sources_emulationstation() {
    gitPullOrClone "$md_build" "https://github.com/Aloshi/EmulationStation" NS
    git checkout unstable || return 1
}

function build_emulationstation() {
    rpSwap on 512
    cmake .
    make clean
    make
    rpSwap off
    md_ret_require="$md_build/emulationstation"
}

function install_emulationstation() {
    md_ret_files=(
        'CREDITS.md'
        'emulationstation'
        'GAMELISTS.md'
        'README.md'
        'THEMES.md'
    )

}

function configure_emulationstation() {
    ln -s "$md_inst/emulationstation" /usr/local/bin/
    # cat > /usr/bin/emulationstation << _EOF_
# #!/bin/bash

es_bin="$md_inst/emulationstation"

# nb_lock_files=\$(find /tmp -name ".X?-lock" | wc -l)
# if [ \$nb_lock_files -ne 0 ]; then
    # echo "X is running. Please shut down X in order to mitigate problems with loosing keyboard input. For example, logout from LXDE."
    # exit 1
# fi

# \$es_bin "\$@"
# _EOF_
    # chmod +x /usr/bin/emulationstation

    # make sure that ES has enough GPU memory
    ensureKeyValueBootconfig "gpu_mem_256" 128 "/boot/config.txt"
    ensureKeyValueBootconfig "gpu_mem_512" 256 "/boot/config.txt"
    ensureKeyValueBootconfig "overscan_scale" 1 "/boot/config.txt"

    if [[ $__netplayenable == "E" ]]; then
         local __tmpnetplaymode="-$__netplaymode "
         local __tmpnetplayhostip_cfile=$__netplayhostip_cfile
         local __tmpnetplayport="--port $__netplayport "
         local __tmpnetplayframes="--frames $__netplayframes"
     else
         local __tmpnetplaymode=""
         local __tmpnetplayhostip_cfile=""
         local __tmpnetplayport=""
         local __tmpnetplayframes=""
     fi

    mkdir -p "/etc/emulationstation"

    setESSystem "Input Configuration" "esconfig" "~/RetroPie/roms/esconfig" ".py .PY" "%ROM%" "ignore" "esconfig"
    chmod 644 "/etc/emulationstation/es_systems.cfg"
}

function package_emulationstation() {
    local PKGNAME

    checkNeededPackages reprepro

    printMsg "Building package of EmulationStation"

#   # create Raspbian package
#   $PKGNAME="retropie-supplementary-emulationstation"
#   mkdir $PKGNAME
#   mkdir $PKGNAME/DEBIAN
#   cat >> $PKGNAME/DEBIAN/control << _EOF_
# Package: $PKGNAME
# Priority: optional
# Section: devel
# Installed-Size: 1
# Maintainer: Florian Mueller
# Architecture: armhf
# Version: 1.0
# Depends: libboost-system-dev libboost-filesystem-dev libboost-date-time-dev libfreeimage-dev libfreetype6-dev libeigen3-dev libcurl4-openssl-dev libasound2-dev cmake g++-4.7
# Description: This package contains the front-end EmulationStation.
# _EOF_

#   mkdir -p $PKGNAME/usr/share/RetroPie/supplementary/EmulationStation
#   cd
#   cp -r $rootdir/supplementary/EmulationStation/emulationstation $PKGNAME$rootdir/supplementary/EmulationStation/

#   # create package
#   dpkg-deb -z8 -Zgzip --build $PKGNAME

#   # sign Raspbian package
#   dpkg-sig --sign builder $PKGNAME.deb

#   # add package to repository
#   cd RetroPieRepo
#   reprepro --ask-passphrase -Vb . includedeb wheezy /home/pi/$PKGNAME.deb

}
