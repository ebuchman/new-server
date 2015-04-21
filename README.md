New Server
----------

This directory contains scripts for a simple moderately secure server setup.

To fetch the directory in the first place, run:
```
apt-get update
apt-get upgrade -y
apt-get install git
git clone https://github.com/ebuchman/new-server /new-server
cd /new-server
```

Add your info to `info.sh` and ensure you are logged in as root.

## To get set up in 4 steps:

First harden the server with

`bash new_server.sh`

Note you should only ever run this script once.

You should now be some user (not root). Change to his directory:

`cd ~/new-server`

Now install golang:

`source ./install_go.sh`

And tendermint:

`bash install_tendermint.sh`

It would now be a good idea to log out and ssh back in with the new user.

## You can run tendermint with 

`bash mint`
