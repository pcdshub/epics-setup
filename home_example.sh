#!/bin/bash
# shellcheck disable=SC1090,SC2164

# This launcher has options for most kinds of historical home screens.
# Copy the script, change the "HUTCH" variable, then pick an option:
# Option 1: edm home
# Option 2: lucid launcher with dev_conda
# Option 3: lucid launcher with pixi
# Option 4: pydm home with pixi
# Comment out or delete the old variants that will no longer be used.
# Uncomment the option you are using
# Comment out the variants that are new if you don't want to use them yes.
# In this way, you can pick which variant your hutch is running and update at your convenience.
# You can also use this to customize your hutch's environment further if you have special things you need to pull in.

HUTCH=tst

# Option 1: edm home
# /cds/group/pcds/epics-dev/screens/edm/"${HUTCH,,}"/current/"${HUTCH,,}home"
# Option 2: lucid launcher with dev_conda
# "${EPICS_SETUP}"/lucid-launcher.sh "${HUTCH^^}"

# Options 3-4: Using pixi
# Put these to fixed version numbers for maximum safety, or "latest-released" for automatic updates.
ENVVER=latest-released
ENGTOOLS=latest-released

# Stay at ctrlenv-lucid if you are continuing to use typhos
PIXIBASE=ctrlenv-lucid
# Switch to ctrlenv-widget if you are no longer using typhos
# PIXIBASE=ctrlenv-widget

# Setup pixi
unset PYTHONPATH
source /cds/group/pcds/engineering_tools/"${ENGTOOLS}"/scripts/ctrlenv_setup.sh
ctrlenv-activate "${PIXIBASE}"/"${ENVVER}"

# Option 3: lucid launcher with pixi
# lucid "$1" --toolbar="$LUCID_CONFIG"/"$1"_toolbar.yaml &

# Option 4: pydm home with pixi
cd /cds/group/pcds/epics-dev/screens/pydm/"${HUTCH,,}"
pydm --hide-nav-bar --hide-menu-bar --hide-status-bar "${HUTCH,,}"_home.ui