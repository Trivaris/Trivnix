{ inputs, config, lib, hostInfos, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{

  options.hostPrefs.wireguard = import ./config.nix { inherit (lib) mkEnableOption; };

  config = mkIf prefs.wireguard.enable {
    networking.firewall.allowedUDPPorts = [ 51820 ];
    services.resolved.enable = true;
    services.resolved.dnssec = "allow-downgrade";    
    
    networking.wg-quick = {
      interfaces = lib.mapAttrs' (interfaceName: interface:
        lib.nameValuePair
          interfaceName
          (interface {
            privateKeyFile = config.sops.secrets.wireguard-client-key.path;
            presharedKeyFile = config.sops.secrets."wireguard-preshared-keys/${interfaceName}".path;
            ipAddr = hostInfos.ip;
          })
      ) inputs.trivnix-private.wireguardInterfaces;
    };
  };
}