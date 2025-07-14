{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts."94.16.114.133" = {
      extraConfig = ''
        tls internal
        respond "Hello, world!"
      '';
    };
  };
}