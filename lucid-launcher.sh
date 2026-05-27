#!/usr/bin/env bash

# shellcheck disable=SC1091
source /cds/group/pcds/pyps/conda/dev_conda

case "$1" in
  UED)
    # Hold off on the update for now
    export PYTHONPATH="/cds/group/pcds/pyps/apps/dev/lucid-old:$PYTHONPATH"
    ;;
  *)
    # All others: keep the dev_conda paths
    ;;
esac

if [ "$2" == "dev" ]; then
  echo "Loading lucid-stale-fix dev build"
  export PYTHONPATH="/cds/group/pcds/pyps/apps/dev/lucid-stale-fix:$PYTHONPATH"
fi

lucid "$1" --toolbar="$LUCID_CONFIG"/"$1"_toolbar.yaml &
