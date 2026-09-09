#!/usr/bin/env bash
#
# This script creates several shell functions that can be
# useful shortcuts in the PCDS EPICS environment.


if [ -z "$CONFIG_SITE_TOP" ]; then
    export CONFIG_SITE_TOP=/reg/g/pcds/pyps/config
fi
if [ -z "$PACKAGE_SITE_TOP" ]; then
    export PACKAGE_SITE_TOP=/reg/g/pcds/package
fi
if [ -z "$EPICS_SITE_TOP" ]; then
    export EPICS_SITE_TOP=/reg/g/pcds/epics
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

# Set umask default to allow group write access
umask 0002

function ssh_show_procServ( )
{
    PROCSERV_HOST=`hostname -s`
    if [ -e /usr/bin/expand ]; then
        EXPAND_TABS='/usr/bin/expand --tabs=9,19,45,55,75'
    else
        EXPAND_TABS='cat'
    fi
    if [   -e /usr/bin/gawk ]; then
        REORDER='/usr/bin/gawk {OFS="\t";print$2,$3,$5,$4,$1,$6}'
    elif [ -e /usr/bin/awk ]; then
        REORDER='/usr/bin/awk {OFS="\t";print$2,$3,$5,$4,$1,$6}'
    else
        REORDER='cat'
    fi
    if [ -z "$1" ]; then
        SSH_CMD=""
    elif [ -z "$2" ]; then
        SSH_CMD="ssh -o LogLevel=error $1"
        PROCSERV_HOST=$1
    else
        SSH_CMD="ssh -o LogLevel=error $2@$1"
        PROCSERV_HOST=$1
    fi
    # ps output is piped through sed to remove unwanted ps header
    # and uninteresting procServ parameters and keywords
    $SSH_CMD ps -C procServ -o pid,user,command     |\
                sed     -e "s/\S*procServ /procServ /"  \
                     -e "s/--restrict//"             \
                     -e "s/--savelog//"              \
                     -e "s/--allow//g"               \
                     -e "s/-i\s\+\S\+//"             \
                     -e "s/--ignore\s\+\S\+//"       \
                     -e "s/--coresize\s\+\S\+//"     \
                     -e "s/--logfile\s\+\S\+//"      \
                     -e "s/--killcmd\s\+\S\+//"      \
                     -e "s/--killsig\s\+\S\+//"      \
                     -e "s/-k\s\+\S\+//"             \
                     -e "s/--logport\s\+\S\+//"      \
                     -e "s/-l\s\+\S\+//"             \
                     -e "s/--pidfile\s\+\S\+//"      \
                     -e "s/-p\s\+\S\+//"             \
                     -e "s/--noautorestart//"        \
                     -e "s/--oneshot//"              \
                     -e "s/--foreground//"           \
                     -e "s/\s-f\s/ /"                \
                     -e "s/\s-o\s/ /"                \
                     -e "s/--timefmt\s\+\S\+//"      \
                     -e "s/--logstamp//"             \
                     -e "s/--name//"                 \
                     -e "s/\s-n\s/\s/"               \
                     -e "s/^/$PROCSERV_HOST\t/"      \
                     -e "s/  */\t/g"                 \
                     -e "/PID\tUSER\tCOMMAND/d"     |\
                $REORDER                            |\
                $EXPAND_TABS
    return
}
export ssh_show_procServ

function show_epics_sioc( )
{
    if [ -e /usr/bin/expand ]; then
        EXPAND_TABS='/usr/bin/expand --tabs=9,19,45,55,75'
    else
        EXPAND_TABS='cat'
    fi
    if [ -e /usr/bin/gawk -o -e /usr/bin/awk ]; then
        echo "PID    USER    SIOC    COMMAND    HOSTNAME    PORT" | $EXPAND_TABS
    else
        echo "HOSTNAME        PID    USER    COMMAND        PORT    SIOC" | $EXPAND_TABS
    fi
    if [ ! $1 ];
    then
        ssh_show_procServ
    else
        for a in $*;
        do
            if [ $a != "all" ];
            then
                ssh_show_procServ $a
            else
                for h in $IOC_COMMON/hosts/*;
                do
                    if [ ! -f $h/startup.cmd ]; then continue; fi
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
    epics-versions $*
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
            echo "    IOC:        $ioc"

            # Look for IOC PV root
            ioc_pv=`/bin/egrep UPTIME ${IOC_DATA}/$ioc/iocInfo/IOC.pvlist | /bin/sed -e "s/:UPTIME.*//"`
            if (( ${#ioc_pv} == 0 ));
            then
                echo "    IOC_PV:        Not found!"
            else
                echo "    IOC_PV:        $ioc_pv"
            fi

            # Look for hard ioc
            hioc_list=`/bin/egrep -l -e "$ioc" ${IOC_COMMON}/hioc/ioc*/startup.cmd | /bin/cut -d / -f6`
            if (( ${#hioc_list} ));
            then
                for hioc in $hioc_list;
                do
                    echo "    HIOC:        $hioc"
                    echo "    STARTUP:    ${IOC_COMMON}/hioc/$hioc/startup.cmd"
                    boot_list=`/bin/egrep -w -e "^chdir" ${IOC_COMMON}/hioc/$hioc/startup.cmd | /bin/cut -d \" -f2`
                    for d in $boot_list;
                    do
                        echo "    BOOT_DIR:    $d"
                    done
                done
            fi

            # Look for IocManager Configs
            ${PYPS_SITE_TOP}/apps/ioc/latest-R3/scripts/find_ioc --name $ioc
        done
    done
}
export find_pv

export MASK=255.255.255.0
# Handy way to get host IP addr into a shell variable
if [ -e /usr/bin/gethostip -a -e /sbin/ifconfig -a -e /bin/grep ]; then
dns_addr=`/usr/bin/gethostip -d "$HOSTNAME"`
ip_list="$(/sbin/ifconfig | /bin/grep -w inet | sed -e 's/ *inet[^0-9]*\([0-9.]*\) .*/\1/')"
for ip in $ip_list;
do
if [ "$ip" == "$dns_addr" ]; then
    export IP="$dns_addr"
    export MASK=`/sbin/ifconfig | /bin/grep $dns_addr | head -n1 | sed -e 's/.*Mask:[^0-9]*\([0-9.]*\).*/\1/'`
fi
done
unset dns_addr
unset ip_list
fi

# if we don't have gethostip use the older less reliable way this fails if the CDS interface is not the first
if [ -z "$IP" -a -e /sbin/ifconfig -a -e /bin/grep ]; then
    export IP=`/sbin/ifconfig | /bin/grep -w inet | head -n1 | sed -e 's/ *inet[^0-9]*\([0-9.]*\) .*/\1/'`
    export MASK=`/sbin/ifconfig | /bin/grep -w inet | head -n1 | sed -e 's/.*Mask:[^0-9]*\([0-9.]*\).*/\1/'`
fi
export SUBNET=`echo $IP | cut -d. -f3`

# Now supporting 10 bit subnets
# As prior SUBNET was just the 3rd field of IP addr,
# for 10 bit support I'm setting extra 2 bits to make it
# easier to create the broadcast addr via 172.21.$SUBNET.255
if [ "$MASK" == "255.255.252.0" ]; then
    export SUBNET=$(($SUBNET | 3))
fi

export SRV_SUBNET=32
export DMZ_SUBNET=33
export CDS_SUBNET=35
export DET_SUBNET=(58 59)
export FEE_SUBNET=(88 89 90 91)
export TMO_SUBNET=(28 132 133 134 135)
export XPP_SUBNET=(22 84 85 86 87)
export RIX_SUBNET=(140 141 142 143)
export TST_SUBNET=(148 149 150 151)
export DRP_SUBNET=(152 153 154 155)
export XCS_SUBNET=(25 80 81 82 83)
export CXI_SUBNET=(26 68 69 70 71)
export MEC_SUBNET=(27 76 77 78 79)
export THZ_SUBNET=57
export MFX_SUBNET=(24 72 73 74 75)
export ANA_SUBNET=(48 49 50 51)
export HPL_SUBNET=64
export DEV_SUBNET=165
export ICS_SUBNET=46
export TXI_SUBNET=(136 137 138 139)

export DEV_BC=134.79.${DEV_SUBNET}.255

function subnet_check()
{
    hutchname="$1"
    varname="${hutchname^^}_SUBNET"
    subnet_vals="${!varname}"
    for number in "${subnet_vals[@]}"; do
        if (( number == SUBNET )); then
            echo "Warning: launching live ${hutchname^^} screen"
            return
        fi
    done
    echo "Warning: launching read-only ${hutchname^^} screen"
}


#
# ACR
#

function pydm_lclshome()
{
    "${EPICS_SETUP}"/pydm_lclshome.sh
}
export pydm_lclshome


#
# XBDO
#

function lfe()
{
    subnet_check lfe
    "${PYPS_SITE_TOP}"/config/lfe/lfe_home.sh &
}
export lfe

function kfe()
{
    subnet_check kfe
    "${PYPS_SITE_TOP}"/config/kfe/kfe_home.sh &
}
export kfe

function lpmps()
{
    "${PYPS_SITE_TOP}"/config/lfe/lpmps.sh &
}
export lpmps

function kpmps()
{
    "${PYPS_SITE_TOP}"/config/kfe/kpmps.sh &
}
export kpmps


#
# Control rooms
#

function tmo()
{
    subnet_check tmo
    "${PYPS_SITE_TOP}"/config/tmo/tmo_home.sh &
}
export tmo

function rix()
{
    subnet_check rix
    "${PYPS_SITE_TOP}"/config/rix/rix_home.sh &
}
export rix

function txi()
{
    subnet_check txi
    "${PYPS_SITE_TOP}"/config/txi/txi_home.sh &
}
export txi

function k3()
{
    subnet_check txi
    "${PYPS_SITE_TOP}"/config/txi/k3_home.sh &
}
export k3

function xpp()
{
    subnet_check xpp
    "${PYPS_SITE_TOP}"/config/xpp/xpp_home.sh &
}
export xpp

function xcs()
{
    subnet_check xcs
    "${PYPS_SITE_TOP}"/config/xcs/xcs_home.sh &
}
export xcs

function cxi()
{
    subnet_check cxi
    "${PYPS_SITE_TOP}"/config/cxi/cxi_home.sh &
}
export cxi

function mfx()
{
    subnet_check mfx
    "${PYPS_SITE_TOP}"/config/mfx/mfx_home.sh &
}
export mfx

function mec()
{
    subnet_check mec
    "${PYPS_SITE_TOP}"/config/mec/mec_home.sh &
}
export mec

function ued()
{
    subnet_check ued
    "${PYPS_SITE_TOP}"/config/ued/ued_home.sh &
}
export ued 


#
# Laser land
#

function las()
{
    subnet_check las
    "${PYPS_SITE_TOP}"/config/las/las_home.sh &
}
export las

function timing()
{
    subnet_check las
    "${PYPS_SITE_TOP}"/config/las/timing_home.sh &
}
export timing

function mods_ip1()
{
    subnet_check las
    "${PYPS_SITE_TOP}"/config/las/mods_ip1_home.sh &
}
export mods_ip1 

function mods_ip2()
{
    subnet_check las
    "${PYPS_SITE_TOP}"/config/las/mods_ip2_home.sh &
}
export mods_ip2

function mods_crix()
{
    subnet_check las
    "${PYPS_SITE_TOP}"/config/las/mods_crix_home.sh &
}
export mods_crix

function mods_qrix()
{
    subnet_check las
    "${PYPS_SITE_TOP}"/config/las/mods_qrix_home.sh &
}
export mods_qrix


#
# Other screens
#

function icl()
{
    subnet_check icl
    "${PYPS_SITE_TOP}"/config/icl/icl_home.sh &
}
export icl

function gw()
{
    /reg/g/pcds/epics-dev/screens/edm/gateway/current/gwhome
}
export gw

function switchtool()
{
  /cds/group/pcds/pyps/apps/switchtool/latest/scripts/switchtool "$@"
}
export switchtool


function updateScreenLinks
{
    EPICS_SITE_TOP=/reg/g/pcds/epics
    EPICS_DEV_AREA=/reg/g/pcds/epics-dev
    areas="tmo kfe lfe xpp xcs cxi mec mfx fee las thz";
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
            echo "epics-dev version of each hutch's edm home directory."
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

# Moved archiver macros and aliases to epics-ca-env.*

# Here's a convenient alias for visual diff of svn files
# Define VISUALDIFF to your favorite visual diff tool or default to vimdiff
alias svnvdiff='svn diff --diff-cmd $TOOLS_SITE_TOP/bin/svn-vdiffwrap.sh '

