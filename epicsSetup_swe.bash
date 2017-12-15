#####################################################################
#                                                                   #
#  Title: epicsSetup_swe.bash                                       #
#                                                                   #
#  Purpose: '.' this file to set your EPICS environment correctly   #
#           This file sets up edm, vdct and cmlog as part of the deal
#                                                                   #
#  History:                                                         # 
#  14Sept2011 Ernest Williams : cloned FACET setup                  #
#  19Jul2011 Jingchen Zhou changed setup.sh to setup_facet for edm  #
#  01Feb2011 jrock         changed ALHCONFIGFILES to facet dir      #
#  02Nov2010 Jingchen Zhou Cloned from LCLS epicsSetup.bash         #
#  17Nov2009 Jingchen Zhou Moved CVS part from epicsSetup.bash to   #
#                          commonSetup.bash                         #
#  05Nov2009 Jingchen Zhou Added to LD_LIBRARY_PATH for python to   #
#                          to find tcltk.                           # 	
#  28May2009 Judy Rock     Added logic to point to dev SCREENIOCS   #
#                          on development, prod on production       #
#  11Nov2008 Jingchen Zhou Added /usr/X11R6/bin in PATH             #
#                          to ensure xwd available for nonlogin     #
#  15Sep2008 Jingchen Zhou Added a logic to EPICS_MODULES_TOP and   #
#                          EPICS_IOC_TOP to allow user defined on   #
#                          Ernest's request for relocatability      #    
#  18Jun2008 Jingchen Zhou Updated PRINTER and PSPRINTER            #
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
# Set up SWE_ROOT
#
if [ -d /afs/slac/g/cd/swe/rhel5 ]; then
   export SWE_ROOT=/afs/slac/g/cd/swe/rhel5
   export IOCCONSOLE_ENV=Dev
fi
#
# Set up SWE_DATA
#
if [ -d /nfs/slac/g/cd/swe ]; then
   export SWE_DATA=/nfs/slac/g/cd/swe  
fi
#
# Set up WWW_ROOT
#
if [ -d /afs/slac/www ]; then
   export WWW_ROOT=/afs/slac/www
fi

#
# Set up the rest of environment variables based on above root variables 
#
export RTEMS_DEV=/afs/slac/package/rtems
export VXWORKS_DEV=/afs/slac/package/vxworks
export PACKAGE=$SWE_ROOT/package
export TOOLS=$SWE_ROOT/tools
export TOOLS_DATA=$SWE_DATA/tools
export FACET_WWW=$WWW_ROOT/grp/cd

# =============================================================
# Setup Java, Netbeans and Ant
export JAVA_HOME=$SWE_ROOT/package/java/jdk${JAVA_VER}
export ANT_HOME=$SWE_ROOT/package/ant/apache-ant-1.8.2
export NETBEANS_HOME=$SWE_ROOT/package/netbeans/netbeans-${NETBEANS_VER}
# =============================================================

export PHYSDATA=$SWE_DATA/physics

export EPICS_SETUP=$SWE_ROOT/epics/setup
export HOST_ARCH=`$EPICS_SETUP/HostArch`

export EPICS_TOP=$SWE_ROOT/epics
export EPICS_BASE_TOP=$EPICS_TOP/base
export EPICS_BASE_RELEASE=$EPICS_BASE_TOP/${EPICS_BASE_VER}
export EPICS_EXTENSIONS=$EPICS_TOP/extensions/extensions-${EPICS_EXTENSIONS_VER}

if [ -z $EPICS_MODULES_TOP ]; then
   export EPICS_MODULES_TOP=$EPICS_TOP/modules/${EPICS_MODULES_VER}
fi
if [ -z $EPICS_IOC_TOP ]; then
   export EPICS_IOC_TOP=$EPICS_TOP/iocTop/${EPICS_IOC_VER}
fi

export APP=$EPICS_IOC_TOP

export EPICS_IOCS=$EPICS_TOP/iocCommon

export EPICS_DATA=$SWE_DATA/epics
export EPICS_WWW=$WWW_ROOT/comp/unix/package/epics
export EPICS_HOST_ARCH=`$EPICS_BASE_RELEASE/startup/EpicsHostArch`
#
# For running iocConsole
#
export IOC_DATA=$EPICS_DATA/ioc/data
export IOC_OWNER=laci
export IOC_OWNER_OS=Linux
export IOC_OWNER_SHELL=bash
export IOC_SCREEN=$EPICS_TOP/iocCommon/All/$IOCCONSOLE_ENV

#
# Setup remaining EPICS CA environment variables
#
if [ -e $EPICS_SETUP/envSet_swe.bash ]; then
  . $EPICS_SETUP/envSet_swe.bash
else
  echo $EPICS_SETUP/envSet_swe.bash does not exist
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
  export PATH=$EPICS_BASE_RELEASE/bin/$EPICS_HOST_ARCH:$PATH
fi
if [ -z `echo $PATH | grep $EPICS_EXTENSIONS/bin/$EPICS_HOST_ARCH` ]; then
   export PATH=$EPICS_EXTENSIONS/bin/$EPICS_HOST_ARCH:$PATH   
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

# Add procServ
export PATH=$TOOLS/procServ:$PATH

# Add our Java Package to the path.
# Do not use the java provided by SCCS!!
if [ -z `echo $PATH | grep $JAVA_HOME/bin` ]; then
  export PATH=$JAVA_HOME/bin:$PATH
fi

#
# Add system areas to LD_LIBRARY_PATH (for graphics and java)
#

  export SCREENBIN=/home/screen/bin
  
  # to find libjava.so
  if [ -z `echo $LD_LIBRARY_PATH | grep $JAVA_HOME/jre/lib/i386` ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_HOME/jre/lib/i386
  fi
  # to find libjvm.so
  if [ -z `echo $LD_LIBRARY_PATH | grep $JAVA_HOME/jre/lib/i386/server` ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_HOME/jre/lib/i386/server
  fi
  if [ -z `echo $LD_LIBRARY_PATH | grep /usr/local/lib` ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
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

########################################################################
# For edm 
########################################################################
export EDMSETUP=$TOOLS/edm/config
if [ -r $EDMSETUP/setup_facet.sh ]; then
  . $EDMSETUP/setup_facet.sh > /dev/null
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
export ALHCONFIGFILES=$TOOLS/alh/config-facet
export ALARMHANDLER=$ALHCONFIGFILES
export ALHLOGFILES=$TOOLS_DATA/alh/log
export NETSCAPEPATH=firefox

########################################################################
# For cmlog
########################################################################
export CMLOGSETUP=$FACET_ROOT/package/cmlog/config
if [ -r $CMLOGSETUP/cmlogSetup.bash ]; then
  . $CMLOGSETUP/cmlogSetup.bash > /dev/null
fi
