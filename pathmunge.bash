#!env bash


pathpurge()
{
	if [ "$1" == "" ] ; then
		echo Usage: pathpurge dirname
		return
	fi
	while [ $# -gt 0 ] ;
	do
		PATH=`echo $PATH | sed -e "s%$1:%%g"`
		PATH=`echo $PATH | sed -e "s%:$1\$%%g"`
		PATH=`echo $PATH | sed -e "s%^$1\$%%"`
		shift
	done
}

pathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: pathmunge dirname
		return
	fi
	if [ ! -d "$1" ] ; then
		echo pathmunge: $1 is not a directory
		return
	fi
	if [ "$PATH" == "" ] ; then
		export PATH=$1
		return
	fi
	pathpurge $1
	export PATH=$1:$PATH
#	echo pathmunge: prepended $1 to PATH
}

edmpathpurge()
{
	if [ "$1" == "" ] ; then
		echo Usage: edmpathpurge dirname
		return
	fi
	while [ $# -gt 0 ] ;
	do
		EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%$1:%%g"`
		EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%:$1\$%%g"`
		EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%^$1\$%%"`
		shift
	done
}

edmpathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: edmpathmunge dirname
		return
	fi
	if [ ! -d "$1" ] ; then
		echo edmpathmunge: $1 is not a directory
		return
	fi
	if [ "$EDMDATAFILES" == "" -o "$EDMDATAFILES" == "$1" ] ; then
		export EDMDATAFILES=$1
		return
	fi
	edmpathpurge $1
	export EDMDATAFILES=$1:$EDMDATAFILES
}

ldpathpurge()
{
	if [ "$1" == "" ] ; then
		echo Usage: ldpathpurge dirname
		return
	fi
	while [ $# -gt 0 ] ;
	do
		LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%$1:%%g"`
		LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%:$1\$%%g"`
		LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%^$1\$%%"`
		shift
	done
}

ldpathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: ldpathmunge dirname
		return
	fi
	if [ ! -d "$1" ] ; then
		echo ldpathmunge: $1 is not a directory
		return
	fi
	if [ "$LD_LIBRARY_PATH" == "" -o "$LD_LIBRARY_PATH" == "$1" ] ; then
		export LD_LIBRARY_PATH=$1
		return
	fi
	ldpathpurge $1
	export LD_LIBRARY_PATH=$1:$LD_LIBRARY_PATH
#	echo ldpathmunge: prepended $1 to LD_LIBRARY_PATH
}

pythonpathpurge()
{
	if [ "$1" == "" ] ; then
		echo Usage: pythonpathpurge dirname
		return
	fi
	while [ $# -gt 0 ] ;
	do
		PYTHONPATH=`echo $PYTHONPATH | sed -e "s%$1:%%g"`
		PYTHONPATH=`echo $PYTHONPATH | sed -e "s%:$1\$%%g"`
		PYTHONPATH=`echo $PYTHONPATH | sed -e "s%^$1\$%%"`
		shift
	done
}

pythonpathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: pythonpathmunge dirname
		return
	fi
	if [ ! -d "$1" ] ; then
		echo pythonpathmunge: $1 is not a directory
		return
	fi
	if [ "$PYTHONPATH" == "" -o "$PYTHONPATH" == "$1" ] ; then
		export PYTHONPATH=$1
		return
	fi
	pythonpathpurge $1
	export PYTHONPATH=$1:$PYTHONPATH
}

