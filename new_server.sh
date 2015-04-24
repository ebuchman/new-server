#!/bin/bash -x 
set -e

# set up a fresh server with moderate security settings and some 
# monitoring
# eg. http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers

# assumes we logged in as root (ie. for the first time)
if [ "$UU" = "true" ]; then
	apt-get update
	apt-get -y upgrade
fi

# load the user info
source info.sh
# load the configs
source config.sh

# Get the dependencies
echo "GETTING DEPENDENCIES ..."
for  dep in "${OPENPORTS[@]}"; do
	apt-get install -y $dep
done

# copy in the sudoers file
echo $SUDOERS > /etc/sudoers
chmod 400 /etc/sudoers

echo "CREATE USER $USER ..."
bash new_user.sh

echo "BAN SSH ROOT LOGIN and DISABLE PASSWORDS ..."

# copy in the ssh config with locked down settings
echo "$SSHCONFIG" > /etc/ssh/sshd_config

# TODO: add ssh whitelist

service ssh restart

# GET SERVICES
for service in "${SERVICES[@]}"; do
	apt-get install -y $service
done

# GET APP dependencies
for app in "${APPS[@]}"; do
	apt-get install -y $app
done

echo "ENABLE FIREWALL ..."

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
yes | ufw enable

# watch the logs and have them emailed to me
# TODO: investigate this further .. 
# apt-get install -y logwatch
# echo "/usr/sbin/logwatch --output mail --mailto $USEREMAIL --detail high" >> /etc/cron.daily/00logwatch

echo "DONE HARDENING THE SERVER. SWITCHING OUT OF ROOT"
su $USER
