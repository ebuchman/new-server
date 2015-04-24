#!/bin/bash

# set up a fresh server with moderate security settings and some 
# monitoring
# eg. http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers

# assumes we logged in as root (ie. for the first time)
#apt-get update
#apt-get -y upgrade

# load the user info
source info.sh

echo "CREATE USER $USER ..."

# create user
useradd $USER
mkdir /home/$USER
mkdir /home/$USER/.ssh
chmod 700 /home/$USER/.ssh

# copy this dir into the users
mkdir -p /home/$USER/new-server
cp -a ./* /home/$USER/new-server/
cp -a ./.git /home/$USER/new-server/
chmod 700 /home/$USER/new-server

cp /etc/skel/.bashrc /home/$USER/
cp /etc/skel/.profile /home/$USER/

# give him bash on ssh
chsh -s /bin/bash $USER


# set user password
# TODO: password in info.sh should be hashed
if [ "$PWD" != "" ]; then
	echo $USER:$PWD | chpasswd
else
	passwd $USER
fi

# update authorized keys
echo "AUTHORIZING USER's PUBKEY"
echo $IDRSAPUB
echo $IDRSAPUB >> /home/$USER/.ssh/authorized_keys
chmod 400 /home/$USER/.ssh/authorized_keys
chown -R $USER:$USER /home/$USER

if [ "$SUDO" = "true" ]; then
	echo "GIVE $USER sudo PERMISSIONS ... "
	echo "$USER	ALL=(ALL) ALL" >> /etc/sudoers
fi

