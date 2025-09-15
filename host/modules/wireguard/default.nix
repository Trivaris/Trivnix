{
  config,
  lib,
  inputs,
  hostInfos,
  ...
}:
let
  inherit (lib) mkIf mapAttrs' nameValuePair;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.wireguard = import ./options.nix { inherit (lib) mkEnableOption; };

  config = mkIf prefs.wireguard.enable {
    networking.firewall.allowedUDPPorts = [ 51820 ];
    services.resolved.enable = true;
    services.resolved.dnssec = "allow-downgrade";

    networking.wg-quick = {
      interfaces = mapAttrs' (
        interfaceName: interface:
        nameValuePair interfaceName (interface {
          privateKeyFile = config.sops.secrets.wireguard-client-key.path;
          presharedKeyFile = config.sops.secrets."wireguard-preshared-keys/${interfaceName}".path;
          ipAddr = hostInfos.ip;
        })
      ) inputs.trivnixPrivate.wireguardInterfaces;
    };
  };
}
