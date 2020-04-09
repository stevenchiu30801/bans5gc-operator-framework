#!/bin/bash
# Remove all BansSlice CRs

CRS=$( kubectl get bansslice.bans.io -o jsonpath='{.items[*].metadata.name}' )
IFS=' ' read -r -a cr_list <<< "$CRS"

for cr in "${cr_list[@]}"
do
    kubectl delete bansslice.bans.io $cr
done
