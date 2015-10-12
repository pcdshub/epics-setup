

PLC_DIR='/reg/g/pcds/plc-common'

MECD='MEC=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/iss/mec_plc_dump'
CXID='CXI=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/iss/cxi_plc_dump'
XCSD='XCS=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/iss/xcs_plc_dump'

# command templates
#regular size
reg_plc_com="rdesktop -g 1200x800 -a 32 -x 0x80 -r disk:GEN=${PLC_DIR} -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR"
# big size
big_plc_com="rdesktop -g 1700x900 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:${MECD} -r disk:${!CXID} -r disk:PLC=${PLC_DIR} -r disk:${XCSD}"
# big size
mega_plc_com="rdesktop -g 2100x1181 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:${MECD} -r disk:${!CXID} -r disk:PLC=${PLC_DIR} -r disk:${XCSD}"
# small size
small_plc_com="rdesktop -g 960x640 -a 32 -x 0x80 -r disk:GEN=$PLC_DIR -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR"
#tablet size
tablet_plc_com="rdesktop -g 1200x600 -a 32 -x 0x80 -r disk:GEN=$PLC_DIR -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR"

alias plcpc1='$reg_plc_com plc-prg-01 &' 
alias smallplcpc1='$small_plc_com plc-prg-01 &' 
alias bigplcpc1='${big_plc_com} plc-prg-01 &' 
alias megaplcpc1='${mega_plc_com} plc-prg-01 &' 
alias plcpc2='$reg_plc_com plc-prg-02 &' 
alias smallplcpc2='$small_plc_com plc-prg-02 &' 
alias bigplcpc2='${big_plc_com} plc-prg-02 &' 
alias megaplcpc2='${mega_plc_com} plc-prg-02 &' 
alias plcpc3='$reg_plc_com plc-prg-03 &' 
alias smallplcpc3='$small_plc_com plc-prg-03 &' 
alias bigplcpc3='$big_plc_com plc-prg-03 &'
alias megaplcpc3='${mega_plc_com} plc-prg-03 &' 
alias plcpc4='$reg_plc_com plc-prg-04 &' 
alias smallplcpc4='$small_plc_com plc-prg-04 &' 
alias bigplcpc4='$big_plc_com plc-prg-04 &'
alias megaplcpc4='${mega_plc_com} plc-prg-04 &' 
alias tabletplcpc4='${tablet_plc_com} plc-prg-04 &' 
