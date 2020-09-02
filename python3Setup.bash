
if [ -z "$LD_LIBRARY_PATH" ]
then
   LD_LIBRARY_PATH=""
fi

# Autoconf path
#PY_PATH=/afs/slac.stanford.edu/g/reseng/vol21/python/3.6.1
# Rogue requires python 3.6 or higher
#PY_PATH=/afs/slac/g/lcls/package/python/python2.7.9/rhel6-x86_64
PY_PATH=/afs/slac/g/lcls/package/python/3.6.1/rhel6-x86_64

# Setup path
PATH=${PY_PATH}/bin:${PATH}

# Library path
LD_LIBRARY_PATH=${PY_PATH}/lib:${PY_PATH}/lib/python3.6.1/lib-dynload:${LD_LIBRARY_PATH}

# =============================================================================
# Support for PyEPICS within ipython3:
# =============================================================================
export PYEPICS_LIBCA=${EPICS_BASE_RELEASE}/lib/${EPICS_HOST_ARCH}/libca.so
export PYEPICS_LIBCOM=${EPICS_BASE_RELEASE}/lib/${EPICS_HOST_ARCH}/libCom.so
# =============================================================================

export PATH
export LD_LIBRARY_PATH

