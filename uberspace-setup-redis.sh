#!/bin/sh

USER=`id -u`

if [ "$USER" = "0" ] ; then
  echo "This script is not meant to be run as root."
  exit 1
fi

if [ ! -d ~/service ] ; then
  echo "You don't have a ~/service directory."
  echo "Please run \"uberspace-setup-svscan\" to setup daemon-tools before setting up Redis."
  exit 2
fi

for DIR in ~/.redis ~/service/redis ~/etc/run-redis ; do
  if [ -d $DIR ] ; then
    echo "You already have a $DIR directory. Nothing to do here."
    exit 3
  fi
done

# Let's build redis
echo "Installing redis. This might take some time."
exec toast arm redis

if ["$?" ! = "0" ] then
  echo "Redis-installation with toast failed. This should not have happend."
  echo "Please contact hallo@uberspace.de so we can fix this. Thanks!"
  echo "Redis could not be installed. We're really sorry."
  exit 3

# create configuration for redis
echo "Creating Redis-configuration"
mkdir .redis
cat <<__EOF__ > unixsocket /home/$USER/.redis/sock
daemonize no
logfile /home/$USER/.redis/log
port 0
__EOF__

mkdir ~/etc/run-redis
cat <<__EOF__ > ~/etc/run-redis/run
#!/bin/sh
exec redis-server ~/.redis/conf
__EOF__
chmod 755 ~/etc/run-redis/run

echo "Creating symlink for ~/etc/run-redis to ~/service/redis to start the service"
exec ln -s ../etc/run-redis ~/service/redis

echo "Starting Redis..."
svc -u ~/service/redis

if [ "$?" ! = "0" ] 
then
  echo "Redis couldn't be started. This should not have happened."
  echo "Please contact hallo@uberspace.de so we can fix this. Thanks!"
else
  echo "Redis has been started."
fi

# famous last words
echo "Everything's been setup. You can use Redis now."
echo
echo "Please note that Redis does not use TCP."
echo "Instead, we setup Redis to use a UNIX-Socket to connect to."
echo
echo "To connect to redis via socket, use:"
echo
echo "redis-cli ~/.redis/sock"
echo 

