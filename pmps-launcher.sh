#!/usr/bin/env bash

export PCDS_CONDA_VER=6.1.0
source /cds/group/pcds/pyps/conda/pcds_conda

cd "/cds/group/pcds/epics-dev/screens/pydm/pmps-ui"
python -m pmpsui --area "$1" --no-web &
