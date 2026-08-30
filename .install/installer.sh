function install::installer() {
    (
        cd "${opt}/${targetins}"
        install::getinstall \
            "
                command dub build \
                    --compiler=ldc2 \
                    --build=release
            " \
            "Compiling: ${color_GG}${targetins}${color_N}"
    )
}; readonly -f install::installer