{
  name = "trivlaptop";
  stateVersion = "25.05";
  hardwareKey = true;
  ip = "192.168.178.90";
  architecture = "x86_64-linux";

  users.trivaris = {
    homeModules = {
      librewolf.enable = true;
      wezterm.enable = true;
      eza.enable = true;
      fish.enable = true;
      fzf.enable = true;

      git.email = "github@tripple.lurdane.de";
    };
  };

  nixosModules = {
    bluetooth.enable = true;
    font.enable = true;
    kde.enable = true;
    openssh.enable = true;
    printing.enable = true;
  };
}