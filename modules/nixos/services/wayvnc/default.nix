{
  flake.nixosModules.services-wayvnc =
    { lib, config, ... }:
    let
      wayvnc-prefs = config.host-prefs.wayvnc;
    in
    {
      options.host-prefs.wayvnc.enable = lib.mkEnableOption "Remote desktop access via WayVNC";

      config = lib.mkIf wayvnc-prefs.enable {
        networking.firewall.allowedTCPPorts = lib.optionals config.host-prefs.wayvnc.enable [
          5900
        ];
      };
    };
}
