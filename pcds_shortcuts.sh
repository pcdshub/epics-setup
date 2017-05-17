#!env bash
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

if [ -z "$CONFIG_SITE_TOP" ]; then
export CONFIG_SITE_TOP=/reg/g/pcds/pyps/config
fi
if [ -z "$PACKAGE_SITE_TOP" ]; then
export PACKAGE_SITE_TOP=/reg/g/pcds/package
fi
if [ -z "$EPICS_SITE_TOP" ]; then
export EPICS_SITE_TOP=/reg/g/pcds/package/epics/3.14
fi
if [ -z "$IOC_COMMON" ]; then
export IOC_COMMON=/reg/d/iocCommon
fi
if [ -z "$IOC_DATA" ]; then
export IOC_DATA=/reg/d/iocData
fi
if [ -z "$PYPS_SITE_TOP" ]; then
export PYPS_SITE_TOP=/reg/g/pcds/pyps
fi

export PKGS=$PACKAGE_SITE_TOP

function ssh_show_procServ( )
{
	PROCSERV_HOST=`hostname`
	EXPAND_TABS='/usr/bin/expand --tabs=6,16,42,52,72'
	REORDER='gawk {OFS="\t";print$2,$3,$6,$4,$1,$5}'
	if [ -z "$1" ]; then
		SSH_CMD=""
	elif [ -z "$2" ]; then
		SSH_CMD="ssh $1"
		PROCSERV_HOST=$1
	else
		SSH_CMD="ssh $2@$1"
		PROCSERV_HOST=$1
	fi
	$SSH_CMD ps -C procServ -o pid,user,command     |\
				sed	 -e "s/\S*procServ /procServ /"  \
					 -e "s/--savelog//"              \
					 -e "s/--allow//"                \
					 -e "s/--ignore\s*\S*//"         \
					 -e "s/--coresize\s*\S*//"       \
					 -e "s/--logfile\s*\S*//"        \
					 -e "s/--noautorestart//"        \
					 -e "s/--logstamp//"             \
					 -e "s/--name\s*\(\S\+\)\s*\([0-9]\+\)/\2 \1/"  \
					 -e "s^/\S*/g/\S*\/caRepeater^caRepeater^"      \
					 -e "s/^/$PROCSERV_HOST\t/"                     \
					 -e "s/  */\t/g"                                \
					 -e "/PID\tUSER\tCOMMAND/d"                    |\
				$REORDER                                           |\
                $EXPAND_TABS
	return
}

function show_epics_sioc_filter( )
{
	if [ -e /usr/bin/expand ]; then
		EXPAND_TABS='/usr/bin/expand --tabs=6,16,42,52,72'
	else
		EXPAND_TABS='cat'
	fi
	if [ -e /bin/gawk ]; then
		REORDER='gawk {OFS="\t";print$2,$3,$6,$4,$1,$5}'
	else
		REORDER='cat'
	fi
	ps -C procServ -o pid,user,command		|\
                env sed -e "s/\S*procServ /procServ /"  \
                         -e "s/--savelog//"              \
                         -e "s/--allow//"                \
                         -e "s/--ignore\s*\S*//"         \
                         -e "s/--coresize\s*\S*//"       \
                         -e "s/--logfile\s*\S*//"        \
                         -e "s/--noautorestart//"        \
                         -e "s/--logstamp//"             \
                         -e "s/--name\s*\(\S\+\)\s*\([0-9]\+\)/\2 \1/"  \
                         -e "s^/\S*/g/\S*\/caRepeater^caRepeater^"    \
                         -e "s/^/$HOSTNAME\t/"                          \
                         -e "s/  */\t/g"                                \
                         -e "/PID\tUSER\tCOMMAND/d"                    |\
				$REORDER                                               |\
                $EXPAND_TABS
	return
}
export show_epics_sioc_filter

function show_epics_sioc( )
{
	if [ -e /usr/bin/expand ]; then
		EXPAND_TABS='/usr/bin/expand --tabs=6,16,42,52,72'
	else
		EXPAND_TABS='cat'
	fi
	if [ -n "`which gawk`" ]; then
		echo "PID	USER	SIOC	COMMAND	HOSTNAME	PORT" | $EXPAND_TABS
	else
		echo "HOSTNAME		PID	USER	COMMAND		PORT	SIOC" | $EXPAND_TABS
	fi
	if [ ! $1 ];
	then
		#show_epics_sioc_filter
		ssh_show_procServ
	else
		for a in $*;
		do
			if [ $a != "all" ];
			then
				#ssh $a show_epics_sioc_filter
				ssh_show_procServ $a
			else
				for h in $IOC_COMMON/hosts/*;
				do
					if [ ! -f $h/startup.cmd ]; then continue; fi
					# ssh $(basename $h) show_epics_sioc_filter
					ssh_show_procServ $(basename $h)
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
		echo "  ${IOC_DATA}/ioc*/iocInfo/IOC.pvlist"
		echo ""
		echo Then it looks for the linux host or hard IOC hostname in:
		echo "  ${IOC_COMMON}/hosts/ioc*/startup.cmd"
		echo "  ${IOC_COMMON}/hioc/ioc*/startup.cmd"
		echo "If no host is found, the IOC will not autoboot after a power cycle!"
		echo ""
		echo Finally it looks for the boot directory in:
		echo "  ${IOC_COMMON}/hioc/<ioc-name>/startup.cmd"
		echo ""
		echo "Hard IOC boot directories are shown with the nfs mount name."
		echo "Typically this is /iocs mounting ${PACKAGE_SITE_TOP}/epics/ioc"
		return 1;
	fi 
	for pv in $*;
	do
		echo PV: $pv
		ioc_list=`/bin/egrep -l -e "$pv" ${IOC_DATA}/ioc*/iocInfo/IOC.pvlist | /bin/cut -d / -f5`
		for ioc in $ioc_list;
		do
			echo "  IOC: $ioc"

			# Look for IOC PV root
			ioc_pv=`/bin/egrep UPTIME ${IOC_DATA}/$ioc/iocInfo/IOC.pvlist | /bin/sed -e "s/:UPTIME.*//"`
			if (( ${#ioc_pv} == 0 ));
			then
				echo "  IOC_PV: Not found!"
			else
				echo "  IOC_PV: $ioc_pv"
			fi

			# Look for linux hosts
			host_list=`/bin/egrep -l -e "$ioc" ${IOC_COMMON}/hosts/ioc*/startup.cmd | /bin/cut -d / -f6`
			for h in $host_list;
			do
				echo "  HOST: $h"
			done

			# Look for hard ioc
			hioc_list=`/bin/egrep -l -e "$ioc" ${IOC_COMMON}/hioc/ioc*/startup.cmd | /bin/cut -d / -f6`
			if (( ${#hioc_list} ));
			then
				for hioc in $hioc_list;
				do
					echo "  HIOC: $hioc"
					echo "  STARTUP: ${IOC_COMMON}/hioc/$hioc/startup.cmd"
					boot_list=`/bin/egrep -w -e "^chdir" ${IOC_COMMON}/hioc/$hioc/startup.cmd | /bin/cut -d \" -f2`
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
			${PYPS_SITE_TOP}/apps/ioc/latest/find_ioc --name $ioc
		done
	done
}
export find_pv

# Handy way to get host IP addr into a shell variable
if [ -e /sbin/ifconfig -a -e /bin/awk -a -e /bin/grep ]; then
#export IP=`/sbin/ifconfig | /bin/grep 'inet addr:' | head -1 | cut -d: -f2 | /bin/awk '{ print $1 }'`
export IP=`/sbin/ifconfig | /bin/grep -w inet | head -1 | sed -e 's/ *inet[^0-9]*\([0-9.]*\) .*/\1/'`
export SUBNET=`echo $IP | cut -d. -f3`
fi
export MGT_SUBNET=24
export SRV_SUBNET=32
export DMZ_SUBNET=33
export CDS_SUBNET=35
export FEE_SUBNET=36
export AMO_SUBNET=37
export XPP_SUBNET=38
export SXR_SUBNET=39
export TST_SUBNET=42
export XCS_SUBNET=43
export CXI_SUBNET=68
export MEC_SUBNET=45
export THZ_SUBNET=57
export MFX_SUBNET=62
export HPL_SUBNET=64
export DEV_SUBNET=165
export DEV_BC=134.79.${DEV_SUBNET}.255

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
#	pushd $PKGS/epics/3.14-dev/screens/edm/amo/current
	pushd ${PACKAGE_SITE_TOP}/screens/edm/amo
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
#	pushd $PKGS/epics/3.14-dev/screens/edm/sxr/current
	pushd ${PACKAGE_SITE_TOP}/screens/edm/sxr
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
	pushd $PKGS/epics/3.14-dev/screens/edm/tst/current
	./tsthome
}
export tst

function afs()
{
	pushd $PKGS/epics/3.14-dev/screens/edm/afs/current
	./afshome
}

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
alias xtod=fee

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

function mfx()
{
	if [ $SUBNET == $MFX_SUBNET ]; then
		echo "Warning: Launching live MFX screen ..."
	else
		echo "Launching read-only MFX screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/mfx/current
	./mfxhome
}
export mfx

function hpl()
{
	if [ $SUBNET == $HPL_SUBNET ]; then
		echo "Warning: Launching live HPL screen ..."
	else
		echo "Launching read-only HPL screen ..."
	fi
	pushd $PKGS/epics/3.14-dev/screens/edm/hpl/current
	./hplhome
}
export mfx


function updateScreenLinks
{
	EPICS_SITE_TOP=${PACKAGE_SITE_TOP}/epics/3.14
	EPICS_DEV_AREA=${PACKAGE_SITE_TOP}/epics/3.14-dev
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

function gsed
{
	if [ $# -lt 2 ]
	then
		echo Usage: gsed sedExpr file ....
		echo Example: gsed s/R0.1.0/R0.2.0/g ioc-tst-cam1.cfg ioc-*2.cfg
		return
	fi
	tmp=/tmp/gsed.$$
	op=$1
	shift
	sed_files=$*
	echo "sed $op in specified files"
	for f in $sed_files ;
	do
		if [ ! -w $f ];
		then
			echo ============ $f: Read-Only, N/C ;
			continue ;
		fi
		sed -e "$op" $f > $tmp || break ;
		if cmp -s $tmp $f ;
		then
			echo ============ $f: Same, N/C ;
			continue ;
		fi
		# Fix execute permission if needed
		f_is_exec=N
		if [ -x $f ];
		then
			f_is_exec=Y;
		fi
		mv $tmp $f ;
		if [ "$f_is_exec" == "Y" ];
		then
			chmod a+x $f;
		fi
		echo ============ $f: UPDATED ;
	done
	/bin/rm -f $tmp 2>&1 > /dev/null
}
export gsed

# URL and firefox launcher for the PCDS Archiver Appliance Management web U/I
# Recommend firefox version 43 or newer or google-chrome version 44 or newer
export ARCHIVER_URL=http://pscaa02.slac.stanford.edu:17665/mgmt/ui/index.html
alias Archiver="firefox --no-remote $ARCHIVER_URL 2>1 > /dev/null&"
alias ArchiveManager="google-chrome --no-remote $ARCHIVER_URL 2>1 > /dev/null&"

# Archiver Appliance Viewer URL:
# Recommend firefox version 43 or newer or google-chrome version 44 or newer
export ARCHIVE_VIEWER_URL=https://pswww-dev.slac.stanford.edu/apps-dev/EpicsViewer
alias ArchiveViewer="google-chrome --no-remote $ARCHIVER_URL 2>1 > /dev/null&"
