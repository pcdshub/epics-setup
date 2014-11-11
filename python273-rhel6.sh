# This script provides access to our python 2.7 installation (this
# currently includes SIP, PyQt, numpy, Matplotlib and ipython)

source /reg/g/pcds/setup/pathmungerev.sh

pythondir=/reg/common/package/Python/2.7.3/x86_64-rhel6-opt

pathmunge $pythondir/bin
ldpathmunge $pythondir/lib

