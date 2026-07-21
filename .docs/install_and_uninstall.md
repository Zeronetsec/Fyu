<!-- https://github.com/Zeronetsec/Fyu -->

# Installation
`install.sh` optional option:
- `--backup`
- `--no-remove-rootfs`

Use `--backup` to create a backup of the existing Fyu installation before replacing it.

## Termux & Linux (root)
```bash
git clone https://github.com/Zeronetsec/Fyu
cd Fyu
chmod +x install.sh
./install.sh
```

## Linux (user)
```bash
git clone https://github.com/Zeronetsec/Fyu
cd Fyu
chmod +x install.sh
sudo ./install.sh
```

## Uninstallation
```bash
export prefix="${PREFIX:-/usr}"
rm -f "${prefix}/bin/fyu"
rm -rf "${prefix}/opt/fyu"
```

<!-- Copyright (c) 2026 Zeronetsec -->