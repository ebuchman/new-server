#!/bin/bash

USER=`whoami`
cd $GOPATH/src/github.com/tendermint/tendermint/build
cat ../cmd/barak/seed | ./barak &
./tendermint node --fast_sync
