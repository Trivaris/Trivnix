{
  flake.nixosModules.services-wayvnc =
    { lib, config, ... }:
    let
      wayvncPreferences = config.host.preferences.wayvnc;
    in
    {
      options.host.preferences.wayvnc.enable = lib.mkEnableOption "Remote desktop access via WayVNC";

      config = lib.mkIf wayvncPreferences.enable {
        networking.firewall.allowedTCPPorts = lib.optionals config.host.preferences.wayvnc.enable [
          5900
        ];
      };
    };
}
