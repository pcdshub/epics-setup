

PLC_DIR='/reg/g/pcds/plc-common'

MECD='MEC=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/iss/mec_plc_dump'
CXID='CXI=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/iss/cxi_plc_dump'
XCSD='XCS=/reg/g/pcds/package/epics/3.14-dev/tools/current/scripts/iss/xcs_plc_dump'
DRIVES=" -r disk:Package=/reg/common/package -r disk:${MECD} -r disk:${CXID} -r disk:PLC=${PLC_DIR} -r disk:${XCSD}"

# command templates
all='xfreerdp -sec-nla /d: /size:60% /drive:PLC,/reg/g/pcds/plc-common /v:'
allbig='xfreerdp -sec-nla /d: /size:90% /drive:PLC,/reg/g/pcds/plc-common /v:'

alias plcpc1="${all}plc-prg-01 &" 
alias bigplcpc1="${allbig}plc-prg-01 &"
alias plcpc2="${all}plc-prg-02 &" 
alias bigplcpc2="${allbig}plc-prg-02 &"
alias plcpc3="${all}plc-prg-03 &"
alias bigplcpc3="${allbig}plc-prg-03 &"
alias plcpc4="${all}plc-prg-04 &"
alias bigplcpc4="${allbig}plc-prg-04 &"
