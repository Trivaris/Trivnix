{
  name = "trivdesktop";
  stateVersion = "25.05";
  hardwareKey = true;
  ip = "192.168.178.70";
  architecture = "x86_64-linux";

  users.trivaris = {
    name = "trivaris";
    homeModules = {
      hyprland.enable = true;
      librewolf.enable = false;
      wezterm.enable = true;
      cli-utils.enable = true;
      fish.enable = true;
      font.enable = true;
      fzf.enable = true;
      nvim.enable = true;
      rofi.enable = true;
      waybar.enable = true;
      git.email = "github@tripple.lurdane.de";
    };
  };

  nixosModules = {
    bluetooth.enable = true;
    fish.enable = true;
    kde.enable = true;
    openssh.enable = true;
    printing.enable = true;
  };
}