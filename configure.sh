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
HPC_WORKDIR="/beegfs/home/tommaso.fogliobonda/tmp/streamflow"   # working dir on HPC
PORT_WORKDIR="/beegfs/home/tommaso.fogliobonda/cwl-examples/07_streamflow_ports"  # where port input files live on HPC
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
        -e "s|<HPC_USER>|$HPC_USER|g" \
        -e "s|<HPC_HOST>|$HPC_HOST|g" \
        -e "s|<SSH_KEY>|$SSH_KEY|g" \
        -e "s|<HPC_WORKDIR>|$HPC_WORKDIR|g" \
        -e "s|<PORT_WORKDIR>|$PORT_WORKDIR|g" \
        "$file"
    echo "patched: $file"
}

find "$SCRIPT_DIR" -name "streamflow.yml" | while read -r f; do
    apply "$f"
done

$DRY_RUN && echo "(dry-run complete — no files changed)" || true
