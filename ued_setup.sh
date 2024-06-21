if [[ `hostname` =~ ued ]]; then
	export EPICS_CA_ADDR_LIST="172.21.36.255:5064 172.27.99.255:5058"
	export EPICS_CA_AUTO_ADDR_LIST=NO
fi
