#!/bin/bash
# Fill in HPC placeholders across all streamflow.yml files.
# Usage: ./configure.sh [--dry-run]
#
# Edit the variables below, then run the script.
# Original files are backed up to *.bak before modification.

# ── Your values ─────────────────────────────────────────────────────────────
HPC_USER="tommaso.fogliobonda"
HPC_HOST="c3s"                         # SSH hostname or address
SSH_KEY="/home/tommo/.ssh/unito"             # absolute path to private key on this machine
HPC_WORKDIR="/beegfs/home/tommaso.fogliobonda/cwl-examples"   # working dir on HPC
# ────────────────────────────────────────────────────────────────────────────

DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

apply() {
    local file="$1"
    if $DRY_RUN; then
        echo "[dry-run] would patch: $file"
        return
    fi
    cp "$file" "$file.bak"
    sed -i \
        -e "s|<username>|$HPC_USER|g" \
        -e "s|<user>|$HPC_USER|g" \
        -e "s|<hpc-hostname>|$HPC_HOST|g" \
        -e "s|<address of node 1>|$HPC_HOST|g" \
        -e "s|- <address of node 2>||g" \
        -e "s|<path/to/ssh/key>|$SSH_KEY|g" \
        -e "s|/home/<user>/\.ssh/id_rsa|$SSH_KEY|g" \
        -e "s|# workdir: <path/to/workdir>|workdir: $HPC_WORKDIR|g" \
        "$file"
    echo "patched: $file"
}

find "$SCRIPT_DIR" -name "streamflow.yml" | while read -r f; do
    apply "$f"
done

$DRY_RUN && echo "(dry-run complete — no files changed)"
