{ ... }:
{

  imports = [
    ../common
    ./credentials.nix
  ];

  config.modules = {
    hyprland = true;
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

}
