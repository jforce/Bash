#! /bin/sh
### BEGIN INIT INFO
# Provides:          bingo 
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Mounts a fusedav definition
# Description:       Mounts a remote directory locally using fusedav.
### END INIT INFO

# Author: Jamie Talbot <code@jamietalbot.com>
# Parts of the script stolen from http://msuzso.hu

# Unique name to run this script
NAME=bingo

# Path to fusedav
DAEMON=/usr/bin/fusedav

# PID file to check for already running processes.
PIDFILE=/var/run/$NAME.pid

# Name of this script
SCRIPTNAME=/etc/init.d/$NAME

# Location of mount file.
MOUNT_FILE=/etc/fusedav/mounts-available/$NAME

# Local point at which to mount the remote directory
MOUNT_POINT=/mnt/$NAME

PATH=/sbin:/usr/sbin:/bin:/usr/bin

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Check we have a valid mount file.
[ -r "$MOUNT_FILE" ] || exit 0 

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions

#
# Reads the mount file and mounts the remote drive appropriately.
#
do_start()
{
	# Return
	start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $DAEMON --test > /dev/null \
		|| return 1
	
	set -- $(cat ${MOUNT_FILE})
	URI=$1
	USERNAME=$2
	PASSWORD=$3

	DAEMON_ARGS="-u $USERNAME -p $PASSWORD $URI $MOUNT_POINT"

	start-stop-daemon --start --quiet --pidfile $PIDFILE --background --make-pidfile --exec $DAEMON -- \
		$DAEMON_ARGS \
		|| return 2 
}

#
# Unmounts the remote share.
#
do_stop()
{
	umount $MOUNT_POINT
	rm -f $PIDFILE
	return 0
}

case "$1" in
  start)
	[ "$VERBOSE" != no ] && log_daemon_msg "Mounting $MOUNT_POINT"
	do_start
	case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  stop)
	[ "$VERBOSE" != no ] && log_daemon_msg "Unmounting $MOUNT_POINT"
	do_stop
	case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  status)
       status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
       ;;
  restart|force-reload)
	log_daemon_msg "Remounting $MOUNT_POINT"
	do_stop
	case "$?" in
	  0|1)
		do_start
		case "$?" in
			0) log_end_msg 0 ;;
			1) log_end_msg 1 ;; # Old process is still running
			*) log_end_msg 1 ;; # Failed to start
		esac
		;;
	  *)
	  	# Failed to stop
		log_end_msg 1
		;;
	esac
	;;
  *)
	echo "Usage: $SCRIPTNAME {start|stop|status|restart|force-reload}" >&2
	exit 3
	;;
esac

:
