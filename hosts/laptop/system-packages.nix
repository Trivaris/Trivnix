{ ... }:
{

  services.printing.enable = true;
  hardware.bluetooth.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

}
