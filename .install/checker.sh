function install::checker() {
    if [[ "${__ANDROID__}" != true ]]; then
        if command -v ${targetins} &>/dev/null; then
            echo -e "${GG}[+] ${N}${targetins^} installed!"
            echo -e "${GG}[+] ${N}Usage: ${GG}${targetins} --help ${N}to show helper"
            return 0
        else
            echo -e "${R}[!] ${N}Failed installing: ${GG}${targetins}${N}"
            return 1
        fi
    fi
}; readonly -f install::checker