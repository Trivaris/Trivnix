let
  commons = import ./common.nix;
in
{
  name = "trivlaptop";
  stateVersion = "25.05";
  hardwareKey = true;
  ip = "192.168.178.90";
  architecture = "x86_64-linux";

  users.trivaris = {
    homeConfig = {
      eza.enable = true;
      fish.enable = true;
      fzf.enable = true;
      spotify.enable = true;
      thunderbird.enable = true;
      vesktop.enable = true;
      waydroid.enable = true;
      email.enable = true;

      git.email = "github@tripple.lurdane.de";
      terminals = [ "alacritty" ];

      inherit (commons.homeConfig) librewolf;
    };
  };

  nixosConfig = {
    bluetooth.enable = true;
    openssh.enable = true;
    printing.enable = true;
    kde.enable = true;
    sddm.enable = true;

    inherit (commons.nixosConfig) stylix;
  };
}