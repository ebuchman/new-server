#!/bin/bash

# should we apt-get update & upgrade?
UU=true

# User's info
USER=deploy
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


