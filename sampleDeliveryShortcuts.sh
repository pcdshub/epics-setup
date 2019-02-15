# Sample delivery system shortcuts/ environment setup
# A. Wallace 2015-4-14

#Sample Delivery System
SDS_TOP_DEV=/reg/g/pcds/package/epics/3.14-dev/ioc/common/sds/current/
alias iclsds="pushd $SDS_TOP_DEV; ./icl-samplescreen.cmd"
alias amosds="pushd $SDS_TOP_DEV; ./amo-samplescreen.cmd"
alias sxrsds="pushd $SDS_TOP_DEV; ./sxr-samplescreen.cmd"
alias iclcamera="pushd /reg/g/pcds/package/epics/3.14-dev/ioc/icl/gige/current; ./edm-ioc-icl-gige-01.cmd"
alias felsimcamera="pushd ~awallace/workspace/icl/edtCam/current/; ./edm-ioc-icl-felSim.cmd"
#alias iclcamera="source /reg/g/pcds/package/epics/3.14-dev/ioc/icl/gige/current/build/iocBoot/ioc-icl-gige-01/edm-ioc-icl-gige-01.cmd"
alias iclvac="pushd $SDS_TOP_DEV; ./icl-vacuumScreen.cmd"

#Knob Box Config Screen
KNOB_TOP_DEV=/reg/g/pcds/package/epics/3.14-dev/ioc/common/knobBox/current/
alias cxiknob1="pushd $KNOB_TOP_DEV; ./edm-cxi-knob.cmd"
alias iclknob1="pushd $KNOB_TOP_DEV; ./icl-edm-knob.cmd"

# MicroFab Laptop
alias sedlaptop="rdesktop -u .\ICL -g 1700x900 -a 32 -x 0x80 laptop-cxi-ihDeponte &"
alias cxilaptop="rdesktop -u .\sds -g 1700x900 -a 32 -x 0x80 ppa-pc92243 &"
alias amolaptop="rdesktop -u user -p Just6Now -g 1700x900 -a 32 -x 0x80 amo-win-laptop &"

#Experiment setups
alias amosample="amosds"

#Add SDS shortcuts to bashrc
function persist-sds-shortcuts {
	export SHORTCUT_COMMAND="source /reg/g/pcds/setup/sampleDeliveryShortcuts.sh"
	if grep -q "$SHORTCUT_COMMAND" $HOME/.bashrc; then
		echo Alreaded added!
	else
		echo "#SDS shortcuts" >> $HOME/.bashrc
		echo $SHORTCUT_COMMAND >> $HOME/.bashrc
		echo Added pcds shortcuts to your bashrc!
	fi
}
