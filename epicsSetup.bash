#####################################################################
#                                                                   #
#  Title: epicsSetup.bash                                           #
#                                                                   #
#  Purpose: '.' this file to set your EPICS environment correctly   #
#           This file sets up edm, vdct and cmlog as part of the deal
#                                                                   #
#  History: 
#  02Jun2008 Jingchen Zhou add export NETSCAPEPATH=firefox for ALH  #
#  21Apr2008 Jingchen Zhou Updated to support AFS based development #
#                          environment                              #
#  10Feb2008 Jingchen Zhou Add quotation around CVSEDITOR           #
#  29Jan2008 Mike Zelazny  Remove XAL from epics setup              #
#  14jan2005 Dayle Kotturi Add to LD PATH (linux only) to find jca  #
#                          lib for XAL                              #
#  16Feb2005 K. Luchini    Added LCLS_TFTP,LCLS_CVS,IOC,IOC_DATA    #
#                          EPICS_SITE,EPICS_BASE_RELEASE,LCLS_WWW   #
#  18feb2005 Dayle Kotturi Added quotes around $CVSIGNORE in the if #
#                          zero length string test to protect       #
#                          contents from being parsed as an error   #
#  24Apr2005 D Rogind      Added IOC_OWNER_OS                       #
#  31May2005 S. Chevtsov   Added archiveviewer.jar to the CLASSPATH #
#  22jul2005 Dayle Kotturi add $EPICS_EXTENSIONS/bin/$EPICS_HOST_ARCH
#                          to PATH                                  #
#  25jul2005 K. Luchini    Add VDCT and plugins to class path       #
#                          and JAVAVER environment variable.        # 
#  26jul2005 K. Luchini    Changed path for VDCT plugins to         #
#                          javalib/vdct/*.jar                       #
#  20oct2005 Dayle Kotturi Change RTEMS version from 4.6.2 to 4.6.5 #
#  26oct2005 Dayle Kotturi Removed RTEMS_MAKEFILE_PATH definition   #
#  08dec2005 Dayle Kotturi Change CLASSPATH to point to TOOLS/javalib#
#  09Mar2006 Mike Zelazny  Added core* to CVSIGNORE                 #
#  23aug2006 K. Luchini    Added $TOOLS/edm/script to path          #
#  05Oct2006 Mike Zelazny  Set LCLS_DATA based on dir availability     #
#                          instead of node name.                    #
#  16Apr2007 Jingchen Zhou Set LCLS_DATA based on HOSTNAME             #
#                          Remove the conditional check for         # 
#                          ALHLOGFILES and just set it.             #
# 24Apr2007 Jingchen Zhou  Removed STRIPCONFIGFILES STRIPDATAFILES  #
#                          Defined STRIP_FILE_SEARCH_PATH and       #
#                          STRIP_FILE_SEARCH_PATH                   #
# 22May2007 Jingchen Zhou Added PHYSDATA, a data area for physicists #
# 30Oct2007 Jingchen Zhou updated to support standalone production #
#            environment     
# 07Dec2007 Jingchen Zhou Added $LCLS_ROOT/bin to PATH             #
#####################################################################
umask 002      
HOSTNAME=`hostname`
#
# Set up LCLS_ROOT
#
if [ -d /afs/slac/g/lcls ]; then
   export LCLS_ROOT=/afs/slac/g/lcls
else 
   export LCLS_ROOT=/usr/local/lcls 
fi
#
# Set up LCLS_DATA
#
if [ -d /nfs/slac/g/lcls ]; then
   export LCLS_DATA=/nfs/slac/g/lcls  
elif [ -d /u1/lcls ]; then
   export LCLS_DATA=/u1/lcls
else
   export LCLS_DATA=	
#   echo "ERROR: this ${HOSTNAME} is not supported for LCLS dev/prod" 
#   exit 1		
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
export RTEMS=$LCLS_ROOT/rtems
export TOOLS=$LCLS_ROOT/tools
export TOOLS_DATA=$LCLS_DATA/tools
export LCLS_WWW=$WWW_ROOT/grp/lcls/controls
#export JAVAVER=1.5
export JAVA_HOME=$LCLS_ROOT/package/java/jdk1.6.0_02
export ANT_HOME=$LCLS_ROOT/package/ant/apache-ant-1.7.0
export PHYSDATA=$LCLS_DATA/physics

export EPICS_SETUP=$LCLS_ROOT/epics/setup
export HOST_ARCH=`$EPICS_SETUP/HostArch`

export EPICS_TOP=$LCLS_ROOT/epics
export EPICS_BASE_TOP=$EPICS_TOP/base
export EPICS_BASE_RELEASE=$EPICS_BASE_TOP/${EPICS_BASE_VER}
export EPICS_EXTENSIONS=$EPICS_TOP/extensions/extensions-${EPICS_EXTENSIONS_VER}

export EPICS_MODULES_TOP=$EPICS_TOP/modules
export EPICS_IOC_TOP=$EPICS_TOP/iocTop
export APP=$EPICS_IOC_TOP

export EPICS_IOCS=$EPICS_TOP/iocCommon

export EPICS_DATA=$LCLS_DATA/epics
export EPICS_WWW=$WWW_ROOT/comp/unix/package/epics
export EPICS_HOST_ARCH=`$EPICS_BASE_RELEASE/startup/EpicsHostArch`
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
export IOC_SCREEN=$EPICS_TOP/iocCommon
export IOC_PRIM_MAP=slc/primary.map
#
# For CVS
#
if [ -z $CVSROOT ]; then
   if [ -d /afs/slac/g/lcls/cvs ]; then
  	export CVSROOT=/afs/slac/g/lcls/cvs
   else
	USER=`whoami`
#	export CVSROOT=:ext:${USER}@lcls-prod02:/afs/slac/g/lcls/cvs
   fi
fi
export CVS_RSH=ssh

if [ -z "$CVSIGNORE" ]; then
  export CVSIGNORE="O.* *~ *.class *.BAK core*"
fi
if [ -z "$CVSEDITOR" ]; then
  export CVSEDITOR=emacs
fi
#
# Setup remaining EPICS CA environment variables
#
if [ -e $EPICS_SETUP/envSet.bash ]; then
  . $EPICS_SETUP/envSet.bash
else
  echo $EPICS_SETUP/envSet.bash does not exist
fi
#
# Add EPICS base and extensions to PATH
#
# Append to existing paths. Desired order is to search system, then base/bin, 
# then extensions/bin, then tools/script, then xal/script
#
if [ -z `echo $PATH | grep $EPICS_BASE_RELEASE/bin/$EPICS_HOST_ARCH` ]; then
  if [ ! -z $DEBUG ]; then
    echo Unable to find $EPICS_BASE_RELEASE/bin/$EPICS_HOST_ARCH in PATH so adding
  fi
  export PATH=$PATH:$EPICS_BASE_RELEASE/bin/$EPICS_HOST_ARCH
fi
if [ -z `echo $PATH | grep $EPICS_EXTENSIONS/bin/$EPICS_HOST_ARCH` ]; then
   export PATH=$PATH:$EPICS_EXTENSIONS/bin/$EPICS_HOST_ARCH   
fi
#
# Add xal and tool scripts to PATH
#
if [ -z `echo $PATH | grep $TOOLS/bin/$EPICS_HOST_ARCH` ]; then
  export PATH=$PATH:$TOOLS/bin/$EPICS_HOST_ARCH
fi 
if [ -z `echo $PATH | grep $TOOLS/script` ]; then
  export PATH=$PATH:$TOOLS/script
fi 
if [ -z `echo $PATH | grep $TOOLS/edm/script` ]; then
  export PATH=$PATH:$TOOLS/edm/script
fi
#
# Add $LCLS_ROOT/bin to PATH
#
if [ -z `echo $PATH | grep $LCLS_ROOT/bin` ]; then
  export PATH=$PATH:$LCLS_ROOT/bin
fi

if [ ! -z $DEBUG ]; then
  echo PATH is $PATH
fi
# Add procServ
export PATH=$TOOLS/procServ:$PATH
#
# Add system areas to LD_LIBRARY_PATH (for graphics and java)
#
if [ $HOST_ARCH=="Linux" ]; then
# To avoid pthread_cancel() crash when exiting a CA client. 
#  export LD_ASSUME_KERNEL=2.4.1
#  export JAVA_HOME=$JAVA_HOME/i386_linux2/jdk$JAVAVER
  export SCREENBIN=/home/screen/bin
  if [ -z $LD_LIBRARY_PATH ];  then
    export LD_LIBRARY_PATH=/usr/X11R6/lib
  fi
  if [ -z `echo $LD_LIBRARY_PATH | grep /usr/X11R6/lib` ]; then
    export LD_LIBRARY_PATH=/usr/X11R6/lib:$LD_LIBRARY_PATH
  fi
  # to find libjava.so
  if [ -z `echo $LD_LIBRARY_PATH | grep $JAVA_HOME/jre/lib/i386` ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_HOME/jre/lib/i386
  fi
  # to find libjvm.so
  if [ -z `echo $LD_LIBRARY_PATH | grep $JAVA_HOME/jre/lib/i386/server` ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_HOME/jre/lib/i386/server
  fi
else
  if [ $HOST_ARCH=="solaris" ]; then
  export JAVA_HOME=$JAVA_HOME/sun4x_55/jdk$JAVAVER
  export SCREENBIN=/opt/screen/bin
  if [ -z $LD_LIBRARY_PATH ]; then #give it the basics
    export LD_LIBRARY_PATH=/usr/openwin/lib:/usr/dt/lib:/usr/local/lib
  fi
  if [ -z `echo $LD_LIBRARY_PATH | grep /usr/local/lib` ]; then
    export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
  fi
  if [ -z `echo $LD_LIBRARY_PATH | grep /usr/dt/lib` ]; then
    export LD_LIBRARY_PATH=/usr/dt/lib:$LD_LIBRARY_PATH
  fi
  if [ -z `echo $LD_LIBRARY_PATH | grep /usr/openwin/lib` ]; then
    export LD_LIBRARY_PATH=/usr/openwin/lib:$LD_LIBRARY_PATH
  fi
  # to find libjava.so
  if [ -z `echo $LD_LIBRARY_PATH | grep $JAVA_HOME/jre/lib/sparc` ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_HOME/jre/lib/sparc
  fi
  # to find libjvm.so
  if [ -z `echo $LD_LIBRARY_PATH | grep $JAVA_HOME/jre/lib/sparc/server` ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_HOME/jre/lib/sparc/server
  fi
  fi
fi
#
# Add EPICS base and extensions to LD_LIBRARY_PATH
#
if [ -z `echo $LD_LIBRARY_PATH | grep $EPICS_BASE_RELEASE/lib/$EPICS_HOST_ARCH` ]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EPICS_BASE_RELEASE/lib/$EPICS_HOST_ARCH
fi
if [ -z `echo $LD_LIBRARY_PATH | grep $EPICS_EXTENSIONS/lib/$EPICS_HOST_ARCH` ]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EPICS_EXTENSIONS/lib/$EPICS_HOST_ARCH
fi
#
# Add xal libraries to LD_LIBRARY_PATH
#
if [ -z `echo $LD_LIBRARY_PATH | grep $TOOLS/lib/$EPICS_HOST_ARCH` ]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TOOLS/lib/$EPICS_HOST_ARCH
fi

if [ ! -z $DEBUG ]; then
  echo Check epicsSetup.bash: LD_LIBRARY_PATH is $LD_LIBRARY_PATH
fi

########################################################################
# Printer related environment variables
########################################################################
if [ -z $PSPRINTER ]; then
  export PSPRINTER=betsy
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

########################################################################
# For edm 
########################################################################
export EDMSETUP=$TOOLS/edm/config
if [ -r $EDMSETUP/setup.sh ]; then
  . $EDMSETUP/setup.sh > /dev/null
fi

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

########################################################################
# For cmlog
########################################################################
export CMLOGSETUP=$LCLS_ROOT/package/cmlog/config
if [ -r $CMLOGSETUP/cmlogSetup.bash ]; then
  . $CMLOGSETUP/cmlogSetup.bash > /dev/null
fi
