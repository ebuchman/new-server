#!/bin/bash -x
set -e

if [ `whoami` == "root" ];
then
	echo "You should not run this script as root"
	exit 1
fi

USER=`whoami`
source /home/$USER/.profile
rm -rf $GOPATH/src/github.com/tendermint/tendermint
go get github.com/tendermint/tendermint/cmd/tendermint

cd $GOPATH/src/github.com/tendermint/tendermint
git checkout develop
git pull 
make

