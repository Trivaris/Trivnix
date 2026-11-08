{
  flake.homeModules.desktop-environment-wayvnc =
    {
      osConfig,
      lib,
      ...
    }:
    let
      wayvncPreferences = osConfig.host.preferences.wayvnc;
    in
    {
      config = lib.mkIf wayvncPreferences.enable {
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
