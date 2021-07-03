#!/usr/bin/env bash

source /reg/g/pcds/pyps/conda/dev_conda

pushd "/reg/g/pcds/epics-dev/screens/pydm/pmps-ui-$1"

pydm --hide-nav-bar --hide-status-bar -m "CFG=$1" pmps.py &
