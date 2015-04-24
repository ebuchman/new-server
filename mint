#!/bin/bash

USER=`whoami`
cd $GOPATH/src/github.com/tendermint/tendermint/build
cat ../cmd/barak/seed0 | ./barak &
./tendermint node --fast_sync
