# BANS 5GC Operator Framework

BANS 5GC Operator Framework consists of three operators, [free5GC Operator](https://github.com/stevenchiu30801/free5gc-operator), [ONOS Bandwidth Operator](https://github.com/stevenchiu30801/onos-bandiwdth-operator) and [BANS 5GC Operator](https://github.com/stevenchiu30801/bans5gc-operator), to provide automation of BANS 5GC.

## Prerequisite

See [operator-framework/operator-sdk](https://github.com/operator-framework/operator-sdk#prerequisites).

```ShellSession
# Pre-install
sudo apt instal make
```

## Usage

### Run

```ShellSession
# Pull the latest submodule with specific branch
BRANCH=<branch> make submodule

# Install all operator resources
make install
```

### Procedure Test

See [procedure test](https://github.com/stevenchiu30801/bans5gc-operator#procedure-test) in BANS 5GC Operator.

### Reset

```ShellSession
# Uninstall all operator resources and functions
make uninstall
```
