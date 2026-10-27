{ lib, ... }:
{
  options.hostPrefs.openssh = {
    enable = lib.mkEnableOption "OpenSSH service and Exposure through firewall";

    ports = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ 22 ];
      description = ''
        TCP port the OpenSSH daemon will listen on.
        Ensure this port is allowed through the firewall if accessing remotely.
      '';
    };
  };
}
