#!/bin/bash

# 
# Use lsb_release to determine which linux distribution we're using
# lsb_release is the standard cmd line tool for displaying release information
# LSB is a standard from the Free Standards Group and stands for Linux Standard Base
#
# First, determine the release family
# Use the -i option to get the distributor id
LSB_DIST_ID=`LD_LIBRARY_PATH= lsb_release -i | /bin/cut -f2`

# Check for rhel family: RedHatEnterpriseClient and RedHatEnterpriseServer
LSB_FAMILY=`/bin/echo $LSB_DIST_ID | /bin/sed -e "s/RedHatEnterprise.*/rhel/"`

# TODO: Add tests for Ubuntu, SUSE, Mint, etc.
#? LSB_FAMILY=`/bin/echo $LSB_FAMILY | /bin/sed -e "s/SuSE.*/suse/"`
#? LSB_FAMILY=`/bin/echo $LSB_FAMILY | /bin/sed -e "s/Ubuntu.*/ubu/"`
#? LSB_FAMILY=`/bin/echo $LSB_FAMILY | /bin/sed -e "s/Mint.*/mint/"`

# Get the primary release number
# For example, if "lsb_release -r" reports 5.8, our primary release is 5
LSB_REL=`LD_LIBRARY_PATH= lsb_release -r | /bin/cut -f2 | /bin/cut -d. -f1`
# Append the release number
# For example, rhel5
LSB_FAMILY=`/bin/echo ${LSB_FAMILY}${LSB_REL}`

pathpurge()
{
	PATH=`echo $PATH | sed -e "s%^$1$%%"`
	PATH=`echo $PATH | sed -e "s%^\(.*\):$1$%\1%"`
	PATH=`echo $PATH | sed -e "s%^\(.*\):$1:\(.*\)$%\1:\2%"`
	PATH=`echo $PATH | sed -e "s%^$1:\(.*\)$%\1%"`
}

pathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: pathmunge dirname
		return
	fi
	if [ "$PATH" == "" ] ; then
		export PATH=$1
		return
	fi
	pathpurge $1
	export PATH=$1:$PATH
}

edmpathpurge()
{
	EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%^$1$%%"`
	EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%^\(.*\):$1$%\1%"`
	EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%^\(.*\):$1:\(.*\)$%\1:\2%"`
	EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%^$1:\(.*\)$%\1%"`
}

edmpathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: edmpathmunge dirname
		return
	fi
	if [ "$EDMDATAFILES" == "" -o "$EDMDATAFILES" == "$1" ] ; then
		export EDMDATAFILES=$1
		return
	fi
	edmpathpurge $1
	export EDMDATAFILES=$1:$EDMDATAFILES
}

ldpathpurge()
{
	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%^$1$%%"`
	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%^\(.*\):$1$%\1%"`
	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%^\(.*\):$1:\(.*\)$%\1:\2%"`
	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%^$1:\(.*\)$%\1%"`
}

ldpathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: ldpathmunge dirname
		return
	fi
	if [ "$LD_LIBRARY_PATH" == "" -o "$LD_LIBRARY_PATH" == "$1" ] ; then
		export LD_LIBRARY_PATH=$1
		return
	fi
	ldpathpurge $1
	export LD_LIBRARY_PATH=$1:$LD_LIBRARY_PATH
}

pythonpathpurge()
{
	PYTHONPATH=`echo $PYTHONPATH | sed -e "s%^$1$%%"`
	PYTHONPATH=`echo $PYTHONPATH | sed -e "s%^\(.*\):$1$%\1%"`
	PYTHONPATH=`echo $PYTHONPATH | sed -e "s%^\(.*\):$1:\(.*\)$%\1:\2%"`
	PYTHONPATH=`echo $PYTHONPATH | sed -e "s%^$1:\(.*\)$%\1%"`
}

pythonpathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: pythonpathmunge dirname
		return
	fi
	if [ "$PYTHONPATH" == "" -o "$PYTHONPATH" == "$1" ] ; then
		export PYTHONPATH=$1
		return
	fi
	pythonpathpurge $1
	export PYTHONPATH=$1:$PYTHONPATH
}

