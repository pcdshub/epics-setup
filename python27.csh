# This script provides access to our python 2.7 installation (this
# currently includes SIP, PyQt, numpy, Matplotlib and ipython)

source /reg/g/pcds/setup/pathmunge.csh

set pythondir=/reg/common/package/python/2.7.2-rhel5

prepend PATH $pythondir/bin
prepend LD_LIBRARY_PATH $pythondir/lib

