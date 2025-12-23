{
  lib,
  ...
}:
{
  options.hostPrefs.openconnectClient = {
    enable = lib.mkEnableOption "Enable Openconnect VPN Client";

    user = lib.mkOption {
      type = lib.types.str;
      description = "The username for the vpn";
    };

    gateway = lib.mkOption {
      type = lib.types.str;
      description = "The FQDN of the vpn";
    };

    cafile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "Path to the server cert";
      default = null;
    };

    authgroup = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "The authgroup you want to authenticate with";
      default = null;
    };
  };
}
