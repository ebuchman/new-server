#!/bin/bash

# we start as root, but switch to install go and tendermint

# harden the server
source ./new_server.sh

su $USER

# install golang. retain env variables
source install_go.sh

# remove and install tendermint
bash install_tendermint.sh

