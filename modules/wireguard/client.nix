{ config, pkgs, ... }:

let
  vpnNamespace = "vpnspace";
in {
    environment.systemPackages = with pkgs; [ wireguard-tools ];
    age.secrets.wireguard-pk.file = ../../secrets/wireguards/tristepin-pk.age;
   
    networking.firewall.allowedUDPPorts = [ 51820 51821 ];
  
    networking.wireguard.interfaces = {
        wg0 = {
            privateKeyFile = config.age.secrets.wireguard-pk.path;
            ips = [ "10.100.0.2/24" ];
            interfaceNamespace = vpnNamespace;

            peers = [
            {
                publicKey = "fiG3Pgw35nzjpcr+eNdD8vjpRoEe4qZG32ieyD7T0R0=";
                allowedIPs = [ "0.0.0.0/0" "::/0" ];
                endpoint = "94.16.114.133:51820";
                persistentKeepalive = 25;
            }];
        };

        wg1 = {
            privateKeyFile = config.age.secrets.wireguard-pk.path;
            ips = [ "10.200.0.2/24" ];

            peers = [
            {
                publicKey = "fiG3Pgw35nzjpcr+eNdD8vjpRoEe4qZG32ieyD7T0R0=";
                allowedIPs = [ "10.200.0.1/32" ];
                endpoint = "94.16.114.133:51821";
                persistentKeepalive = 25;
            }];
        };
    
    };
 
}