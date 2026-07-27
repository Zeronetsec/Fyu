function install::installer() {
    (
        cd "${opt}/${targetins}"
        install::getinstall \
            "
                command dub build \
                    --compiler=ldc2 \
                    --build=release
            " \
            "Compiling: ${GG}${targetins}${N}"
        cd
    )
}; readonly -f install::installer