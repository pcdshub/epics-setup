# This script provides access to our snmp 2.7.2 installation
# This version is needed to fix some errors in earlier
# snmp versions that are needed for our Sentry PDU controls.

source /reg/g/pcds/setup/pathmunge.sh

snmpdir=/reg/g/pcds/package/net-snmp-5.7.2

pathmunge $snmpdir/bin
ldpathmunge $snmpdir/lib

