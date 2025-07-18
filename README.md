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

 #### Prepare disk for Mergerfs - Snapraid 

 ```bash
  # run this command to get drives informations
  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,LABEL,UUID
  # format parity and data drives
  sudo mkfs.ext4 -L data(x) /dev/sda(x)
  sudo mkfs.ext4 -L parity(x) /dev/sdb(x)
  # run this command again
  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,LABEL,UUID
 ```

Update ./modules/mergerfs-snapraid.nix file to match UUID for each disk from new system.

 ## Editor config

By default the os will be setup to open vscode

In case you need to use vim use this command to force vim instead.

```bash
export EDITOR=vim
```

## Back up lost HDD

add a new disk with the size lost and format it to ext4

```bash
sudo mkfs.ext4 -L data(x) /dev/sda(x)
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,LABEL,UUID
```

Put the new idea to mount and replace the old one on same place from ./modules/mergerfs-snapraid.nix

Then run command 

```bash
snapraid -c /etc/snapraid.conf fix
```