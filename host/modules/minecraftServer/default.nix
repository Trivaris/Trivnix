{
  config,
  lib,
  pkgs,
  ...
}:
let
  minecraftServerPrefs = config.hostPrefs.minecraftServer;
in
{
  config = lib.mkIf minecraftServerPrefs.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
      package = minecraftServerPrefs.package;
    };
  };
}
