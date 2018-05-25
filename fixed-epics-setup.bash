#-*-sh-*-
#
#   Title: fixed-epics-setup.bash
#
#  Purpose:
#   Source this file once from .bash_profile on login to
#   set your fixed EPICS environment variables.
#
#   NOTE: This file should not set any version specific paths.
#   Instead, source generic-epics-setup.bash after specifying
#   EPICS versions to setup version env variables.
#
#   Derived from epicsSetup.bash
#   Use git log for history.
umask 002
HOSTNAME=`hostname`

#
# Set up LCLS_ROOT
#
if [ -d /afs/slac/g/lcls ]; then
   export LCLS_ROOT=/afs/slac/g/lcls
   export IOCCONSOLE_ENV=Dev
   export TFTPBOOT=$LCLS_ROOT/tftpboot
else 
   export LCLS_ROOT=/usr/local/lcls 
   export IOCCONSOLE_ENV=Prod
   export TFTPBOOT=/usr/local/common/tftpboot
fi
export FACILITY_ROOT=$LCLS_ROOT

#
# Set up LCLS_DATA
#
if [ -d /nfs/slac/g/lcls ]; then
   export LCLS_DATA=/nfs/slac/g/lcls  
elif [ -d /u1/lcls ]; then
   export LCLS_DATA=/u1/lcls
else
   export LCLS_DATA=	
fi

#
# Set up WWW_ROOT
#
if [ -d /afs/slac/www ]; then
   export WWW_ROOT=/afs/slac/www
else 
   export WWW_ROOT=/usr/local/www 
fi

#
# Set up the rest of environment variables based on above root variables 
#
export FACILITY_ROOT=$LCLS_ROOT
export RTEMS=$LCLS_ROOT/rtems
export TOOLS=$LCLS_ROOT/tools
export TOOLS_DATA=$LCLS_DATA/tools
export LCLS_WWW=$WWW_ROOT/grp/lcls/controls

#export JAVA_HOME=$LCLS_ROOT/package/java/jdk${JAVAVER}
#export ANT_HOME=$LCLS_ROOT/package/ant/apache-ant-1.7.0
export PHYSDATA=$LCLS_DATA/physics

export EPICS_TOP=$LCLS_ROOT/epics
export EPICS_SETUP=$EPICS_TOP/setup

# IOC
export EPICS_IOC_TOP=$EPICS_TOP/iocTop

# Data
export APP=$EPICS_IOC_TOP
export EPICS_IOCS=$EPICS_TOP/iocCommon
if [ -d $EPICS_TOP/cpuBoot ]; then 
  export EPICS_CPUS=$EPICS_TOP/cpuBoot
  export CPU=$EPICS_CPUS
fi

export EPICS_DATA=$LCLS_DATA/epics
export EPICS_WWW=$WWW_ROOT/comp/unix/package/epics

#
# For running IOCs and iocConsole
#
if [ -z `echo $HOSTNAME | grep tftp` ]; then
  export IOC=$EPICS_IOCS
else
  export LCLS_TFTP=/tftpboot/g/lcls
  export IOC=$LCLS_TFTP/ioc/iocBoot
fi
export IOC_DATA=$EPICS_DATA/ioc/data
export IOC_OWNER=laci
export IOC_OWNER_OS=Linux
export IOC_OWNER_SHELL=bash
export IOC_SCREEN=$EPICS_IOCS/facility
export IOC_PRIM_MAP=slc/primary.map

#
# Setup remaining EPICS CA environment variables
#
if [ -e $EPICS_SETUP/envSet.bash ]; then
  . $EPICS_SETUP/envSet.bash
else
  echo $EPICS_SETUP/envSet.bash does not exist
fi

#
# Append to existing paths.
#

if [ -d $TOOLS/script ]; then
    if [ -z `echo $PATH | grep $TOOLS/script` ]; then
      export PATH=$PATH:$TOOLS/script
    fi 
fi
if [ -d $TOOLS/edm/script ]; then
    if [ -z `echo $PATH | grep $TOOLS/edm/script` ]; then
      export PATH=$PATH:$TOOLS/edm/script
    fi
fi

# Add $TOOLS/AlarmConfigTop/SCRIPT  
if [ -d $TOOLS/AlarmConfigsTop/SCRIPT ]; then
    if [ -z `echo $PATH | grep $TOOLS/AlarmConfigsTop/SCRIPT` ]; then
      export PATH=$PATH:$TOOLS/AlarmConfigsTop/SCRIPT
    fi
fi

#
# Add $LCLS_ROOT/bin to PATH
#
if [ -d $LCLS_ROOT/bin ]; then
    if [ -z `echo $PATH | grep $LCLS_ROOT/bin` ]; then
      export PATH=$PATH:$LCLS_ROOT/bin
    fi
fi
#
# Add X to PATH
#
if [ -d /usr/X11R6/bin ]; then
    if [ -z `echo $PATH | grep /usr/X11R6/bin` ]; then
      export PATH=$PATH:/usr/X11R6/bin
    fi
fi


# Add our LCLS Java Package to the path.
# Do not use the java provided by SCCS!!
#if [ -z `echo $PATH | grep $JAVA_HOME/bin` ]; then
#  export PATH=$JAVA_HOME/bin:$PATH
#fi

export SCREENBIN=/home/screen/bin

########################################################################
# Printer related environment variables
########################################################################
if [ -z $PSPRINTER ]; then
  export PSPRINTER=mcc_big
fi
if [ -z $PRINTER ]; then
  export PRINTER=mcc_big
fi
if [ -z $PSFILENAME ]; then
  export PSFILENAME=${USER}_default.ps
fi
# The first seven printers used by ArchiveViewer.
export EPICS_PR_LIST=svmcccolor:svmcc4035:mcc_big:hpmccprint:elog_rotate:acclog:elog_lcls:lclslog
export EPICS_PR_LIST=$EPICS_PR_LIST:$PSPRINTER
if [ -z `echo $EPICS_PR_LIST | grep betsy` ]; then
  export EPICS_PR_LIST=$EPICS_PR_LIST:betsy
fi
export EPICS_PR_LIST=$EPICS_PR_LIST:hpcolorb280r202:hpb280r202:hpcolorb280r202t:lcls-hpcolor163:lcls-hp163:lcls-hpcolor182:lcls-hp182

###############################################
# For StripTool
###############################################
export STRIP_FILE_SEARCH_PATH=$TOOLS_DATA/StripTool/data
export STRIP_CONFIGFILE_DIR=$TOOLS_DATA/StripTool/config

if [ -z $EPICS_DISPLAY_PATH ];  then
  export EPICS_DISPLAY_PATH=$STRIP_CONFIGFILE_DIR
fi
if [ -z `echo $EPICS_DISPLAY_PATH | grep $STRIP_CONFIGFILE_DIR` ]; then
  export EPICS_DISPLAY_PATH=$EPICS_DISPLAY_PATH:$STRIP_CONFIGFILE_DIR
fi

###############################################
# For Archive Browser
###############################################
export ARCHCONFIGFILES=$TOOLS_DATA/ArchiveBrowser/config
export ARCHDATAFILES=$TOOLS_DATA/ArchiveBrowser/data

###############################################
# For Alarm Handler
###############################################
export ALHCONFIGFILES=$TOOLS/alh/config
export ALARMHANDLER=$ALHCONFIGFILES
export ALHLOGFILES=$TOOLS_DATA/alh/log
export NETSCAPEPATH=firefox

