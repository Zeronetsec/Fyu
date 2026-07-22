#!/usr/bin/env bash

set -o errexit

src="${BASH_SOURCE[0]}"
while [[ -h "${src}" ]]; do
    dir="$(
        cd -P "$(
            command dirname "${src}"
        )" > /dev/null 2>&1 && pwd
    )"
    src="$(command readlink "${src}")"
    [[ "${src}" != /* ]] && src="${dir}/${src}"
done

dir="$(
    cd -P "$(
        command dirname "${src}"
    )" > /dev/null 2>&1 && pwd
)"

export root="${dir}"; readonly root
source "${root}/.install/include.sh"

include : '(
    .install/color
    .install/variable
    .install/error
    .install/getinstall
    .install/extern/xvariable
)'

__RMBK__=false
__NRMRFS__=true

while [[ ${#} -gt 0 ]]; do
    case "${1}" in
        "--remove-backup") export __RMBK__=true ;;
        "--remove-rootfs="*) export __NRMRFS__="${1#*=}" ;;
    esac
    shift
done

if [[ "${__RMBK__}" == true ]]; then
    install::getinstall \
        "command rm -f ${opt}/fyu_*.zip.bak" \
        "Removing all backup..."
fi

install::getinstall \
    "command rm -rf ${opt}/fyu" \
    "Removing: ${GG}${opt}/fyu${N}"

install::getinstall \
    "command rm -f ${bin}/fyu" \
    "Removing: ${GG}${bin}/fyu${N}"

if [[ "${__NRMRFS__}" == true ]]; then
    if [[ -d "${rootfs}/${rname}" ]]; then
        if command -v proot-distro &>/dev/null; then
            install::getinstall \
                "command proot-distro remove ${rname}" \
                "Removing rootfs: ${GG}${rname}${N}"
        else
            install::getinstall \
                "command rm -rf ${rootfs}/${rname}" \
                "Removing: ${GG}${rootfs}/${rname}${N}"
        fi
    fi
fi

echo -e "${GG}[+] ${N}Fyu removed"

trap - EXIT
exit ${?}