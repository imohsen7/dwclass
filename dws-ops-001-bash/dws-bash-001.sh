#!/bin/bash

checkEnv() { 
	if [[ ! -v $1 ]];then
		case $1 in
			TRY_INTERVAL)
				TRY_INTERVAL=2
				;;
			TRY_NUMBER)
				TRY_NUMBER=3
				;;
			TRY_COMMAND)
				TRY_COMMAND="testapp new app"
				;;
		esac
	fi
}

if [[ $# -eq 0 ]]; then
	checkEnv TRY_INTERVAL
	if [[ $? -eq 0 ]];then
		interval=$TRY_INTERVAL
	fi
	checkEnv TRY_NUMBER
	if [[ $? -eq 0 ]];then
		number=$TRY_NUMBER
	fi
	checkEnv TRY_COMMAND
	if [[ $? -eq 0 ]];then
		cmd=$TRY_COMMAND
	fi
else
	while true; do
		case $1 in
			-i)
			interval=$2
			shift 2
			;;
			-n)
			number=$2
			shift 2;
			;;
			*)
			cmd=$*
			break
			;;
		esac
	done
fi

$cmd 2>/dev/null
cmdres=$?
if [[ $cmdres -ne 0 ]];then
	for (( i=1;i<=$number;i++));do
		echo "Run ->"$cmd
		$cmd 2>/dev/null
		cmdres=$?
		if [[ $cmdres -eq 0 ]];then
			echo "OK"
			exit 0;
		else
			echo "Retry :"$interval" sec"
			sleep $interval
		fi
	done
	echo "Run Timeout ."
	exit 1;
fi
