{ config, pkgs, ... }:

{
    # Jellyfin
    users.groups.medias = {};

    users.users.jellyfin = {
        isSystemUser = true;
        group = "jellyfin";
        extraGroups = [ "video" "medias" ]; # video for access to gpu drivers
    };

    systemd.tmpfiles.rules = [
        "d /storage/jellyfin 2774 jellyfin jellyfin - -"
        "d /storage/jellyfin/animes 2774 jellyfin medias - -"
        "d /storage/jellyfin/series 2774 jellyfin medias - -"
        "d /storage/jellyfin/movies 2774 jellyfin medias - -"
        "d /storage/jellyfin/dramas 2774 jellyfin medias - -"
    ];

    services.jellyfin = {
        enable = true;
        dataDir = "/var/lib/jellyfin";
        openFirewall = true; #8096
    };

    systemd.services.jellyfin.serviceConfig = {
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = "yes";
    };

    # Enabling transcoding with intel quicksync 
    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-driver
            vaapiIntel
            vpl-gpu-rt
        ];
    };

    # Radarr
    services.radarr = {
        enable = true;
        dataDir = "/var/lib/radarr";
        openFirewall = true; #7878
    };

    users.users.radarr = {
        isSystemUser = true;
        extraGroups = [ "medias" ];
    };

    # Sonarr
    services.sonarr = {
        enable = true;
        dataDir = "/var/lib/sonarr";
        openFirewall = true; #8989
    };

    users.users.sonarr = {
        isSystemUser = true;
        extraGroups = [ "medias" ];
    };

}