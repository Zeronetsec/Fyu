export tmp="${TMPDIR:-/tmp}"; readonly tmp
export bin="${PREFIX:-/usr}/bin"; readonly bin
export opt="${HOME}/.local/opt"; readonly opt

export bkdate="$(
    command date '+%Y_%b_%d_%H_%M_%S'
)"; readonly bkdate

export targetins="fyu"; readonly targetins
export targetsyml="${targetins}"; readonly targetsyml