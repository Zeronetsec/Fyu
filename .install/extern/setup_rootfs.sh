function install::extern::setupRootfs() {
    echo -e "${B}[*] ${N}Installing: ${GG}proot-distro${N}"
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
            "Installing rootfs: ${GG}debian:13 ${DG}-> ${GG}${rname}${N}"
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