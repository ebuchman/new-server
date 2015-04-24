#!/bin/bash

# set up a fresh server with moderate security settings and some 
# monitoring
# eg. http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers

# assumes we logged in as root (ie. for the first time)
#apt-get update
#apt-get -y upgrade

# load the user info
source info.sh
# load the configs
source config.sh

echo "CREATE USER $USER ..."

# create user
useradd $USER
mkdir /home/$USER
mkdir /home/$USER/.ssh
chmod 700 /home/$USER/.ssh

# copy this dir into the users
mkdir /home/$USER/new-server
cp -r ./* /home/$USER/new-server/
cp -r ./.git /home/$USER/new-server/
chmod 700 /home/$USER/new-server

# give him bash on ssh
chsh -s /bin/bash $USER

echo "GIVE $USER sudo PERMISSIONS ... "

if [ "$PWD" != "" ]; then
	echo $USER:$PWD | chpasswd
else
	passwd $USER
fi

# update authorized keys
echo $IDRSAPUB >> /home/$USER/.ssh/authorized_keys
chmod 400 /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER -R
