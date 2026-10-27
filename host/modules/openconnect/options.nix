{
  lib,
  ...
}:
{
  options.hostPrefs.openconnectClient = {
    enable = lib.mkEnableOption "VPN connection with the OpenConnect client";

    user = lib.mkOption {
      type = lib.types.str;
      description = "Username used to authenticate with the VPN gateway";
    };

    gateway = lib.mkOption {
      type = lib.types.str;
      description = "Fully qualified domain name of the VPN gateway";
    };

    cafile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "Optional path to a CA certificate used to verify the VPN server";
      default = null;
    };

    authgroup = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Optional authentication group selected on the VPN gateway";
      default = null;
    };
  };
}
