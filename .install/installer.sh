function install::installer() {
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

    (
        cd "${opt}/fyu"
        install::getinstall \
            "
                command dub build \
                    --compiler=ldc2 \
                    --build=release
            " \
            "Building: ${GG}fyu${N}"
        cd
    )

    install::getinstall \
        "
            command ln -sf \
                ${opt}/fyu/fyu \
                ${bin}/fyu
        " \
        "Symlink: ${GG}${opt}/fyu/fyu ${DG}-> ${GG}${bin}/fyu${N}"
}; readonly -f install::installer