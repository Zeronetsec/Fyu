function install::extern::androidInpackages() {
    command mapfile -t packages < <(
        command cat "${root}/.install/extern/termux_packages.txt"
    )

    for line in "${packages[@]}"; do
        [[ -z "${line}" ]] && continue
        [[ "${line}" =~ ^# ]] && continue

        echo -e "${color_B}[*] ${color_N}Installing: ${color_GG}${line}${color_N}"
        install::zinstall "${line}"

        if [[ "${line}" =~ ^(glibc-repo)$ ]]; then
            install::getinstall \
                "
                    command apt update -y
                    export DEBIAN_FRONTEND=noninteractive
                    command apt \
                        -o Dpkg::Options::=\"--force-confdef\" \
                        -o Dpkg::Options::=\"--force-confold\" \
                        -o Dpkg::Options::=\"--force-overwrite\" \
                        full-upgrade -y
                " \
                "Upgrading environment..."
        fi
    done
}; readonly -f install::extern::androidInpackages