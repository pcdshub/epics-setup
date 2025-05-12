#!/usr/bin/env bash

export PCDS_CONDA_VER=5.9.1
source /cds/group/pcds/pyps/conda/pcds_conda

cd "/cds/group/pcds/epics-dev/screens/pydm/pmps-ui"
pydm --hide-nav-bar --hide-status-bar -m "CFG=$1" pmpsui/pmps.py --no-web &
