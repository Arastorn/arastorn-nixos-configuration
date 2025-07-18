{ config, pkgs, lib, ... }:

let
    wireguardInterface = "wg0";
    wireguardOnlyGID = 991;
in {
    environment.systemPackages = [
        pkgs.qbittorrent-nox
    ];

    users.groups.wireguard_only  = {};
    users.groups.wireguard_only.gid = wireguardOnlyGID;

    networking.nftables.enable = true;
    # Drop all traffic from vpnonly group user not via wg0
    # May change ip daddrto match local network ip mask
    networking.nftables.ruleset = ''
        table inet filter {
            chain output {
                type filter hook output priority filter; policy accept;
                
                meta skgid != 991 accept

                oifname "wg0" accept

                drop
            }
        }
    '';

    users.users.qbittorrent = {
        isSystemUser = true;
        group = "wireguard_only";
        createHome = true;
        home = "/var/lib/qbittorrent";
    };

    systemd.tmpfiles.rules = [
        "d /storage/downloads 2775 qbittorrent medias - -"
    ];

    systemd.services.qbittorrent = {
        enable = true;
        description = "qBittorrent-nox daemon";
        after = [ "wireguard-${wireguardInterface}.service" ];
        requires = [ "wireguard-${wireguardInterface}.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
        Type = "simple";
        User = "qbittorrent";
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=9421";
        Restart = "on-failure";
        WorkingDirectory = "/var/lib/qbittorrent";
        };
    };

    networking.firewall.allowedTCPPorts = [ 9421 ];

    # Prowlarr
    users.users.prowlarr = {
        isSystemUser = true;
        group = "wireguard_only";
    };

    services.prowlarr = {
        enable = true;
        # dataDir = "/var/lib/prowlarr";
        openFirewall = true; #9696
    };
}