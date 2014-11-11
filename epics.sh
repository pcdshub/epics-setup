# This script provides access to the EPICS binaries
source /reg/g/pcds/setup/pathmunge.sh

export EPICS_BASE=/reg/g/pcds/package/epics/3.14/base/current
export EPICS_EXTENSIONS=/reg/g/pcds/package/epics/3.14/extensions/extensions-R3-14-10

pathmunge $EPICS_BASE/bin/linux-x86_64
pathmunge $EPICS_EXTENSIONS/bin/linux-x86_64
pathmunge $EPICS_EXTENSIONS/bin/linux-x86

export EPICS_CA_MAX_ARRAY_BYTES=8000000
