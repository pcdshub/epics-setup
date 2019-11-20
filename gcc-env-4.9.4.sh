# This script updates your environment to run pkg_mgr gcc/4.9.4
if   [ -f  /reg/g/pcds/pyps/config/common_dirs.sh ]; then
    source /reg/g/pcds/pyps/config/common_dirs.sh
elif [ -f  /afs/slac/g/pcds/config/common_dirs.sh ]; then
	source /afs/slac/g/pcds/config/common_dirs.sh
fi
if [ -z "$PSPKG_ROOT" ]; then
	export PSPKG_ROOT=/reg/g/pcds/pkg_mgr
fi

source $PSPKG_ROOT/etc/env_add_pkg.sh mpc/0.8.1
env_add_pkg mpfr/2.4.2
env_add_pkg gmp/4.3.2
env_add_pkg gcc/4.9.4

