{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{
  options.nixosModules.android-emulator = mkEnableOption "Android Emulator";

  config = mkIf cfg.android-emulator {

    virtualisation.waydroid.enable = true;
    environment.systemPackages = with pkgs; [
      androidsdk
      android-tools
      waydroid-helper
      nur.repos.ataraxiasjel.waydroid-script
    ];

  };
}
