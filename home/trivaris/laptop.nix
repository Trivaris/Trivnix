{ ... }:
{

  imports = [
    ../common
    ../modules
  ];

  config.homeModules = {
    hyprland = true;
    librewolf = false;
    wezterm = true;
    cli-utils = true;
    fish = true;
    font = true;
    fzf = true;
    nvim = true;
    rofi = true;
    vscodium = true;
    waybar = true;
  };

  config.git.userEmail = "github@tripple.lurdane.de";

}
