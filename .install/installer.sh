function install::installer() {
    if [[ "${__XCOMPILE__}" == true ]]; then
        echo -e "${color_B}[*] ${color_N}Set: ${color_GG}\"lflags\": [\"-fuse-ld=lld\"], \"dflags-ldc\": [\"-O3\", \"-flto=full\", \"-mcpu=native\"] ${color_DG}-> ${color_GG}${opt}/${targetins}/dub.json${color_N}"
        command cat > "${opt}/${targetins}/dub.json" << 'EOF'
{
    "name": "fyu",
    "mainSourceFile": "fyu.d",
    "sourcePaths": ["."],
    "stringImportPaths": ["."],
    "targetType": "executable",
    "preBuildCommands": [
        "command ls metadata/*.json | command sed 's/metadata\\///' > metadata.txt"
    ],
    "lflags": [
        "-fuse-ld=lld"
    ],
    "dflags-ldc": [
        "-O3",
        "-flto=full",
        "-mcpu=native"
    ]
}
EOF
    fi

    (
        cd "${opt}/${targetins}"
        install::getinstall \
            "
                CC=clang command dub build \
                    --compiler=ldc2 \
                    --build=release
            " \
            "Compiling: ${color_GG}${targetins}${color_N}"
    )
}; readonly -f install::installer