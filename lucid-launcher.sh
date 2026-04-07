#!/usr/bin/env bash

# shellcheck disable=SC1091
source /cds/group/pcds/pyps/conda/dev_conda

case "$1" in
  TMO|UED)
    # Hold off on the update for now
    export PYTHONPATH="/cds/group/pcds/pyps/apps/dev/lucid-old:$PYTHONPATH"
    ;;
  *)
    # All others: keep the dev_conda paths
    ;;
esac

lucid "$1" --toolbar="$LUCID_CONFIG"/"$1"_toolbar.yaml &
