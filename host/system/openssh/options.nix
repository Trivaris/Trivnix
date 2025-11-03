{ lib, ... }:
{
  options.hostPrefs.openssh = {
    enable = lib.mkEnableOption ''
      Enable the OpenSSH service and expose it through the firewall.
      Turn this on when the host should accept incoming SSH connections.
    '';

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
