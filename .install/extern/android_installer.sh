function install::extern::androidInstaller() {
    install::getinstall \
        "
            command cp -r \
                ${opt}/${targetins} \
                ${rootfs}/${rname}/rootfs/root/${targetins}
        " \
        "Copying: ${GG}${opt}/${targetins} ${DG}-> ${GG}${rootfs}/${rname}/rootfs/root/${targetins}${N}"

    install::getinstall \
        "
            command proot-distro login ${rname} \
                -- bash -c '
                    set -o errexit
                    command chmod +x /root/${targetins}/install.sh
                ' \
        " \
        "Set permission for: ${GG}${rootfs}/${rname}/rootfs/root/${targetins}/install.sh${N}"

    command proot-distro login "${rname}" \
        -- bash -c "
            set -o errexit
            export __ANDROID__=true
            command bash /root/${targetins}/install.sh
        "

    install::getinstall \
    "
        echo '
            #!/usr/bin/env bash
            exec proot-distro login \"${rname}\" --work-dir \$(pwd) -- ${targetins} \"\${@}\"
        ' > ${bin}/${targetins}
    " \
    "Bridging: ${GG}${bin}/${targetins} ${DG}-> ${GG}${rootfs}/${rname}/rootfs/usr/bin/${targetins}${N}"
}; readonly -f install::extern::androidInstaller