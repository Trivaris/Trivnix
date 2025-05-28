{
  config,
  ...
}: {

  cli = {
    cli-tools.enable = true;
    fish.enable = true;
    fzf.enable = true;
  };

  desktop = {
    wayland.enable = true;
    hyprland.enable = true;
    fonts.enable = true;
  };

}