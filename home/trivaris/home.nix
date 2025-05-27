{ 
  config, 
  lib, 
  pkgs, 
  ... 
}: {

  home.username = lib.mkDefault "trivaris";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    cowsay

    wezterm
    rofi

  ];

  home.file = {

  };

  home.sessionVariables = {

  };

  programs.home-manager.enable = true;

}