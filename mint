#!/bin/bash

USER=`whoami`
source /home/$USER/.profile
BUILD=$GOPATH/src/github.com/tendermint/tendermint/build
if [ ! -d "$BUILD" ]; then
	mkdir -p $BUILD
fi
cd $BUILD
cat ../cmd/barak/seed0 | ./barak &
./tendermint node --fast_sync
