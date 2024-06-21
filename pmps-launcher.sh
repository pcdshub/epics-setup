#!/usr/bin/env bash

export PCDS_CONDA_VER=5.8.0
source /cds/group/pcds/pyps/conda/pcds_conda

pushd "/cds/group/pcds/epics-dev/screens/pydm/pmps-ui"

pydm --hide-nav-bar --hide-status-bar -m "CFG=$1" pmps.py --no-web &
