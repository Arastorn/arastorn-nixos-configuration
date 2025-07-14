{ pkgs, ... }:

{
  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "gnzh";
      plugins = [ "git" ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Arastorn";
    userEmail = "pro.abourgeois@gmail.com";
    extraConfig.push.autoSetupRemote = true;
  };

}