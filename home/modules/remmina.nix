{
  config,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  options.userPrefs.remmina.enable = lib.mkEnableOption ''
    Enable Remmina remote desktop client.
  '';

  config = lib.mkIf prefs.remmina.enable {
    services.remmina = {
      enable = true;
      addRdpMimeTypeAssoc = true;
    };
  };
}
