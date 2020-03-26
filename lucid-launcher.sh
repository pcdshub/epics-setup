#!/usr/bin/env bash

source /reg/g/pcds/pyps/conda/dev_conda

lucid "$1" --toolbar=$LUCID_CONFIG/"$1"_toolbar.yaml &
