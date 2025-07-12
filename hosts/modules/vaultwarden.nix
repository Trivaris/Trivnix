{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.vaultwarden = mkEnableOption "vaultwarden";

  config = mkIf cfg.vaultwarden {

    services.vaultwarden = {
      enable = true;
      dbBackend = "sqlite";
      environmentFile = "/etc/vaultwarden.env";
      config = {
        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_PORT = 25565;
        ADMIN_TOKEN = config.sops.secrets.vaultwarden-admin-token.path;
        DOMAIN = "http://192.168.178.75";
        SIGNUPS_ALLOWED = true;
        LOG_FILE = "/var/lib/bitwarden_rs/access.log";
      };
    };

    environment.etc."vaultwarden.env".text = ''
      ADMIN_TOKEN=${config.sops.secrets.vaultwarden-admin-token.contents}
    '';

    networking.firewall.allowedTCPPorts = [ 25565 ];

  };

}
