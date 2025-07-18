{ config, pkgs, agenix, ... }:

{
    environment.systemPackages = with pkgs; [ wireguard-tools ];

    age.secrets.wireguard-pk.file = ../../secrets/wireguards/evangelyne-pk.age;
        
    networking.firewall.allowedUDPPorts = [ 51820 51821 ];
    networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ]; 
      listenPort = 51820;

      privateKeyFile = config.age.secrets.wireguard-pk.path;

      peers = [
        {
          publicKey = "+MVPPO2qBPJMLjTowdva4gDbNzGYVkW/G98xDI/N228=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };

    wg1 = {
      ips = [ "10.100.1.1/24" ]; 
      listenPort = 51821;

      privateKeyFile = config.age.secrets.wireguard-pk.path;

      peers = [
        {
          publicKey = "+MVPPO2qBPJMLjTowdva4gDbNzGYVkW/G98xDI/N228=";
          allowedIPs = [ "10.100.1.2/32" ];
        }
      ];
    };
  };
}