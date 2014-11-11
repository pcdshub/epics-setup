#!/bin/bash
kernel_family=`uname -r | sed -e s/.*el5.*/RHEL5/ | sed -e s/.*el6.*/RHEL6/`

pathmunge () {
  PATH=${PATH:+:$PATH}
  if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
    export PATH=$1$PATH
  fi
}

ldpathmunge () {
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
  if ! echo $LD_LIBRARY_PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
    export LD_LIBRARY_PATH=$1$LD_LIBRARY_PATH
  fi
}

pythonpathmunge () {
  PYTHONPATH=${PYTHONPATH:+:$PYTHONPATH}
  if ! echo $PYTHONPATH | /bin/egrep -q "(^|:)$1($|:)" ; then
    export PYTHONPATH=$1$PYTHONPATH
  fi
}

