#!/bin/bash


function get_self_dir(){
	pushd `dirname $0` > /dev/null;
	local SELF_PATH=`pwd -P`;
	popd > /dev/null;
	echo $SELF_PATH;
}

SELF_PATH=`get_self_dir`;

function remove_db_if_exists(){
	if [ -f $SELF_PATH/db/lab_viewer.db ]; then
		echo "removing old db file...";
		rm $SELF_PATH/db/lab_viewer.db;
        fi
}

function install(){
        remove_db_if_exists;
        echo "creating db structure...";
	sqlite3 $SELF_PATH/db/lab_viewer.db < $SELF_PATH/config/create_db.sql;
	echo "inserting initial data...";
	sqlite3 $SELF_PATH/db/lab_viewer.db < $SELF_PATH/config/initial_data.sql;
	echo "database ready.";
}

function interactive(){
	echo -n "Installation will overwrite existing db file. Continue? [yes or no]: "
	read yno
	case $yno in

		[yY] | [yY][Ee][Ss] )
			install
		       ;;

		[nN] | [n|N][O|o] )
			echo "Not agreed, exiting.";
			exit 1
			;;
		*) echo "Invalid input, choose yes or no."
		    ;;
	esac
}

interactive;
