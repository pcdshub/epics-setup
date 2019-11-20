#!/bin/bash

pathmunge ()
{
	MUNGE_TMP=`/reg/g/pcds/setup/pathmunge.py PATH            $1`
	if [ "$MUNGE_TMP" == "" ]; then
		echo "Usage: pathmunge PATH"
		return 1
	fi
	export PATH=$MUNGE_TMP
}

ldpathmunge ()
{
	MUNGE_TMP=`/reg/g/pcds/setup/pathmunge.py LD_LIBRARY_PATH $1`
	if [ "$MUNGE_TMP" == "" ]; then
		echo "Usage: ldpathmunge PATH"
		return 1
	fi
	export LD_LIBRARY_PATH=$MUNGE_TMP
}

pythonpathmunge ()
{
	MUNGE_TMP=`/reg/g/pcds/setup/pathmunge.py PYTHONPATH      $1`
	if [ "$MUNGE_TMP" == "" ]; then
		echo "Usage: pythonpathmunge PATH"
		return 1
	fi
	export PYTHONPATH=$MUNGE_TMP
}

edmpathmunge ()
{
	MUNGE_TMP=`/reg/g/pcds/setup/pathmunge.py EDMDATAFILES    $1`
	if [ "$MUNGE_TMP" == "" ]; then
		echo "Usage: edmpathmunge PATH"
		return 1
	fi
	export EDMDATAFILES=$MUNGE_TMP
}

