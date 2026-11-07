{
  flake.homeModules.desktop-environment-wayvnc =
    {
      osConfig,
      lib,
      ...
    }:
    let
      wayvnc-prefs = osConfig.host-prefs.wayvnc;
    in
    {
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
