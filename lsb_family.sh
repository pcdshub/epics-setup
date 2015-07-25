#
# source this file from sh or bash to define LSB_FAMILY as rhel5, rhel6, or rt9 (linuxRT)
#

if [ "$LSB_FAMILY" != "" ];
then
	return
fi

HAS_LSB=`which lsb_release`
if [ ! -z "$HAS_LSB" ];
then
	# 
	# Use lsb_release to determine which linux distribution we're using
	# lsb_release is the standard cmd line tool for displaying release information
	# LSB is a standard from the Free Standards Group and stands for Linux Standard Base
	#
	# First, determine the release family
	# Use the -i option to get the distributor id
	LSB_DIST_ID=`LD_LIBRARY_PATH= lsb_release -i | cut -f2`

	# Check for rhel family: RedHatEnterpriseClient and RedHatEnterpriseServer
	LSB_FAMILY=`echo $LSB_DIST_ID | sed -e "s/RedHatEnterprise.*/rhel/"`

	# TODO: Add tests for Ubuntu, SUSE, Mint, etc.
	#? LSB_FAMILY=`echo $LSB_FAMILY | sed -e "s/SuSE.*/suse/"`
	#? LSB_FAMILY=`echo $LSB_FAMILY | sed -e "s/Ubuntu.*/ubu/"`
	#? LSB_FAMILY=`echo $LSB_FAMILY | sed -e "s/Mint.*/mint/"`

	# Get the primary release number
	# For example, if "lsb_release -r" reports 5.8, our primary release is 5
	LSB_REL=`LD_LIBRARY_PATH= lsb_release -r | cut -f2 | cut -d. -f1`
	# Append the release number
	# For example, rhel5
	LSB_FAMILY=`echo ${LSB_FAMILY}${LSB_REL}`
else
	# lsb_release not available
	# Probably linuxRT rt9 kernel
	KERNEL=`uname -r`
	RT9_KERNEL=`echo $KERNEL | fgrep -e "-rt9"`
	if [ ! -z "$RT9_KERNEL" ]; then
		LSB_FAMILY=rt9
	else
		RH5_KERNEL=`echo $KERNEL | fgrep -e ".el5."`
		if [ ! -z "$RH5_KERNEL" ]; then
			LSB_FAMILY=rhel5
		else
			RH6_KERNEL=`echo $KERNEL | fgrep -e ".el6."`
			if [ ! -z "$RH6_KERNEL" ]; then
				LSB_FAMILY=rhel6
			fi
		fi
	fi
fi
