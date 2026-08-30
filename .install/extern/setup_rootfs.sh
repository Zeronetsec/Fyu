function install::extern::setupRootfs() {
    echo -e "${color_B}[*] ${color_N}Installing: ${color_GG}proot-distro${color_N}"
    install::zinstall "proot-distro"

    if [[ "${__NOREMRFS__}" == false ]]; then
        if [[ -d "${rootfs}/${rname}" ]]; then
            install::getinstall \
                "command proot-distro remove ${rname}" \
                "Removing old rootfs..."
        fi
    fi

    if [[ ! -d "${rootfs}/${rname}" ]]; then
        install::getinstall \
            "
                command proot-distro install \
                    debian:13 \
                    --name ${rname}
            " \
            "Installing rootfs: ${color_GG}debian:13 ${color_DG}-> ${color_GG}${rname}${color_N}"
    fi

    install::getinstall \
        "
            command proot-distro login ${rname} \
                -- bash -c '
                    set -o errexit
                    command apt update -y
                    export DEBIAN_FRONTEND=noninteractive
                    command apt \
                        -o Dpkg::Options::=\"--force-confdef\" \
                        -o Dpkg::Options::=\"--force-confold\" \
                        -o Dpkg::Options::=\"--force-overwrite\" \
                        full-upgrade -y
                ' \
        " \
        "Upgrading rootfs..."

    install::getinstall \
        "
            echo '
                export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games
                export LANG=C.UTF-8
                export LC_ALL=C.UTF-8
                export LS_OPTIONS='--color=always'
                export PROMPT_DIRTRIM=2
                export PROOT_NO_SECCOMPT=1
            ' > ${rootfs}/${rname}/rootfs/root/.bashrc
        " \
        "Setup rootfs bashrc..."
}; readonly -f install::extern::setupRootfs