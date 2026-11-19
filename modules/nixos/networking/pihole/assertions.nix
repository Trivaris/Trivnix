{
  flake.nixosModules.networking-pihole =
    { config, ... }:
    let
      prefs = config.host.preferences;
    in
    {
      assertions = [
        {
          assertion = prefs.pihole.enable -> (prefs.pihole.wireguardOnly -> prefs.wireguard.enable);
          message = "If pihole should route through wiregurad only, then wireguard must be enabled";
        }
      ];
    };
}
