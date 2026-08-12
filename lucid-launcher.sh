#!/usr/bin/env bash

# shellcheck disable=SC1091
source /cds/group/pcds/pyps/conda/dev_conda

case "$1" in
  UED)
    # Hold off on the update for now
    export PYTHONPATH="/cds/group/pcds/pyps/apps/dev/lucid-old:/cds/group/pcds/pyps/apps/dev/pydm-ued:/cds/group/pcds/pyps/apps/dev/pcdswidgets-ued:$PYTHONPATH"
    ;;
  *)
    # All others: keep the dev_conda paths
    ;;
esac

if [ "$2" == "dev" ]; then
  echo "No active dev builds, loading standard build."
fi

lucid "$1" --toolbar="$LUCID_CONFIG"/"$1"_toolbar.yaml &

