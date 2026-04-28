{
  config,
  lib,
  ...
}:
let
  remminaPrefs = config.userPrefs.remmina;
in
{
  options.userPrefs.remmina.enable = lib.mkEnableOption ''
    Enable Remmina remote desktop client.
  '';

  config = lib.mkIf remminaPrefs.enable {
    services.remmina = {
      enable = true;
      addRdpMimeTypeAssoc = true;
    };
  };
}
