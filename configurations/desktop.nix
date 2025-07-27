let
  commons = import ./common.nix;
in
{
  name = "trivdesktop";
  stateVersion = "25.05";
  hardwareKey = true;
  ip = "192.168.178.70";
  architecture = "x86_64-linux";

  users.trivaris = {    
    homeConfig = {
      bitwarden.enable = true;
      # chatgpt.enable = true;
      email.enable = true;
      spotify.enable = true;
      thunderbird.enable = true;
      vesktop.enable = true;
      vscodium = {
        enable = true;
        enableLSP = true;
      };

      fish.enable = true;
      eza.enable = true;
      fzf.enable = true;

      git.email = "github@tripple.lurdane.de";

      inherit (commons.homeConfig) librewolf terminals;
    };
  };

  nixosConfig = {
    bluetooth.enable = true;
    kde.enable = true;
    openssh.enable = true;
    printing.enable = true;
    sddm.enable = true;
    steam.enable = true;

    inherit (commons.nixosConfig) stylix;
  };
}
