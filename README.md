# arastorn-nixos-configuration

## Description

This repo is to store and make it easy to start my multimachines configuration from start.

The goal of this configuration is to run two services all services within nixos and using flake.

- Caddy
- Wireguard

Giving the possibility to connect to homeserver and forward all application without exposing home server ports.

And giving all the applications specific host naming through nginx proxy manager which will also manage certificate.

## Installation

 From a fresh install of nixos clone the repo on your user.

 Then get your pub key from the new root user and add it to the list on secrets/secrets.nix usually from 

 ```bash
    ssh-keygen -t ed25519
 ```

 from there back to a computer that have already a private key access to the encrypted secrets and run this command to reencrypt all secret making them available for it.

 ```bash
    agenix --rekey
 ```

Then pull changes on git from the new machine and run the next command to start the machine configuration.

 ### VPS

 ```bash
   sudo nixos-rebuild switch --flake .#evangelyne
 ```

### Home Server

 ```bash
   sudo nixos-rebuild switch --flake .#tristepin
 ```

 ## Editor config

By default the os will be setup to open vscode

In case you need to use vim use this command to force vim instead.

```bash
export EDITOR=vim
```