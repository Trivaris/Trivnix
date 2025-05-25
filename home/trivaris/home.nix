{ 
  config, 
  lib, 
  pkgs, 
  ... 
}: {

  home.username = lib.mkDefault "trivaris";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    cowsay

    ghostty
    rofi

  ];

  home.file = {

  };

  home.sessionVariables = {

  };

  programs.home-manager.enable = true;

}