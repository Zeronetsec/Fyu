function install::extern::androidInstaller() {
    install::getinstall \
        "
            command cp -r \
                ${opt}/${targetins} \
                ${rootfs}/${rname}/rootfs/root/${targetins}
        " \
        "Copying: ${color_GG}${opt}/${targetins} ${color_DG}-> ${color_GG}${rootfs}/${rname}/rootfs/root/${targetins}${color_N}"

    install::getinstall \
        "
            command proot-distro login ${rname} \
                -- bash -c '
                    set -o errexit
                    command chmod +x /root/${targetins}/install.sh
                ' \
        " \
        "Set permission for: ${color_GG}${rootfs}/${rname}/rootfs/root/${targetins}/install.sh${color_N}"

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
                exec -a Fyu \
                    glibc-runner \
                    ${rootfs}/${rname}/rootfs/usr/opt/${targetins}/${targetins} \
                    \"\${*}\"
            ' > ${bin}/${targetins}
        " \
        "Bridging: ${color_GG}${bin}/${targetins} ${color_DG}-> ${color_GG}${rootfs}/${rname}/rootfs/usr/opt/${targetins}/${targetins}${color_N}"
}; readonly -f install::extern::androidInstaller