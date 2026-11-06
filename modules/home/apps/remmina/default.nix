{
  flake.homeModules.apps-remmina =
    {
      config,
      lib,
      ...
    }:
    let
      remmina-prefs = config.user-prefs.remmina;
    in
    {
      options.user-prefs.remmina.enable = lib.mkEnableOption "Remmina remote desktop client";

      config = lib.mkIf remmina-prefs.enable {
        services.remmina = {
          enable = true;
          addRdpMimeTypeAssoc = true;
        };
      };
    };
}
