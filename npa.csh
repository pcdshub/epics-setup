#
# setup on non-AFS machines for 'debug' environment only 
# Not for development;  use AFS environment
#
set xildir='/reg/common/package/xilinx'
set gnudir='/reg/common/package/gnu'

# Xilinx tools
source ${xildir}/ise92i/settings.csh
source ${xildir}/edk92i/settings.csh
setenv CHIPSCOPE ${xildir}/ChipScope_Pro_9_2i

# GNU tools
setenv PATH ${gnudir}/powerpc-rtems49-gcc432/bin:${PATH}
