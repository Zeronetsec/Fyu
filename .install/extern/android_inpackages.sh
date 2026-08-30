function install::extern::androidInpackages() {
    command mapfile -t packages < <(
        command cat "${root}/.install/extern/termux_packages.txt"
    )

    for line in "${packages[@]}"; do
        [[ -z "${line}" ]] && continue
        [[ "${line}" =~ ^# ]] && continue

        echo -e "${color_B}[*] ${color_N}Installing: ${color_GG}${line}${color_N}"
        install::zinstall "${line}"

        if [[ "${line}" =~ ^(tur-repo|glibc-repo)$ ]]; then
            command apt update -y \
                > /dev/null 2>&1
            export DEBIAN_FRONTEND=noninteractive
            command apt \
                -o Dpkg::Options::="--force-confdef" \
                -o Dpkg::Options::="--force-confold" \
                -o Dpkg::Options::="--force-overwrite" \
                full-upgrade -y \
                > /dev/null 2>&1
        fi
    done
}; readonly -f install::extern::androidInpackages