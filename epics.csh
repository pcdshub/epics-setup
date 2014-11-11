# This script provides access to the EPICS binaries
source /reg/g/pcds/setup/pathmunge.csh

set EPICS_BASE=/reg/g/pcds/package/epics/3.14/base/current
set EPICS_EXTENSIONS=/reg/g/pcds/package/epics/3.14/extensions/extensions-R3-14-10

prepend PATH $EPICS_BASE/bin/linux-x86_64
prepend PATH $EPICS_EXTENSIONS/bin/linux-x86_64
prepend PATH $EPICS_EXTENSIONS/bin/linux-x86

setenv EPICS_CA_MAX_ARRAY_BYTES 8000000
