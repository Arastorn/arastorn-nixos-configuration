{ config, pkgs, lib, ... }:

let
    wireguardInterface = "wg0";
in {
    environment.systemPackages = [
        pkgs.qbittorrent-nox
        pkgs.prowlarr
    ];

    users.groups.qbittorrent = {};

    users.users.qbittorrent = {
        isSystemUser = true;
        group = "qbittorrent";
        createHome = true;
        home = "/var/lib/qbittorrent";
    };

    systemd.tmpfiles.rules = [
        "d /storage/downloads 2775 qbittorrent medias - -"
        "d /var/lib/prowlarr 2770 prowlarr prowlarr - -"
        "d /var/lib/private 2775 prowlarr prowlarr - -"
        "d /var/lib/private/prowlarr 2770 prowlarr prowlarr - -"
    ];

    networking.firewall.allowedTCPPorts = [ 9421 9696 ];
    
    
    systemd.services.qbittorrent = {
        enable = true;
        description = "qBittorrent via wireguard";
        after = [ "wireguard-${wireguardInterface}.service" ];
        requires = [ "wireguard-${wireguardInterface}.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
            NetworkNamespacePath= "/var/run/netns/vpnspace";
            Type = "simple";
            User = "qbittorrent";
            ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=9421";
            Restart = "on-failure";
            WorkingDirectory = "/var/lib/qbittorrent";
        };
    };

    # Prowlarr

    users.groups.prowlarr = {};

    users.users.prowlarr = {
        isSystemUser = true;
        group = "prowlarr";
        home = "/var/lib/prowlarr";
    }; 

    systemd.services.prowlarr = {
        enable = true;
        description = "Prowlarr Service (via WireGuard)";
        after = [ "wireguard-${wireguardInterface}.service" ];
        requires = [ "wireguard-${wireguardInterface}.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
            NetworkNamespacePath = "/var/run/netns/vpnspace";
            Type = "simple";
            User = "prowlarr";
            ExecStart = "${pkgs.prowlarr}/bin/Prowlarr";
            Restart = "on-failure";
            WorkingDirectory = "/var/lib/prowlarr";
        };
    }; 

}