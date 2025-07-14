{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [ wireguard-tools ];
    
    age.secrets.wireguard-pk.file = ../../secrets/wireguards/tristepin-pk.age;
   
    networking.firewall.allowedUDPPorts = [ 51820 ];

  
    networking.wireguard.interfaces.wg0 = {
        privateKeyFile = config.age.secrets.wireguard-pk.path;

        ips = [ "10.100.0.2/32" ];

        peers = [
        {
            publicKey = "fiG3Pgw35nzjpcr+eNdD8vjpRoEe4qZG32ieyD7T0R0=";
            allowedIPs = [ "10.100.0.0/24" ];
            endpoint = "94.16.114.133:51820";
            persistentKeepalive = 25;
        }
        ];
    };

 
}