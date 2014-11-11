# This script provides access to the EPICS libraries required by our
# local implementation (pyca) of an EPICS python client
source /reg/g/pcds/setup/pathmunge.sh

source /reg/g/pcds/setup/python.sh

ldpathmunge /reg/common/package/epicsca/3.14.12/lib/x86_64-linux

pythonpathmunge /reg/g/pcds/pds/pyca
pythonpathmunge /reg/g/pcds/controls

export EPICS_CA_MAX_ARRAY_BYTES=8000000
