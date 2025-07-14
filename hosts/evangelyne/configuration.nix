{ config, pkgs, agenix, ... }:

{

  imports = [
    ./hardware-configuration.nix
    agenix.nixosModules.default
    ../../modules/caddy.nix
    ../../modules/wireguard/host.nix
  ];

  age = { 
    identityPaths = [ "/root/.ssh/id_ed25519" ];
    secrets = {
      user-password.file =  ../../secrets/passwords/user.age;
      root-password.file = ../../secrets/passwords/root.age;
    };
  };
  
  system.stateVersion = "25.05";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "evangelyne";
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    zsh 
    vim 
    git 
    curl
    agenix.packages."${system}".default
    caddy
  ];

  # Enable Remote vscode
  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  services.openssh = {
    enable = true;
    ports = [ 2923 ];
  };

  systemd.services.sshd.restartIfChanged = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = false;

  users.users = let
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvqb4Nu8zH0y8XylZVXIUpgI/cBJ4SeQXKkw6t5dTbo antoine.bourgeois1996@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7ig2rTLNkn1U3Lwoq97KASoPWg96IeP4NMsgrJqMUL4l2lU+Rdne5vuhUIUwzTn1B3/tWJQy54dJuLMzFw+UpHDeHHEzDjFPqftXYAwzoQh7At3//iplGdv7bdy06BsyU3t8YGY+xRPB5VncuPjVlVvjluJjl0r4RLgOvCs2m1FxNlEKwLxccoAezb5ekTt+sot658tRJQ/wxMXXwWs7P1oIBvtaPyWn8dVyXwH3sZ024uLaUznj1BikfQEZ1s6gW8xSXwVIlfSVEzNrac0/Z4rxESVZY1w4ciOier2NO0x6kVEgw3cdVqLplBiGJGPuZEJbF34xvQplIh9U/mh3+5L4TWx9KoAysp6VAhmnjIpADm25qja7IOcqa4TOCChHPJ34Lx7TbVrBJcp5zOpeLrmJKhQ7gWwg6/3ULc8Zfg07cJlwkr2ufWKUM+q69cX6eqd4CH+G2oxdMoRI6wL8G5LQJrNFwwGL/VUpcIa0y5Jp3qLuudF5031s4tnvsVfc= antoine.bourgeois@DL68G14J3"
    ];
  in {
    arastorn = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = sshKeys;
      hashedPasswordFile = config.age.secrets.user-password.path;
    };

    root = {
      hashedPasswordFile = config.age.secrets.root-password.path;
      openssh.authorizedKeys.keys = sshKeys;
    };
  };

  home-manager.users.root = import ../../home/root.nix;
  home-manager.users.arastorn = import ../../home/arastorn.nix;
  
}
