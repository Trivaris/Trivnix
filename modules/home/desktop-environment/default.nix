{ self, ... }:
{
  flake.homeModules.desktop-environment = {
    imports = [
      self.homeModules.desktop-environment-hyprland
      self.homeModules.desktop-environment-quickshell
      self.homeModules.desktop-environment-rofi
      self.homeModules.desktop-environment-wayvnc
    ];
  };
}
