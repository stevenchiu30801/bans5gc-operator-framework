#!/bin/bash
# Check avaiability of BansSlice

usage() {
    echo "Wait for BansSlice to be ready"
    echo ""
    echo "Usage: ./check_bansslice.sh BANSSLICE"
    echo "Arguments:"
    echo "      BANSSLICE       BansSlice to be waited"
}

if [[ $# -ne 1 ]]; then
    usage
    exit 1
fi

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
    usage
    exit 0
fi

BANSSLICE=$1
INTERVAL_SEC=1

while true; do
    if kubectl describe bansslice.bans.io $BANSSLICE | grep 'Ready:' | grep 'true' >/dev/null; then
        break
    fi
    sleep $INTERVAL_SEC
done

echo "BansSlice $BANSSLICE is ready!"
