


PLC_DIR='/reg/g/pcds/plc-common'

MECD='MEC=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/iss/mec_plc_dump'
CXID='CXI=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/iss/cxi_plc_dump'
XCSD='XCS=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/iss/xcs_plc_dump'
DRIVES=" -r disk:Package=/reg/common/package -r disk:${MECD} -r disk:${CXID} -r disk:PLC=${PLC_DIR} -r disk:${XCSD} -r disk:'Home=~'"
DRIVEX=" /drive:Package,/reg/common/package /drive:PLC,/reg/g/pcds/plc-common /drive:Home,${HOME}"

# command templates
all="xfreerdp -sec-nla /d: /size:60% ${DRIVEX} /cert-ignore /v:"
allbig='xfreerdp -sec-nla /d: /size:90% /drive:PLC,/reg/g/pcds/plc-common /cert-ignore /v:'

alias plcpc1="${all}plc-prg-01 &" 
alias bigplcpc1="${allbig}plc-prg-01 &"
alias plcpc2="${all}plc-prg-02 &" 
alias bigplcpc2="${allbig}plc-prg-02 &"
alias plcpc3="${all}plc-prg-03 &"
alias bigplcpc3="${allbig}plc-prg-03 &"
alias plcpc4="${all}plc-prg-04 &"
alias bigplcpc4="${allbig}plc-prg-04 &"

# old rdesktop command templates - as a fallback
#regular size
reg_plc_com="rdesktop -g 1200x800 -a 32 -x 0x80 ${DRIVES}"
# big size
big_plc_com="rdesktop -g 1800x1028 -a 32 -x 0x80 ${DRIVES}"

alias oldplcpc1='$reg_plc_com plc-prg-01 &' 
alias oldbigplcpc1='${big_plc_com} plc-prg-01 &' 
alias oldplcpc2='$reg_plc_com plc-prg-02 &' 
alias oldbigplcpc2='${big_plc_com} plc-prg-02 &' 
alias oldplcpc3='$reg_plc_com plc-prg-03 &' 
alias oldbigplcpc3='$big_plc_com plc-prg-03 &'
alias oldplcpc4='$reg_plc_com plc-prg-04 &' 
alias oldbigplcpc4='$big_plc_com plc-prg-04 &'

alias plcprog='xfreerdp -g ${PLCPROG_RESOLUTION:-60%} -u ${USER} --plugin cliprdr plcprog-console &'

export PATH=$PATH:/reg/g/pcds/plc-common/InstallFiles/modpoll/linux/
