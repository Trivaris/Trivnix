{
  flake.homeModules.apps-remmina =
    {
      config,
      lib,
      ...
    }:
    let
      remminaPreferences = config.user.preferences.remmina;
    in
    {
      options.user.preferences.remmina.enable = lib.mkEnableOption "Remmina remote desktop client";

      config = lib.mkIf remminaPreferences.enable {
        services.remmina = {
          enable = true;
          addRdpMimeTypeAssoc = true;
        };
      };
    };
}
