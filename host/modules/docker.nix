{
  lib,
  pkgs,
  config,
  ...
}:
let
  dockerPrefs = config.hostPrefs.docker;
in
{
  options = {
    hostPrefs.docker.enable = lib.mkEnableOption "Enable Docker";
  };

  config = lib.mkIf dockerPrefs.enable {
    environment.systemPackages = [ pkgs.docker ];
    virtualisation.docker.enable = true;
  };

}