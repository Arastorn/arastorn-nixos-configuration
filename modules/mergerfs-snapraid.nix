{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    snapraid
    mergerfs
  ];

  # MergerFS Configuration
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/6450f991-6e54-4395-a0b6-49995cb4df46";
    fsType = "ext4";
  };

  fileSystems."/mnt/parity" = {
    device = "/dev/disk/by-uuid/3dbf052f-5472-4485-abaf-4cd7cecb5064";
    fsType = "ext4";
  };

  fileSystems."/storage" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/data";
    options = [
      "defaults"
      "allow_other"
      "use_ino"
      "category.create=mfs"
    ];
    neededForBoot = false;
  };

  # SnapRAID configuration
  environment.etc."snapraid.conf".text = ''
    parity /mnt/parity/snapraid.parity
    content /mnt/data/.snapraid.content
    data /mnt/data
    exclude *.unrecoverable
    exclude /lost+found/
    exclude /tmp/
    exclude *.bak
    exclude *.log
  '';

  systemd.tmpfiles.rules = [
    "d /mnt/data 0755 root root -"
    "d /mnt/parity 0755 root root -"
    "d /storage 0755 root root -"
  ];

    systemd.services.snapraid-sync = {
        description = "Daily SnapRAID sync";
        serviceConfig = {
            ExecStart = "${pkgs.snapraid}/bin/snapraid sync";
        };
    };

    systemd.timers.snapraid-sync = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
        };
    };
}