{
  flake.nixosModules.networking-tailscale =
    { lib, config, ... }:
    let
      tsPreferences = config.host.preferences.tailscale;
    in
    {
      options.host.preferences.tailscale = {
        enable = lib.mkEnableOption "Tailscale client";
        loginServer = lib.mkOption {
          type = lib.types.str;
          description = "URL of the Headscale server";
        };
      };

      config = lib.mkIf tsPreferences.enable {
        sops.secrets.tailscale-auth-key = {
          sopsFile = config.host.private.secrets.commonSecretsFile;
          owner = "root";
          group = "root";
        };

        services.tailscale = {
          enable = true;
          openFirewall = true;
          useRoutingFeatures = "client";
          authKeyFile = tsPreferences.authKeyFile;
          extraUpFlags = [ "--login-server=${tsPreferences.loginServer}" ];
        };

        networking.firewall.trustedInterfaces = [ "tailscale0" ];
      };
    };
}
