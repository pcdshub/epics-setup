# This script provides access to our python 2.7 installation (this
# currently includes SIP, PyQt, numpy, Matplotlib and ipython)

source /reg/g/pcds/setup/pathmungerev.sh

#if [ "$kernel_family" == "RHEL6" ]; then
if [ "$LSB_FAMILY" == "rhel6" ]; then
	pythondir=/reg/common/package/python/2.7.2-rhel6
else
	pythondir=/reg/common/package/python/2.7.2-rhel5
fi
pathmunge $pythondir/bin
ldpathmunge $pythondir/lib

