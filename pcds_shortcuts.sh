#!/bin/bash
#
# This script creates several shell functions that can be
# usefull shortcuts in the PCDS EPICS environment.
#
# Copyright @2010 SLAC National Accelerator Laboratory

# Convenience functions
#	show_epics_sioc [ all | hostname ] ...
#		Shows all procServ info on local or specified host
#	show_epics_versions [ base | module ] ...
#		Shows the release versions for the specified modules
#	amo
#	sxr
#	tst
#	xtod
#	amolas
#	sxrlas
#	xpp
#		These functions all pushd to the edm screens home
#		directory and launch the home screen
#

export PKGS=/reg/g/pcds/package

function show_epics_sioc_filter( )
{
	EXPAND_TABS='/usr/bin/expand --tabs=6,16,42,52,72'
	ps -C procServ -o pid,user,command		|\
                /bin/sed -e "s/\S*procServ /procServ /"  \
                         -e "s/--savelog//"              \
                         -e "s/--allow//"                \
                         -e "s/--ignore\s*\S*//"         \
                         -e "s/--coresize\s*\S*//"       \
                         -e "s/--logfile\s*\S*//"        \
                         -e "s/--noautorestart//"        \
                         -e "s/--logstamp//"             \
                         -e "s/--name\s*\(\S\+\)\s*\([0-9]\+\)/\2 \1/"  \
                         -e "s^/reg/g/pcds\S*caRepeater^caRepeater^"    \
                         -e "s/^/$HOSTNAME\t/"                          \
                         -e "s/  */\t/g"                                \
                         -e "/PID\tUSER\tCOMMAND/d"                    |\
                gawk '{ OFS="\t"; print $2,$3,$6,$4,$1,$5}'            |\
                $EXPAND_TABS
	return
}
export show_epics_sioc_filter

function show_epics_sioc( )
{
	EXPAND_TABS='/usr/bin/expand --tabs=6,16,42,52,72'
	echo "PID	USER-ID	SIOC	COMMAND	HOSTNAME	PORT" | $EXPAND_TABS
	if [ ! $1 ];
	then
		show_epics_sioc_filter
	else
		for a in $*;
		do
			if [ $a != "all" ];
			then
				ssh $a show_epics_sioc_filter
			else
				for h in /reg/d/iocCommon/hosts/*;
				do
					if [ ! -f $h/startup.cmd ]; then continue; fi
					ssh $(basename $h) show_epics_sioc_filter
				done
			fi
		done
	fi
	return
}
export show_epics_sioc
alias psproc=show_epics_sioc

function show_epics_versions( )
{
	if [ $1 ];
	then
		for m in $*;
		do
			if [ $m == "base" ];
			then
				/bin/ls -F -td $EPICS_SITE_TOP/base/*	|\
				/bin/sed -e "s^$EPICS_SITE_TOP/\([a-zA-Z0-9_-]*\)/\([a-zA-Z0-9.-]*\)/^\1\t\2^" |\
				/usr/bin/expand --tabs=1,25 | egrep "R[0-9]";
				continue;
			fi
			if [ -d $EPICS_SITE_TOP/modules/$m	];
			then
				/bin/ls -F -td $EPICS_SITE_TOP/modules/$m/*	|\
				/bin/sed -e "s^$EPICS_SITE_TOP/\(modules/\)\?\([a-zA-Z0-9_/-]*\)/\(R[a-zA-Z0-9.-]*\)/^\2\t\3^" |\
				/usr/bin/expand --tabs=1,25 | egrep "R[0-9]";
				continue;
			fi
			if [ -d $EPICS_SITE_TOP/ioc/$m	];
			then
				/bin/ls -F -td $EPICS_SITE_TOP/ioc/$m/*	|\
				/bin/sed -e "s^$EPICS_SITE_TOP/\(ioc/\)\?\([a-zA-Z0-9_/-]*\)/\(R[a-zA-Z0-9.-]*\)/^\2\t\3^" |\
				/usr/bin/expand --tabs=1,25 | egrep "R[0-9]";
				continue;
			fi
			if [ -d $EPICS_SITE_TOP/$m	];
			then
				/bin/ls -F -td $EPICS_SITE_TOP/$m/*	|\
				/bin/sed -e "s^$EPICS_SITE_TOP/\([a-zA-Z0-9_/-]*\)/\(R[a-zA-Z0-9.-]*\)/^\1\t\2^" |\
				/usr/bin/expand --tabs=1,25 | egrep "R[0-9]";
				continue;
			fi
			echo Unknown module: $m;
		done;
		return 0;
	fi
	for d in $EPICS_SITE_TOP/base $EPICS_SITE_TOP/modules/*;
	do	
		if [ ! -d $d ]; then continue; fi;
		/bin/ls -F -td $d/*	| head -1	|\
		/bin/sed -e "s^$EPICS_SITE_TOP/\(modules/\)\?\([a-zA-Z0-9_/-]*\)/\(R[a-zA-Z0-9.-]*\)/^\2\t\3^" |\
		/usr/bin/expand --tabs=1,25 | egrep "R[0-9]";
	done
}
export show_epics_versions

function find_pv( )
{
	if [ $# -eq 0 ];
	then
		echo Usage: find_pv pv_name [pv_name2 ...]
		echo This script will search for each specified EPICS PV in:
		echo "  /reg/d/iocData/ioc*/iocInfo/IOC.pvlist"
		echo ""
		echo Then it looks for the linux host or hard IOC hostname in:
		echo "  /reg/d/iocCommon/hosts/ioc*/startup.cmd"
		echo "  /reg/d/iocCommon/hioc/ioc*/startup.cmd"
		echo "If no host is found, the IOC will not autoboot after a power cycle!"
		echo ""
		echo Finally it looks for the boot directory in:
		echo "  /reg/d/iocCommon/{hioc,sioc}/<ioc-name>/startup.cmd"
		echo ""
		echo "Hard IOC boot directories are shown with the nfs mount name."
		echo "Typically this is /iocs mounting /reg/g/pcds/package/epics/ioc"
		return 1;
	fi 
	for pv in $*;
	do
		echo PV: $pv
		ioc_list=`/bin/egrep -l -e "$pv" /reg/d/iocData/ioc*/iocInfo/IOC.pvlist | /bin/cut -d / -f5`
		for ioc in $ioc_list;
		do
			echo "  IOC: $ioc"

			# Look for IOC PV root
			ioc_pv=`/bin/egrep UPTIME /reg/d/iocData/$ioc/iocInfo/IOC.pvlist | /bin/sed -e "s/:UPTIME.*//"`
			if (( ${#ioc_pv} == 0 ));
			then
				echo "  IOC_PV: Not found!"
			else
				echo "  IOC_PV: $ioc_pv"
			fi

			# Look for linux hosts
			host_list=`/bin/egrep -l -e "$ioc" /reg/d/iocCommon/hosts/ioc*/startup.cmd | /bin/cut -d / -f6`
			for h in $host_list;
			do
				echo "  HOST: $h"
			done

			if [ -f /reg/d/iocCommon/sioc/$ioc/startup.cmd ];
			then
				# Look for soft IOC boot directories
				boot_list=`/bin/egrep -w -e "^cd" /reg/d/iocCommon/sioc/$ioc/startup.cmd | /bin/awk '{ print $2}'`
				if (( ${#boot_list} ));
				then
					echo "  STARTUP: /reg/d/iocCommon/sioc/$ioc/startup.cmd"
					for d in $boot_list;
					do
						echo "  BOOT_DIR: $d"
					done
				fi
			fi

			# Look for hard ioc
			hioc_list=`/bin/egrep -l -e "$ioc" /reg/d/iocCommon/hioc/ioc*/startup.cmd | /bin/cut -d / -f6`
			if (( ${#hioc_list} ));
			then
				for hioc in $hioc_list;
				do
					echo "  HIOC: $hioc"
					echo "  STARTUP: /reg/d/iocCommon/hioc/$hioc/startup.cmd"
					boot_list=`/bin/egrep -w -e "^chdir" /reg/d/iocCommon/hioc/$hioc/startup.cmd | /bin/cut -d \" -f2`
					for d in $boot_list;
					do
						echo "  BOOT_DIR: $d"
					done
				done
			fi

			if (( ${#host_list} == 0 && ${#hioc_list} == 0 ));
			then
				echo "  HOST: Not found!"
				echo "  HIOC: Not found!"
			fi

			# Show boot directory for this PV
			if (( ${#boot_list} == 0 ));
			then
				echo "  BOOT_DIR: Not found!"
			fi

                        # Look for IocManager Configs
			echo "  IocManager Configs:"
			/reg/g/pcds/pyps/apps/ioc/latest/find_ioc --name $ioc
		done
	done
}
export find_pv

# Handy way to get host IP addr into a shell variable
export IP=`/sbin/ifconfig eth0 | /bin/grep 'inet addr:' | /bin/cut -d: -f2 | /bin/awk '{ print $1 }'`
export SUBNET=`echo $IP | /bin/cut -d. -f3`
export MGT_SUBNET=24
export CDS_SUBNET=35
export FEE_SUBNET=36
export AMO_SUBNET=37
export XPP_SUBNET=38
export SXR_SUBNET=39
export TST_SUBNET=42
export XCS_SUBNET=43
export CXI_SUBNET=44
export MEC_SUBNET=45
export THZ_SUBNET=57

#
# Functions for launching various control room home screens
#

function amo()
{
	if [ $SUBNET == $AMO_SUBNET ]; then
		echo "Warning: Launching live AMO screen ..."
	else
		echo "Launching read-only AMO screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/amo/current
	./amohome
}
export amo

function sxr()
{
	if [ $SUBNET == $SXR_SUBNET ]; then
		echo "Warning: Launching live SXR screen ..."
	else
		echo "Launching read-only SXR screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/sxr/current
	./sxrhome
}
export sxr

function tst()
{
	if [ $SUBNET == $TST_SUBNET ]; then
		echo "Warning: Launching live TST screen ..."
	else
		echo "Launching read-only TST screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/sxr/current
	./tsthome
}
export tst

function xtod()
{
	XTOD_HOST=xtod-console
	HOSTNAME=`hostname`
	if [ $HOSTNAME != $XTOD_HOST ]; then
		echo "Warning: You may need ssh to $XTOD_HOST to access EPICS PV's"
	fi
	export LCLS_ROOT=/reg/g/pcds/package/xtod-lcls-old
	export EPICS_TOP=$LCLS_ROOT/epics
	export EPICS_HOST_ARCH=linux-x86
	source $EPICS_TOP/setup/3.14.9/epicsSetup.bash
	pushd $LCLS_ROOT/tools/edm/display
	edm -eolc -x xtod_main.edl&
}
export xtod

function fee()
{
	if [ $SUBNET == $FEE_SUBNET ]; then
		echo "Warning: Launching live FEE screen ..."
	else
		echo "Launching read-only FEE screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/fee/current
	./feehome
}
export fee
alias xrt=fee

function pcds()
{
	echo "Launching top level PCDS screen ..."
	pushd $PKGS/epics/3.14-dev/screens/edm/pcds/current
	./pcdshome
}
export pcds

function amolas()
{
	if [ $SUBNET == $CDS_SUBNET ]; then
		echo "Warning: Launching live AMO Laser screen ..."
	else
		echo "Launching read-only AMO Laser screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/las/current
	./AMO-Laser
}
export sxrlas

function sxrlas()
{
	if [ $SUBNET == $CDS_SUBNET ]; then
		echo "Warning: Launching live SXR Laser screen ..."
	else
		echo "Launching read-only SXR Laser screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/las/current
	./SXR-Laser
}
export sxrlas

function xpp()
{
	if [ $SUBNET == $XPP_SUBNET ]; then
		echo "Warning: Launching live XPP screen ..."
	else
		echo "Launching read-only XPP screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/xpp/current
	./xpphome
}
export xpp

function las()
{
	if [ $SUBNET == $CDS_SUBNET ]; then
		echo "Warning: Launching live Laser screen ..."
	else
		echo "Launching read-only Laser screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/las/current
	./laserhome
}
export las

function xcs()
{
	if [ $SUBNET == $XCS_SUBNET ]; then
		echo "Warning: Launching live XCS screen ..."
	else
		echo "Launching read-only XCS screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/xcs/current
	./xcshome
}
export xcs

function cxi()
{
	if [ $SUBNET == $CXI_SUBNET ]; then
		echo "Warning: Launching live CXI screen ..."
	else
		echo "Launching read-only CXI screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/cxi/current
	./cxihome
}
export cxi

function mec()
{
	if [ $SUBNET == $MEC_SUBNET ]; then
		echo "Warning: Launching live MEC screen ..."
	else
		echo "Launching read-only MEC screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/mec/current
	./mechome
}
export mec


# This funcion is used to prevent EPICS channel access network
# traffic from being seen by the data acquisition FEZ networks.
# It is run by our standard epics setup scripts, but only affects
# the hutch console machines listed below because they have
# network adapters on the FEZ network.
function setEPICS_CA_ADDR_LIST()
{
	HOSTNAME=`hostname`
	case $HOSTNAME in
		amo-console | amo-daq | amo-monitor | amo-control )
			EPICS_CA_AUTO_ADDR_LIST=NO
			EPICS_CA_ADDR_LIST=172.21.37.255
			;;
		sxr-console | sxr-daq | sxr-monitor | sxr-control | sxr-elog )
			EPICS_CA_AUTO_ADDR_LIST=NO
			EPICS_CA_ADDR_LIST=172.21.39.255
			;;
		xpp-daq | xpp-daq2 | xpp-control )
			EPICS_CA_AUTO_ADDR_LIST=NO
			EPICS_CA_ADDR_LIST=172.21.38.255
			;;
		xcs-console | xcs-daq | xcs-control )
			EPICS_CA_AUTO_ADDR_LIST=NO
			EPICS_CA_ADDR_LIST=172.21.43.255
			;;
		cxi-console | cxi-daq | cxi-monitor | cxi-control )
			EPICS_CA_AUTO_ADDR_LIST=NO
			EPICS_CA_ADDR_LIST=172.21.44.255
			;;
		mec-console | mec-daq | mec-monitor | mec-control )
			EPICS_CA_AUTO_ADDR_LIST=NO
			EPICS_CA_ADDR_LIST=172.21.45.255
			;;
	esac
	export EPICS_CA_AUTO_ADDR_LIST
	export EPICS_CA_ADDR_LIST
}
export setEPICS_CA_ADDR_LIST

function updateScreenLinks
{
	EPICS_SITE_TOP=/reg/g/pcds/package/epics/3.14
	EPICS_DEV_AREA=/reg/g/pcds/package/epics/3.14-dev
	areas="amo sxr xpp xcs cxi mec fee las thz";
	relpath="$1";
	if [ "$relpath" != "" -a ! -e "$relpath" ]; then
		relpath=$EPICS_SITE_TOP/$relpath
	fi
	screens=($relpath/*.edl)
	numScreens=${#screens[*]}
	if [ ! -f "${screens[0]}" ]; then
		numScreens=0
	fi
	if [ -e "$relpath" ]; then
		echo Path "$relpath" has $numScreens edm screens.;
	fi
	if [ ! -e "$relpath" -o $numScreens == 0 ]; then
			echo ""
			echo "updateScreenLinks usage: updateScreenLinks <pathToScreenRelease>"
			echo "Creates a soft link to the specified directory in the"
			echo "3.14-dev version of each hutch's edm home directory."
			echo "The soft link name is derived from the basename of the"
			echo "provided path."
			echo ""
			echo "If an absolute path is not provided, the path is"
			echo "evaluated relative to the root of our EPICS releases:"
			echo $EPICS_SITE_TOP
			echo ""
			echo "Examples:"
			echo "  updateScreenLinks $EPICS_SITE_TOP/ioc/las/fstiming/R2.3.0/fstimingScreens"
			echo "  updateScreenLinks modules/history/R0.4.0/historyScreens"
			return
	fi
	linkName=`basename $relpath`
	read -p "Create/replace $linkName links in each hutch's home: [yN]" confirm
	if [ "$confirm" != "y" -a "$confirm" != "Y" ];
	then
		echo "Canceled.";
		return;
	fi

	pushd $EPICS_DEV_AREA/screens/edm 2>&1 > /dev/null
	for h in $areas;
	do
			cd $h/current;
			/bin/rm -f $linkName;
			/bin/ln -s $relpath;
			/usr/bin/svn add $linkName 2>&1 > /dev/null;
			cd ../..;
	done
	/usr/bin/svn ci */current/$linkName -m "Updated $linkName links via updateScreenLinks bash function"
	ls -ld */current/$linkName
	popd 2>&1 > /dev/null
}
export updateScreenLinks
