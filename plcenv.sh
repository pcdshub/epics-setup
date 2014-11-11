#TODO Need to change these common file areas to a real common area outside of my home directory :)


export PLC_DIR='/reg/g/pcds/plc-common'

export MECD='MEC=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/interlock-screen-system/mec_plc_dump'
export CXID='CXI=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/interlock-screen-system/cxi_plc_dump'

alias plcpc1='rdesktop -g 1200x800 -a 32 -x 0x80 -r disk:GEN=$PLC_DIR -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR lcls-pc82609 &' 
alias smallplcpc1='rdesktop -g 960x640 -a 32 -x 0x80 -r disk:GEN=$PLC_DIR -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR lcls-pc82609 &' 
alias bigplcpc1='rdesktop -g 1700x900 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR lcls-pc82609 &' 
alias plcpc2='rdesktop -g 1200x800 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR lcls-pc82608 &'
alias smallplcpc2='rdesktop -g 960x640 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR lcls-pc82608 &'
alias bigplcpc2='rdesktop -g 1700x900 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR lcls-pc82608 &'
alias plcpc3='rdesktop -g 1200x600 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR plc-prg-01 &' 
alias smallplcpc3='rdesktop -g 960x480 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR plc-prg-01 &' 
alias bigplcpc3='rdesktop -g 1700x900 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR plc-prg-01 &'
alias bigplcpc4='rdesktop -g 1700x900 -a 32 -x 0x80 -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR plc-prg-02 &'
alias plcpc4='rdesktop -a 32 -x 0x80 -g 1200x800  -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR plc-prg-02 &'
alias megaplcpc4='rdesktop -g 2560x1600 -x 0x80 -a 32 -r disk:Package=/reg/common/package -r disk:$MECD -r disk:$CXID -r disk:PLC=$PLC_DIR plc-prg-02 &'
