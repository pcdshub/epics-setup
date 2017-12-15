#!/bin/bash

# V4 CPP build dir
export EPICS_PVCPP=${EPICS_BASE_TOP}/base-cpp-R4-6-0

# V4 Java  build dir
export EPICS_PVJAVA=${EPICS_BASE_TOP}/base-java-R4-6-0/epics-core

#
# Add EPICS V4 executables to PATH
#
if [ -z `echo $PATH | grep ${EPICS_PVCPP}/pvAccessCPP/bin/${EPICS_HOST_ARCH}` ]; then
    export PATH=${EPICS_PVCPP}/pvAccessCPP/bin/${EPICS_HOST_ARCH}:$PATH
fi

#
# Add EPICS V4 libs to LD_LIBRARY_PATH
#
if [ -z `echo $LD_LIBRARY_PATH | grep ${EPICS_PVCPP}/lib/${EPICS_HOST_ARCH}` ]; then
    export LD_LIBRARY_PATH=${EPICS_PVCPP}/lib/${EPICS_HOST_ARCH}:$LD_LIBRARY_PATH
fi

# Add EPICS V4 pvaPy to PYTHONPATH    
PVAPY_DIR="${EPICS_PVCPP}/pvaPy/lib/python/2.7/${EPICS_HOST_ARCH}"
if [ -z `echo $PYTHONPATH | grep ${PVAPY_DIR}` ]; then
    export PYTHONPATH=${PVAPY_DIR}:${PYTHONPATH}
fi
