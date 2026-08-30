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
            command cp \
                ${rootfs}/${rname}/rootfs/usr/opt/${targetins}/${targetins} \
                ${opt}/${targetins}/${targetins}
        " \
        "Copying: ${color_GG}${rootfs}/${rname}/rootfs/usr/opt/${targetins}/${targetins} ${color_DG}-> ${color_GG}${opt}/${targetins}/${targetins}${color_N}"

    if [[ ! -x "${opt}/${targetins}/${targetins}" ]]; then
        install::getinstall \
            "command chmod +x ${opt}/${targetins}/${targetins}" \
            "Set permission for: ${color_GG}${opt}/${targetins}/${targetins}${color_N}"
    fi

    install::getinstall \
        "
            echo '
                #!/usr/bin/env bash
                exec -a Fyu \
                    glibc-runner \
                    ${opt}/${targetins}/${targetins}
                    \"\${*}\"
            ' > ${bin}/${targetins}
        " \
        "Create file: ${color_GG}${bin}/${targetins} ${color_DG}-> ${color_GG}${opt}/${targetins}/${targetins}${color_N}"
}; readonly -f install::extern::androidInstaller