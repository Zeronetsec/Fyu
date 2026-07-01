function install::extern::androidInpackages() {
    command mapfile -t packages < <(
        command cat "${root}/.install/extern/termux_packages.txt"
    )

    for line in "${packages[@]}"; do
        [[ -z "${line}" ]] && continue
        [[ "${line}" =~ ^# ]] && continue
        echo -e "${B}[*] ${N}Installing: ${GG}${line}${N}"
        install::zinstall "${line}"
    done
}; readonly -f install::extern::androidInpackages