#!/bin/bash
# basic script to update the Ghost blog-software to a given version
# only works on Uberspace-systems. Depends on strictly following
# the documentation of the Uberspace-wiki: http://goo.gl/eW5TlR

# set the current ghost-version here
VERSION='0.5.3'

# let's save the current CentOS-version
RHEL='cat /etc/redhat-release | cut -d" " -f3 | cut -d "." -f1"'

for DIR in ~/ghost ; do
    if [ -d DIR ] ; then
        echo "you do not seem to have ghost-directory in your ~/."
        echo "please make sure you have followed the documentation."
        echo "if you are unsure, check the wiki: http://goo.gl/eW5TlR"
        exit 1
    fi
done

# let's make sure we're in the user's home directory
cd /home/$USER/

echo "stopping your current ghost-service to perform upgrade..."
svc -d ~/service/ghost/

# let's backup the current ghost-directory
cp -r ~/ghost ~/ghost-$(date +%T-%F)
echo "your ghost-directory has been backed up.";

export TMPDIR=`mktemp -d /tmp/XXXXXX`

curl -L https://ghost.org/zip/ghost-$VERSION.zip -O
unzip ghost-$VERSION.zip -d ghost-$VERSION

rm -rf ~/ghost/core
mv ~/ghost-$VERSION/core ~/ghost/core
rm -rf ~/ghost/content/themes/casper/
echo "updated default-theme casper. Check your custom theme for compatibility."
mv ~/ghost-$VERSION/content/themes/casper ~/ghost/content/themes/
cd ~/ghost-$VERSION/
cp *.js *.json *.md LICENSE ~/ghost

echo "entering ~/ghost-directory to perform final steps."
cd ~/ghost/

# ghost 0.5.2 needs a new directory in ~/ghost/content
mkdir content/apps

# if RHEL is not 6 assume it's 5. Do not use this on RHEL7 beta.
if [ "$RHEL" == 6  ];
then
    npm install --production
else
    npm install --python="/usr/local/bin/python2.7" --production
fi

echo "starting your ghost-service."
echo "Check for errors by executing 'tail -F ~/service/ghost/log/main/current'"
svc -u ~/service/ghost/

echo "cleaning up..."
rm -rf ~/ghost-$VERSION*
