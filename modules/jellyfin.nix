{ config, pkgs, ... }:

{
    services.jellyfin = {
        enable = true;
        dataDir = "/srv/jellyfin/config";
    };

    networking.firewall.allowedTCPPorts = [ 8096 ];

    systemd.services.jellyfin.serviceConfig = {
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = "read-only";
    };

    users.users.jellyfin = {
        isSystemUser = true;
        home = "/srv/jellyfin";
        createHome = true;
        group = "jellyfin";
        extraGroups = [ "media" ];
    };

    systemd.tmpfiles.rules = [
        # Dossier racine
        "d /srv 0755 root root - -"
        
        # Dossiers Jellyfin
        "d /srv/jellyfin 0755 jellyfin media - -"
        "d /srv/jellyfin/config 0755 jellyfin media - -"
        "d /srv/jellyfin/animes 0775 jellyfin media - -"
        "d /srv/jellyfin/series 0775 jellyfin media - -"
        "d /srv/jellyfin/movies 0775 jellyfin media - -"
        "d /srv/jellyfin/dramas 0775 jellyfin media - -"

        # Dossier Deluge
        "d /srv/deluge 0755 deluge media - -"
        "d /srv/deluge/config 0755 deluge media - -"

        # Dossier partagé
        "d /srv/downloads 2775 root media - -"
    ];

    fileSystems."/srv/downloads" = {
        device = "/srv/downloads";
        options = [ "bind" ];
    };

    fileSystems."/srv/jellyfin/animes" = {
        device = "/srv/jellyfin/animes";
        options = [ "bind" ];
    };

    fileSystems."/srv/jellyfin/series" = {
        device = "/srv/jellyfin/series";
        options = [ "bind" ];
    };

    fileSystems."/srv/jellyfin/movies" = {
        device = "/srv/jellyfin/movies";
        options = [ "bind" ];
    };

    fileSystems."/srv/jellyfin/dramas" = {
        device = "/srv/jellyfin/dramas";
        options = [ "bind" ];
    };
}