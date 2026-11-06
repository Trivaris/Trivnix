{
  flake.homeModules.desktop-environment-wayvnc =
    {
      config,
      lib,
      ...
    }:
    let
      wayvnc-prefs = config.user-prefs.wayvnc;
    in
    {
      options.user-prefs.wayvnc.enable = lib.mkEnableOption "Remote desktop access via WayVNC";

      config = lib.mkIf wayvnc-prefs.enable {
        services.wayvnc = {
          enable = true;
          autoStart = true;
          settings = {
            address = "0.0.0.0";
            port = 5900;
          };
        };
      };
    };
}
