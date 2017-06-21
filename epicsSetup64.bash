#-*-sh-*-
#####################################################################
#                                                                   #
#  Title: epicsSetup.bash                                           #
#                                                                   #
#  Purpose: Source this file to set your EPICS environment.         #
#           This file sets up all EPICS clients side paths etc.     #
#           See also envSet*.bash for the runtime connection conf.  #
#                                                                   #
#  History:                                                         #
#  21Jun2017 K.Luchini     Chg IOC_SCREENS to $EPICS_IOCS/facility  #
#  30Mar2017 K.Luchini     Add EPICS_CPUS,CPU,TFTPBOOT and          #
#                          FACILITY_ROOT                            # 
#  17Feb2017 B. Hill       Per Jingchen, created 64 bit variant     #
#  29Apr2016 M Shankar     Per Jingchen, created softlinks to all   #
#                          the .so files in V4 in a lib/linux-x86   #
#                          and add that single directory to         # 
#                          LD_LIBRARY_PATH                          #
#  26Apr2016 M Shankar     Version in ${TOOLS}/script has extra     #
#                          PATH of $TOOLS/AlarmConfigsTop/SCRIPT    #
#                          Added these lines into CVS               #
#  26Apr2016 M Shankar     Change V4 to 4.5                         #
#  18Aug2015 Greg White    Added EPICS Version 4 (specifically      #
#                          4.4.0). And add path stat checks.        #
#  14Jul2014 Jingchen Zhou set EPICS_HOST_ARCH = linux-x86 during   #
#                          the transition to 64 bit.                #
#  06Nov2013 Jingchen Zhou remove CMLOG                             # 
#  08Apr2013 Jingchen Zhou Keep prod and dev in sycn                # 
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
# Set up LCLS_ROOT
#
if [ -d /afs/slac/g/lcls ]; then
   export LCLS_ROOT=/afs/slac/g/lcls
   export IOCCONSOLE_ENV=Dev
   export TFTPBOOT=/afs/slac/g/lcls/tftpboot
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

export JAVA_HOME=$LCLS_ROOT/package/java/jdk${JAVAVER}
export ANT_HOME=$LCLS_ROOT/package/ant/apache-ant-1.7.0
export PHYSDATA=$LCLS_DATA/physics

export EPICS_SETUP=$LCLS_ROOT/epics/setup
export HOST_ARCH=`$EPICS_SETUP/HostArch`

export EPICS_TOP=$LCLS_ROOT/epics

# Base
export EPICS_BASE_TOP=$EPICS_TOP/base
export EPICS_BASE_RELEASE=$EPICS_BASE_TOP/${EPICS_BASE_VER}

# V4
EPICS_PVCPP=${EPICS_BASE_TOP}/base-cpp-R4-5-0
EPICS_PVJAVA=${EPICS_BASE_TOP}/base-java-R4-5-0

# Extensions
export EPICS_EXTENSIONS=$EPICS_TOP/extensions/extensions-${EPICS_EXTENSIONS_VER}
# Modules
if [ -z $EPICS_MODULES_TOP ]; then
   export EPICS_MODULES_TOP=$EPICS_TOP/modules/${EPICS_MODULES_VER}
fi

# IOC
if [ -z $EPICS_IOC_TOP ]; then
   export EPICS_IOC_TOP=$EPICS_TOP/iocTop
fi

# Data
export APP=$EPICS_IOC_TOP
export EPICS_IOCS=$EPICS_TOP/iocCommon
if [ -d $EPICS_TOP/cpuBoot ]; then
  export EPICS_CPUS=$EPICS_TOP/cpuBoot
  export CPU=$EPICS_CPUS
fi
export EPICS_DATA=$LCLS_DATA/epics
export EPICS_WWW=$WWW_ROOT/comp/unix/package/epics
# Set EPICS_HOST_ARCH via current EPICS BASE release of EpicsHostArch script
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


# Add EPICS base, V4, and extensions to PATH
#
# Append to existing paths. Desired order is to search system, then base/bin, 
# then extensions/bin, then tools/script, then xal/script
#

# Base
if [ -z `echo $PATH | grep $EPICS_BASE_RELEASE/bin/$EPICS_HOST_ARCH` ]; then
  if [ ! -z $DEBUG ]; then
    echo Unable to find $EPICS_BASE_RELEASE/bin/$EPICS_HOST_ARCH in PATH so adding
  fi
  export PATH=$EPICS_BASE_RELEASE/bin/$EPICS_HOST_ARCH:$PATH
fi

# EPICS V4
if [ -z `echo $PATH | grep ${EPICS_PVCPP}/pvAccessCPP/bin/${EPICS_HOST_ARCH}` ]; then
    export PATH=${EPICS_PVCPP}/pvAccessCPP/bin/${EPICS_HOST_ARCH}:$PATH
fi

# Extensions
if [ -z `echo $PATH | grep $EPICS_EXTENSIONS/bin/$EPICS_HOST_ARCH` ]; then
   export PATH=$EPICS_EXTENSIONS/bin/$EPICS_HOST_ARCH:$PATH   
fi

# Add xal and tool scripts to PATH
if [ -z `echo $PATH | grep $TOOLS/bin/$EPICS_HOST_ARCH` ]; then
  export PATH=$PATH:$TOOLS/bin/$EPICS_HOST_ARCH
fi 
if [ -z `echo $PATH | grep $TOOLS/script` ]; then
  export PATH=$PATH:$TOOLS/script
fi 
if [ -z `echo $PATH | grep $TOOLS/edm/script` ]; then
  export PATH=$PATH:$TOOLS/edm/script
fi

# Add $TOOLS/AlarmConfigTop/SCRIPT  
if [ -z `echo $PATH | grep $TOOLS/AlarmConfigsTop/SCRIPT` ]; then
  export PATH=$PATH:$TOOLS/AlarmConfigsTop/SCRIPT
fi

#
# Add $LCLS_ROOT/bin to PATH
#
if [ -z `echo $PATH | grep $LCLS_ROOT/bin` ]; then
  export PATH=$PATH:$LCLS_ROOT/bin
fi
#
# Add X to PATH
#
if [ -z `echo $PATH | grep /usr/X11R6/bin` ]; then
  export PATH=$PATH:/usr/X11R6/bin
fi

# Print and stat check PATH if DEBUG is defined.
if [ ! -z $DEBUG ]; then
  echo epicsSetup_dev.bash: PATH check:
  echo -n ${PATH} | xargs -r -d: stat -c %n
fi

# Add procServ
export PATH=$TOOLS/procServ:$PATH

# Add our LCLS Java Package to the path.
# Do not use the java provided by SCCS!!
if [ -z `echo $PATH | grep $JAVA_HOME/bin` ]; then
  export PATH=$JAVA_HOME/bin:$PATH
fi

#
# Add system areas to LD_LIBRARY_PATH (for graphics and java)
#
if [ $HOST_ARCH=="Linux" ]; then
  export SCREENBIN=/home/screen/bin
  if [ -z $LD_LIBRARY_PATH ];  then
    export LD_LIBRARY_PATH=/usr/X11R6/lib
  fi
  if [ -z `echo $LD_LIBRARY_PATH | grep /usr/X11R6/lib` ]; then
    export LD_LIBRARY_PATH=/usr/X11R6/lib:$LD_LIBRARY_PATH
  fi
  # to find libjava.so
  if [ -z `echo $LD_LIBRARY_PATH | grep $JAVA_HOME/jre/lib/amd64` ]; then
    export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64:$LD_LIBRARY_PATH 
  fi
  # to find libjvm.so
  if [ -z `echo $LD_LIBRARY_PATH | grep $JAVA_HOME/jre/lib/amd64/server` ]; then
    export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH
  fi
  # to find libtcl8.5.so and libtk8.5.so
  if [ -z `echo $LD_LIBRARY_PATH | grep $LCLS_ROOT/package/python/tcltk/lib` ]; then
    export LD_LIBRARY_PATH=$LCLS_ROOT/package/python/tcltk/lib:$LD_LIBRARY_PATH
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
  export LD_LIBRARY_PATH=$EPICS_BASE_RELEASE/lib/$EPICS_HOST_ARCH:$LD_LIBRARY_PATH
fi
if [ -z `echo $LD_LIBRARY_PATH | grep $EPICS_EXTENSIONS/lib/$EPICS_HOST_ARCH` ]; then
  export LD_LIBRARY_PATH=$EPICS_EXTENSIONS/lib/$EPICS_HOST_ARCH:$LD_LIBRARY_PATH
fi

#
# Add EPICS V4 core to LD_LIBRARY_PATH
# Instead of adding all the paths to the LD_LIBRARY_PATH, per Jingchen, create softlinks in a lib/linux-x86 folder to all the .so files in ../..
# And then add that single path (lib/linux-x86) instead.
#
if [ -z `echo $LD_LIBRARY_PATH | grep ${EPICS_PVCPP}/lib/${EPICS_HOST_ARCH}` ]; then
  export LD_LIBRARY_PATH=${EPICS_PVCPP}/lib/${EPICS_HOST_ARCH}:$LD_LIBRARY_PATH
fi

#
# Add xal libraries to LD_LIBRARY_PATH
#
if [ -z `echo $LD_LIBRARY_PATH | grep $TOOLS/lib/$EPICS_HOST_ARCH` ]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TOOLS/lib/$EPICS_HOST_ARCH
fi

if [ ! -z $DEBUG ]; then
  echo epicsSetup.bash LD_LIBRARY_PATH check:
  echo -n ${LD_LIBRARY_PATH} | xargs -r -d: stat -c %n
  echo "Checking Java version in epicsSetup"
  java -version
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
#export CMLOGSETUP=$LCLS_ROOT/package/cmlog/config
#if [ -r $CMLOGSETUP/cmlogSetup.bash ]; then
#  . $CMLOGSETUP/cmlogSetup.bash > /dev/null
#fi
