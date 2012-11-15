#!/bin/sh

usage() {
  echo "Usage: $0 <service to be removed>"
  echo "for example: $0 mydaemon"
  exit 1
}

if [ $# -ne 1 ]
then
  echo "One argument expected."
  echo "You probably forgot to name the daemon you want to expel?"
  exit 1
fi

DAEMON=$0
# Let's shift things up if we decide to allow multiple deletions:
# shift

if [ "$DAEMON" = "" ] ; then
  usage
fi

# There's a nasty syntax-error somewhere, nothing to see here...
if [[ ! "$DAEMON" =~ "^[a-z]" ]]
  usage
fi

if [ -d ~/service ] ; then
  echo "~/service directory exists, good..."
else 
  echo "You don't seem to have any services in ~/service." 
  exit 1
fi

# Let's see if this daemon actually exists
if [ ! -f ~/service/$DAEMON ] ; then
  echo "The daemon $DAEMON doesn't exist. "
  exit 2
fi 

# Behold!
echo "Deleting $DAEMON service"
cd ~/service/$DAEMON
rm ~/service/$DAEMON
svc -dx . log
rm -rf ~/etc/run-$DAEMON
cd ~

exit 0
