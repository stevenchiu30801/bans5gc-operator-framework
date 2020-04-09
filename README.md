# BANS 5GC Operator Framework

BANS 5GC Operator Framework consists of three operators, [free5GC Operator](https://github.com/stevenchiu30801/free5gc-operator), [ONOS Bandwidth Operator](https://github.com/stevenchiu30801/onos-bandiwdth-operator) and [BANS 5GC Operator](https://github.com/stevenchiu30801/bans5gc-operator), to provide automation of BANS 5GC.

## Prerequisite

See [operator-framework/operator-sdk](https://github.com/operator-framework/operator-sdk#prerequisites).

```ShellSession
# Pre-install
sudo apt instal make
```

## Usage

### Network Environment

```
     |---- Mongo Service Connection ----|
     |                                  |
RANSIM Node ----- P4 Switch ----- Kubernetes Node
```

### Run

```ShellSession
# On Kubernetes node

# Install submodules
make submodule

# Pull submodules with the specified branch
BRANCH=<branch> make update-submodule

# Install all operator resources
SRIOV_INTF=<sriov-interface> make install

# Create ONOS device and queue netcfg
kubectl apply -f onos-bandwidth-operator/deploy/crds/bans.io_v1alpha1_onosdevicenetcfg_cr.yaml
kubectl apply -f onos-bandwidth-operator/deploy/crds/bans.io_v1alpha1_onosqueuenetcfg_cr.yaml

# Create network slice infrastructure
kubectl apply -f bans5gc-operator/deploy/crds/bans.io_v1alpha1_bansslice_cr1.yaml

# Check if status of the new slice is ready before proceeding
kubectl describe bansslice.bans.io example-bansslice1 | grep -A 1 Status
```

### Procedure Test

```ShellSession
# On RANSIM node

# Setup IP address of interface to core network
sudo ip address add 192.168.3.11/24 dev <ransim-interface>

# Clone modified version of free5GC Stage 2
# NOTE: This repository is private currently
git clone https://github.com/stevenchiu30801/free5gc-stage-2

# Run tests with example slice 1
cd free5gc-stage-2/src/test
go test -vet=off -run TestRegistration -ue-idx=1 -sst=1 -sd=010203
```

### Reset

```ShellSession
# Uninstall all operator resources and functions
make uninstall
```
