function install::extern::androidInstaller() {
    if [[ "${__BACKUP__}" == "true" && -d "${opt}/fyu" ]]; then
        (
            cd "${opt}"
            install::getinstall \
                "
                    command zip -r \
                        fyu_${bkdate}.bak.zip \
                        fyu
                " \
                "Backup: ${GG}${opt}/fyu ${DG}-> ${GG}${opt}/fyu_${bkdate}.bak.zip${N}"
            cd
        )
    fi

    if [[ -d "${opt}/fyu" ]]; then
        install::getinstall \
            "command rm -rf ${opt}/fyu" \
            "Removing old source...."
    fi

    install::getinstall \
        "
            command mv \
                ${root} \
                ${opt}/fyu
        " \
        "Moving: ${GG}${root} ${DG}-> ${GG}${opt}/fyu${N}"

    install::getinstall \
        "
            command cp -r \
                ${opt}/fyu \
                ${rootfs}/${rname}/rootfs/root/fyu
        " \
        "Copying: ${GG}${opt}/fyu ${DG}-> ${GG}${rootfs}/${rname}/rootfs/root/fyu${N}"

    install::getinstall \
        "
            command proot-distro login ${rname} \
                -- bash -c '
                    set -o errexit
                    command chmod +x /root/fyu/install.sh
                ' \
        " \
        "Set permission for: ${GG}${rootfs}/${rname}/rootfs/root/fyu/install.sh${N}"

    command proot-distro login "${rname}" \
        -- bash -c '
            set -o errexit
            export __ANDROID__=true
            command bash /root/fyu/install.sh
        '

    install::getinstall \
    "
        echo '
            #!/usr/bin/env bash
            exec proot-distro login \"${rname}\" --work-dir \$(pwd) -- fyu \"\${@}\"
        ' > ${bin}/fyu
    " \
    "Bridging: ${GG}${bin}/fyu ${DG}-> ${GG}${rootfs}/${rname}/rootfs/usr/bin/fyu${N}"

    install::getinstall \
        "command chmod +x ${bin}/fyu" \
        "Set permission for: ${GG}${bin}/fyu${N}"
}; readonly -f install::extern::androidInstaller