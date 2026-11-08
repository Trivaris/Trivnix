{
  flake.nixosModules.networking-openconnect =
    { lib, ... }:
    {
      options.host.preferences.openconnect = {
        enable = lib.mkEnableOption "VPN connection with the OpenConnect client";

        user = lib.mkOption {
          type = lib.types.nullOr lib.types.nonEmptyStr;
          default = null;
          description = "Username used to authenticate with the VPN gateway when enabled.";
        };

        gateway = lib.mkOption {
          type = lib.types.nullOr lib.types.nonEmptyStr;
          default = null;
          description = "Fully qualified domain name of the VPN gateway when enabled.";
        };

        caFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Optional path to a CA certificate used to verify the VPN server";
        };

        authGroup = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Optional authentication group selected on the VPN gateway";
        };
      };
    };
}
