{ config, pkgs, agenix, ... }:

{
    environment.systemPackages = with pkgs; [ wireguard-tools ];

    age.secrets.wireguard-pk.file = ../../secrets/wireguards/evangelyne-pk.age;


    boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
    networking.firewall = {
      allowedUDPPorts = [ 51820 51821 ];

      extraCommands  = ''
        iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
        iptables -A FORWARD -i wg0 -o ens3 -j ACCEPT
        iptables -A FORWARD -i ens3 -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT
        iptables -A INPUT -i wg0 -j ACCEPT
      '';
    };

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
        ips = [ "10.200.0.1/24" ]; 
        listenPort = 51821;

        privateKeyFile = config.age.secrets.wireguard-pk.path;

        peers = [
          {
            publicKey = "+MVPPO2qBPJMLjTowdva4gDbNzGYVkW/G98xDI/N228=";
            allowedIPs = [ "10.200.0.2/32" ];
          }
        ];
      };
    };
}
