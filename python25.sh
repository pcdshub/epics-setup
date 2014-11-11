# This script provides access to our python 2.5 installation (this
# currently includes SIP, PyQt, numpy, Matplotlib and ipython)

source /reg/g/pcds/setup/pathmunge.sh

pythondir=/reg/common/package/python/2.5.5

pathmunge $pythondir/bin
ldpathmunge $pythondir/lib

