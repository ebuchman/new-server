#!/bin/bash

# should we apt-get update & upgrade?
UU=true

# set to disable to lock the root user
# other wise it will set its password
# TODO: this should be hashed
ROOTPWD=disable

# User's info
USER=deploy
# TODO: this should be hashed
PWD=balls
USEREMAIL="deploy@hulabaloo.com"
IDRSAPUB="ssh-rsa MYLONGPHATRSAKEY deploy@hulabaloo.com"
SUDO=true

# Network config/firewall
WHITELIST=()
SSHPORT=22
OPENPORTS=()
PORTRANGE_LOW=(46600)
PORTRANGE_HIGH=(46699)

# Deps
# non-ubuntu doesnt necessarily come with these things...
DEPS=("sudo", "ufw")

# Services
# TODO: configs for services
SERVICES=("ntp")

# applications
APPS=(make screen gcc git mercurial libc6-dev pkg-config libgmp-dev)
