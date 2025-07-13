# nixos-vps-configuration

## Description

This repo is to store and make it easy to start a vps from start.

The goal of this configuration is to run two services within nixos and using flake.

- Nginx proxy manager
- Wireguard

Giving the possibility to connect to homeserver and forward all application without exposing home server ports.

And giving all the applications specific host naming through nginx proxy manager which will also manage certificate.


## Installation

 From a fresh install of nixos clone the repo on your user.

 run theses commands to free /etc/nixos and symlink this configuration in that place.

 ```bash
    sudo ln -s ~/nixos-vps-configuration /etc/nixos
 ```

 Add your environment file in this place :

 Follow env.exemple to know which value to add.

 Ready to update configuration running

 ```bash
   sudo nixos-rebuild switch --flake .#evangelyne
 ```