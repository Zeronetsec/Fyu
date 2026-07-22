<!-- https://github.com/Zeronetsec/Fyu -->

# Installation
`install.sh` optional options (can be used together):
- `--backup`
- └── create a backup of the existing source installation before replacing it.
- `--no-remove-rootfs`
- └── do not delete rootfs.

### Usage
```bash
git clone https://github.com/Zeronetsec/Fyu
bash Fyu/install.sh <option>
```

# Uninstallation
`uninstall.sh` optional options (can be used together):
- `--remove-backup`
- └── remove all backup found.
- `--remove-rootfs=<true|false>`
- └── remove rootfs option.

### Usage
```bash
export prefix="${PREFIX:-/usr}"
bash $prefix/opt/fyu/uninstall.sh <option>
```

<!-- Copyright (c) 2026 Zeronetsec -->