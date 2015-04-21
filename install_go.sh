#!/bin/bash

if [ `whoami` == "root" ];
then
	echo "You should not run this script as root"
	exit 1
fi

#sudo apt-get update -y
#sudo apt-get upgrade -y

# get dependencies
sudo apt-get install -y make screen gcc git mercurial libc6-dev pkg-config libgmp-dev

USER=`whoami`

# install go
cd /home/$USER
wget https://storage.googleapis.com/golang/go1.4.2.src.tar.gz
tar -xzvf go*.tar.gz
cd go/src
./make.bash
cd /home/$USER
cp /etc/skel/.bashrc .
echo "export GOROOT=/home/$USER/go" >> /home/$USER/.bashrc
echo "export GOPATH=/home/$USER/goApps" >> /home/$USER/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin' >> /home/$USER/.bashrc
source /home/$USER/.bashrc

cd /home/$USER/new-server
