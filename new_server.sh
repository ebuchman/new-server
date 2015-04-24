#!/bin/bash

# set up a fresh server with moderate security settings and some 
# monitoring
# eg. http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers

# assumes we logged in as root (ie. for the first time)
#apt-get update
#apt-get -y upgrade

# fail2ban for monitoring logins
apt-get install -y fail2ban

# debian doesn't come with sudo?
apt-get install sudo

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

# make the user a sudoer
passwd $USER

# copy in the sudoers file
echo $SUDOERS > /etc/sudoers
chmod 400 /etc/sudoers

echo "GIVE $USER ssh ACCESS; BAN ROOT LOGIN; DISABLE PASSWORDS ..."

# update authorized keys
echo $IDRSAPUB >> /home/$USER/.ssh/authorized_keys
chmod 400 /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER -R

# copy in the ssh config with locked down settings
echo "$SSHCONFIG" > /etc/ssh/sshd_config

# TODO: add ssh whitelist

service ssh restart

# set up the network time daemon
if $NTP ; then 
	apt-get install -y ntp
fi

echo "ENABLE FIREWALL ..."

# set up firewall
apt-get install ufw

# white list ssh access 
for ip in "${WHITELIST[@]}"; do
	ufw allow from $ip to any port $SSHPORT
done
# if the whitelist is empty, open ssh port
if [ ${#WHITELIST[@]} -eq 0 ]; then
	ufw allow $SSHPORT
fi
# open ports
for port in "${OPENPORTS[@]}"; do
	ufw allow $port
done
# open port ranges
if [ ${#PORTRANGE_LOW[@]} != ${#PORTRANGE_HIGH[@]} ]; then
	echo "length of PORTRANGE_LOW and PORTRANGE_HIGH must be equal!"
	exit 1
fi
for ((i=0;i<${#PORTRANGE_LOW[@]};++i)); do
	ufw allow ${PORTRANGE_LOW[i]}:${PORTRANGE_HIGH[i]}/tcp
done

# apply
ufw enable

# watch the logs and have them emailed to me
apt-get install -y logwatch
echo "/usr/sbin/logwatch --output mail --mailto $USEREMAIL --detail high" >> /etc/cron.daily/00logwatch

echo "DONE HARDENING THE SERVER. SWITCHING OUT OF ROOT"
su $USER
